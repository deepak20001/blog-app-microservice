import express from "express";
import { followProfile } from "../controllers/relationship.js";
import { isAuth } from "../middleware/isAuth.js";

const router = express.Router();

router.post("/follow/:id", isAuth, followProfile);

export default router;