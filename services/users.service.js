const db = require('../db')


// SignUp
module.exports.addUser = async(obj) => {
    const id = Date.now().toString(36) + Math.random().toString(36).substring(13);
    const response = await db.query("INSERT INTO users(id, email, password) VALUES (?, ?, ?)", [id, obj.email, obj.password])
        .catch(e => console.log(e))
        return response;
}

// Login
module.exports.logIn = async(email) => {
    const response = await db.query("SELECT password FROM users WHERE email = ?", [email])
        .catch(e => console.log(e))
        return response;
}

