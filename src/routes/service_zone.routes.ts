import { Router } from "express";
import {
  createServiceZone,
  listServiceZones,
} from "../controllers/service_zone.controller";

const router = Router();

router.route("/")
  .post(createServiceZone)
  .get(listServiceZones);

export default router;
