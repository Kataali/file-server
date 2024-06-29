const db = require("../databasepg")
const bcrypt = require("bcrypt");
const saltRounds = 10;

// Insert new user into database
module.exports.addUser = async (obj) => {
    const email = obj.email.trim();
    const password = obj.password.trim();
    const id = (Date.now() * Math.random()).toString().substring(0,10);
    bcrypt.hash(password, saltRounds, async (err, hashedPassword) => {
        if(err){
            console.log("Error Hashing Password", err);
            return;
        }
        const response = await db.query('INSERT INTO users(id, email, password) VALUES ($1, $2, $3)', [id, obj.email, hashedPassword])
        .catch(e => console.log(e))
        return response;
    })
         
}

//Get password from the Database
module.exports.logIn = async(email, obj) => {
    const password = obj.password.trim();
    const response = await db.query("SELECT * FROM users WHERE email = $1", [email.trim()])
        .catch(e => console.log(e))
        if (response.rows.length > 0){
            const hashedPassword = response.rows[0].password;
            if(bcrypt.compareSync(password, hashedPassword)){
                return "Login Successful";
            }
            else
                return "Failed to login";
        }else
            return "Account not found";
        
}


// Get All Users from the Database
 module.exports.getUsers = async() => {
    const response = await db.query('SELECT * FROM users ORDER BY id ASC')
    .catch(e => console.log(e))
        return response;
  }


// Change Password in Database
module.exports.updatePassword = async(obj, email) => {
    const password = obj.password.trim();
    const response = await db.query("UPDATE users SET password = $1 WHERE email = $2", [password, email.trim()])
        .catch(e => console.log(e))
        return response;
}



