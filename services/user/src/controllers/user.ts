import type { Request, Response } from "express";
import User from "../model/user.js";
import jwt from "jsonwebtoken";
import {z} from "zod";
import type { AuthenticatedRequest } from "../middleware/isAuth.js";
import mongoose from "mongoose";
import getBuffer from "../utils/data_uri.js";
import {v2 as cloudinary} from "cloudinary";

// Validation schemas
const registerSchema = z.object({
    name: z.string().
        min(2, "Name must be at least 2 characters long").
        max(50, "Name must not exceed 50 characters"),
    image: z.string(),
    instagram: z.string().optional().refine(val => val === undefined || val === null || val.trim() !== "", {
        message: "Instagram must be a non-empty string if provided"
    }),
    facebook: z.string().optional().refine(val => val === undefined || val === null || val.trim() !== "", {
        message: "Facebook must be a non-empty string if provided"
    }),
    linkedin: z.string().optional().refine(val => val === undefined || val === null || val.trim() !== "", {
        message: "Linkedin must be a non-empty string if provided"
    }),
    bio: z.string().optional().refine(val => val === undefined || val === null || val.trim() !== "", {
        message: "Bio must be a non-empty string if provided"
    }),
});

const updateUserSchema = z.object({
    name: z.string().
        min(2, "Name must be at least 2 characters long").
        max(50, "Name must not exceed 50 characters"),
    image: z.string().optional().refine(val => val === undefined || val === null || val.trim() !== "", {
        message: "Image must be non-empty string if provided"
    }),
    instagram: z.string().optional().refine(val => val === undefined || val === null || val.trim() !== "", {
        message: "Instagram must be a non-empty string if provided"
    }),
    facebook: z.string().optional().refine(val => val === undefined || val === null || val.trim() !== "", {
        message: "Facebook must be a non-empty string if provided"
    }),
    linkedin: z.string().optional().refine(val => val === undefined || val === null || val.trim() !== "", {
        message: "Linkedin must be a non-empty string if provided"
    }),
    bio: z.string().optional().refine(val => val === undefined || val === null || val.trim() !== "", {
        message: "Bio must be a non-empty string if provided"
    }),
});

// Controllers ::::::::::
export const loginUser = async(req: Request, res: Response) => {
    try {
        // TODO social login functionality
        const { email, name, image } = req.body;
        let user = await User.findOne({email});
        if(!user) {
            user = await User.create({
                name, 
                email, 
                image,
            });
        } 

        const token = jwt.sign({user}, process.env.JWT_SECRET as string);

        res.status(200).json({
            success: true,
            message: "Login successful",
            data: {
                token,
                user,
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

export const myProfile = async(req: AuthenticatedRequest, res: Response) => {
    try {
        if(!req.user || !req.user._id) {
            return res.status(401).json({
                success: false,
                error: 'Unauthorized user',
            });
        }

        return res.status(200).json({
            success: true,
            data: req.user,
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const getUserProfile = async(req: Request, res: Response) => {
    try {
        const {id} = req.params;

        if(!id || !mongoose.Types.ObjectId.isValid(id)) {
            return res.status(400).json({
                success: false,
                error: "Invalid user ID",
            });
        }
        const userRecord = await User.findById(id);
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User not found",
            });
        }

        return res.status(200).json({
            success: true,
            data: userRecord,
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
        if(!req.user || !req.user._id) {
            return res.status(401).json({
                success: false,
                error: 'Unauthorized user',
            });
        }

        const userId = req.user._id;

        const validationResult = updateUserSchema.safeParse(req.body);
        if (!validationResult.success) {
            return res.status(400).json({
                success: false,
                message: "Validation failed",
                errors: validationResult.error.issues.map((err) => ({
                    field: err.path.join('.'),
                    message: err.message
                }))
            });
        }

        const { name, image, instagram, facebook, linkedin, bio } = validationResult.data;
        const updatedUserRecord = await User.findByIdAndUpdate(
            userId,
            {
                name, image, instagram, facebook, linkedin, bio
            },
            {
                new: true,
            },
        );

        const token = jwt.sign({ 
            user: updatedUserRecord 
        }, process.env.JWT_SECRET as string);

        return res.status(200).json({
            success: true,
            data: {
                user: updatedUserRecord,
                token,
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

export const updateProfilePic = async(req: AuthenticatedRequest, res: Response) => {
    try {
        if(!req.user || !req.user._id) {
            return res.status(401).json({
                success: false,
                error: 'Unauthorized user',
            });
        }

        const userId = req.user._id;
        const file = req.file;
        if(!file) {
            return res.status(400).json({
                success: false,
                message: "File is missing",
            });
        }
        const allowedMimeTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
        if (!allowedMimeTypes.includes(file.mimetype)) {
            return res.status(400).json({
                success: false,
                message: "Only JPEG, PNG, and WebP images are allowed"
            });
        }
        const maxSize = 3 * 1024 * 1024; // 3MB in bytes
        if (file.size > maxSize) {
            return res.status(400).json({
                success: false,
                message: "File size must be less than 3MB"
            });
        }

        const fileBuffer = getBuffer(file);
        if(!fileBuffer || !fileBuffer.content) {
            return res.status(500).json({
                success: false,
                message: "Failed to generate file buffer",
            });
        }

        const cloudStorage = await cloudinary.uploader.upload(
            fileBuffer.content, {
                folder: "blog-app-storage/user-avatars",
                resource_type: "image",
            }
        );

        const updatedUserRecord = await User.findByIdAndUpdate(
            userId,
            {
                image: cloudStorage.secure_url,
            },
            { 
                new: true,
            },
        );

        const token = jwt.sign({
            user: updatedUserRecord
        }, process.env.JWT_SECRET as string);

        return res.status(200).json({
            success: true,
            message: "Profile image updated successfully",
            data: {
                user: updatedUserRecord,
                token,
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