require("dotenv").config();
const ProfilePhotos = require("../../_models/profile/profilePhotos");
const cloudinary = require("../../services/img-upload/cloundinary");

module.exports = {
    // [POST]
    async createProfilePhotos(req, res) {
        try {
            const filePath = req.file.path;
            const options = { folder: process.env.CLOUDINARY_FOLDER + "/profile-photos", unique_filename: true };
            const uploadedImg = await cloudinary.uploader.upload(filePath, options);
            
            req.body.url = uploadedImg.url;
            req.body.publicId = uploadedImg.public_id;
   
            return new ProfilePhotos(req.body)
                .save()
                .then((value) => res.status(200).json(value))
                .catch((err) => res.status(400).send(err.errors));
        } catch (error) {
            console.error(error);
        }
    },
    // [GET]
    async getAllProfilePhotos(req, res) {
        try {
            const accountId = req.params.id;
            return ProfilePhotos.find({ accountId })
                .sort({ dateJoined: -1 })
                .select({ __v: 0 })
                .then((value) => res.status(200).json(value))
                .catch((err) => res.status(400).json(err));
        } catch (error) {
            console.error(error);
        }
    },
      // [DELETE]
    async deleteProfilePhotos(req, res) {
        try {
            const _id = req.body._id;
            const publicId = req.body.publicId;

            if (publicId === null || publicId === "") 
                return res.status(400).json({ message: "publicId is required" });
            
            ProfilePhotos.findByIdAndDelete(_id)
                .then(async (value) => {
                    if(value != null) {
                        await cloudinary.uploader.destroy(publicId);
                        return res.status(200).json({ message: "deleted"});
                    }
                    return res.status(400).json({ message: "_id doesn't exist or has already been deleted"});
                })
                .catch((err) => res.status(400).json(err));

        } catch (error) {
            console.log(error);
        }
    },
}