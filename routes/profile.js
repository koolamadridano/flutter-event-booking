const express = require("express");
const router = express.Router();

const profileController = require("../controllers/profileController");
const protected = require("../middleware/authentication");

// [POST] api/profile
// @Description: Create profile
router.post("/profile", (req, res) =>
  profileController.createProfile(req, res)
);

// [GET] api/profile
// @Description: Get all profiles
router.get("/profile", (req, res) =>
  profileController.getAllProfiles(req, res)
);

// [GET] api/profile/<objectId>
// @Description: Get one profile
router.get("/profile/:id", (req, res) =>
  profileController.getProfile(req, res)
);

// [PUT] api/profile/<objectId>
// @Description: Update profile by objectId
router.put("/profile/:id", (req, res) =>
  profileController.updateProfile(req, res)
);

// [DELETE] api/profile/<objectId>
// @Description: Delete profile by objectId
router.delete("/profile/:id", (req, res) =>
  profileController.deleteProfile(req, res)
);

// [DELETE] api/profile/<objectId>
// @Description: Delete profile by objectId
router.delete("/doc/profile/delete-all", (req, res) =>
  profileController.deleteAll(req, res)
);

module.exports = router;
