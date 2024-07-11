const express = require("express");
const multer = require("multer");
const path = require("node:path");

router = express.Router();

const service = require("../services/files.service");
const client = require("../databasepg");
const statService = require("../services/stats.service");

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
router.post("/file-upload", upload.single('file'), async (req, res) => {
    try {
        // const dbPath = req.file.filename;
        const result = await service.uploadFile(req.body, req.file);
        const fileId = await service.getFileByPath(result);
        const response = await statService.initFileStats(fileId);
        res.send(response);
    } catch (error) {
        console.log(error);
        res.status(400).send(error);
    }
    
})


// Get all files
router.get("/all", async(req, res) => {
    const files = await service.getFiles();
    // console.log(users.rows);
    res.send(files.rows);
})

// Download file
router.get('/download/:path/:fileId', async (req, res) => {
    const filePath = req.params.path;
    const fileId = req.params.fileId;
    const rootPath = path.join(__dirname, "../files/");
    // Increment Download count
    await statService.incrementDownloadCount(fileId);
    // Download
    res.download(`${rootPath}${filePath}`, async (err) => {
        if (err) {
            // Decrement Download count
            await statService.decrementDownloadCount(fileId);
            console.log("There was a problem downloading file", err);
        }
        else
            console.log("Download completed");
    });

})

// Email File
router.post("/mail/:path", async(req, res) => {
    const email = req.body.email;
    const path = req.params.path;
    const title = req.body.title;
    const fileId = req.body.fileId;
    try {
        // Increment emails sent
    await statService.incrementEmailsSent(fileId);
        var result = await service.emailFile(email, path, title);
        res.status(200).send({message: `File sent to ${email} successfully`},);
    } catch (error) {
        // Decrement Emails sent if they are not zero
        await statService.decrementEmailsSent(fileId);
    }
    
})

// Search Database for a keyword
router.get("/search/:keyword", async(req, res) => {
    const keyword = req.params.keyword;
    const searchResults = await service.searchForFile(keyword);
    res.status(200).send(searchResults);
})

// Delte File
router.delete('/delete/:id', async (req, res) => {
    try {
        fileId = req.params.id;
        const response = await service.deleteFile(fileId);
        res.status(200).send(response);
    } catch (error) {
        res.status(400).send(error);
    }
    
})

module.exports = router;