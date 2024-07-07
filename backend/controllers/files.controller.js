const express = require("express");
const multer = require("multer");
const path = require("node:path");
const cors = require("cors");

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
    console.log(req.file);
    console.log(req.body);
    const result = await service.uploadFile(req.body, req.file);
    res.status(200).send(result);
})


// Get all files
router.get("/all", async(req, res) => {
    const users = await service.getFiles();
    console.log(users.rows);
    res.send(users.rows);
})

// Download file
// router.get("/download/:title", async(req, res) => {
//     const filePath = path.join(__dirname, "../files/");
//     const title = req.params.title;
//     let dbFilePath = await service.getFileDbPath(title);
//     if(dbFilePath){
//         dbFilePath = dbFilePath["file"];

//     // increase download count
//     await statService.incrementDownloadCount(dbFilePath);

    // // Download
    // res.download(`${filePath}${dbFilePath}`, async (err) => {
    //     if(err){
    //         await statService.decrementDownloadCount(dbFilePath);
    //         console.log("There was a problem downloading file", err);
    //     }
    //     else
    //         console.log("Download completed");
    // });
    // }else
    //     res.status(400).send("No file with that title");
// })

// Download file
router.get('/download/:path', async (req, res) => {
    const filePath = req.params.path;
    const rootPath = path.join(__dirname, "../files/");
    // Increment DOwnload count
    await statService.incrementDownloadCount(filePath);
    // Download
    res.download(`${rootPath}${filePath}`, async (err) => {
        if (err) {
            // Decrement Download count
            await statService.decrementDownloadCount(filePath);
            console.log("There was a problem downloading file", err);
        }
        else
            console.log("Download completed");
    });
    // }else
    // res.status(400).send("No file with that title");

})

// Email File
router.post("/mail/:path", async(req, res) => {
    const email = req.body.email;
    const path = req.params.path;
    const title = req.body.title;
    try {
        // Increment emails sent
    await statService.incrementEmailsSent(path);
        var result = await service.emailFile(email, path, title);
        res.status(200).send({message: `File sent to ${email} successfully`},);
    } catch (error) {
        await statService.decrementEmailsSent(path);
    }
    
})

// Search Database for a keyword
router.get("/search/:keyword", async(req, res) => {
    const keyword = req.params.keyword;
    const searchResults = await service.searchForFile(keyword);
    res.status(200).send(searchResults);
})

router.get("/download-stats/:filePath", async (req, res) => {
    const filePath = req.params.filePath;
    const results = await statService.incrementDownloadCount(filePath);
    await statService.incrementEmailsSent(filePath);
    res.send(results);
})

module.exports = router;