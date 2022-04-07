const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const ReportUserSchema = new Schema({
    reportedAccount: {
        accountId: {
            type: String,
            required: [true, "accountId is required"],
        },
        fullName: {
            type: String,
            required: [true, "fullName required"],
        },
    },
    reportedBy: {
        accountId: {
            type: String,
            required: [true, "accountId is required"],
        },
        fullName: {
            type: String,
            required: [true, "fullName required"],
        },
        reason: {
            type: String,
            required: [true, "reason required"],
        },
        category: {
            type: String,
            required: [true, "category required"],
        },
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

module.exports = ReportUser = mongoose.model("report-users", ReportUserSchema);
