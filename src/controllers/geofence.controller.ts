import { Request, Response } from "express"
import { prisma } from "../lib/prisma"
import { Prisma } from "@prisma/client"

export const createGeofence = async (req: Request, res: Response) => {
  try {
    const {
      id,
      type,
      country_code,
      province_code,
      cities = [],
      municipalities = [],
      postal_codes = [],
      service_zone_id,
      metadata,
    } = req.body

    const cityArray = Array.isArray(cities) ? cities.map(String) : []
    const municipalityArray = Array.isArray(municipalities) ? municipalities.map(String) : []
    const postalArray = Array.isArray(postal_codes) ? postal_codes.map(String) : []
    const provinceArray = Array.isArray(province_code) ? province_code.map(String) : []

    const uniqueCities = [...new Set(cityArray.map((c) => c.trim()))]
    const uniqueMunicipalities = [...new Set(municipalityArray.map((m) => m.trim()))]
    const uniquePostalCodes = [...new Set(postalArray.map((p) => p.trim()))]
    const uniqueProvinces = [...new Set(provinceArray.map((p) => p.trim()))]

    const geofence = await prisma.geofence.create({
      data: {
        id,
        type,
        country_code,
        province_code: uniqueProvinces,
        cities: uniqueCities,
        municipalities: uniqueMunicipalities,
        postal_codes: uniquePostalCodes,
        service_zone_id,
        metadata,
      },
    })

    return res.status(201).json(geofence)
  } catch (error) {
    console.error(error)
    return res.status(500).json({ message: "Error creating geofence" })
  }
}


export const getGeofences = async (req: Request, res: Response) => {
  try {
    const qRaw = (req.query.q as string) ?? ""
    const fieldRaw = ((req.query.field as string) ?? "city").toLowerCase()
    const page = Math.max(parseInt((req.query.page as string) ?? "1", 10) || 1, 1)
    const limitRaw = parseInt((req.query.limit as string) ?? "10", 10) || 10
    const limit = Math.min(Math.max(limitRaw, 1), 100)
    const skip = (page - 1) * limit

    type FilterField = "name" | "description" | "status" | "state" | "city" | "township"
    const allowedFields: FilterField[] = ["name", "description", "status", "state", "city", "township"]
    const field = (allowedFields.includes(fieldRaw as any) ? (fieldRaw as FilterField) : "city")

    const q = (qRaw || "").trim()
    const like = `%${q}%`

    const baseWhere: Prisma.GeofenceWhereInput = { deleted_at: null }

    if (!q) {
      const [data, total] = await Promise.all([
        prisma.geofence.findMany({
          where: baseWhere,
          orderBy: { created_at: "desc" },
          skip,
          take: limit,
        }),
        prisma.geofence.count({ where: baseWhere }),
      ])

      return res.status(200).json({
        data,
        pagination: {
          total,
          page,
          limit,
          pages: Math.max(1, Math.ceil(total / limit)),
        },
      })
    }

    if (field === "name" || field === "description") {
      const where: Prisma.GeofenceWhereInput = {
        ...baseWhere,
        metadata: {
          path: [field],            
          string_contains: q,
          mode: "insensitive",
        },
      }

      const [data, total] = await Promise.all([
        prisma.geofence.findMany({
          where,
          orderBy: { created_at: "desc" },
          skip,
          take: limit,
        }),
        prisma.geofence.count({ where }),
      ])

      return res.status(200).json({
        data,
        pagination: {
          total,
          page,
          limit,
          pages: Math.max(1, Math.ceil(total / limit)),
        },
      })
    }

    if (field === "status") {
      const s = q.toLowerCase()
      const enabled =
        s === "active" || s === "true" || s === "1" || s.startsWith("a")
          ? true
          : s === "inactive" || s === "false" || s === "0" || s.startsWith("i")
          ? false
          : null

      const where: Prisma.GeofenceWhereInput =
        enabled === null
          ? baseWhere
          : {
              ...baseWhere,
              metadata: { path: ["enabled"], equals: enabled },
            }

      const [data, total] = await Promise.all([
        prisma.geofence.findMany({
          where,
          orderBy: { created_at: "desc" },
          skip,
          take: limit,
        }),
        prisma.geofence.count({ where }),
      ])

      return res.status(200).json({
        data,
        pagination: {
          total,
          page,
          limit,
          pages: Math.max(1, Math.ceil(total / limit)),
        },
      })
    }

    // ---- Arrays (state/city/township) con substring en cada elemento ----
    // Tabla física y columnas reales (tu @@map("geo_zone"))
    const table = Prisma.raw(`"geo_zone"`)
    const column: "province_code" | "cities" | "municipalities" =
      field === "state" ? "province_code" : field === "city" ? "cities" : "municipalities"
    const colRef = Prisma.raw(`"geo_zone"."${column}"`)

    // Data
    const data = await prisma.$queryRaw<any[]>`
      SELECT *
      FROM ${table}
      WHERE "deleted_at" IS NULL
        AND (
          ${q
            ? Prisma.sql`EXISTS (SELECT 1 FROM unnest(${colRef}) AS v WHERE v ILIKE ${like})`
            : Prisma.sql`TRUE`}
        )
      ORDER BY "created_at" DESC
      LIMIT ${limit} OFFSET ${skip}
    `

    // Count
    const [{ count }] = await prisma.$queryRaw<{ count: bigint }[]>`
      SELECT COUNT(*)::bigint AS count
      FROM ${table}
      WHERE "deleted_at" IS NULL
        AND (
          ${q
            ? Prisma.sql`EXISTS (SELECT 1 FROM unnest(${colRef}) AS v WHERE v ILIKE ${like})`
            : Prisma.sql`TRUE`}
        )
    `

    return res.status(200).json({
      data,
      pagination: {
        total: Number(count),
        page,
        limit,
        pages: Math.max(1, Math.ceil(Number(count) / limit)),
      },
    })
  } catch (error) {
    console.error(error)
    return res.status(500).json({ message: "Error fetching geofences" })
  }
}


export const getGeofence = async (req: Request, res: Response) => {
  const { id } = req.params
  try {
    const gf = await prisma.geofence.findUnique({ where: { id } })
    if (!gf) {
      return res.status(404).json({ message: "Geofence not found" })
    }
    return res.json(gf)
  } catch (error) {
    console.error(error)
    return res.status(500).json({ message: "Error fetching geofence" })
  }
}


export const updateGeofence = async (req: Request, res: Response) => {
  const { id } = req.params
  try {
    const {
      type,
      country_code,
      province_code,
      cities = [],
      municipalities = [],
      postal_codes = [],
      service_zone_id,
      metadata,
    } = req.body

    const cityArray = Array.isArray(cities) ? cities.map(String) : []
    const municipalityArray = Array.isArray(municipalities) ? municipalities.map(String) : []
    const postalArray = Array.isArray(postal_codes) ? postal_codes.map(String) : []
    const provinceArray = Array.isArray(province_code) ? province_code.map(String) : []

    const uniqueCities = [...new Set(cityArray.map((c) => c.trim()))]
    const uniqueMunicipalities = [...new Set(municipalityArray.map((m) => m.trim()))]
    const uniquePostalCodes = [...new Set(postalArray.map((p) => p.trim()))]
    const uniqueProvinces = [...new Set(provinceArray.map((p) => p.trim()))]

    const updated = await prisma.geofence.update({
      where: { id },
      data: {
        type,
        country_code,
        province_code: uniqueProvinces,
        cities: uniqueCities,
        municipalities: uniqueMunicipalities,
        postal_codes: uniquePostalCodes,
        service_zone_id,
        metadata,
        updated_at: new Date(),
      },
    })

    return res.json(updated)
  } catch (error) {
    console.error(error)
    return res.status(500).json({ message: "Error updating geofence" })
  }
}


export const deleteGeofence = async (req: Request, res: Response) => {
  const { id } = req.params
  try {
    await prisma.geofence.delete({ where: { id } })
    return res.status(204).send()
  } catch (error) {
    console.error(error)
    return res.status(500).json({ message: "Error deleting geofence" })
  }
}

export const getGeofenceByPostalCode = async (
  req: Request,
  res: Response
) => {
  const postal = (req.params.postal ?? "").trim()
  if (!postal) return res.status(400).json({ message: "Postal code required" })

  try {
    const gf = await prisma.geofence.findFirst({
      where: {
        postal_codes: { has: postal },
        deleted_at: null,
      },
    })
    if (!gf) return res.status(404).json({ message: "Geofence not found" })
    return res.json(gf)
  } catch (err) {
    console.error(err)
    return res.status(500).json({ message: "Error fetching geofence" })
  }
}
