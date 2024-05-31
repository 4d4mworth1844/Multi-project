import paho.mqtt.client as mqtt
import sys
import random
import time
from uart import *
from newAI import *
from schedule import *

DATA_CHANNEL = "/mqtt/data"
FEED_CHANNEL = "/mqtt/feed"
SCHEDULE_CHANNEL = "/mqtt/schedule"
AUTO_FEED = "/mqtt/automation"


MQTT_SERVER = "broker.emqx.io"
MQTT_PORT = 1883
MQTT_USERNAME = "emqx"
MQTT_PASSWORD = "public" 
MQTT_TOPIC = [DATA_CHANNEL, FEED_CHANNEL, SCHEDULE_CHANNEL, AUTO_FEED]


def mqtt_connected(client, userdata, flags, rc, properties):
    if rc == 0:
        print("Connected successfully!!")
        for item in MQTT_TOPIC:
            client.subscribe(item)
    else:
        print("Connection failed with error code " + str(rc))

def mqtt_subscribed(client, userdata, mid, reason_code_list, properties):
    for i in range(0, len(reason_code_list) -1 ):
        if reason_code_list[i].is_failure:
            print(f"Broker rejected you subscription: {reason_code_list[i]}")
        else:
            print("Subscribed to Topic!!!")

def mqtt_disconected(client):
    print ("Ngat ket noi ...")
    sys.exit(1)

def mqtt_message(client, userdata, msg):
    receive_mess = f"{msg.payload.decode()}"
    print(receive_mess)
    print(msg.topic)
    receive_mess = receive_mess.replace("[", "")
    receive_mess = receive_mess.replace("]", "")
    receive_mess = receive_mess.replace("\"", "")
    receive_mess = receive_mess.replace("{", "")
    receive_mess = receive_mess.replace("}", "")
    receive_mess = receive_mess.replace(":", "")
    receive_mess = receive_mess.replace("scheduleId", "")
    receive_mess = receive_mess.replace("time_on", "")
    receive_mess = receive_mess.replace("time_off", "")

    data = receive_mess
    data = data.split(",")  


    if(msg.topic == "/mqtt/feed") :
        if(data[0]=="button003"):   # dieu khien may bom
            if(data[1] == "1"):
                writeACK("MB1")
            if(data[1] == "0"):
                writeACK("MB0")
        elif(data[0]=="button001"):   # dieu khien quat
            if(data[1] == "1"):
                writeACK("Q1")
            if(data[1] == "0"):
                writeACK("Q0")
        elif(data[0]=="button002"):   # dieu khien den
            if(data[1] == "1"):
                writeACK("D1")
            if(data[1] == "0"):
                writeACK("D0")
    if(msg.topic == "/mqtt/automation") :
        if(data[0]=="button002"):   # den tu dong
            if(data[1] == "1"):
                writeACK("DA1")
            if(data[1] == "0"):
                writeACK("DA0")
        elif(data[0]=="button001"):   # quat tu dong
            if(data[1] == "1"):
                writeACK("QA1")
            if(data[1] == "0"):
                writeACK("QA0")
        elif(data[0]=="button003"):   # may bom tu dong
            if(data[1] == "1"):
                writeACK("BA1")
            if(data[1] == "0"):
                writeACK("BA0")
        elif(data[0]=="button004"):   # may bom theo gio
            update_auto_bump(data[1])
    if(msg.topic == "/mqtt/schedule") :
        if(data[0]=="button003"):   # hen gio may bom(khi lay thong tin khoi tao)
            new_schedule(str(data[2]), str(data[3]), str(data[1]))
        if(data[0]=="Schedule"):   # hen gio may bom
            new_schedule(str(data[1]), str(data[2]), str(data[3]))
        if(data[0]=="delete") :
            delete_schedule(str(data[1])) 
    




mqttClient = mqtt.Client(callback_api_version=mqtt.CallbackAPIVersion.VERSION2)
mqttClient.username_pw_set(MQTT_USERNAME, MQTT_PASSWORD)
mqttClient.connect(MQTT_SERVER, int(MQTT_PORT), 60)

#Register mqtt events
mqttClient.on_connect = mqtt_connected
mqttClient.on_subscribe = mqtt_subscribed
mqttClient.on_disconnect = mqtt_disconected
mqttClient.on_message = mqtt_message


mqttClient.loop_start()

time_sleep = 0.2
counter_AI = (1/time_sleep)*5 # 5s
counter_print = (1/time_sleep)*3 # 3s

counter_schedule = (1/time_sleep)*10 # 10s
counter_request = (1/time_sleep)*15 #15s
requested = 0

ai_result = 0
pre_ai_result = ai_result


while True:


    if (counter_request <= 0) & (requested == 0):
        mqttClient.publish("/mqtt/feed", "request")   ## lay lich ban dau  
        mqttClient.publish("/mqtt/feed", "request")   ## lay lich ban dau  

        mqttClient.publish("/mqtt/automation", "request")   ## lay lich ban dau  
        mqttClient.publish("/mqtt/automation", "request")   ## lay lich ban dau  

        mqttClient.publish("/mqtt/schedule", "request")   ## lay lich ban dau  
        mqttClient.publish("/mqtt/schedule", "request")   ## lay lich ban dau
        requested = 1  
    else:
        counter_request = counter_request - 1

    readSerial(mqttClient)
    if(counter_print <= 0):
        counter_print = (1/time_sleep)*3
        print("Client is running...")
    else:
        counter_print = counter_print - 1

    if (counter_AI <= 0) :
        counter_AI = (1/time_sleep)*10
        ai_result = image_detect()
        if ai_result !=  pre_ai_result:
            message = {
                "status": str(ai_result)
            }
            mqttClient.publish("/mqtt/ai_result", json.dumps(message))    # quat bat
        pre_ai_result = ai_result
    else:
        counter_AI = counter_AI - 1

    if(counter_schedule <= 0):
        counter_schedule = (1/time_sleep)*5 # 5s
        check_schedule(mqttClient)
    else:
        counter_schedule = counter_schedule - 1

    time.sleep(time_sleep)

mqttClient.loop_stop()
    