
import facebook
import json
import requests
import time
#import praw
from pymongo import MongoClient

MAX_MESSAGE_NUMBER = 10
AAPI_KEY = 'c53e15d0a29aa87dc4a287e96f28e1134b8f3c7d'

url = 'http://access.alchemyapi.com/calls/text/TextGetTextSentiment'
page_access_token='CAAMFluwhbIkBAEBaBxso6kVFZAGCPhumq3XZBMSqgt6hc4fcZBWADIiodPsZBsqZCRZB12ZBsnOYqMZAowhvSKZCSg3Bo3R6ilBGao5SltggvTidKUJZB79kYh4qP5ZCTlti2bkyZCY0MxI8gPERrqZBVXV6uQEJduewZCmq1A8ev2UOM3KMy1pJOn0rvu25LlYEMm1riwGPPgFYtE3qYa1D7Vi2O1'

graph = facebook.GraphAPI(access_token=page_access_token)
jdec = json.JSONDecoder()

client = MongoClient("localhost:27017")
db = client.cdb

##
def get_user_fb_messages(facebook_id):
  data = db.fb_feed.find({'from_id':facebook_id})
  data = [doc for doc in data]
  
  messages = list()
  for data_field in data:
    messages.append({'message':data_field['message'],
                     'source':'facebook',
                     'time':time.strptime(data_field['date'], '%Y-%m-%dT%H:%M:%S+0000'),
                     'cat':' '})
  return messages

##
def get_user_internal_messages(customer_profile):
  messages = customer_profile['messages']['messages']
  id = 0
  for message in messages:
    message['time'] = time.strptime(message['time'], '%Y-%m-%dT%H:%M:%S+0000')
    messages[id] = message
    id += 1
  return messages

##
def get_user_messages(customer_id):
  customer_profile = db.arr.find({'X_id':customer_id})[0]
  if 'messages' not in customer_profile: return None
  if 'last_time_updated' in customer_profile['messages']:
    last_time_updated = customer_profile['messages']['last_time_updated']
    last_time_updated = time.strptime(last_time_updated, '%Y-%m-%dT%H:%M:%S+0000')
  else:
    last_time_updated = 0
  
  
  messages_fb = list()
  if 'facebook_id' in customer_profile:
    facebook_id = customer_profile['facebook_id']
    messages_fb = get_user_fb_messages(facebook_id)
    messages_fb = filter(lambda x:x['time']>last_time_updated, messages_fb)
  
  
  messages_internal = get_user_internal_messages(customer_profile)
  
  messages = messages_fb + messages_internal
  messages = sorted(messages, key=lambda x:x['time'], reverse=1)
  messages = messages[0:MAX_MESSAGE_NUMBER]
  
  id = 0
  for message in messages:
    message['time'] = time.strftime('%Y-%m-%dT%H:%M:%S+0000', message['time'])
    if 'sent' not in message:
      payload = {  'apikey': AAPI_KEY,
                  'text': message['message'],
                  'outputMode': 'json'}
      result = requests.get(url, params=payload)
      sentiment = jdec.decode(result.text)
      message['sent'] = sentiment['docSentiment']['type']
    
    messages[id] = message
    id += 1
  
  #db.arr.update_one({ 'X_id': customer_id },{ '$set': { "messages.last_time_updated": messages[0]['time'] }})
  #db.arr.update_one({ 'X_id': customer_id },{ '$set': { "messages.messages": messages }})
  return messages


