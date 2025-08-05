import express from "express";
import cors from "cors";
import dotenv from "dotenv";

import geofenceRoutes from "./routes/geofence.routes";
import serviceZoneRoutes from "./routes/service_zone.routes";
import fulfillmentSetRoutes from "./routes/fulfillment_set.routes";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// ───── middlewares ─────
app.use(cors());
app.use(express.json());

// ───── health check ────
app.get("/api/health", (_req, res) => res.send("OK"));

// ───── routes ──────────
app.use("/api", geofenceRoutes);       // /api/geofences…
app.use("/api", serviceZoneRoutes);    // /api/service-zones…
app.use("/api", fulfillmentSetRoutes); // /api/fulfillment-sets…

// 404
app.use((_req, res) => res.status(404).json({ message: "Not Found" }));

app.listen(PORT, () => {
  console.log(`🚀  Server running on http://localhost:${PORT}`);
});
