/*
  Warnings:

  - You are about to drop the column `city` on the `geofence` table. All the data in the column will be lost.
  - You are about to drop the column `municipality` on the `geofence` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "geofence" DROP COLUMN "city",
DROP COLUMN "municipality",
ADD COLUMN     "cities" TEXT[],
ADD COLUMN     "municipalities" TEXT[],
ADD COLUMN     "postal_codes" TEXT[];
