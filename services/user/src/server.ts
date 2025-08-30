import express from "express";
import dotenv from "dotenv";
import connectDB from "./utils/db.js";
import userRoutes from "./routes/user.js";
import relationshipRoutes from "./routes/relationship.js"
import {v2 as cloudinary} from "cloudinary";

dotenv.config();

cloudinary.config({ 
    cloud_name: process.env.CLOUD_NAME as string,
    api_key: process.env.CLOUD_API_KEY as string,
    api_secret: process.env.CLOUD_API_SECRET as string,
});

const app = express();
app.use(express.json());

app.use("/api/v1/health", (req, res) => {
    res.send("User service running successfully");
});
app.use("/api/v1", userRoutes);
app.use("/api/v1", relationshipRoutes);

connectDB();

const port = process.env.PORT;
app.listen(port, () => {
    console.log(`User service is running on port: ${port}`);
});