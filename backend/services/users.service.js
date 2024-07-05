const db = require("../databasepg");
const bcrypt = require("bcrypt");
const saltRounds = 10;

// Insert new user into database
module.exports.addUser = async (obj) => {
    const email = obj.email.trim();
    const password = obj.password.trim();
    const id = (Date.now() * Math.random()).toString().substring(0, 10);
    bcrypt.hash(password, saltRounds, async (err, hashedPassword) => {
        if(err){
            throw "Error Hashing Password";
        }
        const response = await db.query('INSERT INTO users(id, email, password) VALUES ($1, $2, $3)', [id, obj.email, hashedPassword])
            .catch(e => { throw "database query error" });
        return response;
    })
         
}

//Get password from the Database
module.exports.logIn = async(email, obj) => {
    const password = obj.password.trim();
    const response = await db.query("SELECT * FROM users WHERE email = $1", [email])
        .catch(e => { throw "database query error" });
        if (response.rows.length > 0){
            const hashedPassword = response.rows[0].password;
            if(bcrypt.compareSync(password, hashedPassword)){
                return "Login Successful";
            }
            else
                return "Failed to login";
        }else
            throw "Account not found";
        
}


// Get All Users from the Database
 module.exports.getUsers = async() => {
     const response = await db.query('SELECT * FROM users ORDER BY id ASC')
         .catch(e => "database query error");
        return response;
  }


// Change Password in Database
module.exports.updatePassword = async(obj, email) => {
    const password = obj.newPassword.trim();
    const enteredValue = obj.enteredPassword.trim();
    const emailValue = email.trim();

    const passwordResponse = await db.query("SELECT password FROM users WHERE email = $1", [emailValue])
        .catch(e => { throw "Error querying database for password" });
    const currentValue = passwordResponse.rows[0].password;
    if (bcrypt.compareSync(enteredValue, currentValue)) {
        bcrypt.hash(password, saltRounds, async (err, hashedPassword) => {
            if (err) {
                throw "Error Hashing Password";
            }
            const response = await db.query("UPDATE users SET password = $1 WHERE email = $2", [hashedPassword, email])
                .catch(e => { throw "database query error" });
            return response;
        })
    }
    else
        throw "Invalid Password";


    
}

// Verify Password
module.exports.verifyPassword = async (enteredPassword, currentPassword, email) => {
     const enteredValue = enteredPassword.trim();
    const currentValue = currentPassword.trim();
    const emailValue = email.trim();

    const response =  await db.query("SELECT password FROM users WHERE email = $1", [emailValue])
        .catch(e => { throw e })
    
    if (enteredValue === currentValue)
        return true;
    return false;
}

