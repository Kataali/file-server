const db = require("../databasepg");

// Increment download count
module.exports.incrementDownloadCount = async(dbFilePath) => {
    const result = await db.query("UPDATE file_stats SET download_count = download_count + 1 WHERE file = $1", [dbFilePath])
        .catch(e => { console.log("Error incrementing download count", e) });
    if (result.rowCount < 1) {
        const response = await db.query("INSERT into file_stats(file, download_count, emails_sent) VALUES($1, 1, 0)", [dbFilePath])
            .catch(e => { console.log("Error incrementing download count", e) });
    }
    return result;
}

// Decrement download count
module.exports.decrementDownloadCount = async(dbFilePath) => {
    const result = await db.query("UPDATE file_stats SET download_count = download_count - 1 WHERE file = $1 AND download_count > 0", [dbFilePath])
        .catch(e => { console.log("Error incrementing download count", e) });
    return result;
}

// Increment emails sent
module.exports.incrementEmailsSent = async (dbFilePath) => {
    const result = await db.query("UPDATE file_stats SET emails_sent = emails_sent + 1 WHERE file = $1", [dbFilePath])
        .catch(e => { console.log("Error incrementing email count", e) })
    if (result.rowCount < 1) {
        const response = await db.query("INSERT into file_stats(file, download_count, emails_sent) VALUES($1, 0, 1)", [dbFilePath])
            .catch(e => { console.log("Error incrementing download count", e) });
        return result;
    }
}

// Decrement emails sent
module.exports.decrementEmailsSent = async(dbFilePath) => {
    const result = await db.query("UPDATE file_stats SET emails_sent = emails_sent - 1 WHERE file = $1 AND emails_sent > 0", [dbFilePath])
    .catch(e =>{console.log("Error incrementing email count", e)})
    return result;
}

// Get stats for all files
module.exports.getFileStats = async() => {
    const result = await db.query("SELECT * FROM file_stats ORDER BY id ASC")
    .catch(e =>{console.log("Error getting file statistics", e)})
    return result;
}