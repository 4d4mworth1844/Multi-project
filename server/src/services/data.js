const pool = require('../database');
const mqtt = require('mqtt')

async function getMostRecentData(feedKey) {
    sql = `SELECT * FROM data WHERE feedKey = ? ORDER BY time_ DESC LIMIT 1;`;
    const [rows] = await pool.query(sql, [feedKey]);
    return rows;
}

async function postNewData(feedKey, value) {
    sql = `INSERT INTO data(\`value\`,\`feedKey\`) VALUES (?,?)`;
    const [result] = await pool.query(sql, [value, feedKey]);
    return result;
}

/**
 * MQTT Data client
 */
async function subscribeData() {
    const clientId = `mqtt_${Math.random().toString(16).slice(3)}`;                                 // client ID
    const connectUrl = `mqtt://${process.env.MQTT_BROKER_HOST}:${process.env.MQTT_BROKER_PORT}`;    // mqtt broker url
    const topic = process.env.DATA_CHANNEL;                                                         // topic to subcribe
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

        /**
         * Insert new data into Database
         */
        var dataObject = JSON.parse(dataMessage);                            // Convert Json to Object 
        console.log(dataObject);
 	postNewData(dataObject["feedKey"], parseFloat(dataObject["value"])); // post new data to database 
        console.log("Success");
    })
}

module.exports = { getMostRecentData, postNewData, subscribeData };
