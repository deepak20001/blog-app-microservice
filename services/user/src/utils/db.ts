import mongoose from "mongoose";

const connectDB = async () => {
    try {
        mongoose.connect(process.env.MONGO_URI as string, {
            dbName: "blog-DB"
        },);
        console.log('Mongoose DB connected successfully!!!!');
    } catch (error) {
        console.log(error);
    }
};

export default connectDB;