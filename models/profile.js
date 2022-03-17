const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const rolesEnum = ["customer", "event-planner", "organizer", "admin"];
      
const ProfileSchema = new Schema({
  accountId: {
    type: String,
    required: [true, "accountId is required"],
  },
  userType: {
    type: String,
    enum: rolesEnum,
    required: [true, "userType is required"],
  },
  firstName: {
    type: String,
    required: [true, "firstName is required"],
  },
  lastName: {
    type: String,
    required: [true, "lastName is required"],
  },
  bio: {
    type: String,
    //required: [true, "bio is required"],
  },
  address: {
    name: {
      type: String,
      //required: [true, "name is required"],
    },
    coordinates: {
      latitude: {
        type: String,
        //required: [true, "latitude is required"],
      },
      longitude: {
        type: String,
        // required: [true, "longitude is required"],
      },
    },
  },
  contact: {
    email: {
      type: String,
      // required: [true, "email is required"],
    },
    number: {
      type: String,
      //required: [true, "contactNo is required"],
    },
  },
  isVerified: {
     type: Bool,
     required: [true, "isVerified is required"],
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = Profile = mongoose.model("profiles", ProfileSchema);
