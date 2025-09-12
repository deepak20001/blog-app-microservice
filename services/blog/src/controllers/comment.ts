import type { AuthenticatedRequest } from "../middleware/isAuth.js";
import type { Request, Response } from "express";
import { z } from "zod";
import { sql } from "../utils/db.js";
import { getTokenFromHeader } from "../utils/get_token.js";
import axios from "axios";

// Validation schemas
const createCommentSchema = z.object({
    comment: z
        .string()
        .min(1, "Comment cannnot be empty")
        .max(500, "Comment must be at most 500 characters"),
    blog_id: z.number().int("Blog ID is invalid"),
});

// Controllers :::::::::::::::::::::::
export const createComment = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const validationResult = createCommentSchema.safeParse(req.body);
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

        const { comment, blog_id: blogId } = req.body;
        const result = await sql`
            INSERT INTO comments 
            (comment, user_id, blog_id) VALUES (${comment}, ${payloadData._id}, ${blogId})
            RETURNING *
        `;

        if(!result || result.length === 0) {
            return res.status(500).json({
                success: false,
                error: "Error posting comment",
            });
        }

        return res.status(201).json({
            success: true,
            message: "Comment posted successfully",
            data: result[0],
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const getComments = async(req: AuthenticatedRequest, res: Response) => {
    try {
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated request",
            });
        }

        const { id } = req.params;
        const blogId = Number(id);
        if (!id || isNaN(blogId) || blogId <= 0) {
            return res.status(400).json({
                success: false,
                error: "Invalid blog ID",
            });
        }

        const result = await sql`
            SELECT * FROM comments 
            WHERE blog_id = ${id}
        `;
        if(!result) {
            return res.status(500).json({
                success: false,
                error: "Error fetching comments",
            });
        }

        // vote-count
        const commentIds = result.map(comment => comment.id);
        const voteCountQueryResult = await sql`
            SELECT comment_id, COUNT(*)::int as count
            FROM commentupvotes
            WHERE user_id = ${payloadData._id} AND blog_id = ${blogId} AND status = 'like' AND comment_id = ANY(${commentIds})
            GROUP BY comment_id
        `;
        /* 
        [ 
            { comment_id: 1, count: 1 }
        ] 
        */
        const voteCountMap = Object.fromEntries(voteCountQueryResult.map(v => [v.comment_id, v.count]));
        
        // is-voted
        const userVotes = await sql`
            SELECT comment_id 
            FROM commentupvotes
            WHERE comment_id = ANY(${commentIds}) AND user_id = ${payloadData._id}
        `;
        const votedMap = new Set(userVotes.map(v => v.comment_id));

        if(result.length > 0 ) {
            const userIds = [...new Set(result.map(comment => comment.user_id))];
            const token = getTokenFromHeader(req);
            if (!token) {
                    return res.status(401).json({
                    success: false,
                    error: "Invalid token",
                });
            }
            const usersResult = await axios.post(
                `${process.env.USER_SERVICE_URL}/api/v1/users/profiles`,
                {
                    ids: userIds,
                },
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                }
            );
            if(!usersResult) {
                return res.status(400).json({
                    success: false,
                    error: "Error fetch users details",
                });
            }
            const usersMap: Record<string, any> = {};
            for(const user of usersResult.data.data) {
                usersMap[user._id] = user;
            }

            const commentsWithMoreFields = result.map(comment => {
                return ({
                    ...comment,
                    author: usersMap[comment.user_id] || null,
                    vote_count: voteCountMap[comment.id] || 0,
                    is_voted: votedMap.has(comment.id),
                });
            });

                return res.status(200).json({
                    success: true,
                    message: "Comments fetched successfully",
                    data: commentsWithMoreFields,
                });
            } else {
                return res.status(200).json({
                    success: true,
                    message: "Comments fetched successfully",
                    data: [],
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

export const upvoteComment = async (req: AuthenticatedRequest, res: Response) => {
    try {
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated request",
            });
        }

        const {blog_id: blogId, comment_id: commentId} = req.body;
        if(!blogId || isNaN(blogId) || blogId <= 0) {
            return res.status(400).json({
                success: false,
                error: "Invalid blog id",
            });
        }
        if(!commentId || isNaN(commentId) || commentId <= 0) {
            return res.status(400).json({
                success: false,
                error: "Invalid comment id",
            });
        }

        const result = await sql`
            SELECT * FROM commentupvotes
            WHERE comment_id = ${commentId} AND blog_id = ${blogId} AND user_id = ${payloadData._id}
        `;
        if(result && result.length > 0) {
            return res.status(409).json({
                success: false,
                error: "Comment is already upvoted",
            });
        }

        const commentRecord = await sql`
            SELECT * FROM comments
            WHERE id = ${commentId}
        `;
        if(!commentRecord || commentRecord.length === 0) {
            res.status(404).json({
                success: false,
                error: "Comment not found",
            });
        }

        const blogRecord = await sql`
            SELECT * FROM blogs
            WHERE id = ${blogId}
        `;
        if(!blogRecord || blogRecord.length === 0) {
            return res.status(404).json({
                success: false, 
                error: "Blog not found",
            });
        }

        await sql`
            INSERT INTO commentupvotes 
            (user_id, comment_id, blog_id, status)
            VALUES (${payloadData._id}, ${commentId}, ${blogId}, 'like')
        `;

        return res.status(201).json({
            success: true,
            message: "Comment upvoted successfully",
            data: {},
        });
    } catch (error: any) {
        console.log(error);
        res.status(500).json({
            success: false,
            error: error.message,
        });
    }
}

export const unupvoteComment = async (req: AuthenticatedRequest, res: Response) => {
    try { 
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }

        const { blog_id: blogId, comment_id: commentId } = req.body;
        const isInvalidBlogId = !blogId || isNaN(blogId) || blogId <= 0;
        const isInvalidCommentId = !commentId || isNaN(commentId) || commentId <= 0;
        if(isInvalidBlogId || isInvalidCommentId) {
            return res.status(400).json({
                success: false,
                error: isInvalidBlogId ? 'Invalid blog id' : 'Invalid comment id'
            });
        }

        const result = await sql`
            SELECT * FROM commentupvotes
            WHERE comment_id = ${commentId} AND blog_id = ${blogId} AND user_id = ${payloadData._id}
        `;
        if(!result || result.length === 0) {
            return res.status(409).json({
                success: true,
                error: "Comment is not voted",
            });
        }

        await sql`
            DELETE FROM commentupvotes
            WHERE comment_id = ${commentId} AND blog_id = ${blogId} AND user_id = ${payloadData._id}
        `;

        return res.status(200).json({
            success: true,
            message: "Comment unvoted successfully",
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

export const deleteComment = async (req: AuthenticatedRequest, res: Response) => {
    try {
        const payloadData = req.user;
        if(!payloadData || !payloadData._id) {
            return res.status(401).json({
                success: false,
                error: "Unauthenticated user",
            });
        }

        const { comment_id: commentId, blog_id: blogId } = req.body;
        const isInvalidBlogId = !blogId || isNaN(blogId) || blogId <= 0;
        const isInvalidCommentId = !commentId || isNaN(commentId) || commentId <= 0;
        if(isInvalidBlogId || isInvalidCommentId) {
            return res.status(400).json({
                success: false,
                error: isInvalidBlogId ? 'Invalid blog id' : 'Invalid comment id'
            });
        }

        const result = await sql`
            SELECT * FROM comments 
            WHERE id = ${commentId} AND user_id = ${payloadData._id} AND blog_id = ${blogId}
        `;
        if(!result || result.length === 0) {
            return res.status(404).json({
                success: false,
                error: "Comment record not found for this user",
            });
        }

        await sql`
            DELETE FROM comments 
            WHERE id = ${commentId} AND user_id = ${payloadData._id} AND blog_id = ${blogId}
        `;

        return res.status(200).json({
            success: true,
            message: "Comment deleted successfully",
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