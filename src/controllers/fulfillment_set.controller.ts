import { RequestHandler } from "express"
import { prisma } from "../lib/prisma"

export const createFulfillmentSet: RequestHandler = async (req, res) => {
  try {
    const fs = await prisma.fulfillment_set.create({ data: req.body })
    res.status(201).json(fs)
  } catch (err) {
    console.error("Error creating fulfillment set", err)
    res.status(500).json({ message: "Error creating fulfillment set" })
  }
}

export const listFulfillmentSets: RequestHandler = async (_req, res) => {
  try {
    const all = await prisma.fulfillment_set.findMany()
    res.json(all)
  } catch (err) {
    console.error("Error fetching fulfillment sets", err)
    res.status(500).json({ message: "Error fetching fulfillment sets" })
  }
}
