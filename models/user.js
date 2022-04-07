const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const UserSchema = new Schema({
  email: {
    type: String,
    unique: true,
    required: [true, "Username is required"],
  },
  hashValue: {
    type: String,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  disabled: {
    type: Boolean,
    required: [true, "disabled is required"],
  }
});

module.exports = User = mongoose.model("user", UserSchema);
