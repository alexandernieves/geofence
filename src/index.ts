/* ──────────────────────────────
   src/index.ts
   Geofence-service entry point
   ────────────────────────────── */

   import express from "express";
   import cors from "cors";
   import dotenv from "dotenv";
   
   import geofenceRoutes from "./routes/geofence.routes";
   import serviceZoneRoutes from "./routes/service_zone.routes";
   import fulfillmentSetRoutes from "./routes/fulfillment_set.routes";
   
   dotenv.config();
   
   const app  = express();
   const PORT = process.env.PORT || 3000;
   
   /* ────────────── Middlewares ────────────── */
   app.use(cors());
   app.use(express.json());
   
   /* ─────────────── Health check ───────────── */
   app.get("/api/health", (_req, res) => res.send("OK"));
   
   /* ───────────── Hello-World test ─────────── */
   app.get("/api/hello", (_req, res) => {
     res.json({ message: "Hola Mundo 👋" });
   });
   
   /* ─────────────── Application routes ─────── */
   app.use("/api", geofenceRoutes);        // /api/geofences…
   app.use("/api", serviceZoneRoutes);     // /api/service-zones…
   app.use("/api", fulfillmentSetRoutes);  // /api/fulfillment-sets…
   
   /* ─────────────── 404 fallback ───────────── */
   app.use((_req, res) => res.status(404).json({ message: "Not Found" }));
   
   /* ─────────────── Error handler ──────────── */
   app.use(
     // eslint-disable-next-line @typescript-eslint/no-unused-vars
     (err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
       console.error(err);
       res.status(500).json({ message: "Internal server error" });
     },
   );
   
   /* ──────────── Start server ──────────────── */
   app.listen(PORT, () => {
     console.log(`🚀  Server running on http://localhost:${PORT}`);
   });
   