const express = require("express");
router = express.Router();
const service = require("../services/users.service");
const client = require("../databasepg");


// API end point
// http://localhost:3000/amali-api/users

// SignUp
router.post('/signup', async (req, res) => {
    try {
        const result = await service.addUser(req.body)
    res.status(200).send(result)
    // res.send(result)
    } catch (error) {
        res.status(400).send(error);
    }
}) 

// Login
router.post('/login/:email', async (req, res) => {
    try {
        const {email} = req.params;
    const result = await service.logIn(email, req.body);
    res.send({"message": result});
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
router.get("/users", async (req, res) => {
    try {
        const users = await service.getUsers();
    res.status(200).send(users.rows)
    } catch (error) {
        res.status(400).send(error);
    }
    
})



module.exports = router;