require("dotenv").config();
const express = require("express");
const multer = require("multer");
const mongoose = require("mongoose");

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

  app.use("/api", require("./routes/User"));
  app.use("/api", require("./routes/Img"));
  app.use("/api", require("./routes/Profile/Profile"));
  app.use("/api", require("./routes/Event/event"));
  app.use("/api", require("./routes/Booking/event-planner-bookings"));
  app.use("/api", require("./routes/Booking/customer-bookings"));
  app.use("/api", require("./routes/Tickets/Verification"));

  app.listen(port, () => console.log("SERVER IS RUNNING"));
} catch (error) {
  console.log(error);
}
