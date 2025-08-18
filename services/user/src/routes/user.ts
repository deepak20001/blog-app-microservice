import express from "express";
import { getUserProfile, loginUser, myProfile, updateProfilePic, updateUser } from "../controllers/user.js";
import { isAuth } from "../middleware/isAuth.js";
import uploadFile from "../middleware/multer.js";

const router = express.Router();

router.post("/login", loginUser);
router.get("/my-profile", isAuth, myProfile);
router.get("/user/:id", isAuth, getUserProfile);
router.patch("/user", isAuth, updateUser);
router.patch("/user/profile-image", isAuth, uploadFile,  updateProfilePic);

export default router;