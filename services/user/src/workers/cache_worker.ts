import amqp from 'amqplib';
import { RedisCache } from '../utils/cache.js';

let channel: amqp.Channel;

export const startCacheWorker = async () => {
    try {
        const connection = await amqp.connect({
            protocol: process.env.RABBITMQ_PROTOCOL,
            hostname: process.env.RABBITMQ_HOST,
            port: Number(process.env.RABBITMQ_PORT),
            username: process.env.RABBITMQ_USER,
            password: process.env.RABBITMQ_PASS,
        });

        channel = await connection.createChannel();
        
        // Make sure the queue exists
        await channel.assertQueue("cache-invalidation", { durable: true });
        
        // Process messages from the queue
        channel.consume("cache-invalidation", async (message) => {
            if (message) {
                try {
                    const data = JSON.parse(message.content.toString());
                    console.log('Cache worker received job:', data);
                    
                    if (data.action === "invalidateCache" && data.keys) {
                        for (const key of data.keys) {
                            if (key.includes('*')) {
                                await RedisCache.deletePattern(key);
                                console.log(`Clearing cache pattern: ${key}`);
                            } else {
                                await RedisCache.delete(key);
                                console.log(`Cleared cache key: ${key}`);
                            }
                        }
                        console.log('Cache invalidation completed');
                    }
                    
                    channel.ack(message);
                } catch (error) {
                    console.error('Cache worker error:', error);
                    channel.nack(message, false, true);
                }
            }
        });
        
        console.log('Cache worker started and waiting for jobs!!!!');
    } catch (error) {
        console.error('Failed to start cache worker:', error);
    }
    
};
