
import time
from uart import *
import paho.mqtt.client as mqtt

# schedule = "id,12:00,13:00"

list_schedule = [] # danh sach lich tuoi nuoc
auto_bump = 0 # may bom theo gio
auto_bump_on = 0 # may bom dang bat

def update_auto_bump(data):
    global auto_bump
    if data == "1" :
        auto_bump = 1
        print("tu dong tuoi : bat")
    elif data == "0" :
        auto_bump = 0
        print("tu dong tuoi : tat")

def new_schedule(time_on, time_off, id) :
    # receive_mess = mess
    # receive_mess = receive_mess.replace("[", "")
    # receive_mess = receive_mess.replace("]", "")
    # # receive_mess = receive_mess.replace("\"", "")
    # data = receive_mess
    # data = data.split(",") # data[0] = id , data[1] = time on
    #                             #data[2] = time off
    time_on = time_on.replace(":", "")
    time_off = time_off.replace(":", "")
    schedule = [id, time_on, time_off]
    global list_schedule
    if len(list_schedule) != 0:
        for i in range(len(list_schedule)):
            # print()
            if (list_schedule[i])[0] == schedule[0]:
                break
            if(i == (len(list_schedule)-1)) :
                list_schedule.append(schedule)
    else:
        list_schedule.append(schedule)
    print(list_schedule)



def check_schedule(client) :
    global auto_bump
    global auto_bump_on
    if auto_bump == 1:
        global list_schedule
        currTime = time.localtime() # 0: year, 1 : month, 2 : day 
                                    # 3 : hour , 4 : min, 5 : sec
        curr_hr = int(currTime[3]) 
        curr_min = int(currTime[4]) 
        currTime_new = curr_hr*60 + curr_min
        for i in range(len(list_schedule)):
            time_on = (list_schedule[i])[1]
            time_off = (list_schedule[i])[2]
            hr_on = int(time_on[0:2])
            min_on = int(time_on[2:4])
            hr_off = int(time_off[0:2])
            min_off = int(time_off[2:4])

            time_on_new = hr_on*60 + min_on
            time_off_new = hr_off*60 + min_off
        
            if (time_on_new <= time_off_new):
                if (time_on_new <= currTime_new < time_off_new):
                    print("bat may bom")
                    writeACK("MB1")
                    server_turn_on_bump(client)
                    auto_bump_on = 1
                    
            elif (time_on_new > time_off_new) :
                if (time_on_new <= currTime_new) | ( currTime_new  < time_off_new ) :
                    print("bat may bom")
                    writeACK("MB1")
                    server_turn_on_bump(client)
                    auto_bump_on = 1

            if (currTime_new  == time_off_new) & (auto_bump_on == 1):
                print("tat may bom")
                writeACK("MB0")
                server_turn_off_bump(client)
                auto_bump_on = 0


def delete_schedule(id) : 
    global list_schedule
    for i in range(len(list_schedule)):
        # print()
        if (list_schedule[i])[0] == id:
            print("deleted")
            list_schedule.pop(i)
            print(list_schedule)
            break