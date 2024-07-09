const { Client } = require('pg');
const dotenv = require("dotenv");
dotenv.config();

const myPostgresPool = new Client({
    host: process.env.PSQL_HOST,
    user: process.env.PSQL_USER,
    port: process.env.PSQL_PORT,
    password: process.env.PSQL_PASSWORD,
    database: process.env.PSQL_DATABASE,
    
});

module.exports = myPostgresPool


