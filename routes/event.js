const express = require("express");
const router = express.Router();

const eventController = require("../controllers/eventController");

// [POST] api/event
// @Description: Create event
router.post("/event", (req, res) => {
  eventController.createEvent(req, res);
});

// [GET] api/event
// @Description: Get all events
router.get("/event", (req, res) => {
  eventController.getAllEvents(req, res);
});

// [GET] api/event/<621d99d6b7e8dd5c70f6a9b8>
// @Description: Get all events by accountId
router.get("/event/:id", (req, res) => {
  eventController.getEventsByEventPlannerAccountId(req, res);
});

// [PUT] api/event/<621d99d6b7e8dd5c70f6a9b8>
// @Description: Update event availability
router.put("/event/:id", (req, res) => {
  eventController.updateEventAvailability(req, res);
});

// [DELETE] api/event/<621d99d6b7e8dd5c70f6a9b8>
// @Description: Delete 
router.delete("/event/:id", (req, res) => {
  eventController.deleteEvent(req, res);
});


module.exports = router;
