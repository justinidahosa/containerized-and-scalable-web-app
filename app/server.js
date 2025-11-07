// Minimal API for ECS Fargate behind ALB → API Gateway → CloudFront
const express = require("express");
const { DynamoDBClient, PutItemCommand, ScanCommand } = require("@aws-sdk/client-dynamodb");
const crypto = require("crypto");

const app = express();
app.use(express.json());

const PORT = process.env.PORT ? Number(process.env.PORT) : 3000;
const TABLE = process.env.TABLE_NAME || "app-items";
const REGION = process.env.AWS_REGION || "us-east-1";

const ddb = new DynamoDBClient({ region: REGION });

app.get("/", (_req, res) => {
  res.status(200).send("OK"); // ALB health check path
});

app.get("/api/health", (_req, res) => {
  res.json({ status: "healthy", table: TABLE, region: REGION });
});

app.get("/api/items", async (_req, res) => {
  try {
    const out = await ddb.send(new ScanCommand({ TableName: TABLE, Limit: 25 }));
    res.json({ count: out.Count || 0, items: out.Items || [] });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post("/api/items", async (req, res) => {
  try {
    const id = crypto.randomUUID();
    const payload = {
      pk: { S: id },
      ts: { N: String(Date.now()) },
      body: { S: JSON.stringify(req.body || {}) },
    };
    await ddb.send(new PutItemCommand({ TableName: TABLE, Item: payload }));
    res.status(201).json({ id });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.listen(PORT, "0.0.0.0", () => {
  // no-op
});
