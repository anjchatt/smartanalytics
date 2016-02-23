
# coding: utf-8

# In[ ]:

from pyspark import SparkContext
sc = SparkContext("local[2]", "twitter_stream")


# In[ ]:

#execfile("shell_init.py")


# In[ ]:

from pyspark.streaming.kafka import KafkaUtils
from pyspark.streaming import StreamingContext

import re
import json
import psycopg2

with open('../AFINN-111.txt') as f:
    sent_dict = [l.split('\t') for l in f]
    sent_dict = {l[0]:int(l[1]) for l in sent_dict}
broadcast_sent_dict = sc.broadcast(sent_dict)

with open('../taxonomy_dict.json') as f:
    s = f.read()
    taxonomy_dict = eval(s)
broadcast_taxonomy_dict = sc.broadcast(taxonomy_dict)


# In[ ]:

ssc = StreamingContext(sc, 5)
zookeeper = ("localhost:2181")
kafka_stream = KafkaUtils.createStream(ssc, zookeeper, "twitter", {"twitter_api_stream":1})

tweets = kafka_stream.map(lambda (x,y):json.loads(y))

tokenize = re.compile('(?u)\\b[a-z][a-z]+\\b')
def tokenize_foo(t):
    t.update({'tokens':tokenize.findall(t['text'].lower())})
    return t
tweets = tweets.map(tokenize_foo)

def include_sent(t):
    toks = t['tokens']
    sent_dict = broadcast_sent_dict.value
    sent = [sent_dict[tok] for tok in toks if tok in sent_dict]
    sent = sum(sent)/float(len(sent)+2)
    t.update({'sentiment':sent})
    return t
tweets = tweets.map(include_sent)


# In[ ]:

def get_taxonomy(t):
    text = t['text'].lower()
    text = text.replace("'","").replace("#","").replace("@","")
    taxonomy_dict = broadcast_taxonomy_dict.value
    category = ''
    for cat,kws in taxonomy_dict.iteritems():
        for kw in kws:
            if kw in text:
                category = category+'|'+cat+'|'
                break
    t.update({'categories':category})
    return t
tweets = tweets.map(get_taxonomy)


# In[ ]:

def send_partition(part):
    con = psycopg2.connect("dbname='twitter' user='postgres'")
    cur = con.cursor()
    for data in part:
        field_names = ['id_str', 'categories', 'in_reply_to_user_id', 'sentiment', 
                       'text', 'created_at', 'user_location', 'in_reply_to_status_id',
                       'in_reply_to_screen_name', 'retweet_count', 'favorite_count',
                       'user_name', 'user_screen_name', 'user_id_str']
        cur.execute("""
        INSERT INTO stream
        (
        id_str, categories, in_reply_to_user_id, sentiment, text, created_at, user_location, in_reply_to_status_id,
        in_reply_to_screen_name, retweet_count, favorite_count, user_name, user_screen_name, user_id_str)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);""",[data[k] for k in field_names])
    con.commit()
    con.close()
    
tweets.foreachRDD(lambda rdd: rdd.foreachPartition(send_partition))


# In[ ]:

def printo(t):
    #t = {k:v for (k,v) in t.iteritems() if k in {'sentiment', 'text','categories'}}
    if len(t['categories']) > 0:
        return t
    else:
        return ''
#tweets.map(printo).pprint()
tweets.pprint()

#ssc.awaitTermination(2)
ssc.start()
ssc.awaitTermination()

# In[ ]:

#ssc.stop()


# In[ ]: