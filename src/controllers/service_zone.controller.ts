import { RequestHandler } from "express"
import { prisma } from "../lib/prisma"

export const createServiceZone: RequestHandler = async (req, res) => {
  try {
    const zone = await prisma.service_zone.create({
      data: req.body,
    })
    res.status(201).json(zone)
  } catch (err) {
    console.error("Error creating service zone", err)
    res.status(500).json({ message: "Error creating service zone" })
  }
}

export const listServiceZones: RequestHandler = async (_req, res) => {
  try {
    const zones = await prisma.service_zone.findMany()
    res.json(zones)
  } catch (err) {
    console.error("Error fetching service zones", err)
    res.status(500).json({ message: "Error fetching service zones" })
  }
}
