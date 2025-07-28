import { Router } from "express";
import { getGeofenceByPostalCode } from "../controllers/geofence.controller";

const router = Router();

router.get('/:postalCode', getGeofenceByPostalCode);

export default router;
