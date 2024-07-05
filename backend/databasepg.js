const {Client} = require('pg');

const myPostgresPool = new Client({
    host: "localhost",
    user: "postgres",
    port: 5432,
    password: "Sumaila@123",
    database: "amali_db"
});

module.exports = myPostgresPool


