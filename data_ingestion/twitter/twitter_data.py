
"""
Example program for the Stream API. This prints public status messages
from the "sample" stream as fast as possible. Use -h for help.
"""

from __future__ import print_function

import argparse

from twitter.stream import TwitterStream, Timeout, HeartbeatTimeout, Hangup
from twitter.oauth import OAuth
from twitter.oauth2 import OAuth2, read_bearer_token_file
from twitter.util import printNicely
#import hadoopy
import json
import os
from kafka import KafkaProducer
import json

def parse_arguments():

    parser = argparse.ArgumentParser(description=__doc__ or "")

    parser.add_argument('-t',  '--token', required=True, help='The Twitter Access Token.')
    parser.add_argument('-ts', '--token-secret', required=True, help='The Twitter Access Token Secret.')
    parser.add_argument('-ck', '--consumer-key', required=True, help='The Twitter Consumer Key.')
    parser.add_argument('-cs', '--consumer-secret', required=True, help='The Twitter Consumer Secret.')
    parser.add_argument('-to', '--timeout', help='Timeout for the stream (seconds).')
    parser.add_argument('-ht', '--heartbeat-timeout', help='Set heartbeat timeout.', default=90)
    parser.add_argument('-nb', '--no-block', action='store_true', help='Set stream to non-blocking.')
    parser.add_argument('-tt', '--track-keywords', help='Search the stream for specific text.')
    return parser.parse_args()

def main():
    os.environ["https_proxy"] = os.environ["http_proxy"]
    args = parse_arguments()
    """
    class arg:
        token = '2360463842-4dvRToWEoFCFkIj9Dg9fDrREZytBRhpiVan1SVl'
        token_secret = 'H7xC8EBkiibjbd7yFgLlK5xRH6qq6Byxr8wp07xhwbDCk'
        consumer_key = 'ogAcB1y6qPLmntrY2KCXvgggF'
        consumer_secret = '9YN11mY0VWltFiOfxp6EtTu5uY8dVxHMsvMZOC3AMcb850568B'
        no_block = True
        track_keywords = 'New York'
        heartbeat_timeout = 90
        timeout = 10
        user_stream = False
        site_stream = False
    args = arg()
    """

    tweet_keys = ['in_reply_to_status_id', 'in_reply_to_screen_name', 'in_reply_to_user_id', 
                  'favorite_count', 'retweet_count', 'text', 'id_str', 'created_at']
    user_keys = ['id_str', 'screen_name', 'name', 'location']
    user_keys_io = {'id_str':'user_id_str', 'screen_name':'user_screen_name', 'name':'user_name', 'location':'user_location'}

    auth = OAuth(args.token, args.token_secret, args.consumer_key, args.consumer_secret)
    
    stream_args = dict(
        timeout=args.timeout,
        block=not args.no_block,
        heartbeat_timeout=args.heartbeat_timeout)

    query_args = dict()
    if args.track_keywords:
        query_args['track'] = args.track_keywords

    stream = TwitterStream(auth=auth, **stream_args)
    if args.track_keywords:
        tweet_iter = stream.statuses.filter(**query_args)
    else:
        tweet_iter = stream.statuses.sample()

    producer = KafkaProducer(bootstrap_servers=['localhost:6667'], value_serializer=lambda m: json.dumps(m).encode('ascii'))
    
    cnt = 0
    for tweet in tweet_iter:
        if tweet is None:
            printNicely("-- None --")
        elif tweet is Timeout:
            printNicely("-- Timeout --")
        elif tweet is HeartbeatTimeout:
            printNicely("-- Heartbeat Timeout --")
        elif tweet is Hangup:
            printNicely("-- Hangup --")
        elif tweet.get('text'):
            #printNicely(tweet['text'])
            tweet_ = {k:tweet[k] for k in tweet_keys}
            tweet_.update({user_keys_io[k]:tweet['user'][k] for k in user_keys})
            future = producer.send('twitter_api_stream', tweet_)
            cnt += 1
            if not cnt%100:
                print('Count: ' + str(cnt))

if __name__ == '__main__':
    main()

"""
local_path = tweet['id_str']+'.json'
hdfs_path = '/user/spark/twitter_data/'+local_path
with open(local_path, 'w') as f:
    f.write(tweet_str)
    hadoopy.put(local_path, hdfs_path)

"""