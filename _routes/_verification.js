const express = require("express");
const router = express.Router();

const verification = require("../controllers/_tickets/_verificationTicketController");

// VERIFICATION
router.post("/ticket/verification", (req, res) => verification.createVerificationTicket(req, res));
router.get("/ticket/verification", (req, res) => verification.getAllVerificationTickets(req, res));
router.get("/ticket/s/verification/:id", (req, res) => verification.getSingleVerificationTicket(req, res));
router.put("/ticket/verification", (req, res) => verification.updateProfileVerificationStatus(req, res));
router.delete("/ticket/verification/:id", (req, res) => verification.deleteVerificationTicket(req, res));

module.exports = router;


