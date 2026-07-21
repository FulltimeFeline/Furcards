import express from "express";
import helmet from "helmet";
import { legalRouter } from "./legal.js";

const app = express();

app.set("trust proxy", 1);
app.use(helmet());
app.disable("x-powered-by");

app.get("/health", (_req, res) => res.json({ ok: true }));

app.use("/", legalRouter);

app.use((_req, res) => res.status(404).send("not found"));

const port = Number(process.env.PORT ?? 8080);
app.listen(port, () => console.log(`furcards.app site listening on :${port}`));
