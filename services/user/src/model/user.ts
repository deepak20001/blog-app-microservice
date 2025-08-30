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
},
{
    timestamps: true,
},
);

const User = mongoose.model<IUser>("User", schema);

export default User;