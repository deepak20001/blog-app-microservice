import multer from "multer";

const storage = multer.memoryStorage(); // memoryStorage() - uploaded file is kept in (RAM) as a Buffer object, instead of saving it to disk
const uploadFile = multer({storage}).single("file");

export default uploadFile;