import express from "express";
import { getUserProfile, login, register, updateAvatar, updateUser } from "../controllers/user.js";
import { isAuth } from "../middleware/isAuth.js";

const router = express.Router();

router.post("/register", register);
router.post("/login", login),
router.get("/user/:id", isAuth, getUserProfile);
router.patch("/user", isAuth, updateUser);
router.patch("/user/avatar", isAuth,  updateAvatar);

export default router;