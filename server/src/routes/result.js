const express = require('express');
const router = express.Router();
const resultService = require('../services/result');

router.get('/', (req, res) => {
    resultService.getResult().then((status) => {
        res.json(status);
    });
});

router.put('/updateResult', (req, res) => {
    resultService.updateResult(req.body.status).then(data => {
        res.json(data); 
    })
}) 
module.exports = router
