from datetime import datetime, timedelta
from pathlib import Path

import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator


DBT_PROJECT_DIR = Path(__file__).resolve().parent.parent / "my_data_pipeline"


def convert_seeds_to_csv():
    import pandas as pd

    seed_dir = DBT_PROJECT_DIR / "seeds"
    for workbook in sorted(seed_dir.iterdir()):
        if workbook.is_file() and workbook.suffix.lower() == ".xlsx":
            csv_name = workbook.stem.lower().replace(" ", "_") + ".csv"
            pd.read_excel(workbook).to_csv(seed_dir / csv_name, index=False)


default_args = {
    "owner": "airflow",
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="my_data_pipeline",
    default_args=default_args,
    start_date=pendulum.datetime(2024, 1, 1, tz="Africa/Cairo"),
    schedule="0 13 * * *",
    catchup=False,
    max_active_runs=1,
    tags=["dbt", "data-pipeline"],
) as dag:
    install_dbt_dependencies = BashOperator(
        task_id="install_dbt_dependencies",
        bash_command=(
            f'cd "{DBT_PROJECT_DIR}" && '
            f'dbt deps --no-version-check --profiles-dir "{DBT_PROJECT_DIR}"'
        ),
    )

    convert_excel_seeds = PythonOperator(
        task_id="convert_excel_seeds_to_csv",
        python_callable=convert_seeds_to_csv,
    )

    load_seeds = BashOperator(
        task_id="load_seeds",
        bash_command=(
            f'cd "{DBT_PROJECT_DIR}" && '
            f'dbt seed --profiles-dir "{DBT_PROJECT_DIR}"'
        ),
    )

    run_staging = BashOperator(
        task_id="run_stg_source",
        bash_command=(
            f'cd "{DBT_PROJECT_DIR}" && '
            f'dbt run --select path:models/stg_source '
            f'--profiles-dir "{DBT_PROJECT_DIR}"'
        ),
    )

    run_standardized = BashOperator(
        task_id="run_std_data",
        bash_command=(
            f'cd "{DBT_PROJECT_DIR}" && '
            f'dbt run --select path:models/std_data '
            f'--profiles-dir "{DBT_PROJECT_DIR}"'
        ),
    )

    run_transformed = BashOperator(
        task_id="run_transformed_data",
        bash_command=(
            f'cd "{DBT_PROJECT_DIR}" && '
            f'dbt run --select path:models/transformed_data '
            f'--profiles-dir "{DBT_PROJECT_DIR}"'
        ),
    )

    run_tests = BashOperator(
        task_id="run_dbt_tests",
        bash_command=(
            f'cd "{DBT_PROJECT_DIR}" && '
            f'dbt test --profiles-dir "{DBT_PROJECT_DIR}"'
        ),
    )

    (
        install_dbt_dependencies
        >> convert_excel_seeds
        >> load_seeds
        >> run_staging
        >> run_standardized
        >> run_transformed
        >> run_tests
    )