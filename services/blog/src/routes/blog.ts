import express from "express";
import { isAuth } from "../middleware/isAuth.js";
import { 
    createBlog, 
    createCategory, 
    deleteBlog, 
    generateAiDescription, 
    generateAiShortDescription, 
    generateAiTitle, 
    getBlogById, 
    getBlogs, 
    getCategories, 
    myBlogs, 
    saveBlog, 
    savedBlogs, 
    unsaveBlog, 
    unupvoteBlog, 
    updateBlog, 
    upvoteBlog,
    userBlogsCount,
    } from "../controllers/blog.js";

const router = express();

// ai
router.post("/ai-title", isAuth, generateAiTitle);
router.post("/ai-short-desc", isAuth, generateAiShortDescription);
router.post("/ai-desc", isAuth, generateAiDescription);

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
router.get("/my-blogs/:id", isAuth, myBlogs);
router.get("/user-blogs-count/:id", isAuth, userBlogsCount);
router.get("/saved-blogs/:id", isAuth, savedBlogs);
router.get("/:id", isAuth, getBlogById);
router.patch("/:id", isAuth, updateBlog);
router.delete("/:id", isAuth, deleteBlog);


export default router;