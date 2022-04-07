const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const ProfileUrlSchema = new Schema({
    accountId: {
        type: String,
        required: [true, "accountId is required"],
      },
    title: {
        type: String,
        required: [true, "title is required"],
    },
    url: {
        type: String,
        required: [true, "url is required"],
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

module.exports = ProfileUrl = mongoose.model("profile-urls", ProfileUrlSchema);
