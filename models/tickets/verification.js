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
    address: {
        type: String,
        required: [true, "address is required"],
    },
    contactNumber: {
        type: String,
        required: [true, "contactNumber is required"],
    },
    url: {
        type: String,
        required: [true, "url is required"],
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
    status: {
        type: String,
        enum: ["pending", "verified", "rejected"],
        required: [true, "status is required"],
    },
    updatedAt: {
        type: Date,
    }
});

module.exports = Verification = mongoose.model("verifications", VerificationSchema);
