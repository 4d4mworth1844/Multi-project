from mqtt import FARM_MQTT
import random
import time
topic = "/mqtt/feed"

def run():
    temperature = FARM_MQTT("button001")
    # temperature.start_loop()
    # i = 0
    # while (i < 6):
    #     time.sleep(5)
    #     value = random.randint(20, 35)
    #     temperature.publishMessage(topic, value)
    #     i += 1
    # temperature.stop_loop()
    message = temperature.subscribeMessage(topic)
    print(message)
    temperature.forever_loop()

if __name__ == "__main__":
    run()
