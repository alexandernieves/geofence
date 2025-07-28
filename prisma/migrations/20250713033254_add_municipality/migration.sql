-- AlterTable
ALTER TABLE "geofence" ADD COLUMN     "municipality" TEXT;

-- AlterTable
ALTER TABLE "order" ALTER COLUMN "display_id" DROP NOT NULL;
