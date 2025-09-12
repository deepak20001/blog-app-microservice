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

// Categories
router.post("/category", isAuth, createCategory);
router.get("/categories", isAuth, getCategories);

// Save/Unsave blog
router.post("/save-blog", isAuth, saveBlog);
router.delete("/unsave-blog", isAuth, unsaveBlog);

// Upvote/Unupvote blog
router.post("/upvote-blog", isAuth, upvoteBlog);
router.delete("/unupvote-blog", isAuth, unupvoteBlog);

// Blog CRUD
router.post("/", isAuth, createBlog);
router.get("/filter", isAuth, getBlogs);
router.get("/:id", isAuth, getBlogById);
router.patch("/:id", isAuth, updateBlog);
router.delete("/:id", isAuth, deleteBlog);


export default router;