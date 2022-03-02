const cloudinary = require("../services/img-upload/cloundinary");

module.exports = {
  async uploadImg(req, res) {
    try {
      const options = {
        folder: "projects/event-booking",
        unique_filename: true,
      };
      const filePath = req.file.path;
      return await cloudinary.uploader
        .upload(filePath, options)
        .then((value) => res.status(200).json(value))
        .catch((err) => res.status(400).json(err));
    } catch (error) {
      return res.status(400).json({ message: "Image is required" });
    }
  },

  async deleteImg(req, res) {
    try {
      const avatar_publicId = req.body.publicId;
      if (avatar_publicId == null || avatar_publicId == "") {
        return res.status(400).json({ message: "Public id is required" });
      }
      await cloudinary.uploader
        .destroy(avatar_publicId)
        .then((value) => {
          if (value.result == "ok") {
            return res.status(200).json(value);
          }
          return res.status(400).json({ message: "File does not exist" });
        })
        .catch((err) => res.status(400).send(err));
    } catch (error) {
      return res.status(400).send(error);
    }
  },
};
