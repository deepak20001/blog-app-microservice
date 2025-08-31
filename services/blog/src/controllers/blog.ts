import type {Request, Response} from "express";
import getBuffer from "../utils/data_uri.js";
import cloudinary from "cloudinary";
import { sql } from "../utils/db.js";
import type { AuthenticatedRequest } from "../middleware/isAuth.js";
import { z } from "zod";
import axios from "axios";
import { getTokenFromHeader } from "../utils/get_token.js";

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
        max(1000, "Name must not exceed 200 characters"),
    image: z.string(),
    category_id: z.string(),
});

// Controllers ::::::::::
export const createCategory = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const validationResult = createCategorySchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues
                .map((issue) => issue.message) 
                .join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        }
        
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }

        const {title} = req.body;
        const categoryRecord = await sql`
        INSERT INTO categories (title) VALUES (${title}) RETURNING *
        `;
        if(!categoryRecord || categoryRecord.length === 0) {
            return res.status(500).json({
                success: false,
                error: "Error creating category",
            });
        } 

        return res.status(201).json({
            sucess: true,
            message: "Category created successfully",
            data: categoryRecord[0],
        });
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
        const validationResult = createBlogSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues
                .map((issue) => issue.message) 
                .join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        }

        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }
        
        const authorId = payloadData._id;
        const {title, description, image, category_id: categoryId} = req.body;

        const categoryRecord = await sql`
        SELECT * FROM categories WHERE id = ${categoryId}
        `;
        if(!categoryRecord || categoryRecord.length === 0) {
            return res.status(400).json({
                success: false,
                error: "Invalid categoryId: category does not exist",
            })
        }
        
        const token = getTokenFromHeader(req);
        if (!token) {
            return res.status(401).json({
            success: false,
            error: "Invalid token",
            });
        }
        const authorRecord = await axios.get(`${process.env.USER_SERVICE_URL}/api/v1/users/${authorId}`, {
            headers: {
                Authorization: `Bearer ${token}`,
            }
        });
        if(!authorRecord) {
            return res.status(400).json({
                success: false,
                error: "Invalid authorId: author does not exist",
            })
        } 

        const result = await sql`
            INSERT INTO blogs (title, description, image_url, category_id, author_id) 
            VALUES (${title}, ${description}, ${image}, ${categoryId}, ${authorId})
            RETURNING *
        `;

        if(!result || result.length === 0) {
            return res.status(500).json({
                success: false,
                error: "Error creating blog",
            })
        }

        return res.status(201).json({
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

export const getBlogById = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const {id} = req.params;

        const blogId = Number(id);
        if (!id || isNaN(blogId) || blogId <= 0) {
        return res.status(400).json({
            success: false,
            error: "Invalid blog ID",
        });
        }

        const result = await sql`
            SELECT * FROM blogs WHERE id = ${blogId}
        `;

        if(!result || result.length === 0) {
            return res.status(400).json({
                success: false,
                error: "Invalid blogId: blog does not exist",
            })
        }
        
        const blog = result[0];
        const authorId = blog!.author_id;
        const token = getTokenFromHeader(req);
        if (!token) {
            return res.status(401).json({
            success: false,
            error: "Invalid token",
            });
        } 

        const authorRecord = await axios.get(`${process.env.USER_SERVICE_URL}/api/v1/users/${authorId}`, {
            headers: {
                Authorization: `Bearer ${token}`,
            }
        });
        if(!authorRecord) {
            return res.status(400).json({
                success: false,
                error: "Invalid authorId: author does not exist",
            })
        } 
        return res.status(200).json({
            success: true,
            message: "Blog fetched successfully",
            data: {
                ...blog,
                author: authorRecord.data["data"],
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

export const getBlogs = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const result = await sql`
            SELECT * FROM blogs
        `;

        if(!result) {
            return res.status(500).json({
                success: false,
                error: "Error fetching blogs",
            });
        }

        const authorIds = [...new Set(result.map(blog => blog.author_id))];
        const token = getTokenFromHeader(req);
        if (!token) {
                return res.status(401).json({
                success: false,
                error: "Invalid token",
            });
        }
        const authorsResult = await axios.post(
            `${process.env.USER_SERVICE_URL}/api/v1/users/profiles`,
            {
                ids: authorIds,
            },
            {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            }
        );
        if(!authorsResult) {
            return res.status(400).json({
                success: false,
                error: "Error fetch authors details",
            });
        }

        const authorsMap: Record<string, any> = {};
        for (const author of authorsResult.data.data) {
            authorsMap[author._id] = author;
        }

        const blogsWithAuthor = result.map(blog => ({
            ...blog,
            author: authorsMap[blog.author_id] || null,
        }));

        return res.status(200).json({
            success: true,
            data: blogsWithAuthor,
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const updateBlog = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const validationResult = createBlogSchema.safeParse(req.body);
        if(!validationResult.success) {
            const errorMessage = validationResult.error.issues
                .map((issue) => issue.message) 
                .join(", ");
            return res.status(400).json({
                success: false,
                error: errorMessage,
            });
        }

        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }

        const authorId = payloadData._id;
        const {title, description, image, category_id: categoryId} = req.body;
        const {id: blodId} = req.params;

        const blogRecord = await sql`
            SELECT * FROM blogs WHERE id = ${blodId}
        `;

        if(!blogRecord || blogRecord.length === 0 || !blogRecord[0]) {
            return res.status(400).json({
                success: false,
                error: "Blog not found",
            });
        }

        if(blogRecord[0].author_id != authorId) {
            return res.status(403).json({
                success: false,
                error: "You are not allowed to update this blog",
            });
        }

        const categoryRecord = await sql`
            SELECT * FROM categories WHERE id = ${categoryId}
        `;
        if(!categoryRecord || categoryRecord.length === 0) {
            return res.status(400).json({
                success: false,
                error: "Invalid categoryId: category does not exist",
            })
        }

        const result = await sql`
            UPDATE blogs SET 
            title = ${title}, description = ${description}, image_url = ${image}, category_id = ${categoryId}
            WHERE id = ${blodId}
            RETURNING * 
        `;

        if(!result || result.length === 0) {
            return res.status(500).json({
                success: false,
                error: "Error updating blog",
            });
        }

        return res.status(200).json({
            success: true,
            data: result,
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const deleteBlog = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const {id: blodId} = req.params;
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }

        const authorId = payloadData._id;
        const blogRecord = await sql`
            SELECT * FROM blogs WHERE id = ${blodId}
        `;
        if(!blogRecord || blogRecord.length === 0 || !blogRecord[0]) {
            return res.status(400).json({
                success: false,
                error: "Blog not found",
            });
        }

        if(blogRecord[0].author_id != authorId) {
            return res.status(403).json({
                success: false,
                error: "You are not allowed to delete this blog",
            });
        }

        await sql`
            DELETE FROM blogs WHERE id = ${1} AND author_id = ${authorId}
        `;

        res.status(200).json({
            success: true,
            message: "Blog deleted successfully",
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}