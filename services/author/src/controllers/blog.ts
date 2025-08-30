import type {Request, Response} from "express";
import getBuffer from "../utils/data_uri.js";
import cloudinary from "cloudinary";
import { sql } from "../utils/db.js";
import type { AuthenticatedRequest } from "../middleware/isAuth.js";
import {z} from "zod";

// Validation schemas
const createCategorySchema = z.object({
    title: z.string().
        min(3, "Name of category must be atleast 3 characters long").
        max(30, "Name of category must not exceed 30 characters"),
});

const createBlogSchema = z.object({
    title: z.string().
        min(3, "Name must be at least 3 characters long").
        max(200, "Name must not exceed 200 characters"),
    description: z.string().
        min(3, "Name must be at least 3 characters long").
        max(200, "Name must not exceed 200 characters"),
    blog_content: z.string().
        min(3, "Name must be at least 3 characters long").
        max(500, "Name must not exceed 500 characters"),
    category: z.string(),
    
});

// Controllers ::::::::::
export const createCategory = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const validationResult = createCategorySchema.safeParse(req.body);
        if(!validationResult.success) {
            return res.status(400)
        }
        const {title} = req.body;
    } catch (error: any) {
        console.log(error);
        res.status(500).json(
            {
                success: false,
                error: error.message,
            }
        );
    }
}

export const createBlog = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const {title, description, blog_content: blogContent, category} = req.body;
        const file = req.file;

        const userId = req.user!._id;

        if(!file) {
            return res.status(400).json({
                success: false,
                message: "Image is required",
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

        const cloudStorage = await cloudinary.v2.uploader.upload(
            fileBuffer.content, {
                folder: "blog-app-storage/blog-images",
                resource_type: "image",
            }
        );

        const result = await sql`
        INSERT INTO blogs (title, description, blog_content, image, category, author)
        VALUES (${title}, ${description}, ${blogContent}, ${cloudStorage.secure_url}, ${category}, ${userId})
        RETURNING *
        `;

        res.status(200).json({
            success: true,
            message: "Blog created successfully",
            data: result[0],
        });
    } catch (error: any) {
        console.log(error);
        return res.status(500).json({
            success: false,
            error: error.message,
        });
    } 
}