const express = require("express");
const router = express.Router();

const bookingsController = require("../controllers/bookingsController");

// [POST] api/me/bookings
// @Description: Create event
router.post("/me/bookings", (req, res) => {
  bookingsController.createBooking(req, res);
});

// [GET] api/me/bookings/<621d99d6b7e8dd5c70f6a9b8>/pending
// @Description: Get books
router.get("/me/bookings/:id?", (req, res) => {
  bookingsController.getBookings(req, res);
});

// [PUT] api/me/bookings/<621d99d6b7e8dd5c70f6a9b8>
// @Description: Get books
router.put("/me/bookings/:id", (req, res) => {
  bookingsController.updateBookingStatus(req, res);
});

module.exports = router;
