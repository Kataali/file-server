const db = require("../databasepg")

// Add file to the Database
module.exports.uploadFile = async(obj, chosenFile) => {
    const file = chosenFile;
    const title = obj.title;
    const description = obj.description;
    console.log(file);
    console.log(title);
    console.log(description);
    const response = await db.query("INSERT into files(title, description, file) VALUES($1, $2, $3)", [title, description, file.filename])
    .catch(e => console.log(e));
    return response;
}

// Get All Files from Database
module.exports.getFiles = async() => {
    const response = await db.query('SELECT * FROM files ORDER BY id ASC')
    .catch(e => console.log(e))
        return response;
  }