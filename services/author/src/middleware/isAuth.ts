import type { Request, Response, NextFunction } from "express";
import jwt, { type JwtPayload } from "jsonwebtoken";

interface IUser extends Document {
    _id: string,
    name: string;
    email: string;
    image: string;
    instagram: string;
    facebook: string;
    linkedin: string;
    bio: string;
}

export interface AuthenticatedRequest extends Request {
    user?: IUser | null,
}

export const isAuth = async(req: AuthenticatedRequest, res: Response, next: NextFunction) : Promise<void> => {
    try {
        const authHeader = req.headers.authorization;
        if(!authHeader || !authHeader.startsWith("Bearer ")) {
            res.status(401).json({
                success: false,
                error: "Invalid token",
            });
            return;
        }
        const token = authHeader.split(" ")[1];
        if(!token || token === "") {
            res.status(401).json({
                success: false,
                error: "Invalid token",
            });
            return;
        }

        const decodedValue = jwt.verify(token, process.env.JWT_SECRET as string) as JwtPayload;
        if(!decodedValue) {
            res.status(401).json({
                success: false,
                error: "Invalid token",
            });
            return;
        }

        req.user = decodedValue.user;
        if(!req.user || !req.user._id) {
            res.status(401).json({
                success: false,
                error: "Unauthorized user",
            });
        }
        next();
    } catch (error) {
        console.log("KWT verification error: ", error);
        res.status(401).json({
            success: false,
            error: "Unauthorized user",
        });
    }
}