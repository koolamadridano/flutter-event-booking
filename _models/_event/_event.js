const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const enumCategory = [
  "custom-wedding",
  "custom-disco",
  "custom-promenade",
  "custom-fashion-show",
  "custom-ball",
  "custom-party",
];

const EventSchema = new Schema({
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
  event: {
    title: {
      type: String,
      required: [true, "title is required"],
    },
    moreDetails: {
      type: String,
      required: [true, "moreDetails is required"],
    },
    images: {
      type: Array,
      required: [true, "images is required"],
      validate: function (el) {
        return el.length >= 1;
      },
    },
    isEventAvailable: {
      type: Boolean,
      required: [true, "isEventAvailable is required"],
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
    postedOn: {
      type: Date,
      default: Date.now,
    },
  },
});

module.exports = Event = mongoose.model("events", EventSchema);
