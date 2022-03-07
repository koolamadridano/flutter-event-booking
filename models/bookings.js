const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const enumStatus = [
  "declined",
  "cancelled",
  "pending",
  "ready",
  "in-progress",
  "completed",
];
const enumCategory = [
  "custom-wedding",
  "custom-disco",
  "custom-promenade",
  "custom-fashion-show",
  "custom-ball",
  "custom-party",
];

Bookings = mongoose.model(
  "bookings",
  new Schema({
       ref: {
        type: String,
        required: [true, "ref is required"],
      },
    header: {
      eventPlanner: {
        id: {
          type: String,
          required: [true, "id is required"],
        },
        firstName: {
          type: String,
          required: [true, "firstName is required"],
        },
        lastName: {
          type: String,
          required: [true, "lastName is required"],
        },
        contactNo: {
          type: String,
          required: [true, "contactNo is required"],
        },
      },
      customer: {
        id: {
          type: String,
          required: [true, "id is required"],
        },
      },
    },
    event: {
      title: {
        type: String,
        required: [true, "title is required"],
      },
      images: {
        type: Array,
        required: [true, "images is required"],
      },
      location: {
        type: String,
        required: [true, "location is required"],
      },
      priceRange: {
        from: {
          type: String,
          required: [true, "start price is required"],
        },
        to: {
          type: String,
          required: [true, "end price is required"],
        },
      },
      category: {
        type: String,
        enum: enumCategory,
        required: [true, "category is required"],
      },
    },
    amountToPay: {
      type: String,
      required: [true, "totalPayment is required"],
    },
    date: {
      booked: {
        type: Date,
        default: Date.now,
      },
      event: {
        type: String,
        required: [true, "event date is required"],
      },
    },
    status: {
      type: String,
      enum: enumStatus,
      required: [true, "status is required"],
    },
  })
);
module.exports = { Bookings };
