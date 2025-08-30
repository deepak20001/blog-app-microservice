import express from "express";
import { isAuth } from "../middleware/isAuth.js";
import { createBlog } from "../controllers/blog.js";
import uploadFile from "../middleware/multer.js";

const router = express();

router.post("/blog", isAuth, uploadFile, createBlog);

export default router;