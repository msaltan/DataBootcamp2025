from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator 
from airflow.providers.postgres.hooks.postgres import PostgresHook 
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta
import pandas as pd

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 2, 9),
    #'retries': 1,
    #'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'transfer_db_data_',
    default_args=default_args,
    description='Transfer data from source to destination',
    schedule_interval='@hourly',
)

def transfer_table_data(table_name):
    # Hook to PostgreSQL
    postgres_source_hook = PostgresHook(postgres_conn_id='postgres_source')
    postgres_destination_hook = PostgresHook(postgres_conn_id='postgres_destination')
    df = postgres_source_hook.get_pandas_df(f"SELECT * FROM {table_name};")  
    conn = postgres_destination_hook.get_conn()
    cursor = conn.cursor()
    cursor.execute(f" truncate table {table_name}" )
    # Insert data into MySQL
    postgres_destination_hook.insert_rows(table=table_name, rows=df.values.tolist(), target_fields=df.columns.tolist())

# Define tasks for each table
tables = ['users', 'films', 'film_category', 'actors', 'film_actors'] 
tasks = {}

# Loop through the tables and create tasks
for table in tables:
    task_id = f'transfer_data_{table}'
    tasks[table] = PythonOperator(
        task_id=task_id,
        python_callable=transfer_table_data,
        op_kwargs={'table_name': table},
        dag=dag
    )

# Set up dependencies (optional, if you want sequential execution)
for i in range(1, len(tables)):
    tasks[tables[i]].set_upstream(tasks[tables[i - 1]])

 