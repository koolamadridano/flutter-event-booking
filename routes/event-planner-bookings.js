const express = require("express");
const router = express.Router();

const bookController = require("../controllers/booksController");

// [POST] api/book
// @Description: Create book
router.post("/book", (req, res) => {
  bookController.createBooking(req, res);
});

// [GET] api/book/<621d99d6b7e8dd5c70f6a9b8>
// @Description: Get books
router.get("/book/:id", (req, res) => {
  bookController.getBookings(req, res);
});

// [PUT] api/book/<621d99d6b7e8dd5c70f6a9b8>
// @Description: Get books
router.put("/book/:refId", (req, res) => {
  bookController.updateBookingStatus(req, res);
});

// [DELETE] api/book/<621d99d6b7e8dd5c70f6a9b8>
// @Description: Get books
router.delete("/book/:id", (req, res) => {
  bookController.deleteBooking(req, res);
});

module.exports = router;
