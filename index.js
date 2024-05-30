const express = require("express");
const bodyparser = require("body-parser");
const db = require("./db");
const cors = require("cors");
usersRoute = require("./controllers/users.controller");

// App config
const app = express();

// middleware config
app.use(bodyparser.json());
app.use(cors());
app.use('/amali-api/users', usersRoute);

// DB connection check
// To Check if the database is actually connected or not since there is no way of checking before creating the pool
db.query("Select 1")
.then(() => {console.log("DB connection successful")
    // Start server
    app.listen(3000, 
        () => console.log("amali express server started at port 3000"))
})
.catch(e => console.log(e + "DB connection unsuccessful"));


