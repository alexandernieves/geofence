import express from "express"
import cors from "cors"

import geofenceRoutes from "./routes/geofence.routes"
import serviceZoneRouter from "./routes/service_zone.routes"
import fulfillmentSetRouter from "./routes/fulfillment_set.routes"

const app = express()

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
)

app.use(express.json())

app.get("/api/health", (_req, res) => res.send("OK"))

app.use("/api", geofenceRoutes)

app.use("/api/service-zones", serviceZoneRouter)
app.use("/api/fulfillment-sets", fulfillmentSetRouter)

app.listen(3000, () => {
  console.log("Server running on http://localhost:3000")
})
