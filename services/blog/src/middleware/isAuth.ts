import type { Request, Response, NextFunction } from "express";
import jwt, { type JwtPayload } from "jsonwebtoken";
import { getTokenFromHeader } from "../utils/get_token.js";

export interface JwtUser {
    _id: string;
    email: string;
}

export interface AuthenticatedRequest extends Request {
    user?: JwtUser | null,
}

export const isAuth = async(req: AuthenticatedRequest, res: Response, next: NextFunction) : Promise<void> => {
    try {
        const token = getTokenFromHeader(req);
        if (!token) {
            res.status(401).json({
            success: false,
            error: "Invalid token",
            });
            return;
        }
        const decodedValue = jwt.verify(token, process.env.JWT_SECRET as string) as JwtUser;
        if (!decodedValue || !decodedValue._id || !decodedValue.email) {
            res.status(401).json({
                success: false,
                error: "Invalid token payload",
            });
            return;
        }
        
        req.user = decodedValue;
        next();
    } catch (error) {
        console.log("KWT verification error: ", error);
        res.status(401).json({
            success: false,
            error: "Unauthorized user",
        });
    }
}