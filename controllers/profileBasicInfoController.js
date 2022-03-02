const Profile = require("../models/profile");

module.exports = {
  async updateProfileAddress(req, res) {
    try {
      const accountId = req.params.id;
      const { name, lat, long } = req.body;

      Profile.findOneAndUpdate(
        { accountId },
        {
          $set: {
            "address.name": name,
            "address.coordinates.latitude": lat,
            "address.coordinates.longitude": long,
          },
        }
      )
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "accountId not found" });
          }
          res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (e) {
      return res.status(400).json({ message: "Something went wrong" });
    }
  },
  async updateProfileContact(req, res) {
    try {
      const accountId = req.params.id;
      const { email, number } = req.body;

      Profile.findOneAndUpdate(
        { accountId },
        {
          $set: {
            "contact.email": email,
            "contact.number": number,
          },
        }
      )
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "accountId not found" });
          }
          return res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (e) {
      return res.status(400).json({ message: "Something went wrong" });
    }
  },
};
