import { Router } from "express"
import {
  createFulfillmentSet,
  listFulfillmentSets,
} from "../controllers/fulfillment_set.controller"

const router = Router()
router.post("/", createFulfillmentSet)
router.get("/", listFulfillmentSets)
export default router
