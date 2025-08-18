import DataUriParser from "datauri/parser.js";
import path from "path";

// Converts an uploaded Multer file buffer into a Base64 Data URI 
// (useful for uploads to Cloudinary, S3, or APIs).
const getBuffer = (file: any) => {
    const parser = new DataUriParser();
    const extName = path.extname(file.originalname).toString();
    return parser.format(extName, file.buffer);
}

export default getBuffer;