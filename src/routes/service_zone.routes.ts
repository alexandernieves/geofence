import { Router } from "express";
import {
  createServiceZone,
  listServiceZones,
} from "../controllers/service_zone.controller";

const router = Router();

//  /api/service-zones  → POST  |  GET
router.post("/service-zones", createServiceZone);
router.get("/service-zones", listServiceZones);

export default router;
