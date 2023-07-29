import os, pandas, psycopg2, sys, yaml
import psycopg2.extras as extras

#data_dir = 'raw_data/'
#data_file = 'raw.csv'
#table = 'raw.raw__weight_daily'

script_dir = os.path.dirname(__file__)
config_path = f'{script_dir}/config.yaml'

def config_parse(config_path):
    #Parse yaml config file for db, user, pw, host, port
    try:
        with open(config_path, 'r') as file:
            config_file = yaml.safe_load(file)
    except FileNotFoundError as e:
        print(f'File {config_path} not found. Exiting.')
        sys.exit(1)
    try:
        db = config_file['database_info']['database']
        table = config_file['database_info']['table']
        user = config_file['database_info']['username']
        pw = config_file['database_info']['password']
        host = config_file['database_info']['host']
        port = config_file['database_info']['port']
        data_file = config_file['data']['file']
    except KeyError as e:
        print(f'Config missing key: {e}. Exiting.')
        sys.exit(1)
    return db, table, user, pw, host, port, data_file

def copy_all(db, host, user, pw, port, table, data_file):
    df = pandas.read_csv(f'{data_file}')

    #connect to db and execute query, takes in data file and db info
    conn = psycopg2.connect(database=db, host=host, user=user, password=pw, port=port)
    cur = conn.cursor()

    tuples = [tuple(x) for x in df.to_numpy()]
    cols = ','.join(list(df.columns))

    query = "INSERT INTO %s(%s) VALUES %%s ON CONFLICT DO NOTHING" % (table, cols)
    try:
        extras.execute_values(cur, query, tuples)
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print("Error: %s" % error)
        conn.rollback()
        cur.close()
        return 1
    print("the dataframe is inserted")

    cur.close()
    conn.close()

def main():
    db, table, user, pw, host, port, data_file = config_parse(config_path)

    print(f'Uploading...\n{data_file}')

    copy_all(db, host, user, pw, port, table, data_file)

if __name__ == '__main__':
    main()