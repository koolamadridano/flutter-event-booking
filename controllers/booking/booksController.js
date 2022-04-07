const Books = require("../../models/booking/books");

const createBooking = async (req, res) => {
  try {
    return new Books(req.body)
      .save()
      .then((value) => res.status(200).json(value))
      .catch((err) => res.status(400).send(err.errors));
  } catch (error) {
    console.error(error);
  }
};

const getBookings = async (req, res) => {
  try {
    const accountId = req.params.id;
    const status = req.query.status;
        
    return Books.find({'header.eventPlanner.id': accountId, status})
        .sort({ _id: -1 }) // filter by _id
        .select({ __v: 0 }) // Do not return  __v
        .then((value) => res.status(200).json(value))
        .catch((err) => res.status(400).json(err));
    
  } catch (error) {
    console.error(error);
  }
};

const updateBookingStatus = async (req, res) => {
  try {
    const ref = req.params.refId;
    const { status } = req.body;
    
    Books.findOneAndUpdate(
      { ref },
      {
        $set: { status },
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
};

const deleteBooking = async (req, res) => {
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
};

module.exports = {
  createBooking,
  getBookings,
  updateBookingStatus,
  deleteBooking
};
