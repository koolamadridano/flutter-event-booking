const express = require("express");
const multer = require("multer");
const mongoose = require("mongoose");

const { fileFilter } = require("./services/img-upload/fileFilter");
const storage = multer.diskStorage({});

const port = process.env.PORT || 5000;
const connectiongString = process.env.CONNECTION_STRING;
const app = express();

try {
  mongoose
    .connect(connectiongString)
    .then(() => console.log("SERVER IS CONNECTED TO MONGODB"))
    .catch(() => console.log("SERVER CANNOT CONNECT TO MONGODB"));

  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(multer({ storage, fileFilter }).single("img"));

  app.use("/api", require("./routes/profile"));
  app.use("/api", require("./routes/user"));
  app.use("/api", require("./routes/img"));
  app.use("/api", require("./routes/profileBasicInfo"));
  app.use("/api", require("./routes/event"));
  app.use("/api", require("./routes/event-planner-bookings"));
  app.use("/api", require("./routes/customer-bookings"));

  app.listen(port, () => console.log("SERVER IS NOW RUNNING"));
} catch (error) {
  console.log(error);
}
