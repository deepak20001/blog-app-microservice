import mongoose, { Document, Schema } from "mongoose";

export interface IRelationship extends Document {
    followerId: mongoose.Types.ObjectId,
    followingId: mongoose.Types.ObjectId,
}

const schema: Schema<IRelationship> = new Schema({
    followerId: {
        type: Schema.Types.ObjectId,
        required: true,
    },
    followingId: {
        type: Schema.Types.ObjectId,
        required: true,
    },
},
{
    timestamps: true,
}
);

const Relationship = mongoose.model<IRelationship>("Relationship", schema);

export default Relationship;