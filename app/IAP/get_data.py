
import time
#import praw
import facebook
import json
import requests
from pymongo import MongoClient

MAX_MESSAGE_NUMBER = 10
AAPI_KEY = 'c53e15d0a29aa87dc4a287e96f28e1134b8f3c7d'
url = 'http://access.alchemyapi.com/calls/text/TextGetTextSentiment'


page_access_token='CAAMFluwhbIkBAEBaBxso6kVFZAGCPhumq3XZBMSqgt6hc4fcZBWADIiodPsZBsqZCRZB12ZBsnOYqMZAowhvSKZCSg3Bo3R6ilBGao5SltggvTidKUJZB79kYh4qP5ZCTlti2bkyZCY0MxI8gPERrqZBVXV6uQEJduewZCmq1A8ev2UOM3KMy1pJOn0rvu25LlYEMm1riwGPPgFYtE3qYa1D7Vi2O1'

graph = facebook.GraphAPI(access_token=page_access_token)

user = graph.get_object("capbankpage")
data = graph.get_connections(user['id'], "feed")['data']
jdec = json.JSONDecoder()

client = MongoClient("localhost:27017")
db = client.cdb

########################
## REMOVE

db.fb_feed.drop()
db.fb_feed.insert_one({'type':'last_update_date', 'time':'1900-01-01T00:00:00+0000'})

##
########################

last_update_date = db.fb_feed.find({'type':'last_update_date'})[0]['time']
last_update_date_t = time.strptime(last_update_date, '%Y-%m-%dT%H:%M:%S+0000')

id = 0
for data_field in data:
  data_field['time_s'] = time.strptime(data_field['updated_time'], '%Y-%m-%dT%H:%M:%S+0000')
  data[id] = data_field
  id+=1

data = filter(lambda x:x['time_s']>last_update_date_t, data)

messages = list()

for data_field in data:
  if ('message' in data_field) and (data_field['from']['name'] != 'CapBank'):
    payload = {  'apikey'    :AAPI_KEY,
                'text'       :data_field['message'],
                'outputMode' :'json'}
    result = requests.get(url, params=payload)
    sentiment = jdec.decode(result.text)
    
    message ={'message'   :data_field['message'],
              'from'      :data_field['from']['name'],
              'from_id'   :data_field['from']['id'],
              'date'      :data_field['updated_time'],
              'sentiment' :sentiment['docSentiment']}
    db.fb_feed.insert_one(message)
    if data_field['time_s'] > last_update_date_t:
      last_update_date = data_field['updated_time']


#db.fb_feed.update_one({'type':'last_update_date'}, {'$set':{'time':last_update_date}})
