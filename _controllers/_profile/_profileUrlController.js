const ProfileUrl = require("../../models/profile/profileUrl");

module.exports = {
    // [POST]
    async createProfileUrl(req, res) {
        try {
            return new ProfileUrl(req.body)
                .save()
                .then((value) => res.status(200).json(value))
                .catch((err) => res.status(400).send(err.errors));
        } catch (error) {
        console.error(error);
        }
    },
    // [GET]
    async getAllProfileUrls(req, res) {
        try {
            const accountId = req.params.id;
            return ProfileUrl.find({ accountId })
                .sort({ dateJoined: -1 })
                .select({ __v: 0 })
                .then((value) => res.status(200).json(value))
                .catch((err) => res.status(400).json(err));
        } catch (error) {
            console.error(error);
        }
    },
      // [DELETE]
    async deleteProfileUrl(req, res) {
        try {
            const _id = req.params.id;
            ProfileUrl.findByIdAndDelete(_id)
                .then((value) => {
                    if (value) 
                        return res.status(200).json({ message: "deleted"});
                    return res.status(400).json({ message: "_id doesn't exist or has already been deleted"});
                })
                .catch((err) => res.status(400).json(err));
        } catch (error) {
            console.log(error);
        }
    },
}