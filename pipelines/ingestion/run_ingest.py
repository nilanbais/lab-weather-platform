import os
from dotenv import load_dotenv
load_dotenv()

import json
import uuid
import yaml
import requests
from datetime import datetime, timezone

from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
from azure.storage.filedatalake import DataLakeServiceClient

ENV = os.environ.get("ENV", "dev")

KV_NAME = os.environ.get("KV_NAME", f"kv-weather-platform-{ENV}")
ADLS_ACCOUNT = os.environ.get("ADLS_ACCOUNT")  # REQUIRED
FILESYSTEM = os.environ.get("FILESYSTEM", "bronze")

LOCATIONS_PATH = os.environ.get("LOCATIONS_PATH", "configs/locations/locations.yaml")
OPENWEATHER_CFG_PATH = os.environ.get("OPENWEATHER_CFG_PATH", "configs/sources/openweather.yaml")
WAQI_CFG_PATH = os.environ.get("WAQI_CFG_PATH", "configs/sources/waqi.yaml")

def load_yaml(path: str) -> dict:
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def get_secret(vault_name: str, secret_name: str) -> str:
    credential = DefaultAzureCredential()
    client = SecretClient(vault_url=f"https://{vault_name}.vault.azure.net/", credential=credential)
    return client.get_secret(secret_name).value

def get_datalake_service(account_name: str) -> DataLakeServiceClient:
    credential = DefaultAzureCredential()
    return DataLakeServiceClient(account_url=f"https://{account_name}.dfs.core.windows.net", credential=credential)

def upload_json(fs_client, path: str, obj: dict):
    payload = json.dumps(obj, ensure_ascii=False)
    file_client = fs_client.get_file_client(path)
    file_client.upload_data(payload, overwrite=True)

def ingest_openweather(loc: dict, cfg: dict, api_key: str) -> dict:
    url = cfg["base_url"] + cfg["endpoint"]
    params = {
        "lat": loc["lat"],
        "lon": loc["lon"],
        cfg["auth"]["key_name"]: api_key,
        **cfg.get("request", {}).get("params", {}),
    }
    r = requests.get(url, params=params, timeout=30)
    r.raise_for_status()
    return r.json()

def ingest_waqi(loc: dict, cfg: dict, api_key: str) -> dict:
    endpoint = cfg["endpoint_template"].format(lat=loc["lat"], lon=loc["lon"])
    url = cfg["base_url"] + endpoint
    params = {cfg["auth"]["key_name"]: api_key}
    r = requests.get(url, params=params, timeout=30)
    r.raise_for_status()
    return r.json()

def build_path(source: str, location_key: str, run_id: str, ts: datetime) -> str:
    return f"{source}/{location_key}/{ts:%Y}/{ts:%m}/{ts:%d}/{run_id}.json"

def main():
    if not ADLS_ACCOUNT:
        raise RuntimeError("Set env var ADLS_ACCOUNT to your dev storage account name (e.g., st...dev...).")

    run_id = str(uuid.uuid4())
    ingest_ts = datetime.now(timezone.utc).isoformat()
    ts = datetime.now(timezone.utc)

    locations = load_yaml(LOCATIONS_PATH)["locations"]
    ow_cfg = load_yaml(OPENWEATHER_CFG_PATH)
    waqi_cfg = load_yaml(WAQI_CFG_PATH)

    ow_key = get_secret(KV_NAME, "openweather-api-key")
    waqi_key = get_secret(KV_NAME, "waqi-api-key")

    service = get_datalake_service(ADLS_ACCOUNT)
    fs_client = service.get_file_system_client(FILESYSTEM)

    for loc in locations:
        ow_payload = ingest_openweather(loc, ow_cfg, ow_key)
        ow_path = build_path("openweather", loc["key"], run_id, ts)
        upload_json(fs_client, ow_path, {
            "run_id": run_id,
            "ingest_ts": ingest_ts,
            "source": "openweather",
            "location": loc,
            "payload": ow_payload
        })

        waqi_payload = ingest_waqi(loc, waqi_cfg, waqi_key)
        waqi_path = build_path("waqi", loc["key"], run_id, ts)
        upload_json(fs_client, waqi_path, {
            "run_id": run_id,
            "ingest_ts": ingest_ts,
            "source": "waqi",
            "location": loc,
            "payload": waqi_payload
        })

    print(f"OK: run_id={run_id}")
    print(f"Written to adls://{ADLS_ACCOUNT}/{FILESYSTEM}/openweather|waqi/<location>/<YYYY>/<MM>/<DD>/{run_id}.json")

if __name__ == "__main__":
    main()
