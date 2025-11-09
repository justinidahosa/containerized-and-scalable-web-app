const express = require("express");
const app = express();

const PORT = process.env.PORT || 3000;

app.get("/health", (_req, res) => res.status(200).send("ok"));
app.get("/", (_req, res) => res.send("hello from ecs:fargate"));

app.get("/api/health", (_req, res) => res.status(200).json({ status: "ok" }));

app.get("/api/echo-auth", (req, res) => {
  res.status(200).json({
    auth: req.headers.authorization || null,
  });
});

app.get("/api/secure-test", (_req, res) => {
  res.status(200).json({ message: "secure route ok" });
});

app.use((req, res) => {
  res.status(404).json({ error: "Not Found", path: req.path });
});


app.listen(PORT, () => {
  console.log(`server listening on ${PORT}`);
});

