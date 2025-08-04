import { Router } from "express"
import {
  createServiceZone,
  listServiceZones,
} from "../controllers/service_zone.controller"

const router = Router()
router.post("/", createServiceZone)
router.get("/", listServiceZones)
export default router
