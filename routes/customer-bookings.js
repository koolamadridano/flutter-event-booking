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
router.get("/me/bookings/:id", (req, res) => {
  bookingsController.getBookings(req, res);
});

// [GET] api/me/bookings/<621d99d6b7e8dd5c70f6a9b8>/pending
// @Description: Get books
router.get("/evp/bookings/:id", (req, res) => {
  bookingsController.getBookingsByEventPlannerId(req, res);
});


// [PUT] api/me/bookings/<621d99d6b7e8dd5c70f6a9b8>
// @Description: Get books
router.put("/me/bookings/:refId", (req, res) => {
  bookingsController.updateBookingStatus(req, res);
});

// [PUT] api/me/bookings/<f09342e0-14f6-451b-bec1-1e8dbe9989be>
// @Description: Get books
router.put("/update-booking-as-ready/:refId", (req, res) => {
  bookingsController.updateBookingAsReady(req, res);
});


module.exports = router;
