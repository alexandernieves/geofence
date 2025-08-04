import express from "express"
import {
  createGeofence,
  getGeofences,
  getGeofence,
  updateGeofence,
  deleteGeofence,
} from "../controllers/geofence.controller"

const router = express.Router()

router.get("/geofences", getGeofences)
router.post("/geofences", createGeofence)
router.get("/geofences/:id", getGeofence)
router.patch("/geofences/:id", updateGeofence)
router.put("/geofences/:id", updateGeofence)   
router.delete("/geofences/:id", deleteGeofence)

export default router
