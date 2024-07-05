const express = require("express");
const path = require("node:path");
router = express.Router();
const service = require("../services/stats.service");

router.get("/all", async(req, res) => {
    const response = await service.getFileStats();
    res.send(response.rows);
})






module.exports = router;