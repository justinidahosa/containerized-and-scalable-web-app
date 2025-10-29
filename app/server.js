import express from "express";
const app = express();
const port = process.env.PORT || 3000;
app.get("/", (_, res) => res.send("Hello from ECS Fargate via ALB + CloudFront!"));
app.get("/api/hello", (_, res) => res.json({ ok: true, msg: "Hello API via API Gateway + JWT (Cognito)!"}));
app.listen(port, () => console.log(`Listening on ${port}`));