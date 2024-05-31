const express = require('express');
const router = express.Router();
const scheduleService = require('../services/schedule');

// route: '/schedule'

router.get('/', (req, res) => {
    scheduleService.getAllSchedule().then((rows) => {
        res.json(rows);
    })
})

router.get('/:feedKey/:id', (req, res) => {
    scheduleService.getScheduleOfFeed(
        req.params.feedKey,
        req.params.id,
    ).then((rows) => {
        res.json(rows);
    });
});

router.put('/:feedKey/:id', (req, res) => {
    scheduleService.updateScheduleOfFeed(
        req.params.feedKey,
        req.params.id,
        req.body.time_on,
        req.body.time_off)
        .then((result) => {
            res.status(result.status).json(result);
        });
})

router.post('/:feedKey/createSchedule', (req, res) => {
    scheduleService.createScheduleForFeed(req.params.feedKey, req.body).then((result) => {
        res.status(result.status).json(result);
    });
})

router.delete('/deleteSchedule/:id', (req, res) => {
    scheduleService.deleteSchedule(req.params.id).then((result) => {
        res.status(result.status).json(result);
    });
});

module.exports = router;