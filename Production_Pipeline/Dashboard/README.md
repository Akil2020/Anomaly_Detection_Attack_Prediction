FINAL package (two containers: Postgres + Grafana)
=================================================

Contents:
- docker-compose.yml
- postgres/initdb/init_predictions.sql  <-- auto-run during DB init, uses server-side COPY to load /data/predictions.csv
- grafana/provisioning/datasources/datasource.yaml  <-- Postgres datasource (PostgresInfra)
- grafana/provisioning/dashboards/*.json  <-- 5 dashboards
- data/predictions.csv  <-- full CSV (will be copied into container at startup)

Important:
- The Postgres init script runs ONLY when the Postgres data directory is empty (first run). To re-run, remove the 'pgdata' volume.
- Grafana provisioning folders are mounted explicitly (datasources and dashboards), ensuring Grafana sees them inside the container.
- Default credentials (change before production):
  - Postgres: mluser / mlpass
  - Grafana admin password: admin

How to run:
1. unzip the package
2. docker-compose up --build
3. Wait for Postgres init to complete and for Grafana to start. Visit http://localhost:3000 (admin/admin).

If anything fails, run:
- docker logs direct_pg
- docker exec -it grafana bash -lc "ls -la /etc/grafana/provisioning/datasources /etc/grafana/provisioning/dashboards && cat /etc/grafana/provisioning/datasources/datasource.yaml"

