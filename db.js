const mysql = require("mysql2/promise")

const mysqlpool = mysql.createPool({
    host:'localhost',
    user:'root',
    password:'mySqlPassword@123',
    database:'amali_db'
})


module.exports = mysqlpool

