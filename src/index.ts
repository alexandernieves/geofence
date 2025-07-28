import express from "express";
import geofenceRoutes from "./routes/geofence.routes";

const app = express();

// Middleware para parsear JSON
app.use(express.json());

// Montar las rutas de geofences bajo /api
app.use("/api", geofenceRoutes);

// Iniciar servidor en el puerto 3000
app.listen(3000, () => {
  console.log("Server running on http://localhost:3000");
});
