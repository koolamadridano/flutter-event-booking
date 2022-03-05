const { Bookings } = require("../models/bookings");

module.exports = {
  // [POST]
  async createBooking(req, res) {
    try {
      return new Bookings(req.body)
        .save()
        .then((value) => res.status(200).json(value))
        .catch((err) => res.status(400).send(err.errors));
    } catch (error) {
      console.error(error);
    }
  },
  // [GET]
  async getBookings(req, res) {
    try {
      const accountId = req.params.id;
      return Books.find()
        .where("header.customer.id")
        .equals(accountId)
        .sort({ _id: -1 }) // filter by _id
        .select({ __v: 0 }) // Do not return  __v
        .then((value) => res.status(200).json(value))
        .catch((err) => res.status(400).json(err));
    } catch (error) {
      console.error(error);
    }
  },
  // [PUT]
  async updateBookingStatus(req, res) {
    try {
      const _id = req.params.id;
      const { status } = req.body;
      Bookings.findOneAndUpdate(
        { _id },
        {
          $set: {
            status,
          },
        },
        { new: true, runValidators: true }
      )
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "bookId not found" });
          }
          return res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (e) {
      return res.status(400).json({ message: "Something went wrong" });
    }
  },
};