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
            user_id_str varchar(30),
            is_agent_reply INT
        );

CREATE TABLE word_ids
        (
            id_str BIGINT,
            word_id INT,
            cluster_id INT,
            user_id_str varchar(30)
        );
        
CREATE INDEX word_id ON word_ids (word_id);

CREATE TABLE cluster_ids
        (
            cluster_id INT
        );