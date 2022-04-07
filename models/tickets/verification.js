const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const VerificationSchema = new Schema({
    accountId: {
        type: String,
        required: [true, "accountId is required"],
      },
    firstName: {
        type: String,
        required: [true, "firstName required"],
    },
    lastName: {
        type: String,
        required: [true, "lastName required"],
    },
    url: {
        type: String,
        required: [true, "url is required"],
    },
    status: {
        type: String,
        enum: ["pending", "verified", "rejected"],
        required: [true, "status is required"],
    },
    updatedAt: {
        type: Date,
    },
     createdAt: {
        type: Date,
        default: Date.now,
    },
});

module.exports = Verification = mongoose.model("verifications", VerificationSchema);
