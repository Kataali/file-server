const express = require("express")

router = express.Router();

const service = require("../services/users.service")

// API end point
// http://localhost:3000/amali-api/users

// SignUp
router.post('/signup/', async (req, res) => {
    const result = await service.addUser(req.body)
    // res.status(200).send("User successfully added")
    res.send(result)
}) 

// Login
router.get('/login/:email', async (req, res) => {
    const userPassword = await service.logIn(req.params.email)
    if (userPassword.length == 0){
        res.status(404).json("No User with given email : " + req.params.email)
    }
    else
        res.send(userPassword)
}) 



module.exports = router;