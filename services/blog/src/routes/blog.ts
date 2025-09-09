import express from "express";
import { isAuth } from "../middleware/isAuth.js";
import { 
    createBlog, 
    createCategory, 
    deleteBlog, 
    getBlogById, 
    getBlogs, 
    getCategories, 
    saveBlog, 
    unsaveBlog, 
    unupvoteBlog, 
    updateBlog, 
    upvoteBlog,
    } from "../controllers/blog.js";

const router = express();

router.post("/blogs/category", isAuth, createCategory);
router.get("/blogs/categories", isAuth, getCategories);
router.post("/blogs/save-blog", isAuth, saveBlog);
router.delete("/blogs/unsave-blog", isAuth, unsaveBlog);
router.post("/blogs/upvote-blog", isAuth, upvoteBlog);
router.delete("/blogs/unupvote-blog", isAuth, unupvoteBlog);
router.post("/blogs", isAuth, createBlog);
router.get("/blogs/:id", isAuth, getBlogById);
router.get("/blogs-filter", isAuth, getBlogs);
router.patch("/blogs/:id", isAuth, updateBlog);
router.delete("/blogs/:id", isAuth, deleteBlog);

export default router;