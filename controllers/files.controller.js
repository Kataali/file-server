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


module.exports = router;