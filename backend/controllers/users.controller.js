const express = require("express");
router = express.Router();
const service = require("../services/users.service");
const client = require("../databasepg");

var otp = 0;

// API end point
// http://localhost:3000/amali-api/users

// SignUp
router.post('/signup', async (req, res) => {
    try {
        const result = await service.addUser(req.body)
    res.send(result)
    // res.send(result)
    } catch (error) {
        res.status(400).send(error);
    }
}) 

// Login
router.post('/login/:email', async (req, res) => {
    try {
        const email = req.params.email;
        const result = await service.logIn(email, req.body);
        console.log(result);
    res.status(200).send(result);
    } catch (error) {
        res.status(400).send(error);
    }   
}) 

// Reset Password
router.put('/reset-password/:email', async (req, res) => {
    try {
        const email = req.params.email;
        const result = await service.resetPassword(req.body, email);
        res.status(200).send(result);
    } catch (error) {
        res.status(400).send(error);
    }
})

// Update User Password
router.put('/update-password/:email', async (req, res) => {
    try {
        const result = await service.updatePassword(req.body, req.params.email)
        res.status(200).send(result);
    }
    catch (error) {
        res.status(400).send(error);
    }
    
})

// Get all users
router.get("/all", async (req, res) => {
    try {
        const users = await service.getUsers();
    res.status(200).send(users.rows)
    } catch (error) {
        res.status(400).send(error);
    }
    
})

// Send email OTP
router.post('/send-otp', async(req, res) => {
    var code = await service.sendOtp(req.body)
    .catch(e => {res.status(500).send({ message: 'Failed to send OTP' },)})
    otp = code
    res.status(200).send({sentotp: `${code}`, message: 'OTP sent successfully'},);
    // console.log(code);
});

// Verify OTP
router.post('/verify-otp', async(req, res) => {
    const response = await service.verifyOtp(otp, req.body)
    res.status(200).send({verified: `${response}`})
})


module.exports = router;