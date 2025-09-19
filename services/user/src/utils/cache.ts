import { redisClient } from "../server.js";

export class RedisCache {
    static async get(key: string) {
        try {
            const data = await redisClient.get(key);
            return data ? JSON.parse(data) : null;
        } catch (error) {
            console.log('Cache get error:', error);
            return null;
        }
    }

    static async set(key: string, data: any, expireInSeconds = 3600) {
        try {
            await redisClient.setEx(key, expireInSeconds, JSON.stringify(data));
        } catch (error) {
            console.log('Cache set error:', error);
        }
    }

    static async delete(key: string) {
        try {
            await redisClient.del(key);
        } catch (error) {
            console.log('Cache delete error:', error);
        }
    }


    // Delete multiple keys matching a pattern
    static async deletePattern(pattern: string) {
        try {
            const keys = await redisClient.keys(pattern);
            if (keys.length > 0) {
                await redisClient.del(keys);
                console.log(`Deleted ${keys.length} keys matching pattern: ${pattern}`);
            } else {
                console.log(`No keys found for pattern: ${pattern}`);
            }
        } catch (error) {
            console.log('Cache delete pattern error:', error);
        }
    }
}
