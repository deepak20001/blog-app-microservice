import express from "express";
import { isAuth } from "../middleware/isAuth.js";
import { createBlog, createCategory, deleteBlog, getBlogById, getBlogs, updateBlog } from "../controllers/blog.js";

const router = express();

router.post("/blogs/category", isAuth, createCategory);
router.post("/blogs", isAuth, createBlog);
router.get("/blogs/:id", isAuth, getBlogById);
router.get("/blogs", isAuth, getBlogs);
router.patch("/blogs/:id", isAuth, updateBlog);
router.delete("/blogs/:id", isAuth, deleteBlog);

export default router;