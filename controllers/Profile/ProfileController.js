const Profile = require("../../models/profile/profile");

module.exports = {
  // [POST]
  async createProfile(req, res) {
    try {
        return new Profile(req.body)
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
      const userType =  req.query.userType;

      if(userType === null || userType === "" || userType === undefined) {
        return Profile.find()
          .sort({ createdAt: -1 }) // filter by date
          .select({ _id: 0, __v: 0 }) // Do not return _id and __v
          .then((value) => res.status(200).json(value))
          .catch((err) => res.status(400).json(err));
      }

      return Profile.find({ userType })
        .sort({ createdAt: -1 }) // filter by date
        .select({ _id: 0, __v: 0 }) // Do not return _id and __v
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
            if (!value) 
              return res.status(400).json({ message: "accountId not found" });
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
            updatedAt: Date.now(),
          }
        )
          .then((value) => {
            if (!value) 
              return res.status(400).json({ message: "accountId not found" });
            return res.status(200).json(value);
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
            if (!value) 
              return res.status(400).json({ message: "accountId not found" });
            return res.status(200).json(value);
          })
          .catch((err) => res.status(400).json(err));
    } catch (error) {
      console.log(error);
    }
  },
};
