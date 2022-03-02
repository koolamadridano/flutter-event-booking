const express = require("express");
const router = express.Router();

const profileBasicInfoController = require("../controllers/profileBasicInfoController");

// [PUT] api/address/<objectId>
// @Description: Update address by objectId
router.put("/address/:id", (req, res) =>
  profileBasicInfoController.updateProfileAddress(req, res)
);

// [PUT] api/address/<objectId>
// @Description: Update address by objectId
router.put("/contact/:id", (req, res) =>
  profileBasicInfoController.updateProfileContact(req, res)
);

module.exports = router;
