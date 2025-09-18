import express from "express";
import { changePassword, deleteAccount, getProfileStats, getUserProfile, getUsersProfile, login, register, searchUsers, updateAvatar, updateUser } from "../controllers/user.js";
import { isAuth } from "../middleware/isAuth.js";

const router = express.Router();

router.post("/users/register", register);
router.post("/users/login", login),
router.patch("/users/change-password", isAuth, changePassword);
router.post("/users/profiles", isAuth, getUsersProfile);
router.get("/users/profile-stats/:id", isAuth, getProfileStats);
router.get("/users/:id", isAuth, getUserProfile);
router.patch("/users", isAuth, updateUser);
router.patch("/users/avatar", isAuth,  updateAvatar);
router.get("/users", isAuth, searchUsers);
router.delete("/users", isAuth, deleteAccount);


export default router;