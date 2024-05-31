import paho.mqtt.client as mqtt
from paho.mqtt import client as mqtt_client
from config import *
import random
import json

'''
THIS CLASS REPRESENT AN MQTT CLIENT
'''
class FARM_MQTT: 
    '''
    Brief: init 
    @id: Client id
    @broker: broker's host
    @port: broker's port
    @username: broker server's username
    @password: broker server's password
    '''
    def __init__(self, feedKey):
        id = f'publish-{random.randint(0, 1000)}'
        def on_connect(client, userdata, flags, rc):
            if rc == 0:
                print("Connected to MQTT Broker!")
            else:
                print("Failed to connect, return code %d\n", rc)
        self.client = mqtt_client.Client(mqtt_client.CallbackAPIVersion.VERSION1, id)
        self.client.username_pw_set(MQTT_BROKER_USERNAME, MQTT_BROKER_PASSWORD)
        self.client.on_connect = on_connect
        self.client.connect(MQTT_BROKER_HOST, int(MQTT_BROKER_PORT))
        self.message = ""       # Message to send to broker
        self.feedKey = feedKey  # Feed to send to 
    
    def custom_broker(self, id, broker, port, username, password, message, feedKey):
        def on_connect(client, userdata, flags, rc):
            if rc == 0:
                print("Connected to MQTT Broker!")
            else:
                print("Failed to connect, return code %d\n", rc)
        self.client = mqtt_client.Client(mqtt_client.CallbackAPIVersion.VERSION1, id)
        self.client.username_pw_set(username, password)
        self.client.on_connect = on_connect
        self.client.connect(broker, port)
        self.message = message
        self.feedKey = feedKey

    
    def publishMessage(self, topic, value):
        message = {
            "feedKey" : self.feedKey,
            "value": str(value)
        }
        message = json.dumps(message)
        result = self.client.publish(topic, message)
        if (result[0] == 0):
            print("Publish Success")
            return message
        else:
            print("Failed")
            return None    

    def subscribeMessage(self, topic):
        def on_message(client, userdata, msg):
            print(f"Received `{msg.payload.decode()}` from `{msg.topic}` topic")
            self.message = f"{msg.payload.decode()}"

        self.client.subscribe(topic)
        self.client.on_message = on_message
        return self.message

    def forever_loop(self):
        self.client.loop_forever()

    def start_loop(self):
        self.client.loop_start()
    
    def stop_loop(self):
        self.client.loop_stop


