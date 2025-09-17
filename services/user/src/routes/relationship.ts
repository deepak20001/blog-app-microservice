import express from "express";
import { followProfile, getFollowers, getFollowings, unfollowProfile } from "../controllers/relationship.js";
import { isAuth } from "../middleware/isAuth.js";

const router = express.Router();

router.get("/relationships/followers/:id", isAuth, getFollowers);
router.get("/relationships/followings/:id", isAuth, getFollowings);
router.post("/relationships/follow", isAuth, followProfile);
router.post("/relationships/unfollow", isAuth, unfollowProfile);

export default router;