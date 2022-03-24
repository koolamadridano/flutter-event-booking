require("dotenv").config();
const express = require("express");
const multer = require("multer");
const mongoose = require("mongoose");

const user = require("./_routes/_user");
const img =  require("./_routes/_img");
const profile = require("./_routes/_profile");
const event = require("./_routes/_event");
const bookingEventPlanner = require("./_routes/_event-planner-bookings");
const bookingCustomer =  require("./_routes/_customer-bookings");
const tickets = require("./_routes/_verification");

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
