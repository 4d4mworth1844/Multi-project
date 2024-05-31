const pool = require('../database');
const mqtt = require('mqtt');

async function getResult() {
    const [rows] = await pool.query('select * from result');
    return rows;
}

async function updateResult(status) {
    const [row] = await pool.query('call updateResult(?);', [status]);
    return row[0][0];
}

async function subscribeResult() {
    const clientId = `mqtt_${Math.random().toString(16).slice(3)}`;                                 // client ID
    const connectUrl = `mqtt://${process.env.MQTT_BROKER_HOST}:${process.env.MQTT_BROKER_PORT}`;    // mqtt broker url
    const topic = process.env.AI_CHANNEL;                                                         // topic to subcribe
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
    client.on('message', (topic, payload) => {
        console.log('Received Message:', topic, payload.toString());
        dataMessage = payload.toString();

        var dataObject = JSON.parse(dataMessage);
        console.log(dataObject);                            // Convert Json to Object 
        updateResult(dataObject["status"]); // update new data to database 
        console.log("Success");
    })
}

module.exports = { getResult, updateResult, subscribeResult }
