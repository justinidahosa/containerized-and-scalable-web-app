// CommonJS style
const express = require("express");
const app = express();

const PORT = process.env.PORT || 3000;

app.get("/health", (_req, res) => res.status(200).send("ok"));
app.get("/", (_req, res) => res.send("hello from ecs:fargate"));
app.get("/api/echo-auth", (req, res) => {
  res.status(200).json({
    auth: req.headers.authorization || null,
  });
});

app.listen(PORT, () => {
  console.log(`server listening on ${PORT}`);
});
