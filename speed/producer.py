'''
This file should do kafka stuff.
maybe coordinate with /etc/cron.hourly?
'''
import json
import requests
import datetime
from kafka import KafkaProducer
from credentials import kafkahost

# Extract 

# Transform

# Load


if __name__ == '__main__':
    # Init producer and send it.
    producer = KafkaProducer(bootstrap_servers=kafkahost)
    producer.send('ndtallant', datetime.datetime.now().strftime('%F %H:%M:%S'))
    producer.flush() # Make sure the message is sent.
