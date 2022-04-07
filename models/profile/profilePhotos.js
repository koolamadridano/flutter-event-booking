const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const ProfilePhotosSchema = new Schema({
    accountId: {
        type: String,
        required: [true, "accountId is required"],
    },
    url: {
        type: String,
        required: [true, "url is required"],
    },
    description: {
        type: String,
        required: [true, "description is required"],
    },
    category: {
        type: String,
        required: [true, "type is required"],
    },
    publicId: {
        type: String,
        required: [true, "public_id is required"],
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

module.exports = ProfilePhotos = mongoose.model("profile-photos", ProfilePhotosSchema);
