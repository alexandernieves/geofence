import express from 'express';
import {
  createGeofence,
  getGeofences
} from '../controllers/geofence.controller';

const router = express.Router();

// ✅ GET: Buscar geofences por filtros (city, municipality, postal)
router.get('/geofences', getGeofences);

// ✅ POST: Crear nueva geofence (con validación de duplicados)
router.post('/geofences', createGeofence);

export default router;
