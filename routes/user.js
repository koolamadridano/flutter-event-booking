const express = require("express");
const router = express.Router();

const userController = require("../controllers/userController");

// [POST] api/user
// @Description: Create profile
router.post("/user", (req, res) =>
  userController.createUser(req, res)
);

// [POST] api/user/login
// @Description: Create profile
router.post("/user/login", (req, res) =>
  userController.loginUser(req, res)
);

// [POST] api/user/status
// @Description: Logout user by removing session
router.put("/user/status", (req, res) =>
  userController.updateUserStatus(req, res)
);

module.exports = router;
