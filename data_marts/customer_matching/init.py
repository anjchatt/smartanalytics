import psycopg2
import sys

con = None

try:
    con = psycopg2.connect("dbname='twitter' user='postgres'")
    
    cur = con.cursor()
  
    cur.execute("""
    CREATE TABLE stream
    (
    id BIGINT PRIMARY KEY,
    categories VARCHAR(255),
    in_reply_to_user_id VARCHAR(30),
    sentiment REAL,
    text VARCHAR(255),
    created_at VARCHAR(35),
    user_location VARCHAR(127),
    in_reply_to_status_id VARCHAR(63),
    in_reply_to_screen_name VARCHAR(25),
    retweet_count INT,
    favorite_count INT,
    user_name VARCHAR(35),
    user_screen_name VARCHAR(25),
    user_id_str VARCHAR(35)
    );""")
    con.commit()
    
except psycopg2.DatabaseError, e:
    if con:
        con.rollback()
    
    print 'Error %s' % e    
    sys.exit(1)
    
    
finally:
    if con:
        con.close()