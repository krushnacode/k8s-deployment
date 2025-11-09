import express from "express";
import client from "prom-client";

const app = express();
const port = process.env.PORT || 3000;

const register = new client.Registry();
client.collectDefaultMetrics({ register });

app.get("/", (_, res) => res.json({ message: "Hello from Node.js app" }));
app.get("/health", (_, res) => res.sendStatus(200));
app.get("/metrics", async (_, res) => {
  res.set("Content-Type", register.contentType);
  res.end(await register.metrics());
});

app.listen(port, () => console.log(`App running on port ${port}`));
