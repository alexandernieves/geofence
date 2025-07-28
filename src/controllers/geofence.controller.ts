import { Request, Response } from 'express';
import { prisma } from '../lib/prisma';

// ✅ POST: Crear Geofence con validación de duplicados
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
    } = req.body;

    // ✅ Forzar tipado correcto
    const cityArray: string[] = Array.isArray(cities) ? cities.map(String) : [];
    const municipalityArray: string[] = Array.isArray(municipalities) ? municipalities.map(String) : [];
    const postalArray: string[] = Array.isArray(postal_codes) ? postal_codes.map(String) : [];

    // ✅ Eliminar duplicados
    const uniqueCities: string[] = [...new Set(cityArray.map((c) => c.trim()))];
    const uniqueMunicipalities: string[] = [...new Set(municipalityArray.map((m) => m.trim()))];
    const uniquePostalCodes: string[] = [...new Set(postalArray.map((p) => p.trim()))];

    const geofence = await prisma.geofence.create({
      data: {
        id,
        type,
        country_code,
        province_code,
        cities: uniqueCities,           // ✅ Ahora son string[]
        municipalities: uniqueMunicipalities,
        postal_codes: uniquePostalCodes,
        service_zone_id,
        metadata,
      },
    });

    return res.status(201).json(geofence);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Error creating geofence' });
  }
};


// ✅ GET: Filtrar geofences
export const getGeofences = async (req: Request, res: Response) => {
  try {
    const { city, municipality, postal, page = 1, limit = 10 } = req.query

    const whereClause: any = {}

    if (city) whereClause.cities = { has: String(city) }
    if (municipality) whereClause.municipalities = { has: String(municipality) }
    if (postal) whereClause.postal_codes = { has: String(postal) }

    const skip = (Number(page) - 1) * Number(limit)

    const [geofences, total] = await Promise.all([
      prisma.geofence.findMany({
        where: whereClause,
        skip,
        take: Number(limit),
        orderBy: { created_at: "desc" },
      }),
      prisma.geofence.count({ where: whereClause }),
    ])

    return res.status(200).json({
      data: geofences,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        pages: Math.ceil(total / Number(limit)),
      },
    })
  } catch (error) {
    console.error(error)
    return res.status(500).json({ message: "Error fetching geofences" })
  }
}

