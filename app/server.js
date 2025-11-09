// server.js (CommonJS)
const express = require("express");
const app = express();

const PORT = process.env.PORT || 3000;

// Basic health checks
app.get("/health", (_req, res) => res.status(200).send("ok"));
app.get("/", (_req, res) => res.send("hello from ecs:fargate"));

// API health (so hitting /api/health works explicitly)
app.get("/api/health", (_req, res) => res.status(200).json({ status: "ok" }));

// Echo the Authorization header to verify CloudFront is forwarding it
app.get("/api/echo-auth", (req, res) => {
  res.status(200).json({
    auth: req.headers.authorization || null,
  });
});

// A simple protected test route (Cognito/JWT is enforced at API Gateway)
app.get("/api/secure-test", (_req, res) => {
  res.status(200).json({ message: "secure route ok" });
});

// Fallback for unknown routes (helps debugging)
app.use((req, res) => {
  res.status(404).json({ error: "Not Found", path: req.path });
});

// Start server
app.listen(PORT, () => {
  console.log(`server listening on ${PORT}`);
});

