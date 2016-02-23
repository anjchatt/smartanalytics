import psycopg2

con = psycopg2.connect("dbname='twitter' user='postgres'")
cur = con.cursor()
cur.execute("""
        CREATE TABLE stream
        (
        id_str BIGINT,
        categories varchar(255),
        in_reply_to_user_id varchar(30),
        sentiment REAL,
        text varchar(255),
        created_at varchar(40), 
        user_location varchar(127), 
        in_reply_to_status_id varchar(40),
        in_reply_to_screen_name varchar(30), 
        retweet_count INT, 
        favorite_count INT, 
        user_name varchar(40), 
        user_screen_name varchar(30), 
        user_id_str varchar(30)
        );""")
con.commit()
con.close()
