# prometheus-scrape-size-rate-sidecar

## Example
```bash
podman build -t prom-scrap-size .
podman run -e TARGET_DATA_DIR=/tmp  -p 9200:9200 localhost/prom-scrap-size
```
