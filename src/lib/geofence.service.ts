import { Prisma, PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

type FilterField = "name" | "description" | "status" | "state" | "city" | "township"

export async function listGeofences(params: {
  q: string
  field: FilterField
  skip: number
  take: number
}): Promise<{ data: any[]; count: number }> {
  const { q, field, skip, take } = params
  const baseWhere: Prisma.GeofenceWhereInput = { deleted_at: null }

  if (field === "name") {
    const where: Prisma.GeofenceWhereInput = {
      ...baseWhere,
      metadata: {
        path: ["name"],
        string_contains: q || "",
        mode: "insensitive",
      },
    }
    const [data, count] = await Promise.all([
      prisma.geofence.findMany({ where, orderBy: { created_at: "desc" }, skip, take }),
      prisma.geofence.count({ where }),
    ])
    return { data, count }
  }

  if (field === "description") {
    const where: Prisma.GeofenceWhereInput = {
      ...baseWhere,
      metadata: {
        path: ["description"],
        string_contains: q || "",
        mode: "insensitive",
      },
    }
    const [data, count] = await Promise.all([
      prisma.geofence.findMany({ where, orderBy: { created_at: "desc" }, skip, take }),
      prisma.geofence.count({ where }),
    ])
    return { data, count }
  }

  if (field === "status") {
    const s = (q || "").toLowerCase()
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

    const [data, count] = await Promise.all([
      prisma.geofence.findMany({ where, orderBy: { created_at: "desc" }, skip, take }),
      prisma.geofence.count({ where }),
    ])
    return { data, count }
  }

  // Arrays (state/province_code, city/cities, township/municipalities).
  // Para "substring" en arrays de texto usamos SQL crudo seguro.
  const like = `%${q ?? ""}%`
  const column =
    field === "state"
      ? "province_code"
      : field === "city"
      ? "cities"
      : "municipalities" 

  if (!["province_code", "cities", "municipalities"].includes(column)) {
    throw new Error("Invalid filter column")
  }

  const colSql = Prisma.raw(`"Geofence"."${column}"`)

  const data = await prisma.$queryRaw<any[]>`
    SELECT *
    FROM "Geofence"
    WHERE "deleted_at" IS NULL
      AND (
        ${q ? Prisma.sql`EXISTS (SELECT 1 FROM unnest(${colSql}) AS v WHERE v ILIKE ${like})` : Prisma.sql`TRUE`}
      )
    ORDER BY "created_at" DESC
    LIMIT ${take} OFFSET ${skip}
  `

  const [{ count }] = await prisma.$queryRaw<{ count: bigint }[]>`
    SELECT COUNT(*)::bigint AS count
    FROM "Geofence"
    WHERE "deleted_at" IS NULL
      AND (
        ${q ? Prisma.sql`EXISTS (SELECT 1 FROM unnest(${colSql}) AS v WHERE v ILIKE ${like})` : Prisma.sql`TRUE`}
      )
  `

  return { data, count: Number(count) }
}
