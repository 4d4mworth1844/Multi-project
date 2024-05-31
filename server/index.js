const express = require('express');
const app = express();
const port = 3000;
const cors = require('cors');
const feedRouter = require('./src/routes/feeds');
const dataRouter = require('./src/routes/data');
const scheduleRouter = require('./src/routes/schedule');
const resultRouter = require('./src/routes/result');

const dataSubscriber = require('./src/services/data')
const feedSubscriber = require('./src/services/feeds')
const resultSubscriber = require('./src/services/result')
const scheduleSubscriber = require('./src/services/schedule')

app.use(express.json());
app.use(express.urlencoded({
    extended: true,
}));
app.use(cors({
    origin: '*',
}))


app.get('/', (req, res) => {
    res.send('Welcome');
});

app.use('/feeds', feedRouter);
app.use('/data', dataRouter);
app.use('/schedule', scheduleRouter);
app.use('/result', resultRouter);
//MQTT
dataSubscriber.subscribeData();
feedSubscriber.subscribeFeed();
feedSubscriber.subcribeAutomation();
resultSubscriber.subscribeResult();
scheduleSubscriber.subscribeSchedule(); 

app.listen(port, () => console.log('listening on port ' + port));
