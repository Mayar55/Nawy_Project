FROM apache/airflow:2.10.5-python3.11

USER airflow

RUN pip install --no-cache-dir \
    "apache-airflow==2.10.5" \
    --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.10.5/constraints-3.11.txt"

RUN pip install --no-cache-dir \
    "dbt-postgres==1.7.19" \
    "pandas>=2,<3" \
    "openpyxl>=3.1,<4"