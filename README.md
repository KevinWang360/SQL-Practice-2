
# People Analytics Practice — GitHub + Codespaces

Run SQL on the synthetic HR dataset directly in your browser via **GitHub Codespaces**.

## Quick Start (Codespaces)
1) Create a new GitHub repo and upload these files (or push via Git).
2) Click **Code ▸ Codespaces ▸ Create codespace on main**.
3) In the terminal, run:
```bash
sqlite3 data/hr_practice.db
```
4) At the `sqlite>` prompt, try:
```sql
.tables
SELECT COUNT(*) FROM employees;
.read queries/01_recruiting_funnel.sql
```
5) To exit: `.quit`.

## Files
- `data/hr_practice.db` — SQLite DB with tables: jobs, applications, employees, compensation, performance_reviews, engagement_responses, exits, training.
- CSVs mirrored in `data/` for optional use.
- `queries/` — starter SQL for 4 projects.

## Alternative: run on CSVs with DuckDB (optional)
DuckDB can query CSVs directly. If you prefer DuckDB, install it in the Codespaces terminal:
```bash
curl -L -o duckdb https://github.com/duckdb/duckdb/releases/download/v1.1.3/duckdb_cli-linux-amd64.zip &&   sudo apt-get update && sudo apt-get install -y unzip && unzip duckdb -d /usr/local/bin && chmod +x /usr/local/bin/duckdb
duckdb
```
Then:
```sql
SELECT COUNT(*) FROM 'data/applications.csv';
```

## Projects
- `01_recruiting_funnel.sql` — stage conversion & time-to-fill
- `02_onboarding_90d_attrition.sql` — 90-day attrition & training-within-60 days
- `03_performance_pay_calibration.sql` — rating distribution & pay vs median by level
- `04_engagement_hotspots.sql` — manager rollups & hotspots

## Notes
- All data are **synthetic**.
- If you prefer local dev, install [DB Browser for SQLite] or use the `sqlite3` CLI.
