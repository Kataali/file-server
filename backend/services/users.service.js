const db = require("../databasepg");
const bcrypt = require("bcrypt");
const saltRounds = 10;
const nodemailer = require("nodemailer");

// Insert new user into database
module.exports.addUser = async (obj) => {
    const email = obj.email;
    const password = obj.password;
    // console.log(email, password);
    const id = (Date.now() * Math.random()).toString().substring(0, 10);
    bcrypt.hash(password, saltRounds, async (err, hashedPassword) => {
        if(err){
            throw "Error Hashing Password";
        }
        const response = await db.query('INSERT INTO users(id, email, password) VALUES ($1, $2, $3)', [id, email, hashedPassword])
            .catch(e => { throw "database query error" });
        return response;
    })
         
}

//Get password from the Database
module.exports.logIn = async(email, password) => {
    const response = await db.query("SELECT * FROM users WHERE email = $1", [email])
        .catch(e => { console.log(e); throw "database query error" });
        if (response.rows.length > 0){
            const hashedPassword = response.rows[0].password;
            if(bcrypt.compareSync(password, hashedPassword)){
                return response.rows;
            }
            else
                throw "Failed to login";
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

// Reset Password
module.exports.resetPassword = async (obj, email) => {
    const newPassword = obj.newPassword.trim();
    console.log(newPassword);
    console.log(email);
    bcrypt.hash(newPassword, saltRounds, async (err, hashedPassword) => {
            if (err) {
                throw "Error Hashing Password";
            }
            const response = await db.query("UPDATE users SET password = $1 WHERE email = $2", [hashedPassword, email])
            .catch(e => { throw "database query error" });
            console.log(response)
            return response;
        })
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

// Send OTP
module.exports.sendOtp = async(obj) => {
    email = obj.email
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: "muhammadismaaiil360@gmail.com",
            pass: "yikl mmak mmmb zfde"
        }
      });
      
    const otpCode = Math.floor(1000 + Math.random() * 9000);
    const mailOptions = {
        from: "muhammadismaaiil360@gmail.com",
        to: email,
        subject: "Amali File Server",
        text: `Your OTP code is ${otpCode}.`,
    };

    await transporter.sendMail(mailOptions)
    .catch(error => {
            console.log(error)
            throw error;
        })
        return otpCode;
}

// Verify OTP
module.exports.verifyOtp = async(otp, obj) =>{
    const code = parseInt(obj.code)
    try {
        if(code === otp){
        return true;
    }
    } catch (error) {
        throw error;
    }
    return false; 
}

// Delete User from Database 
module.exports.deleteUser = async (userId) => {
     const response =  await db.query("DELETE FROM users WHERE id = $1", [userId])
        .catch(e => { throw e })
    return response;
}