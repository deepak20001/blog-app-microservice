import type {Request, Response} from "express";
import { sql } from "../utils/db.js";
import type { AuthenticatedRequest } from "../middleware/isAuth.js";
import { success, z } from "zod";
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
    category_id: z.number(),
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

export const getCategories = async(req: AuthenticatedRequest, res: Response ) => {
    try {
        const categoriesRecord = await sql`
            SELECT * FROM categories
            ORDER BY created_at ASC
        `;
        if(!categoriesRecord) {
            return res.status(500).json({
                success: false,
                error: "Error fetching categories",
            });
        }

        return res.status(200).json({
            success: true,
            message: "Categories fetched successfully",
            data: categoriesRecord,
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        });
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
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        } 
        const {id} = req.params;
        const blogId = Number(id);
        if (!id || isNaN(blogId) || blogId <= 0) {
            return res.status(400).json({
                success: false,
                error: "Invalid blog ID",
            });
        }
        
        // vote-count
        const voteCount = await sql`
            SELECT COUNT(*)::int
            FROM upvotes
            WHERE blog_id = ${blogId}
        `;

        // is-voted
        const isVotedRecord = await sql`
            SELECT * FROM upvotes
            WHERE blog_id = ${blogId} AND user_id = ${payloadData._id}
        `;
        let isVoted = false;
        if(isVotedRecord && isVotedRecord.length != 0) {
            isVoted = true;
        }

        // is-saved
        const isSavedRecord = await sql`
            SELECT * FROM savedblogs 
            WHERE blog_id = ${blogId} AND user_id = ${payloadData._id}
        `;
        let isSaved = false;
        if(isSavedRecord && isSavedRecord.length != 0) {
            isSaved = true;
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
                vote_count: voteCount?.[0]?.count ?? 0,
                is_voted: isVoted,
                is_saved: isSaved,
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
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }
        
        const {category_id: categoryId, search} = req.query;
        const categoryRecord = await sql`
            SELECT * FROM categories WHERE id = ${categoryId}
        `;

        const page = parseInt(req.query.page as string) || 1;
        const limit = Math.min(parseInt(req.query.limit as string) || 10, 20);
        const offset = (page - 1) * limit;

        let countResult;
        if(categoryId && categoryRecord && categoryRecord.length > 0) {
            countResult = await sql`
                SELECT COUNT(*) as total FROM blogs
                WHERE category_id = ${categoryId}
            `;
        } else {
            countResult = await sql`
                SELECT COUNT(*) as total FROM blogs
            `;
        }
        if(!countResult || countResult.length <= 0 || !countResult[0]) {
            return res.status(500).json({
                success: false,
                error: "Error fetching blogs count",
            });
        }
        const totalItems = parseInt(countResult[0].total);
        const totalPages = Math.ceil(totalItems/limit);

        let result;
        if(categoryId && categoryRecord && categoryRecord.length > 0) {
            result = await sql`
                SELECT * FROM blogs 
                WHERE category_id = ${categoryId}
                AND (title ILIKE ${'%' + search + '%'} OR description ILIKE ${'%' + search + '%'})
                ORDER BY created_at DESC
                LIMIT ${limit} OFFSET ${offset}
            `;
        } else {
            result = await sql`
                SELECT * FROM blogs
                WHERE (title ILIKE ${'%' + search + '%'} OR description ILIKE ${'%' + search + '%'})
                ORDER BY created_at DESC
                LIMIT ${limit} OFFSET ${offset}
            `;
        }
        

        if(!result) {
            return res.status(500).json({
                success: false,
                error: "Error fetching blogs",
            });
        } 
        
        // vote-count
        const blogIds = result.map(blog => blog.id);
        const voteCounts = await sql`
            SELECT blog_id, COUNT(*)::int as count
            FROM upvotes
            WHERE blog_id = ANY(${blogIds})
            GROUP BY blog_id
        `;
        /*  will receive it like this
        [
            { blog_id: 'b1', count: 3 },
            { blog_id: 'b2', count: 1 }
        ]
        */
        const voteCountMap = Object.fromEntries(voteCounts.map(v => [v.blog_id, v.count]));

        // is-voted
        const userVotes = await sql`
            SELECT blog_id
            FROM upvotes
            WHERE blog_id = ANY(${blogIds}) AND user_id = ${payloadData._id}
        `;
        const votedMap = new Set(userVotes.map(v => v.blog_id));

        // is-saved
        const userSaves = await sql`
            SELECT blog_id
            FROM savedblogs
            WHERE blog_id = ANY(${blogIds}) AND user_id = ${payloadData._id}
        `;
        const savedMap = new Set(userSaves.map(v => v.blog_id));

        if(result.length > 0) {
            // author-profile data
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
    
            const blogsWithAuthor = result.map(blog => {
                return ({
                    ...blog,
                    author: authorsMap[blog.author_id] || null,
                    vote_count: voteCountMap[blog.id] || 0,
                    is_voted: votedMap.has(String(blog.id)),
                    is_saved: savedMap.has(String(blog.id)), 
                })
            } );

            return res.status(200).json({
                success: true,
                data: blogsWithAuthor,
                pagination: {
                    current_page: page,
                    total_pages: totalPages,
                    total_items: totalItems,
                    items_per_page: limit,
                    has_next: page < totalPages,
                    has_prev: page > 1,
                },
            });
        } else {
            return res.status(200).json({
                success: true,
                data: [],
                pagination: {
                    current_page: page,
                    total_pages: totalPages,
                    total_items: totalItems,
                    items_per_page: limit,
                    has_next: page < totalPages,
                    has_prev: page > 1,
                },
            });
        }
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

export const saveBlog = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }
        const userId = payloadData._id;
        const {blog_id: blogId} = req.body;
        const blogRecord = await sql`
            SELECT * FROM blogs WHERE id = ${blogId}
        `;

        if(!blogRecord || blogRecord.length <= 0) {
            return res.status(400).json({
                success: false,
                error: "Invalid blog id",
            });
        }

        const savedBlogRecord = await sql`
            SELECT * FROM savedblogs 
            WHERE blog_id = ${blogId} AND user_id = ${userId}
        `;

        if(savedBlogRecord && savedBlogRecord.length > 0) {
            return res.status(409).json({
                success: false,
                error: "Blog is already saved",
            });
        }

        await sql`
            INSERT INTO savedblogs (blog_id, user_id) 
            VALUES (${blogId}, ${userId})
        `;
        
        return res.status(201).json({
            success: true,
            message: "Blog saved successfully",
            data: {},
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        })
    }
}

export const unsaveBlog = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }
        const userId = payloadData._id;
        const {blog_id: blogId} = req.body;
        const savedBlogRecord = await sql`
            SELECT * FROM savedblogs 
            WHERE blog_id = ${blogId} AND user_id = ${userId}
        `;

        if(!savedBlogRecord || savedBlogRecord.length <= 0) {
            return res.status(404).json({
                success: false,
                error: "Saved blog record not found for the user",
            });
        }

        await sql`
            DELETE FROM savedblogs where blog_id = ${blogId} AND user_id = ${userId}
        `;
        
        return res.status(200).json({
            success: true,
            message: "Blog unsaved successfully",
            data: {},
        });
    } catch (error: any) {
        console.log(error.message);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const upvoteBlog = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }
        const userId = payloadData._id;
        const {blog_id: blogId} = req.body;
        const blogRecord = await sql`
            SELECT * FROM blogs WHERE id = ${blogId}
        `;

        if(!blogRecord || blogRecord.length <= 0) {
            return res.status(400).json({
                success: false,
                error: "Invalid blog id",
            });
        }

        const upvoteBlogRecord = await sql`
            SELECT * FROM upvotes 
            WHERE blog_id = ${blogId} AND user_id = ${userId}
        `;
        if(upvoteBlogRecord && upvoteBlogRecord.length > 0) {
            return res.status(409).json({
                success: false,
                error: "Blog is already upvoted",
            });
        }

        await sql`
            INSERT INTO upvotes (blog_id, user_id) 
            VALUES (${blogId}, ${userId})
        `;

        return res.status(201).json({
            success: true,
            message: "Blog upvoted successfully",
            data: {},
        });
    } catch (error: any) {
        console.log(error.message);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const unupvoteBlog = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }
        const userId = payloadData._id;
        const {blog_id: blogId} = req.body;
        const upvotedBlogRecord = await sql`
            SELECT * FROM upvotes 
            WHERE blog_id = ${blogId} AND user_id = ${userId}
        `;

        if(!upvotedBlogRecord || upvotedBlogRecord.length <= 0) {
            return res.status(404).json({
                success: false,
                error: "Upvoted blog record not found for the user",
            });
        }

        await sql`
            DELETE FROM upvotes WHERE blog_id = ${blogId} AND user_id = ${userId}
        `;

        return res.status(200).json({
            success: true,
            message: "Blog unupvoted successfully",
            data: {},
        });
    } catch (error: any) {
        console.log(error.message);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

