const express = require("express");
const bodyparser = require("body-parser");
const client = require("./databasepg");
const cors = require("cors");
const multer = require('multer');
usersRoute = require("./controllers/users.controller");
filesRoute = require("./controllers/files.controller");
statsRoute = require("./controllers/stats.controller");


// App config
const app = express();

// middleware config
app.use(bodyparser.json());
app.use(cors());
app.use('/amali-api/users', usersRoute);
app.use('/amali-api/files', filesRoute);
app.use('/amali-api/file-stats', statsRoute);
app.use(bodyparser.urlencoded({extended: true}));
app.use('/files', express.static('files'));

// Postgres DB connection check
client.connect()
.then(async () => {
     client.query('SELECT version(), current_database(), current_schemas(false)', (err, res) => {
        console.log(res.rows[0])
    })
    console.log("Successfully connected to amali postgres database")
    // Start server
    app.listen(3000, 
        () => console.log("amali express server started at port 3000"))
})
.catch((err) => {console.log("Unable to connect to database", err)})


