import express from "express";
import dotenv from "dotenv";
import { sql } from "./utils/db.js";
import blogRoutes from "./routes/blog.js";
import commentRoutes from "./routes/comment.js"
import { createClient } from "redis";
import { connectRabbitMQ } from "./utils/rabbitmq.js";
import { startCacheWorker } from "./workers/cache_worker.js";
import cors from "cors";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

connectRabbitMQ();
startCacheWorker();

async function initDB() {
    try{
        await sql`
            CREATE TABLE IF NOT EXISTS categories(
            id SERIAL PRIMARY KEY,
            title VARCHAR(255) NOT NULL UNIQUE,
            created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
        )
        `;
        await sql`
            CREATE TABLE IF NOT EXISTS blogs(
            id SERIAL PRIMARY KEY,
            title VARCHAR(255) NOT NULL,
            short_description VARCHAR(255) NOT NULL,
            description TEXT NOT NULL,
            image_url VARCHAR(255) NOT NULL,
            category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
            author_id VARCHAR(255) NOT NULL,
            created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
        )
        `;
        await sql`
            CREATE TABLE IF NOT EXISTS savedblogs(
            id SERIAL PRIMARY KEY,
            blog_id INTEGER NOT NULL REFERENCES blogs(id) ON DELETE CASCADE,
            user_id VARCHAR(255) NOT NULL,
            created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
        )
        `;
        await sql`
            CREATE TABLE IF NOT EXISTS upvotes(
            id SERIAL PRIMARY KEY,
            blog_id INTEGER NOT NULL REFERENCES blogs(id) ON DELETE CASCADE,
            user_id VARCHAR(255) NOT NULL,
            created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
        )
        `;
        await sql`
            CREATE TABLE IF NOT EXISTS comments(
            id SERIAL PRIMARY KEY,
            comment TEXT NOT NULL,
            user_id VARCHAR(255) NOT NULL,
            blog_id INTEGER NOT NULL REFERENCES blogs(id) ON DELETE CASCADE,
            created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
            )
        `;
        await sql`
            CREATE TABLE IF NOT EXISTS commentupvotes(
            id SERIAL PRIMARY KEY,
            user_id VARCHAR(255) NOT NULL,
            comment_id INTEGER NOT NULL REFERENCES comments(id) ON DELETE CASCADE,
            blog_id INTEGER NOT NULL REFERENCES blogs(id) ON DELETE CASCADE,
            status VARCHAR(10) NOT NULL CHECK (status IN ('like', 'dislike')),
            created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
            )
        `;

        console.log("DATABASE initialised successfully!!!!");
    } catch(error) {
        console.log("Error initDb", error);
    }
}

export const redisClient = createClient({
    url: process.env.REDIS_URL as string,
});

redisClient
    .connect() 
    .then(() => console.log("Connected to Redis::::::::::"))
    .catch((error) => {
        console.error("Redis connection failed:", error.message);
        console.log("Running without Redis cache...");
    });

app.use("/api/health", (req, res) => { 
    res.send("Author service is running successfully");
});
app.use("/api/v1/blogs", blogRoutes);
app.use("/api/v1/comments", commentRoutes);

initDB().then(() => {
    const port = process.env.PORT as string;
    app.listen(port, () => {
        console.log(`Blog service is listening on PORT: ${port}`);
    });
});
