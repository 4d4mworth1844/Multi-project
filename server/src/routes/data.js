const express = require('express');
const router = express.Router();
const dataService = require('../services/data');

router.get('/:feedKey', (req, res) => {
    dataService.getMostRecentData(req.params.feedKey).then((data) => {
        res.json(data[0]);
    })
});

router.post('/createData',(req, res)=>{
    dataService.postNewData(req.body.feedKey, req.body.value).then((result) => {
        res.json(result);
    })
});

module.exports = router;