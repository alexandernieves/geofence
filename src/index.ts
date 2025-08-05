import express from "express";
import cors from "cors";
import dotenv from "dotenv";

import geofenceRoutes from "./routes/geofence.routes";
import serviceZoneRouter from "./routes/service_zone.routes";
import fulfillmentSetRouter from "./routes/fulfillment_set.routes";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  }),
);
app.use(express.json());

app.get("/api/health", (_req, res) => res.send("OK"));

app.use("/api", geofenceRoutes);

app.use("/api/service-zones", serviceZoneRouter);

app.use("/api/fulfillment-sets", fulfillmentSetRouter);

app.use((_req, res) => res.status(404).json({ message: "Not Found" }));

app.use(
  (err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  },
);

app.listen(PORT, () => {
  console.log(`🦁 Server running on http://localhost:${PORT}`);
});
