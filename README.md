# Airflow and dbt pipeline

## Run with Docker

Install and start Docker Desktop with Linux containers enabled, then run from this directory:

```powershell
docker compose up --build -d
```

Open <http://localhost:8080> and sign in with `admin` / `admin` for a local development setup. Set `AIRFLOW_ADMIN_PASSWORD` before the first startup to use a different password. The `my_data_pipeline` DAG runs daily; you can also trigger it from the Airflow UI.

The Airflow containers mount `dags/` and `my_data_pipeline/`, so changes to the DAG and dbt project are available without rebuilding the image. Airflow's metadata is stored in a Docker volume, and task logs are written under `logs/`.

By default, dbt connects to PostgreSQL on the Windows host using `host.docker.internal:5432`, with the credentials and database in `my_data_pipeline/profiles.yml`. Set `DBT_POSTGRES_HOST` in the shell before starting Compose if PostgreSQL is hosted elsewhere. The database must accept connections from Docker containers.

To stop the services while preserving Airflow metadata:

```powershell
docker compose down
```