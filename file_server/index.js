const express = require("express");
const bodyparser = require("body-parser");
const client = require("./databasepg");
const cors = require("cors");
const dotenv = require("dotenv");
usersRoute = require("./controllers/users.controller");
filesRoute = require("./controllers/files.controller");
statsRoute = require("./controllers/stats.controller");
adminRoute = require("./controllers/admin.controller");


// Middleware
// App config
const app = express();
dotenv.config();
app.use(bodyparser.json());
app.use(cors({allowedHeaders: ["Origin", 'X-Requested-With', 'Content-Type', 'Accept'], maxAge: 1728000, methods:['POST', 'GET', 'OPTIONS', 'PUT', 'DELETE', 'HEAD'], credentials: true, origin:"*"}));
app.use('/amali-api/users', usersRoute);
app.use('/amali-api/files', filesRoute);
app.use('/amali-api/file-stats', statsRoute);
app.use('/amali-api/admin', adminRoute);
app.use(bodyparser.urlencoded({extended: true}));
app.use('/files', express.static('files'));

const port = process.env.PORT || 3000;


// Postgres DB connection check
client.connect()
.then(async () => {
     client.query('SELECT version(), current_database(), current_schemas(false)', (err, res) => {
        console.log(res.rows[0])
    })
    console.log("Successfully connected to amali postgres database")
    // Start server
    app.listen(port, 
        () => console.log(`amali express server started at port ${port}`))
})
.catch((err) => {console.log("Unable to connect to database", err)})


