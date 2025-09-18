import mongoose, { Document, Schema } from "mongoose";

export enum UserRole {
    USER = "user",
    ADMIN = "admin",
}

export interface IUser extends Document {
    username: string;
    email: string;
    password: string;
    bio: string;
    avatar: string;
    role: UserRole;
    isVerified: boolean;
    emailVerificationOtpHash?: string | null;
    emailVerificationOtpExpiresAt?: Date | null;
    emailVerificationAttempts?: number;
    emailVerificationLastSentAt?: Date | null;
    passwordResetOtpHash?: string | null;
    passwordResetOtpExpiresAt?: Date | null;
    passwordResetAttempts?: number;
    passwordResetLastSentAt?: Date | null;
}

const schema: Schema<IUser>  = new Schema({
    username: {
        type: String,
        required: true,
        unique: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
    bio: {
        type: String,
        default: "",
    },
    avatar: {
        type: String,
        default: "",
    },
    role: {
        type: String,
        enum: Object.values(UserRole),
        required: true,
        default: UserRole.USER,
    },
    isVerified: {
        type: Boolean,
        default: false,
    },
    emailVerificationOtpHash: {
        type: String,
        default: null,
    },
    emailVerificationOtpExpiresAt: {
        type: Date,
        default: null,
    },
    emailVerificationAttempts: {
        type: Number,
        default: 0,
    },
    emailVerificationLastSentAt: {
        type: Date,
        default: null,
    },
    passwordResetOtpHash: {
        type: String,
        default: null,
    },
    passwordResetOtpExpiresAt: {
        type: Date,
        default: null,
    },
    passwordResetAttempts: {
        type: Number,
        default: 0,
    },
    passwordResetLastSentAt: {
        type: Date,
        default: null,
    },
},
{
    timestamps: true,
},
);

const User = mongoose.model<IUser>("User", schema);

export default User;