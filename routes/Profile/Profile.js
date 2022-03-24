const express = require("express");
const router = express.Router();

const profile = require("../../controllers/profile/profileController");
const basicInfo = require("../../controllers/profile/profileBasicInfoController");
const photos = require("../../controllers/profile/profilePhotosController");
const urls = require("../../controllers/profile/profileUrlController");

const protected = require("../../middleware/authentication");

// PROFILE
router.post("/profile", (req, res) => profile.createProfile(req, res));
router.get("/profile", (req, res) => profile.getAllProfiles(req, res));
router.get("/profile/:id", (req, res) => profile.getProfile(req, res));
router.put("/profile/:id", (req, res) => profile.updateProfile(req, res));
router.delete("/profile/:id", (req, res) => profile.deleteProfile(req, res));

// PROFILE BASIC INFO
router.put("/address/:id", (req, res) => basicInfo.updateProfileAddress(req, res));
router.put("/contact/:id", (req, res) => basicInfo.updateProfileContact(req, res));

// PROFILE PHOTOS
router.post("/photos", (req, res) => photos.createProfilePhotos(req, res));
router.get("/photos/:id", (req, res) => photos.getAllProfilePhotos(req, res));
router.delete("/photos", (req, res) => photos.deleteProfilePhotos(req, res));

// PROFILE URLS
router.post("/url", (req, res) => urls.createProfileUrl(req, res));
router.get("/url/:id", (req, res) => urls.getAllProfileUrls(req, res));
router.delete("/url/:id", (req, res) => urls.deleteProfileUrl(req, res));

module.exports = router;
