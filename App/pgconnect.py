import psycopg2
from psycopg2 import Error

try:
    connection = psycopg2.connect(user = "postgres",
                                  password = "postgres",
                                  host = "127.0.0.1",
                                  port = "5432",
                                  database = "postgres_db")

    cursor = connection.cursor()
    
    create_table_query = '''CREATE TABLE test_app
          (ID INT PRIMARY KEY     NOT NULL,
          NAME           TEXT    NOT NULL); '''
    
    cursor.execute(create_table_query)
    connection.commit()

except (Exception, psycopg2.DatabaseError) as error :
    print ("Error while creating PostgreSQL table", error)
finally:
        if(connection):
            cursor.close()
            connection.close()