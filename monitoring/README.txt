OPTIONAL OBSERVABILITY WITH PROMETHEUS AND GRAFANA
Assignment 2 optional observability: maximum 1 mark, subject to working evidence.
Not Kubernetes or the full 3 advanced marks.

MANUAL START FROM POWERSHELL IN APPLICATION ROOT
$env:SEATFLOW_MONITORING_DIR = (Join-Path (Get-Location) 'monitoring').Replace('\','/')
$env:SEATFLOW_GRAFANA_PASSWORD = [guid]::NewGuid().ToString('N')
docker compose -f docker-compose.yml -f monitoring/compose.monitoring.yml up -d --build
docker compose -f docker-compose.yml -f monitoring/compose.monitoring.yml ps

Grafana: http://127.0.0.1:3000/d/seatflow-a2/seatflow-service-monitoring?kiosk
Prometheus: http://127.0.0.1:9090
Anonymous Viewer is for this loopback-only local demonstration.
Keep passwords local; do not commit real secrets or .env files.
If using the recorder's monitoring copy, set SEATFLOW_MONITORING_DIR to that folder
and use its absolute compose.monitoring.yml path as the second -f argument.

VERIFY
Run the normal application workflow at http://127.0.0.1:5173/.
Query probe_success{job="seatflow-health"}: four service series, all 1.
Query probe_duration_seconds{job="seatflow-health"}: real probe timing values.
Show Grafana health, timing, history and observed 5-minute availability.
docker compose stop inventory
Wait for a scrape (5 seconds plus timeout). Inventory probe_success must become 0.
docker compose start inventory
Wait for Inventory probe_success to become 1. Recheck application operation.
Capture three screenshots and raw queries across the interruption and recovery.

Probe success checks the endpoint; Prometheus up only checks exporter scraping.
Probe duration is /health latency, not booking transaction latency. Short observed
availability is not a production service level claim. This is intentional failure
injection; the existing application configuration is already correct.

STOP/REMOVE MONITORING (same shell; retains volumes and the application)
docker compose -f docker-compose.yml -f monitoring/compose.monitoring.yml stop grafana prometheus blackbox
docker compose -f docker-compose.yml -f monitoring/compose.monitoring.yml rm -f grafana prometheus blackbox
Keep configuration mount directories until these containers are removed.

COMMIT this whole monitoring/ directory: override, exporter/scrape configurations,
Grafana provisioning and dashboard JSON. Recorder tools belong separately.

References
https://prometheus.io/docs/guides/multi-target-exporter/
https://grafana.com/docs/grafana/latest/administration/provisioning/
