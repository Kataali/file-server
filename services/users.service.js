const db = require("../databasepg")

// Insert new user into database
module.exports.addUser = async (obj) => {
    const id = (Date.now() * Math.random()).toString().substring(0,10);
         await db.query('INSERT INTO users(id, email, password) VALUES ($1, $2, $3)', [id, obj.email, obj.password])
        .catch(e => console.log(e))
        return response;
}

//Get password from the Database
module.exports.logIn = async(email) => {
    const response = await db.query("SELECT password FROM users WHERE email = $1", [email])
        .catch(e => console.log(e))
        return response;
}


// Get All Users from the Database
 module.exports.getUsers = async() => {
    const response = await db.query('SELECT * FROM users ORDER BY id ASC')
    .catch(e => console.log(e))
        return response;
  }


// Change Password in Database
module.exports.updatePassword = async(obj, email) => {
    const response = await db.query("UPDATE users SET password = $1 WHERE email = $2", [obj.password, email])
        .catch(e => console.log(e))
        return response;
}

