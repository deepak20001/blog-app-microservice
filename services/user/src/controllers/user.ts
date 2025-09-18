import type { Request, Response } from "express";
import User, { UserRole } from "../model/user.js";
import jwt from "jsonwebtoken";
import {success, z} from "zod";
import type { AuthenticatedRequest } from "../middleware/isAuth.js";
import mongoose from "mongoose";
import getBuffer from "../utils/data_uri.js";
import {v2 as cloudinary} from "cloudinary";
import bcrypt from "bcrypt";
import Relationship from "../model/relationship.js";
import axios from "axios";
import { getTokenFromHeader } from "../utils/get_token.js";

// Validation schemas
const registerSchema = z.object({
    username: z.string().
        min(2, "Username must be at least 2 characters long").
        max(50, "Username must not exceed 50 characters"),
    email: z.email(),
    password: z.string().
        min(8, "Password must be atleast 8 characters long").
        max(10, "Bio must not exceed 10 characters"),
    bio: z.string().
        min(5, "Bio must be at least 5 characters long").
        max(100, "Bio must not exceed 100 characters"),
    role: z.enum(UserRole)
});

const logionSchema = z.object({
    email: z.email(),
    password: z.string().
        min(8, "Password must be atleast 8 characters long").
        max(10, "Bio must not exceed 10 characters"),
});

const updateUserSchema = z.object({
    username: z.string().
        min(2, "Name must be at least 2 characters long").
        max(50, "Name must not exceed 50 characters"),
    bio: z.string().
        min(5, "Bio must be at least 5 characters long").
        max(100, "Bio must not exceed 100 characters"),
});

// Controllers ::::::::::
export const register = async(req: Request, res: Response) => {
    try {
        const validationResult = registerSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues
                .map((issue) => issue.message) 
                .join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        }

        const {username, email, password, bio, role} = req.body;
        const userRecord = await User.find({email});
        if(userRecord != null && userRecord.length > 0) {
            return res.status(409).json({
                success: false,
                error: "User with same email already exists",
            });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        if(!hashedPassword) {
            return res.status(500).json({
                success: false,
                error: "Error while processing password",
            });
        }

        const createdUserRecord = await User.create({
            username,
            email,
            password: hashedPassword,
            bio,
            role,
        });

        if(!createdUserRecord) {
            return res.status(500).json({
                success: false,
                error: "Error creating user",
            });
        }

        const token = jwt.sign({
            _id: createdUserRecord._id,
            email: createdUserRecord.email,
        }, process.env.JWT_SECRET as string);
        if(!token) {
            return res.status(500).json({
                success: false,
                error: "Failed to generate token",
            });
        }

        return res.status(201).json({
            success: true,
            message: "User created successfully",
            data: { token },
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const login = async(req: Request, res: Response) => {
    try {
        const validationResult = logionSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues.
                map((issue) => issue.message).join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        } 

        const {email, password} = req.body;
        const userRecord = await User.findOne({email});
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User with this email does not exists",
            });
        }
        
        const isPasswordMatch = await bcrypt.compare(password, userRecord.password);
        if(!isPasswordMatch) {
            return res.status(401).json({
                success: false,
                error: "Invalid credentials",
            });
        }

        const token = jwt.sign({ 
            _id: userRecord._id, 
            email: userRecord.email 
        }, process.env.JWT_SECRET as string);
        if(!token) {
            return res.status(500).json({
                success: false,
                error: "Failed to generate token",
            });
        }

        const { password: _, ...userWithoutPassword } = userRecord.toObject();
        return res.status(200).json({
            success: true,
            message: "Login successful",
            data: { 
                token, 
                user: userWithoutPassword,
            },
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const getUserProfile = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const {id} = req.params;

        if(!id || !mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({
                success: false,
                error: "Invalid user ID",
            });
        }
        const userRecord = await User.findById(id).select("-password");
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User not found",
            });
        }

        const followersRecordCount = await Relationship.find({
            followingId: id,
        }).countDocuments();
        const followingsRecordCount = await Relationship.find({
            followerId: id,
        }).countDocuments();

        const token = getTokenFromHeader(req);
        if (!token) {
                return res.status(401).json({
                success: false,
                error: "Invalid token",
            });
        }

        const userPostedBlogsCount = await axios.get(`${process.env.BLOG_SERVICE_URL}/api/v1/blogs/user-blogs-count/${id}`, {
            headers: {
                Authorization: `Bearer ${token}`,
            }
        });
        if(!userPostedBlogsCount) {
            return res.status(400).json({
                success: false,
                error: "Error fetching blogs count",
            });
        }


        return res.status(200).json({
            success: true,
            data: {
                _id: userRecord.id,
                username: userRecord.username,
                email: userRecord.email,
                bio: userRecord.bio,
                avatar: userRecord.avatar,
                role: userRecord.role,
                isVerified: userRecord.isVerified,
                followersCount: followersRecordCount,
                followingsCount: followingsRecordCount,
                userPostedBlogsCount: userPostedBlogsCount.data.data,
            },
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const getUsersProfile = async(req: Request, res: Response) => {
    try {
        const {ids} = req.body;
        if(!ids || !Array.isArray(ids) || ids.length === 0) {
            return res.status(400).json({
                success: false,
                error: "Ids must be a non-empty array",
            });
        }

        const result = await User.find({ _id: { $in: ids } }).
            select("-password");

        return res.status(200).json({
            success: true,
            data: result,
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const updateAvatar = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }

        const {avatar} = req.body;
        if(!avatar) {
            return res.status(400).json({
                success: false,
                error: "Uploaded url not found",
            });
        }

        const userRecord = await User.findById(payloadData._id);
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User not found",
            });
        }
        await User.updateOne(
            {_id: payloadData._id},
            { avatar }
        );

        return res.status(200).json({
            success: true,
            message: "User avatar uploaded successfully",
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    } 
}

export const updateUser = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }

        const userId = payloadData._id;
        const validationResult = updateUserSchema.safeParse(req.body);
        if (!validationResult.success) {
            const errorMessage = validationResult.error.issues.
                map((issue) => issue.message).join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        }

        const { username, bio } = validationResult.data;
        const updatedUserRecord = await User.findByIdAndUpdate(
            userId,
            {  username, bio },
            { new: true },
        ).select("-password");

        return res.status(200).json({
            success: true,
            message: "User updated successfully",
            data: updatedUserRecord,
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const getProfileStats = async(req: AuthenticatedRequest, res: Response) => {
    try {
        // get blogs count
        const {id: userId} = req.params;
        if(!userId || !mongoose.Types.ObjectId.isValid(userId)) {
            return res.status(400).json({
                success: false,
                error: "Invalid user ID",
            });
        }

        const token = getTokenFromHeader(req);
        if (!token) {
                return res.status(401).json({
                success: false,
                error: "Invalid token",
            });
        }
        const userPostedBlogsCount = await axios.get(`${process.env.BLOG_SERVICE_URL}/api/v1/blogs/user-blogs-count/${userId}`, {
            headers: {
                Authorization: `Bearer ${token}`,
            }
        });
        if(!userPostedBlogsCount) {
            return res.status(400).json({
                success: false,
                error: "Error fetching blogs count",
            });
        }

        // get followers count
        const followingsRecordCount = await Relationship.find({
            followingId: userId,
        }).countDocuments();
        // get followings count
        const followersRecordCount = await Relationship.find({
            followerId: userId,
        }).countDocuments();

        return res.json({
            blogsPostedCount: userPostedBlogsCount.data.data,
            followersCount: followersRecordCount,
            followingsCount: followingsRecordCount,
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const searchUsers = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Authenticated user",
            });
        }
        
        const { search } = req.query;
        const page = parseInt(req.query.page as string) || 1;
        const limit = Math.min(parseInt(req.query.limit as string) || 10, 20);
        const offset = (page - 1) * limit;

        let searchQuery: any = {
            _id: { $ne: payloadData._id }
        };
        if (search && typeof search === 'string' && search.trim().length > 0) {
            searchQuery = {
                _id: { $ne: payloadData._id },
                $or: [
                    { username: { $regex: search.trim(), $options: 'i' } },
                    { email: { $regex: search.trim(), $options: 'i' } },
                ]
            };
        }
        const usersResult = await User.find(searchQuery)
            .select('-password')
            .skip(offset)
            .limit(limit)
            .sort({ createdAt: -1 });

        if (!usersResult) {
            return res.status(500).json({
                success: false,
                error: "Error fetching users",
            });
        }

        return res.status(200).json({
            success: true,
            data: usersResult,
            pagination: {
                page,
                limit,
            },
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}