const db = require("../databasepg");
const nodemailer = require("nodemailer");
const path = require("node:path")
// const nodemailerConfig = require("../nodemailer.config")

// Add file to the Database
module.exports.uploadFile = async(obj, chosenFile) => {
    const file = chosenFile;
    const title = obj.title.trim();
    const description = obj.description.trim();
    const response = await db.query("INSERT into files(title, type, description, uploadedOn, file) VALUES($1, $2, $3, CURRENT_TIMESTAMP, $4)", [title, path.extname(file.filename), description, file.filename])
        .catch(e => {
            throw "database query error";
            
         });
    return file.filename;
}

// Get All Files from Database
module.exports.getFiles = async() => {
    const response = await db.query('SELECT * FROM files ORDER BY uploadedon ASC')
        .catch(e => {
            throw "database query error";
    })
        return response;
}

// Get All Files from Database
module.exports.getFileByPath = async(dbPath) => {
    const response = await db.query('SELECT * FROM files WHERE file = $1', [dbPath])
        .catch(e => {
            throw "database query error";
    })
        return response.rows[0]["id"];
}

// Get file path from Database
module.exports.getFileDbPath = async(dbPath) => {
    const response = await db.query('SELECT file FROM files WHERE title = $1', [dbPath])
        .catch(e => {
            throw "database query error";
        });
        return response.rows[0];
}


// Mail File to address
module.exports.emailFile = async(email, fileName, fileTitle) => {
    const filePath = path.join(__dirname, "../files/");
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: "muhammadismaaiil360@gmail.com",
            pass: "yikl mmak mmmb zfde"
        }
      });
      
    var mailOptions = {
        from: "muhammadismaaiil360@gmail.com",
        to: email,
        subject: "File Request",
        text: `The File you requested, ${fileTitle} is attached below.`,
        attachments: [{filename: fileName, path: `${filePath}${fileName}`}]
    };

    const response = await transporter.sendMail(mailOptions)
    // const response = await nodemailerConfig.transporter.sendMail(mailOptions)
        .catch(e => {
            throw "error sending email";
        });
        return response;
}

// Search database for keyword
module.exports.searchForFile = async(keyword) => {
    const response = await db.query(`SELECT * FROM files WHERE title LIKE $1 OR description LIKE $1`, [`%${keyword.trim()}%`])
        .catch(e => {
            throw ("Failed to search database" + e);   
        });
        return response.rows;
}

// 