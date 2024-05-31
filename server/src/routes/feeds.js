const express = require('express');
const router = express.Router();
const feedService = require('../services/feeds');


router.get('/', (req, res) => {
    feedService.getAllFeed().then((feedKeys) => {
        res.json(feedKeys);
    });
});


router.get('/sensors', (req, res) => {
    feedService.getAllSensor().then((sensors) => {
        res.json(sensors);
    });
});

router.get('/buttons', (req, res) => {
    feedService.getAllButton().then((button) => {
        res.json(button);
    });
});

router.get('/:feedKey', (req, res) => {
    feedService.getFeed(req.params.feedKey).then((data) => {
        res.json(data);
    })
});

router.post('/updateStatus/:feedKey', (req, res) => {
    feedService.updateStatus(req.params.feedKey,parseInt(req.body.newStatus)).then((data) => {
        console.log(parseInt(req.body.newStatus));
        res.json(data);
    });
})

router.put('/updateAutomation/:feedKey', (req, res) => {
    feedService.updateAutomation(req.params.feedKey, parseInt(req.body.automated))
                .then((data) => {
                    res.json(data); 
                })  
})

module.exports = router;
