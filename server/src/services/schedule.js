const pool = require('../database');
const mqtt = require('mqtt');

let response = [];

async function getAllSchedule() {
    sql = 'SELECT * FROM schedule join feed on schedule.feedKey = feed.feedKey;'
    const [rows] = await pool.query(sql);
    response = Array.from(rows); 
    return rows;
}

async function getScheduleOfFeed(feedKey, id) {
    sql = `SELECT * FROM schedule JOIN feed on schedule.feedKey = feed.feedKey WHERE schedule.feedKey = ? AND id = ?;`
    const [rows] = await pool.query(sql, [feedKey, id]);
    return rows[0];
}

async function updateScheduleOfFeed(feedKey, scheduleId, time_on, time_off) {
    sql = `call updateSchedule(?,?,?,?);`
    const [results] = await pool.query(sql, [feedKey, scheduleId, time_on, time_off]); 
    message = []
    if (feedKey === "button003") {
        message.push("Schedule");
    } else {
        message.push(feedKey);
    }
    message.push(time_on);
    message.push(time_off);
    message.push(scheduleId);   
    if (results.affectedRows == 0) {
        return {
            "status": 200,
            "message": "No schedules were updated"
        }
    } else {
        console.log(message);
        publishSchedule(message);
        return {
           // publishSchedule(message);
            "status": 204,
            "message": "Update Successfully"
        }
    }
}

async function createScheduleForFeed(feedKey, reqBody) {
    sql = 'insert into schedule(`time_on`, `time_off`,`feedKey`) values(?,?,?);'
    const [results] = await pool.query(sql, [reqBody.time_on, reqBody.time_off, feedKey]);
    const [result2] = await pool.query("select LAST_INSERT_ID();");
    console.log(result2[0]["LAST_INSERT_ID()"]);
    message = []
    if (feedKey === "button003") {
        message.push("Schedule");
    } else {
        message.push(feedKey);
    }
    message.push(reqBody.time_on);
    message.push(reqBody.time_off);
    message.push(result2[0]["LAST_INSERT_ID()"]);
    if (results.affectedRows == 0) {
        return {
            "status": 200,
            "message": "No schedules were deleted"
        }
    } else {
        publishSchedule(message)
        return {
            "status": 201,
            "message": "Create Successfully"
        }
    }
}

async function deleteSchedule(scheduleId) {
    sql = `delete from schedule where id = ?`;
    const [results] = await pool.query(sql, [scheduleId]);
    message = [];
    message.push("delete"); // ["delete", scheduleId]
    message.push(scheduleId);
    if (results.affectedRows == 0) {
        return {
            "status": 200,
            "message": "No schedules were deleted"
        }
    } else {
   	publishSchedule(message);
        return {
            "status": 204,
            "message": "Delete Successfully"
        }
    }
}

async function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
}


async function subscribeSchedule() {
    const clientId = `mqtt_${Math.random().toString(16).slice(3)}`;                                 // client ID
    const connectUrl = `mqtt://${process.env.MQTT_BROKER_HOST}:${process.env.MQTT_BROKER_PORT}`;    // mqtt broker url
    const topic = process.env.SCHEDULE_CHANNEL;                                                         // topic to subcribe
    // Create a mqtt connection object and configuration of itself
    const client = mqtt.connect(connectUrl, {
        clientId,
        clean: true,
        connectTimeout: 4000,
        username: process.env.MQTT_BROKER_USERNAME,
        password: process.env.MQTT_BROKER_PASSWORD,
        reconnectPeriod: 1000,
    })

    // Subcribe to topic on MQTT broker
    client.on('connect', () => {
        console.log('Connected');
        // subcribe step
        client.subscribe([topic], () => {
            console.log(`Subscribe to topic '${topic}'`)
        });
    })

    let dataMessage;
    client.on('message', async (topic, payload) => {
        console.log('Received Message:', topic, payload.toString());
        dataMessage = payload.toString();

        /**
         * Insert new data into Database
         */
       // var dataObject = JSON.parse(dataMessage);                            // Convert Json to Object 
       // postNewData(dataObject["feedKey"], parseFloat(dataObject["value"])); // post new data to database 
        if (dataMessage === "request") {
            getAllSchedule();  
            var len = response.length; 
            for (var i = 0; i < len; i++) {
                var scheduleObj = {};
                scheduleObj["scheduleId"] = response[i]["id"];
                scheduleObj["time_on"] = response[i]["time_on"];
                scheduleObj["time_off"] = response[i]["time_off"]; 

                message = [];
                message.push(response[i]["feedKey"]);
                message.push(scheduleObj);
                   
                publishSchedule(message); 
                await sleep(200);
	    }
        }
        console.log("Success");
    })
}

async function publishSchedule(scheduleStatus) {
    const clientId = `mqtt_${Math.random().toString(16).slice(3)}`;                                 // client ID
    const connectUrl = `mqtt://${process.env.MQTT_BROKER_HOST}:${process.env.MQTT_BROKER_PORT}`;    // mqtt broker url
    const topic = process.env.SCHEDULE_CHANNEL;                                                         // topic to subcribe
    // Create a mqtt connection object and configuration of itself
    const client = mqtt.connect(connectUrl, {
        clientId,
        clean: true,
        connectTimeout: 4000,
        username: process.env.MQTT_BROKER_USERNAME,
        password: process.env.MQTT_BROKER_PASSWORD,
        reconnectPeriod: 1000,
    })

    // Subcribe to topic on MQTT broker
    client.on('connect', () => {
        console.log('Connected');
        // subcribe step
        // feedStatus is in Json
        client.publish(topic, JSON.stringify(scheduleStatus), { qos: 0, retain: false },
        (error) => {
            if (error) {
                console.log(error); 
            }
        });
    })
}


module.exports = {
    getAllSchedule,
    getScheduleOfFeed,
    updateScheduleOfFeed,
    createScheduleForFeed,
    deleteSchedule,
    subscribeSchedule,
};
