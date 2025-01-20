from datetime import datetime
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.dialects.postgresql import UUID, TIMESTAMP, INTEGER, TEXT, BOOLEAN

# Database connection
engine = create_engine('postgresql://postgres:123456@localhost:5432/AdventureWorks')

def clean_and_convert(df, column_mappings):
    """
    Cleans and converts columns based on provided mappings.
    Args:
        df (pd.DataFrame): DataFrame to clean and convert.
        column_mappings (dict): Dictionary of column names and their cleaning logic.
    """
    for column, transformations in column_mappings.items():
        for transform in transformations:
            df[column] = df[column].apply(transform)
    return df

def load_to_sql(table_name, df, schema, dtype):
    """
    Loads the DataFrame into a SQL table.
    Args:
        table_name (str): Target table name.
        df (pd.DataFrame): DataFrame to load.
        schema (str): Target schema.
        dtype (dict): Data type mappings for SQL table.
    """
    df.to_sql(table_name, engine, schema=schema, index=False, if_exists='append', dtype=dtype)

def process_and_load(csv_url, sep, encoding, columns, table_name, schema, dtype, column_mappings):
    """
    Downloads, processes, and loads data from a CSV file into a SQL table.
    Args:
        csv_url (str): URL to the CSV file.
        sep (str): Separator used in the CSV file.
        encoding (str): Encoding of the CSV file.
        columns (list): List of column names.
        table_name (str): Target table name.
        schema (str): Target schema.
        dtype (dict): Data type mappings for SQL table.
        column_mappings (dict): Dictionary of column names and their cleaning logic.
    """
    df = pd.read_csv(csv_url, engine='python', sep=sep, encoding=encoding, header=None, names=columns, index_col=False)
    df = clean_and_convert(df, column_mappings)
    load_to_sql(table_name, df, schema, dtype)

# Common transformations
remove_curly_braces = lambda x: x.replace("{", "").replace("}", "") if isinstance(x, str) else x
remove_ampersand_pipe = lambda x: x.replace("&", "").replace("|", "") if isinstance(x, str) else x
convert_to_datetime = lambda x: pd.to_datetime(x, errors='coerce')

# Table-specific configurations
tables = [
    {
        'csv_url': 'https://github.com/microsoft/sql-server-samples/raw/refs/heads/master/samples/databases/adventure-works/oltp-install-script/BusinessEntity.csv',
        'sep': '\+\|',
        'encoding': 'utf-16',
        'columns': ['businessentityid', 'rowguid', 'modifieddate'],
        'table_name': 'businessentity',
        'schema': 'person',
        'dtype': {'businessentityid': INTEGER, 'rowguid': TEXT, 'modifieddate': TIMESTAMP},
        'column_mappings': {
            'modifieddate': [remove_ampersand_pipe, convert_to_datetime]
        }
    },
    {
        'csv_url': 'https://github.com/microsoft/sql-server-samples/raw/refs/heads/master/samples/databases/adventure-works/oltp-install-script/AddressType.csv',
        'sep': '\t',
        'encoding': 'utf-8',
        'columns': ['addresstypeid', 'name', 'rowguid', 'modifieddate'],
        'table_name': 'addresstype',
        'schema': 'person',
        'dtype': {'addresstypeid': INTEGER, 'name': TEXT, 'rowguid': TEXT, 'modifieddate': TIMESTAMP},
        'column_mappings': {
            'rowguid': [remove_curly_braces],
            'modifieddate': [remove_ampersand_pipe, convert_to_datetime]
        }
    },
    # Add additional table configurations here following the same structure
]

with engine.connect() as con:
    with open("schema_query.sql") as file:
        query = text(file.read())
        con.execute(query)
        con.close()

# Process and load each table
for table in tables:
    process_and_load(
        csv_url=table['csv_url'],
        sep=table['sep'],
        encoding=table['encoding'],
        columns=table['columns'],
        table_name=table['table_name'],
        schema=table['schema'],
        dtype=table['dtype'],
        column_mappings=table['column_mappings']
    )

with engine.connect() as con2:
    with open("pkfk_query.sql") as file2:
        query2 = text(file2.read())
        con2.execute(query2)
        con2.close()

with engine.connect() as con3:        
    with open("create_view.sql") as file3:
        query3 = text(file3.read())
        con3.execute(query3)
        con3.close()