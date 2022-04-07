const express = require("express");
const router = express.Router();

const reportUser = require("../controllers/tickets/reportUserController");

// VERIFICATION
router.post("/ticket/report-user", (req, res) => reportUser.createReportUserTicket(req, res));
router.get("/ticket/report-user", (req, res) => reportUser.getAllReportUserTickets(req, res));
router.put("/ticket/report-user", (req, res) => reportUser.updateReportUser(req, res));
router.delete("/ticket/report-user/:id", (req, res) => reportUser.deleteReportUserTicket(req, res));

module.exports = router;


