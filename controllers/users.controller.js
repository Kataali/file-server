const express = require("express");
router = express.Router();
const service = require("../services/users.service");
const client = require("../databasepg");


// API end point
// http://localhost:3000/amali-api/users

// SignUp
router.post('/signup', async (req, res) => {
    const result = await service.addUser(req.body)
    // res.status(200).send("User successfully added")
    res.send(result)
}) 

// Login
router.get('/login/:email', async(req, res) => {
    const {email} = req.params;
    const result = await service.logIn(email, req.body);
    res.send({"message": result});
}) 

// Update User Password
router.put('/update-password/:email', async (req, res) => {
    const result = await service.updatePassword(req.body, req.params.email)
    res.status(200).send(result)
})


// Get all users
router.get("/users", async(req, res) => {
    const users = await service.getUsers();
    console.log(users.rows)
    res.send(users.rows)
})



module.exports = router;