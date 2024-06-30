const db = require("../databasepg");

// Increment download count
module.exports.incrementDownloadCount = async(dbFilePath) => {
    const result = await db.query("UPDATE file_stats SET download_count = download_count + 1 WHERE file = $1", [dbFilePath])
    .catch(e =>{console.log("Error incrementing download count", e)})
    return result;
}

// Decrement download count
module.exports.decrementDownloadCount = async(dbFilePath) => {
    const result = await db.query("UPDATE file_stats SET download_count = download_count - 1 WHERE file = $1", [dbFilePath])
    .catch(e =>{console.log("Error incrementing download count", e)})
    return result;
}

// Increment emails sent
module.exports.incrementEmailsSent = async(dbFilePath) => {
    const result = await db.query("UPDATE file_stats SET emails_sent = emails_sent + 1 WHERE file = $1", [dbFilePath])
    .catch(e =>{console.log("Error incrementing email count", e)})
    return result;
}

// Decrement emails sent
module.exports.decrementEmailsSent = async(dbFilePath) => {
    const result = await db.query("UPDATE file_stats SET emails_sent = emails_sent - 1 WHERE file = $1", [dbFilePath])
    .catch(e =>{console.log("Error incrementing email count", e)})
    return result;
}

// Get stats for all files
module.exports.getFileStats = async() => {
    const result = await db.query("SELECT * FROM file_stats ORDER BY id ASC")
    .catch(e =>{console.log("Error getting file statistics", e)})
    return result;
}