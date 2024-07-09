const express = require("express");
router = express.Router();
const service = require("../services/admin.service");

// Admin Login
router.get('/login/:password', async (req, res) => {
    try {
        const password = req.params.password
        const result = await service.logIn(password);
        // console.log(result);
    res.status(200).send(result);
    } catch (error) {
        res.status(400).send(error);
    }   
}) 

// Update Admin Password
router.put('/update-password', async (req, res) => {
    try {
        const result = await service.updatePassword(req.body)
        res.status(200).send(result);
    }
    catch (error) {
        res.status(400).send(error);
    } 
})

module.exports = router;