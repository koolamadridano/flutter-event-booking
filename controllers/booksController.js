const Books = require("../models/books");

module.exports = {
  // [POST]
  async createBooking(req, res) {
    try {
      return new Books(req.body)
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
        .where("header.eventPlanner.id")
        .equals(accountId)
        .sort({ _id: -1 }) // filter by date
        .select({ __v: 0 }) // Do not return _id and __v
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
      Books.findOneAndUpdate(
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

  // [DELETE]
  async deleteBooking(req, res) {
    try {
      const _id = req.params.id;
      Books.findOneAndRemove({ _id })
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "bookId not found" });
          }
          return res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (error) {
      console.log(error);
    }
  },
};
