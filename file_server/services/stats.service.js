const db = require("../databasepg");

// Increment download count
module.exports.incrementDownloadCount = async(fileId) => {
    const result = await db.query("UPDATE file_stats SET download_count = download_count + 1 WHERE file_id = $1", [fileId])
        .catch(e => { console.log("Error incrementing download count", e) });
    return result;
}

// Decrement download count if original count > 0
module.exports.decrementDownloadCount = async(fileId) => {
    const result = await db.query("UPDATE file_stats SET download_count = download_count - 1 WHERE file_id = $1 AND download_count > 0", [fileId])
        .catch(e => { console.log("Error incrementing download count", e) });
    return result;
}

// Increment emails sent
module.exports.incrementEmailsSent = async (fileId) => {
    const result = await db.query("UPDATE file_stats SET email_count = email_count + 1 WHERE file_id = $1", [fileId])
        .catch(e => { console.log("Error incrementing email count", e) })
    return result;
}

// Decrement emails sent if original count greater than 0
module.exports.decrementEmailsSent = async(fileId) => {
    const result = await db.query("UPDATE file_stats SET email_count = email_count - 1 WHERE file_id = $1 AND email_count > 0", [fileId])
        .catch(e => { console.log("Error incrementing email count", e) });
    return result;
}

// init file stats with email count and download count as zero
module.exports.initFileStats = async (fileId) => {
    const response = await db.query("INSERT into file_stats(file_id, download_count, email_count) VALUES($1, 0, 0)", [fileId])
        .catch(e => { console.log("Error incrementing email count", e) });
    return response;
}

// Get stats for all files
module.exports.getFileStats = async() => {
    const result = await db.query("SELECT files.id, files.title, files.description, files.type, files.description,\
		                            to_char(timezone('UTC', current_timestamp), 'YY-MM-DD HH24:MI:SS') as real_uploaded_on, file_stats.download_count, file_stats.email_count\
                                    FROM\
	                                files\
                                    INNER JOIN file_stats ON\
	                                files.id = file_stats.file_id\
                                    ORDER BY uploaded_on DESC")
    .catch(e =>{console.log("Error getting file statistics", e)})
    return result;
}