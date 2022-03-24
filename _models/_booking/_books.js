const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const enumStatus = [
  "cancelled",
  "pending",
  "ready",
  "in-progress",
  "completed",
  "declined"
];

const enumCategory = [
  "custom-wedding",
  "custom-disco",
  "custom-promenade",
  "custom-fashion-show",
  "custom-ball",
  "custom-party",
];

const BooksSchema = new Schema({
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
    },
    customer: {
      id: {
        type: String,
        required: [true, "id is required"],
      },
      avatarUrl: {
        type: String,
        required: [true, "avatarUrl is required"],
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
      note: {
        type: String,
        required: [true, "note is required"],
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
      validate: function (el) {
        return el.length >= 1;
      },
    },
    priceRange: {
      from: {
        type: String,
        required: [true, "from is required"],
      },
      to: {
        type: String,
        required: [true, "to is required"],
      },
    },
    category: {
      type: String,
      enum: enumCategory,
      required: [true, "category is required"],
    },
  },
  bookedOn: {
    type: Date,
    default: Date.now,
  },
  status: {
    type: String,
    enum: enumStatus,
    required: [true, "status is required"],
  },
});

module.exports = Books = mongoose.model("books", BooksSchema);
