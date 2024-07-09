const db = require("../databasepg");
const bcrypt = require("bcrypt");
const saltRounds = 10;

//Get Admin info password from the Database
module.exports.logIn = async(password) => {
    const response = await db.query("SELECT * FROM admin")
        .catch(e => { console.log(e); throw "database query error" });
            const hashedPassword = response.rows[0].password;
            if(bcrypt.compareSync(password, hashedPassword)){
                return response.rows;
            }
            else
                throw "Failed to login";
}

// Change Admin Password in Database
module.exports.updatePassword = async(obj) => {
    const password = obj.newPassword.trim();
        bcrypt.hash(password, saltRounds, async (err, hashedPassword) => {
            if (err) {
                throw "Error Hashing Password";
            }
            const response = await db.query("UPDATE admin SET password = $1", [hashedPassword])
                .catch(e => { throw "database query error" });
            console.log(response);
            return response;
        })
    
}