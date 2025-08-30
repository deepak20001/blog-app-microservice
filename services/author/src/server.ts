import express from "express";
import dotenv from "dotenv";
import {sql} from "./utils/db.js";
import blogRoutes from "./routes/blog.js";
import {v2 as cloudinary} from "cloudinary";

dotenv.config();

cloudinary.config({ 
    cloud_name: process.env.CLOUD_NAME as string,
    api_key: process.env.CLOUD_API_KEY as string,
    api_secret: process.env.CLOUD_API_SECRET as string,
});


const app = express();

app.use(express.json());

async function initDB() {
    try{
        await sql`
        CREATE TABLE IF NOT EXISTS categories(
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL
        )
        `;
        await sql`
        CREATE TABLE IF NOT EXISTS blogs(
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        description VARCHAR(255) NOT NULL,
        blog_content TEXT NOT NULL,
        image VARCHAR(255) NOT NULL,
        category VARCHAR(255) NOT NULL,
        author VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        `;
        await sql`
        CREATE TABLE IF NOT EXISTS comments(
        id SERIAL PRIMARY KEY,
        comment VARCHAR(255) NOT NULL,
        user_id VARCHAR(255) NOT NULL,
        username VARCHAR(255) NOT NULL,
        blog_id INT NOT NULL REFERENCES blogs(id) ON DELETE CASCADE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        `;
        await sql`
        CREATE TABLE IF NOT EXISTS savedblogs(
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        blog_id INT NOT NULL REFERENCES blogs(id) ON DELETE CASCADE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        `;

        console.log("DATABASE initialised successfully!!!!");
    } catch(error) {
        console.log("Error initDb", error);
    }
}

app.use("/api/v1/health", (req, res) => { 
    res.send("Author service is running successfully");
});
app.use("/api/v1", blogRoutes);

initDB().then(() => {
    const port = process.env.PORT as string;
    app.listen(port, () => {
        console.log(`Author service is listening on PORT: ${port}`);
    });
});
