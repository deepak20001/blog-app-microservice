import type { Request, Response } from "express";
import Relationship from "../model/relationship.js";
import mongoose from "mongoose";
import type { AuthenticatedRequest } from "../middleware/isAuth.js";
import { success } from "zod";
import User from "../model/user.js";
import { invalidateCacheJob } from "../utils/rabbitmq.js";

// Controllers ::::::::::
export const getFollowers = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const { id } = req.params;
        if(!id || !mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({
                success: false,
                error: "invalid user ID",
            });
        }

        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: 'Unauthenticated user',
            });
        }
        
        // get-followers-for-param-id
        const followersResult = await Relationship.find({
            followingId: new mongoose.Types.ObjectId(id),
        }).populate("followerId",  "username avatar").populate("followingId",  "username avatar");
        
        // get-users-that-logged-in-user-following
        const followingsIdsResult = await Relationship.find({
            followerId: payloadData._id
        });
        const followingsIdsSet = new Set(followingsIdsResult.map(v => v.followingId.toString()));
        const formattedResult = followersResult.map(r => ({
            _id: r._id,
            follower: r.followerId,   
            following: r.followingId,
            // check-if-the-set-of-people-that-logged-in-user-following-containes-follower
            isFollowing: followingsIdsSet.has(r.followerId._id.toString()),
        }));

        return res.status(200).json({
            success: true, 
            data: formattedResult,
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const getFollowings = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const { id } = req.params;
        if(!id || !mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({
                success: false,
                error: "invalid user ID",
            });
        }

        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: 'Unauthenticated user',
            });
        }
        
        // get-followings-for-param-id
        const followingsResult = await Relationship.find({
            followerId: new mongoose.Types.ObjectId(id),
        }).populate("followerId",  "username avatar").populate("followingId",  "username avatar");

        // get-users-that-logged-in-user-following
        const followingsIdsResult = await Relationship.find({
            followerId: payloadData._id
        });
        const followerIdsSet = new Set(followingsIdsResult.map(v => v.followingId.toString()));

        const formattedResult = followingsResult.map(r => ({
            _id: r._id,
            follower: r.followerId,   
            following: r.followingId,
            // check-if-the-set-of-people-that-logged-in-user-following-containes-followings-user
            isFollowing: followerIdsSet.has(r.followingId._id.toString()),
        }));

        return res.status(200).json({
            success: true,
            data: formattedResult,
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const followProfile = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const {id} = req.body;
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

        const userRecord = await User.findById(id);
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User not found with the id",
            });
        }

        const relationshipRecord = await Relationship.findOne({
            followerId:  jwtData._id, 
            followingId: id
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

        // Invalidate user cache
        const cacheKeysToInvalidate = [
            `user:${jwtData._id}`, 
            `user:${id}`, 
        ];
        await invalidateCacheJob(cacheKeysToInvalidate);

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

export const unfollowProfile = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const {id} = req.body;
        if(!id || !mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({
                success: false,
                error: "invalid user ID",
            });
        }  
        
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: 'Unauthenticated user',
            });
        }

        if(id.toString() === payloadData._id.toString()) {
            return res.status(409).json({
                success: false,
                error: "You can't follow yourserlf",
            });
        }

        const relationshipRecord = await Relationship.findOne({
            $or: [
                { followerId:  payloadData._id, followingId: id},
            ]
        });
        if(!relationshipRecord) {
            return res.status(409).json({
                success: false,
                error: "Relationship not exists",
            });
        }

        await Relationship.findOneAndDelete({
            followerId: payloadData._id, 
            followingId: id
        });

        // Invalidate user cache
        const cacheKeysToInvalidate = [
            `user:${payloadData._id}`, 
            `user:${id}`, 
        ];
        await invalidateCacheJob(cacheKeysToInvalidate);

        return res.status(200).json({
            success: true,
            message: "User unfollowed successfully",
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}