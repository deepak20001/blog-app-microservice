import express from "express";
import dotenv from "dotenv";
import connectDB from "./utils/db.js";
import userRoutes from "./routes/user.js";
import relationshipRoutes from "./routes/relationship.js"
import cors from "cors";
import { createClient } from "redis";
import { startCacheWorker } from "./workers/cache_worker.js";
import { connectRabbitMQ } from "./utils/rabbitmq.js";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

connectRabbitMQ();
startCacheWorker();

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