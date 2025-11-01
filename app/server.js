const express = require("express");
const cors = require("cors");
const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Hello from ECS Fargate via ALB + CloudFront!");
});

app.get("/api/data", (req, res) => {
  res.json({
    message: "Fargate API reached successfully!",
    region: process.env.AWS_REGION || "us-east-1",
    time: new Date().toISOString(),
  });
});


app.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy" });
});


app.listen(port, () => {
  console.log(`🚀 Server running on port ${port}`);
});
