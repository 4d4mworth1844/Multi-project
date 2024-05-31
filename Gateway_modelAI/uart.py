import serial.tools.list_ports
import json


def getPort():
    ports = serial.tools.list_ports.comports()
    N = len(ports)
    commPort = "None"
    for i in range(0, N):
        port = ports[i]
        strPort = str(port)
        if "USB-SERIAL CH340" in strPort:
            splitPort = strPort.split(" ")
            commPort = (splitPort[0])
    return "COM5"
    # return commPort

def server_tempature(client, value):
    message = {
                "feedKey": "sensor001",
                "value": str(value)
            }
    client.publish("/mqtt/data", json.dumps(message))

def server_wet(client, value):
    message = {
                "feedKey": "sensor002",
                "value": str(value)
            }
    client.publish("/mqtt/data", json.dumps(message))

def server_light(client, value):
    message = {
                "feedKey": "sensor003",
                "value": str(value)
            }
    client.publish("/mqtt/data", json.dumps(message))    # anh sang


def server_turn_on_bump(client):
    message = {
                "feedKey": "button003",
                "status": 1
            }
    client.publish("/mqtt/feed", json.dumps(message)) # may bom bat

def server_turn_off_bump(client):
    message = {
                    "feedKey": "button003",
                    "status": 0
                }
    client.publish("/mqtt/feed", json.dumps(message))    # may bom tat
def server_turn_on_fan(client):
    message = {
        "feedKey": "button001",
        "status": 1
    }
    client.publish("/mqtt/feed", json.dumps(message))    # quat bat

def server_turn_off_fan(client):
    message = {
                "feedKey": "button001",
                "status": 0
            }
    client.publish("/mqtt/feed", json.dumps(message))    # quat tat

def server_turn_on_light(client):
    message = {
                "feedKey": "button002",
                "status": 1
            }
    client.publish("/mqtt/feed", json.dumps(message))    # den bat

def server_turn_off_light(client):
    message = {
                "feedKey": "button002",
                "status": 0
            }
    client.publish("/mqtt/feed", json.dumps(message))    # den tat



def processData(client,data):
    data = data.replace("!", "")
    data = data.replace("#", "")
    splitData = data.split(":")
    global ack_from_yolo
    ack_from_yolo = splitData[0]
    ack_from_yolo = data.replace(" ", "")
    print(splitData)
    if (len(splitData) > 1):
        if splitData[0] == "T": # nhiet do
            server_tempature(client, splitData[1])

        if splitData[0] == "W":
            server_wet(client, splitData[1])

        if splitData[0] == "L":
            server_light(client, splitData[1])

        if splitData[0] == "BON":
            server_turn_on_bump(client)

        if splitData[0] == "BOFF":
            server_turn_off_bump(client)

        if splitData[0] == "QON":
            server_turn_on_fan(client)
 
        if splitData[0] == "QOFF":
            server_turn_off_fan(client)

        if splitData[0] == "DON":
            server_turn_on_light(client)
 
        if splitData[0] == "DOFF":
            server_turn_off_light(client)

        if splitData[0] == "AI1":
            message = {
                "status": str("khong co cay")
            }
            client.publish("/mqtt/ai_result", json.dumps(message))    
        if splitData[0] == "AI2":
            message = {
                "status": str("khong co sau benh")
            }
            client.publish("/mqtt/ai_result", json.dumps(message))    

            
mess = ""
if getPort() != "None":
    ser = serial.Serial( port=getPort(), baudrate=115200)
    print(ser)

def readSerial(client):
    bytesToRead = ser.inWaiting()
    if (bytesToRead > 0):
        global mess
        mess = ser.read(bytesToRead).decode("UTF-8")
        while ("#" in mess) and ("!" in mess):
            start = mess.find("!")
            end = mess.find("#")
            data = mess[start:end]
            processData(client, data)
            if (end == len(mess)):
                mess = ""
            else:
                mess = mess[end+1:]

# def writeData(data):
#     mes_list.append(data)

def writeACK(data):
    ser.write((str(data)).encode())

# def sendData():
#     global mes_list
#     global ack_from_yolo
#     if(len(mes_list) != 0):
#         if flag_to_send == 1:
#             print(mes_list[0])
#             flag_to_send = 0
#             ser.write((str(mes_list[0])).encode())
#         if ack_from_yolo == mes_list[0]:
#             mes_list.pop(0)
#             flag_to_send = 1
#             ack_from_yolo = 0
            