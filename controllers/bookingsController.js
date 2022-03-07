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
      const status = req.query.status;
      
      console.log({accountId, status});
      
      return Bookings.find({'header.customer.id': accountId, status})
          .sort({ _id: -1 }) // filter by _id
          .select({ __v: 0 }) // Do not return  __v
          .then((value) => res.status(200).json(value))
          .catch((err) => res.status(400).json(err));
     
    } catch (error) {
      console.error(error);
    }
  },
  async getBookingsByEventPlannerId(req, res) {
    try {
      const accountId = req.params.id;
      const status = req.query.status;
      
      console.log({accountId, status});
      
      return Bookings.find({'header.eventPlanner.id': accountId, status})
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
      const _refId = req.params.refId;
      const { status } = req.body;
      Bookings.findOneAndUpdate(
        { ref: _refId },
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
    // [PUT]
  async updateBookingAsReady(req, res) {
    try {
      const _refId = req.params.refId;
      const { amountToPay, eventDate,eventLocation, status } = req.body;
      Bookings.findOneAndUpdate(
        { ref: _refId },
        {
          $set: {
            'event.location': eventLocation,
            'date.event': eventDate,
            amountToPay,
            status
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
