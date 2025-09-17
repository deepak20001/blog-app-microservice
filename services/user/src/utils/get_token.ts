import type { AuthenticatedRequest } from "../middleware/isAuth.js";


export const getTokenFromHeader = (req: AuthenticatedRequest): string | null => {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return null;
    }

    const token = authHeader.split(" ")[1];
    if (!token || token.trim() === "") {
        return null;
    }

    return token;
};