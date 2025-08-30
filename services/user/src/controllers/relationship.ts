import type { Request, Response } from "express";
import Relationship from "../model/relationship.js";
import mongoose from "mongoose";
import type { AuthenticatedRequest } from "../middleware/isAuth.js";
import { success } from "zod";

// Controllers ::::::::::
export const followProfile = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const {id} = req.params;
        if(!id || !mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({
                success: false,
                error: "invalid user ID",
            });
        }  

        const jwtData = req.user;
        if(!jwtData || !jwtData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated request",
            });
        }

        if(jwtData._id.toString() === id.toString()) {
            return res.status(409).json({
                success: false,
                error: "You can't follow yourserlf",
            });
        }

        const relationshipRecord = await Relationship.findOne({
            $or: [
                { followerId:  jwtData._id, followingId: id},
                { followerId:  id, followingId: jwtData._id},
            ]
        });
        if(relationshipRecord) {
            return res.status(409).json({
                success: false,
                error: "Relationship already exists",
            });
        }

        await Relationship.create({
            followerId: jwtData._id,
            followingId: id,
        });

        return res.status(200).json({
            success: true,
            message: "User followed successfully",
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}