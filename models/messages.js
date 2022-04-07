const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const enumMessageType = ['warning-message', 'normal-message']

const MessagesSchema = new Schema({
    accountId: {
        type: String,
        required: [true, "accountId is required"],
    },
    message: {
        type: String,
        required: [true, "message is required"],
    },
    messageType: {
        type: String,
        enum: enumMessageType,
        required: [true, "messageType is required"],
    },
    opened: {
        type: Boolean,
        required: [true, "opened required"],
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

module.exports = Message = mongoose.model("messages", MessagesSchema);
