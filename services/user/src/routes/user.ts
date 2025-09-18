import express from "express";
import { changePassword, checkRegistrationStatus, deleteAccount, forgotPassword, getProfileStats, getUserProfile, getUsersProfile, login, register, resendPasswordResetOtp, resendVerificationOtp, resetPassword, searchUsers, updateAvatar, updateUser, verifyEmail, verifyPasswordResetOtp } from "../controllers/user.js";
import { isAuth } from "../middleware/isAuth.js";

const router = express.Router();

router.post("/users/register", register);
router.post("/users/login", login),
router.post("/users/check-registration", checkRegistrationStatus);
router.post("/users/verify-email", verifyEmail);
router.post("/users/resend-verification-otp", resendVerificationOtp);
router.post("/users/forgot-password", forgotPassword);
router.post("/users/verify-password-reset-otp", verifyPasswordResetOtp);
router.post("/users/resend-password-reset-otp", resendPasswordResetOtp);
router.post("/users/reset-password", resetPassword);
router.patch("/users/change-password", isAuth, changePassword);
router.post("/users/profiles", isAuth, getUsersProfile);
router.get("/users/profile-stats/:id", isAuth, getProfileStats);
router.get("/users/:id", isAuth, getUserProfile);
router.patch("/users", isAuth, updateUser);
router.patch("/users/avatar", isAuth,  updateAvatar);
router.get("/users", isAuth, searchUsers);
router.delete("/users", isAuth, deleteAccount);


export default router;