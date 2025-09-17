import express from "express";
import { getProfileStats, getUserProfile, getUsersProfile, login, register, updateAvatar, updateUser } from "../controllers/user.js";
import { isAuth } from "../middleware/isAuth.js";

const router = express.Router();

router.post("/users/register", register);
router.post("/users/login", login),
router.post("/users/profiles", isAuth, getUsersProfile);
router.get("/users/profile-stats/:id", isAuth, getProfileStats);
router.get("/users/:id", isAuth, getUserProfile);
router.patch("/users", isAuth, updateUser);
router.patch("/users/avatar", isAuth,  updateAvatar);


export default router;