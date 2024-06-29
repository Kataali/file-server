const express = require("express");
const multer = require("multer");
const path = require("node:path");

router = express.Router();

const service = require("../services/files.service");
const client = require("../databasepg");

// storage using multer
var storage = multer.diskStorage({
    destination: function(req, file, cb){
        cb(null, 'files');
    },
    filename: function (req, file, cb) {
        cb(null, `${file.fieldname}-${Date.now()}${path.extname(file.originalname)}`);
    }
})

var upload = multer({storage: storage});


// Upload file
router.post("/file-upload", upload.single('file'), async(req, res) => {
    const result = await service.uploadFile(req.body, req.file);
    res.status(200).send(result);
})


// Get all files
router.get("/all-files", async(req, res) => {
    const users = await service.getFiles();
    console.log(users.rows);
    res.send(users.rows);
})

// Download file
router.get("/download/:title", async(req, res) => {
    const filePath = path.join(__dirname, "../files/");
    const title = req.params.title;
    var fileName = await service.getFile(title);
    fileName = fileName["file"];
    res.download(`${filePath}${fileName}`);
})

// Email File
router.post("/mail/:title", async(req, res) => {
    const email = req.body.email;
    const title = req.params.title;
    var fileName = await service.getFile(title);
    fileName = fileName["file"];
    var result = await service.emailFile(email, fileName, title);
    res.status(200).send({message: `File sent to ${email} successfully`},);
})

// Search Database for a keyword
router.get("/search/:keyword", async(req, res) => {
    const keyword = req.params.keyword;
    const searchResults = await service.searchForFile(keyword);
    res.status(200).send(searchResults);
})

module.exports = router;