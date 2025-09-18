import type { Request, Response } from "express";
import User, { UserRole } from "../model/user.js";
import jwt from "jsonwebtoken";
import { z } from "zod";
import type { AuthenticatedRequest } from "../middleware/isAuth.js";
import mongoose from "mongoose";
import bcrypt from "bcrypt";
import Relationship from "../model/relationship.js";
import axios from "axios";
import { getTokenFromHeader } from "../utils/get_token.js";
import { sendEmail } from "../utils/send_email.js";

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

const loginSchema = z.object({
    email: z.email(),
    password: z.string().
        min(8, "Password must be atleast 8 characters long").
        max(10, "Password must not exceed 10 characters"),
});

const updateUserSchema = z.object({
    username: z.string().
        min(2, "Name must be at least 2 characters long").
        max(50, "Name must not exceed 50 characters"),
    bio: z.string().
        min(5, "Bio must be at least 5 characters long").
        max(100, "Bio must not exceed 100 characters"),
});

const changePasswordSchema = z.object({
    currentPassword: z.string().
        min(8, "Current password must be atleast 8 characters long").
        max(10, "Current password must not exceed 10 characters"),
    newPassword: z.string().
        min(8, "New password must be atleast 8 characters long").
        max(10, "New password must not exceed 10 characters"),
    confirmPassword: z.string().
        min(8, "Confirm password must be atleast 8 characters long").
        max(10, "Confirm password must not exceed 10 characters"),
});

const deleteAccountSchema = z.object({
    password: z.string().
        min(8, "Password must be atleast 8 characters long").
        max(10, "Password must not exceed 10 characters"),
});

const forgotPasswordSchema = z.object({
    email: z.email(),
});

const verifyOtpSchema = z.object({
    email: z.email(),
    otp: z.string().length(6, "OTP must be 6 digits"),
});

const verifyPasswordResetOtpSchema = z.object({
    email: z.email(),
    otp: z.string().length(6, "OTP must be 6 digits"),
});

const resetPasswordSchema = z.object({
    email: z.email(),
    otp: z.string().length(6, "OTP must be 6 digits"),
    newPassword: z.string().
        min(8, "New password must be atleast 8 characters long").
        max(50, "New password must not exceed 50 characters"),
    confirmPassword: z.string().
        min(8, "Confirm password must be atleast 8 characters long").
        max(50, "Confirm password must not exceed 50 characters"),
});

const resendVerificationOtpSchema = z.object({
    email: z.email(),
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
        const existingUser = await User.findOne({email});
        
        if(existingUser && existingUser.isVerified) {
            return res.status(409).json({
                success: false,
                error: "User with same email already exists",
            });
        }
        
        if(existingUser && !existingUser.isVerified) {
            const hashedPassword = await bcrypt.hash(password, 10);
            if(!hashedPassword) {
                return res.status(500).json({
                    success: false,
                    error: "Error while processing password",
                });
            }

            await User.updateOne(
                { _id: existingUser._id },
                {
                    username,
                    password: hashedPassword,
                    bio,
                    role,
                }
            );

            // Generate new OTP
            const otp = Math.floor(100000 + Math.random() * 900000).toString();
            const otpHash = await bcrypt.hash(otp, 10);
            const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

            await User.updateOne(
                { _id: existingUser._id },
                {
                    emailVerificationOtpHash: otpHash,
                    emailVerificationOtpExpiresAt: expiresAt,
                    emailVerificationAttempts: 0,
                    emailVerificationLastSentAt: new Date(),
                }
            );

            const htmlTemplate = `
                <div style="font-family: Arial, sans-serif;">
                    <h2>Verify your email</h2>
                    <p>Hi ${username},</p>
                    <p>Your verification code for Blog App is:</p>
                    <div style="font-size: 24px; font-weight: bold; letter-spacing: 4px;">${otp}</div>
                    <p>This code expires in 5 minutes.</p>
                    <p>If you didn't sign up, you can ignore this email.</p>
                </div>
            `;

            try {
                await sendEmail(username, email, htmlTemplate);
            } catch (e) {
                return res.status(500).json({
                    success: false,
                    error: "Failed to send verification email. Please try resending.",
                });
            }

            return res.status(200).json({
                success: true,
                message: "Account updated. New verification email sent.",
                data: {},
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

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const otpHash = await bcrypt.hash(otp, 10);
        const expiresAt = new Date(Date.now() + 5 * 60 * 1000); 
        await User.updateOne(
            { _id: createdUserRecord._id },
            {
                emailVerificationOtpHash: otpHash,
                emailVerificationOtpExpiresAt: expiresAt,
                emailVerificationAttempts: 0,
                emailVerificationLastSentAt: new Date(),
            }
        );

        const htmlTemplate = `
            <div style="font-family: Arial, sans-serif;">
                <h2>Verify your email</h2>
                <p>Hi ${createdUserRecord.username},</p>
                <p>Your verification code for Blog App is:</p>
                <div style="font-size: 24px; font-weight: bold; letter-spacing: 4px;">${otp}</div>
                <p>This code expires in 5 minutes.</p>
                <p>If you didn't sign up, you can ignore this email.</p>
            </div>
        `;

        try {
            await sendEmail(createdUserRecord.username, createdUserRecord.email, htmlTemplate);
        } catch (e) {
            return res.status(500).json({
                success: false,
                error: "Failed to send verification email. Please try resending.",
            });
        }

        return res.status(201).json({
            success: true,
            message: "User created. Verification email sent.",
            data: {},
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
        const validationResult = loginSchema.safeParse(req.body);
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

        if(!userRecord.isVerified) {
            const otp = Math.floor(100000 + Math.random() * 900000).toString();
            const otpHash = await bcrypt.hash(otp, 10);
            const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

            await User.updateOne({ _id: userRecord._id }, {
                emailVerificationOtpHash: otpHash,
                emailVerificationOtpExpiresAt: expiresAt,
                emailVerificationAttempts: 0,
                emailVerificationLastSentAt: new Date(),
            });

            const htmlTemplate = `
                <div style="font-family: Arial, sans-serif;">
                    <h2>Verify your email</h2>
                    <p>Hi ${userRecord.username},</p>
                    <p>You tried to login but your email is not verified yet. Use the code below to verify your email:</p>
                    <div style="font-size: 24px; font-weight: bold; letter-spacing: 4px;">${otp}</div>
                    <p>This code expires in 5 minutes.</p>
                    <p>If you didn't try to login, you can ignore this email.</p>
                </div>
            `;

            try {
                await sendEmail(userRecord.username, userRecord.email, htmlTemplate);
            } catch (e) {
                return res.status(500).json({
                    success: false,
                    error: "Failed to send verification email. Please try again.",
                });
            }

            return res.status(200).json({
                success: true,
                message: "Email verification required. New verification code sent to your email.",
                data: {
                    email: userRecord.email,
                    isVerified: false,
                    requiresVerification: true,
                    message: "Please check your email and verify your account"
                }
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
                error: "Unauthenticated user",
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

export const changePassword = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const validationResult = changePasswordSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues.
                map((issue) => issue.message).join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        } 
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "UnAuthenticated user",
            });
        }
        
        const { currentPassword, newPassword, confirmPassword } = req.body;
        if(newPassword !== confirmPassword) {
            return res.status(400).json({
                success: false,
                error: "New password and confirm password do not match",
            });
        }
        
        if(currentPassword === newPassword) {
            return res.status(400).json({
                success: false,
                error: "New password must be different from current password",
            });
        }

        const userRecord = await User.findById(payloadData._id);
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User not found",
            });
        }

        const isPasswordMatch = await bcrypt.compare(currentPassword, userRecord.password);
        if(!isPasswordMatch) {
            return res.status(401).json({
                success: false,
                error: "Invalid credentials",
            });
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);
        if(!hashedPassword) {
            return res.status(500).json({
                success: false,
                error: "Error while processing password",
            });
        }

        await User.findByIdAndUpdate(
            { _id: payloadData._id },
            {
                password: hashedPassword,
            }
        );

        return res.status(200).json({
            success: true,
            message: "Password changed successfully",
            data: {},
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const deleteAccount = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const validationResult = deleteAccountSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues.
                map((issue) => issue.message).join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        } 
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "UnAuthenticated user",
            });
        }
        
        const { password } = req.body;
        const userRecord = await User.findById(payloadData._id);
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User not found",
            });
        }

        const isPasswordMatch = await bcrypt.compare(password, userRecord.password);
        if(!isPasswordMatch) {
            return res.status(401).json({
                success: false,
                error: "Invalid credentials",
            });
        }
        
        await User.deleteOne({ _id: payloadData._id });
        return res.status(200).json({
            success: true,
            message: "Account deleted successfully",
            data: {},
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const verifyEmail = async(req: Request, res: Response) => {
    try {
        const validationResult = verifyOtpSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues
                .map((issue) => issue.message) 
                .join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        }
        const { email, otp } = req.body;
        if(!email || !otp) {
            return res.status(400).json({
                success: false,
                error: "Email and OTP are required",
            });
        }

        const userRecord = await User.findOne({ email });
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User not found",
            });
        }

        if(userRecord.isVerified) {
            return res.status(200).json({
                success: true,
                message: "Email already verified",
                data: {},
            });
        }

        if(!userRecord.emailVerificationOtpHash || !userRecord.emailVerificationOtpExpiresAt) {
            return res.status(400).json({
                success: false,
                error: "No verification code found. Please resend.",
            });
        }

        if(userRecord.emailVerificationOtpExpiresAt.getTime() < Date.now()) {
            return res.status(400).json({
                success: false,
                error: "Verification code expired. Please resend.",
            });
        }

        const attempts = userRecord.emailVerificationAttempts ?? 0;
        if(attempts >= 3) {
            return res.status(429).json({
                success: false,
                error: "Too many attempts. Please resend a new code.",
            });
        }

        const isMatch = await bcrypt.compare(otp, userRecord.emailVerificationOtpHash);
        if(!isMatch) {
            await User.updateOne({ _id: userRecord._id }, {
                $inc: { emailVerificationAttempts: 1 },
            });
            return res.status(400).json({
                success: false,
                error: "Invalid verification code",
            });
        }

        await User.updateOne({ _id: userRecord._id }, {
            isVerified: true,
            emailVerificationOtpHash: null,
            emailVerificationOtpExpiresAt: null,
            emailVerificationAttempts: 0,
        });

        const token = jwt.sign({ _id: userRecord._id, email: userRecord.email }, process.env.JWT_SECRET as string);

        return res.status(200).json({
            success: true,
            message: "Email verified successfully",
            data: { 
                token,
                user: userRecord,
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

export const checkRegistrationStatus = async(req: Request, res: Response) => {
    try {
        const { email } = req.body as { email?: string };
        if(!email) {
            return res.status(400).json({
                success: false,
                error: "Email is required",
            });
        }

        const userRecord = await User.findOne({ email }).select("-password");
        if(!userRecord) {
            return res.status(200).json({
                success: true,
                data: {
                    exists: false,
                    isVerified: false,
                    message: "Email not registered"
                }
            });
        }

        return res.status(200).json({
            success: true,
            data: {
                exists: true,
                isVerified: userRecord.isVerified,
                username: userRecord.username,
                message: userRecord.isVerified ? "Email already verified" : "Email registered but not verified"
            }
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const forgotPassword = async(req: Request, res: Response) => {
    try {
        const validationResult = forgotPasswordSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues
                .map((issue) => issue.message) 
                .join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        }

        const { email } = req.body;
        const userRecord = await User.findOne({ email });
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User with this email does not exist",
            });
        }

        if(!userRecord.isVerified) {
            return res.status(400).json({
                success: false,
                error: "Please verify your email first before resetting password",
            });
        }

        const lastSentAt = userRecord.passwordResetLastSentAt?.getTime?.() ?? 0;
        if(Date.now() - lastSentAt < 60 * 1000) {
            return res.status(429).json({
                success: false,
                error: "Please wait before requesting another password reset code",
            });
        }

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const otpHash = await bcrypt.hash(otp, 10);
        const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

        await User.updateOne({ _id: userRecord._id }, {
            passwordResetOtpHash: otpHash,
            passwordResetOtpExpiresAt: expiresAt,
            passwordResetAttempts: 0,
            passwordResetLastSentAt: new Date(),
        });

        const htmlTemplate = `
            <div style="font-family: Arial, sans-serif;">
                <h2>Password Reset Request</h2>
                <p>Hi ${userRecord.username},</p>
                <p>You requested to reset your password. Use the code below to reset your password:</p>
                <div style="font-size: 24px; font-weight: bold; letter-spacing: 4px;">${otp}</div>
                <p>This code expires in 5 minutes.</p>
                <p>If you didn't request this, please ignore this email.</p>
            </div>
        `;

        try {
            await sendEmail(userRecord.username, userRecord.email, htmlTemplate);
        } catch (e) {
            return res.status(500).json({
                success: false,
                error: "Failed to send password reset email. Please try again.",
            });
        }

        return res.status(200).json({
            success: true,
            message: "Password reset code sent to your email",
            data: {},
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const verifyPasswordResetOtp = async(req: Request, res: Response) => {
    try {
        const validationResult = verifyPasswordResetOtpSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues
                .map((issue) => issue.message) 
                .join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        }

        const { email, otp } = req.body;
        const userRecord = await User.findOne({ email });
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User not found",
            });
        }

        if(!userRecord.passwordResetOtpHash || !userRecord.passwordResetOtpExpiresAt) {
            return res.status(400).json({
                success: false,
                error: "No password reset code found. Please request a new one.",
            });
        }

        if(userRecord.passwordResetOtpExpiresAt.getTime() < Date.now()) {
            return res.status(400).json({
                success: false,
                error: "Password reset code expired. Please request a new one.",
            });
        }

        const attempts = userRecord.passwordResetAttempts ?? 0;
        if(attempts >= 3) {
            return res.status(429).json({
                success: false,
                error: "Too many attempts. Please request a new password reset code.",
            });
        }

        const isMatch = await bcrypt.compare(otp, userRecord.passwordResetOtpHash);
        if(!isMatch) {
            await User.updateOne({ _id: userRecord._id }, {
                $inc: { passwordResetAttempts: 1 },
            });
            return res.status(400).json({
                success: false,
                error: "Invalid password reset code",
            });
        }

        return res.status(200).json({
            success: true,
            message: "Password reset code verified successfully",
            data: {},
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const resendPasswordResetOtp = async(req: Request, res: Response) => {
    try {
        const validationResult = forgotPasswordSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues
                .map((issue) => issue.message) 
                .join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        }

        const { email } = req.body;
        const userRecord = await User.findOne({ email });
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User not found",
            });
        }

        if(!userRecord.isVerified) {
            return res.status(400).json({
                success: false,
                error: "Please verify your email first before resetting password",
            });
        }

        const lastSentAt = userRecord.passwordResetLastSentAt?.getTime?.() ?? 0;
        if(Date.now() - lastSentAt < 60 * 1000) {
            return res.status(429).json({
                success: false,
                error: "Please wait before requesting another password reset code",
            });
        }

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const otpHash = await bcrypt.hash(otp, 10);
        const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

        await User.updateOne({ _id: userRecord._id }, {
            passwordResetOtpHash: otpHash,
            passwordResetOtpExpiresAt: expiresAt,
            passwordResetAttempts: 0,
            passwordResetLastSentAt: new Date(),
        });

        const htmlTemplate = `
            <div style="font-family: Arial, sans-serif;">
                <h2>Password Reset Request</h2>
                <p>Hi ${userRecord.username},</p>
                <p>You requested to reset your password. Use the code below to reset your password:</p>
                <div style="font-size: 24px; font-weight: bold; letter-spacing: 4px;">${otp}</div>
                <p>This code expires in 5 minutes.</p>
                <p>If you didn't request this, please ignore this email.</p>
            </div>
        `;

        await sendEmail(userRecord.username, userRecord.email, htmlTemplate);

        return res.status(200).json({
            success: true,
            message: "Password reset code resent",
            data: {},
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const resetPassword = async(req: Request, res: Response) => {
    try {
        const validationResult = resetPasswordSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues
                .map((issue) => issue.message) 
                .join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        }

        const { email, otp, newPassword, confirmPassword } = req.body;
        
        if(newPassword !== confirmPassword) {
            return res.status(400).json({
                success: false,
                error: "New password and confirm password do not match",
            });
        }

        const userRecord = await User.findOne({ email });
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User not found",
            });
        }

        if(!userRecord.passwordResetOtpHash || !userRecord.passwordResetOtpExpiresAt) {
            return res.status(400).json({
                success: false,
                error: "No password reset code found. Please request a new one.",
            });
        }

        if(userRecord.passwordResetOtpExpiresAt.getTime() < Date.now()) {
            return res.status(400).json({
                success: false,
                error: "Password reset code expired. Please request a new one.",
            });
        }

        const attempts = userRecord.passwordResetAttempts ?? 0;
        if(attempts >= 3) {
            return res.status(429).json({
                success: false,
                error: "Too many attempts. Please request a new password reset code.",
            });
        }

        const isMatch = await bcrypt.compare(otp, userRecord.passwordResetOtpHash);
        if(!isMatch) {
            await User.updateOne({ _id: userRecord._id }, {
                $inc: { passwordResetAttempts: 1 },
            });
            return res.status(400).json({
                success: false,
                error: "Invalid password reset code",
            });
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);
        if(!hashedPassword) {
            return res.status(500).json({
                success: false,
                error: "Error while processing new password",
            });
        }

        await User.updateOne({ _id: userRecord._id }, {
            password: hashedPassword,
            passwordResetOtpHash: null,
            passwordResetOtpExpiresAt: null,
            passwordResetAttempts: 0,
        });

        return res.status(200).json({
            success: true,
            message: "Password reset successfully",
            data: {},
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const resendVerificationOtp = async(req: Request, res: Response) => {
    try {
        const validationResult = resendVerificationOtpSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues
                .map((issue) => issue.message) 
                .join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        }
        const { email } = req.body;
        if(!email) {
            return res.status(400).json({
                success: false,
                error: "Email is required",
            });
        }

        const userRecord = await User.findOne({ email });
        if(!userRecord) {
            return res.status(404).json({
                success: false,
                error: "User not found",
            });
        }

        if(userRecord.isVerified) {
            return res.status(200).json({
                success: true,
                message: "Email already verified",
                data: {},
            });
        }

        const lastSentAt = userRecord.emailVerificationLastSentAt?.getTime?.() ?? 0;
        if(Date.now() - lastSentAt < 60 * 1000) {
            return res.status(429).json({
                success: false,
                error: "Please wait before requesting another code",
            });
        }

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const otpHash = await bcrypt.hash(otp, 10);
        const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

        await User.updateOne({ _id: userRecord._id }, {
            emailVerificationOtpHash: otpHash,
            emailVerificationOtpExpiresAt: expiresAt,
            emailVerificationAttempts: 0,
            emailVerificationLastSentAt: new Date(),
        });

        const htmlTemplate = `
            <div style="font-family: Arial, sans-serif;">
                <h2>Verify your email</h2>
                <p>Hi ${userRecord.username},</p>
                <p>Your verification code for Blog App is:</p>
                <div style=\"font-size: 24px; font-weight: bold; letter-spacing: 4px;\">${otp}</div>
                <p>This code expires in 5 minutes.</p>
                <p>If you didn't sign up, you can ignore this email.</p>
            </div>
        `;

        await sendEmail(userRecord.username, userRecord.email, htmlTemplate);
        return res.status(200).json({
            success: true,
            message: "Verification code resent",
            data: {},
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}
