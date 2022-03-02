const Profile = require("../models/profile");

module.exports = {
  // [POST]
  async createProfile(req, res) {
    try {
      const { accountId, userType, firstName, lastName } = req.body;
      return new Profile({ accountId, userType, firstName, lastName })
        .save()
        .then((value) => res.status(200).json(value))
        .catch((err) => res.status(400).send(err.errors));
    } catch (error) {
      console.error(error);
    }
  },

  // [GET]
  async getAllProfiles(req, res) {
    try {
      const reqType = req.body.type;
      if (reqType == "customer") {
        return Profile.find()
          .where("userType")
          .equals("customer")
          .sort({ dateJoined: -1 }) // filter by date
          .select({ _id: 0, __v: 0 }) // Do not return _id and __v
          .then((value) => res.status(200).json(value))
          .catch((err) => res.status(400).json(err));
      }
      if (reqType == "event-planner") {
        return Profile.find()
          .where("userType")
          .equals("event-planner")
          .sort({ dateJoined: -1 })
          .select({ _id: 0, __v: 0 })
          .then((value) => res.status(200).json(value))
          .catch((err) => res.status(400).json(err));
      }
      return Profile.find()
        .sort({ dateJoined: -1 })
        .select({ _id: 0, __v: 0 })
        .then((value) => res.status(200).json(value))
        .catch((err) => res.status(400).json(err));
    } catch (error) {
      console.error(error);
    }
  },
  async getProfile(req, res) {
    try {
      const accountId = req.params.id;
      Profile.findOne({ accountId })
        .select({ _id: 0, __v: 0 })
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "accountId not found" });
          }
          return res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (error) {
      console.error(error);
    }
  },

  // [UPDATE]
  async updateProfile(req, res) {
    try {
      const accountId = req.params.id;
      Profile.findOneAndUpdate(
        { accountId },
        {
          firstName: req.body.firstName,
          lastName: req.body.lastName,
        }
      )
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "accountId not found" });
          }
          res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (error) {
      console.error(error);
    }
  },

  // [DELETE]
  async deleteProfile(req, res) {
    try {
      const accountId = req.params.id;
      Profile.findOneAndRemove({ accountId })
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "accountId not found" });
          }
          return res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (error) {
      console.log(error);
    }
  },
  async deleteAll(req, res) {
    try {
      return Profile.deleteMany({})
        .then((value) => res.status(200).json(value))
        .catch((err) => res.status(400).json(err));
    } catch (error) {
      console.log(error);
    }
  },
};
