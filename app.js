require("dotenv").config();
const express = require("express");
const multer = require("multer");
const mongoose = require("mongoose");

const user = require("./routes/user");
const img =  require("./routes/img");
const profile = require("./routes/profile/profile");
const event = require("./routes/event/event");
const bookingEventPlanner = require("./routes/booking/event-planner-bookings");
const bookingCustomer =  require("./routes/booking/customer-bookings");
const tickets = require("./routes/tickets/verification");

const { fileFilter } = require("./services/img-upload/fileFilter");
const storage = multer.diskStorage({});

const port = process.env.PORT || 5000;
const app = express();

try {
  mongoose
    .connect(process.env.CONNECTION_STRING)
    .then((value) =>console.log(`SERVER IS CONNECTED TO ${value.connections[0]._connectionString}`))
    .catch(() => console.log("SERVER CANNOT CONNECT TO MONGODB"));

  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(multer({ storage, fileFilter }).single("img"));

  app.use("/api", user);
  app.use("/api", img);
  app.use("/api", profile);
  app.use("/api", event);
  app.use("/api", bookingEventPlanner);
  app.use("/api", bookingCustomer);
  app.use("/api", tickets);

  app.listen(port, () => console.log("SERVER IS RUNNING"));
} catch (error) {
  console.log(error);
}
