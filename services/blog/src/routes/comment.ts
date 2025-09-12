import express from "express";
import { isAuth } from "../middleware/isAuth.js"
import { createComment, deleteComment, getComments, unupvoteComment, upvoteComment } from "../controllers/comment.js";

const router = express()

// Comment CRUD
router.post("/", isAuth, createComment);
router.get("/:id", isAuth, getComments);
router.post("/upvote", isAuth, upvoteComment);
router.delete("/unupvote", isAuth, unupvoteComment);
router.delete("/", isAuth, deleteComment);

export default router; 