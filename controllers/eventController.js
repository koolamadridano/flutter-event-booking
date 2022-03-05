const Event = require("../models/event");

module.exports = {
  // [POST]
  async createEvent(req, res) {
    try {
      return new Event(req.body)
        .save()
        .then((value) => res.status(200).json(value))
        .catch((err) => res.status(400).send(err.errors));
    } catch (error) {
      console.error(error);
    }
  },
  // [GET]
  async getAllEvents(req, res) {
    try {
      return Event.find()
        .sort({ _id: -1 }) // filter by date
        .select({ __v: 0 }) // Do not return _id and __v
        .then((value) => res.status(200).json(value))
        .catch((err) => res.status(400).json(err));
    } catch (error) {
      console.error(error);
    }
  },

  async getEventsByEventPlannerAccountId(req, res) {
    try {
      const accountId = req.params.id;
      return Event.find()
        .where("eventPlanner.id")
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
  async updateEventAvailability(req, res) {
    try {
      const eventId = req.params.id;
      const { isEventAvailable } = req.body;
      Event.findOneAndUpdate(
        { _id: eventId },
        {
          $set: {
            "event.isEventAvailable": isEventAvailable,
          },
        }
      )
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "eventId not found" });
          }
          return res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (e) {
      return res.status(400).json({ message: "Something went wrong" });
    }
  },
    // [DELETE]
  async deleteEvent(req, res) {
    try {
      const eventId = req.params.id;
      Event.findOneAndRemove({ _id: eventId })
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "eventId not found" });
          }
          return res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (error) {
      console.log(error);
    }
  },
  
};
