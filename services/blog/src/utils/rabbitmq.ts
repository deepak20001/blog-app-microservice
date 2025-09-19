import amqp from 'amqplib';

let channel: amqp.Channel

export const connectRabbitMQ = async () => {
    try {
        const connection = await amqp.connect({
            protocol: process.env.RABBITMQ_PROTOCOL,
            hostname: process.env.RABBITMQ_HOST,
            port: Number(process.env.RABBITMQ_PORT),
            username: process.env.RABBITMQ_USER,
            password: process.env.RABBITMQ_PASS,
        });
        channel = await connection.createChannel();
        console.log("Connected to RabbitMQ successfully!!!!");
    } catch (error) {
        console.error("Failed to connect to RabbitMQ", error);
    }
}

export const publishToQueue = async(queueName: string, message: any) => {
    if(!channel) {
        console.error("RabbitMQ channel is not initialized");
        return;
    }

    await channel .assertQueue(queueName, { durable: true });
    channel.sendToQueue(queueName, Buffer.from(JSON.stringify(message)), {
        persistent: true,
    });
}

export const invalidateCacheJob = async(cacheKeys: string[]) => {
    try {
        const message = {
            action: "invalidateCache",
            keys: cacheKeys,
        }
        await publishToQueue("cache-invalidation", message);
        console.log("Cache Invalidation job published to RabbitMQ successfully!!!!");
    } catch (error) {
        console.log("Failed to publish cache on RabbitMQ", error);
    }
}