/*
  Warnings:

  - You are about to drop the `GeoZone` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "claim_reason_enum" AS ENUM ('missing_item', 'wrong_item', 'production_failure', 'other');

-- CreateEnum
CREATE TYPE "order_claim_type_enum" AS ENUM ('refund', 'replace');

-- CreateEnum
CREATE TYPE "order_status_enum" AS ENUM ('pending', 'completed', 'draft', 'archived', 'canceled', 'requires_action');

-- CreateEnum
CREATE TYPE "return_status_enum" AS ENUM ('open', 'requested', 'received', 'partially_received', 'canceled');

-- DropTable
DROP TABLE "GeoZone";

-- CreateTable
CREATE TABLE "geofence" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'country',
    "country_code" TEXT NOT NULL,
    "province_code" TEXT,
    "city" TEXT,
    "service_zone_id" TEXT NOT NULL,
    "postal_expression" JSONB,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "geo_zone_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account_holder" (
    "id" TEXT NOT NULL,
    "provider_id" TEXT NOT NULL,
    "external_id" TEXT NOT NULL,
    "email" TEXT,
    "data" JSONB NOT NULL DEFAULT '{}',
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "account_holder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "api_key" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "salt" TEXT NOT NULL,
    "redacted" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "last_used_at" TIMESTAMPTZ(6),
    "created_by" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revoked_by" TEXT,
    "revoked_at" TIMESTAMPTZ(6),
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "api_key_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "application_method_buy_rules" (
    "application_method_id" TEXT NOT NULL,
    "promotion_rule_id" TEXT NOT NULL,

    CONSTRAINT "application_method_buy_rules_pkey" PRIMARY KEY ("application_method_id","promotion_rule_id")
);

-- CreateTable
CREATE TABLE "application_method_target_rules" (
    "application_method_id" TEXT NOT NULL,
    "promotion_rule_id" TEXT NOT NULL,

    CONSTRAINT "application_method_target_rules_pkey" PRIMARY KEY ("application_method_id","promotion_rule_id")
);

-- CreateTable
CREATE TABLE "auth_identity" (
    "id" TEXT NOT NULL,
    "app_metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "auth_identity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "capture" (
    "id" TEXT NOT NULL,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "payment_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "created_by" TEXT,
    "metadata" JSONB,

    CONSTRAINT "capture_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cart" (
    "id" TEXT NOT NULL,
    "region_id" TEXT,
    "customer_id" TEXT,
    "sales_channel_id" TEXT,
    "email" TEXT,
    "currency_code" TEXT NOT NULL,
    "shipping_address_id" TEXT,
    "billing_address_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "completed_at" TIMESTAMPTZ(6),

    CONSTRAINT "cart_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cart_address" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT,
    "company" TEXT,
    "first_name" TEXT,
    "last_name" TEXT,
    "address_1" TEXT,
    "address_2" TEXT,
    "city" TEXT,
    "country_code" TEXT,
    "province" TEXT,
    "postal_code" TEXT,
    "phone" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "cart_address_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cart_line_item" (
    "id" TEXT NOT NULL,
    "cart_id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "subtitle" TEXT,
    "thumbnail" TEXT,
    "quantity" INTEGER NOT NULL,
    "variant_id" TEXT,
    "product_id" TEXT,
    "product_title" TEXT,
    "product_description" TEXT,
    "product_subtitle" TEXT,
    "product_type" TEXT,
    "product_collection" TEXT,
    "product_handle" TEXT,
    "variant_sku" TEXT,
    "variant_barcode" TEXT,
    "variant_title" TEXT,
    "variant_option_values" JSONB,
    "requires_shipping" BOOLEAN NOT NULL DEFAULT true,
    "is_discountable" BOOLEAN NOT NULL DEFAULT true,
    "is_tax_inclusive" BOOLEAN NOT NULL DEFAULT false,
    "compare_at_unit_price" DECIMAL,
    "raw_compare_at_unit_price" JSONB,
    "unit_price" DECIMAL NOT NULL,
    "raw_unit_price" JSONB NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "product_type_id" TEXT,
    "is_custom_price" BOOLEAN NOT NULL DEFAULT false,
    "is_giftcard" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "cart_line_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cart_line_item_adjustment" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "promotion_id" TEXT,
    "code" TEXT,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "provider_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "item_id" TEXT,

    CONSTRAINT "cart_line_item_adjustment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cart_line_item_tax_line" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "tax_rate_id" TEXT,
    "code" TEXT NOT NULL,
    "rate" REAL NOT NULL,
    "provider_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "item_id" TEXT,

    CONSTRAINT "cart_line_item_tax_line_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cart_payment_collection" (
    "cart_id" VARCHAR(255) NOT NULL,
    "payment_collection_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "cart_payment_collection_pkey" PRIMARY KEY ("cart_id","payment_collection_id")
);

-- CreateTable
CREATE TABLE "cart_promotion" (
    "cart_id" VARCHAR(255) NOT NULL,
    "promotion_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "cart_promotion_pkey" PRIMARY KEY ("cart_id","promotion_id")
);

-- CreateTable
CREATE TABLE "cart_shipping_method" (
    "id" TEXT NOT NULL,
    "cart_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" JSONB,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "is_tax_inclusive" BOOLEAN NOT NULL DEFAULT false,
    "shipping_option_id" TEXT,
    "data" JSONB,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "cart_shipping_method_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cart_shipping_method_adjustment" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "promotion_id" TEXT,
    "code" TEXT,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "provider_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "shipping_method_id" TEXT,

    CONSTRAINT "cart_shipping_method_adjustment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cart_shipping_method_tax_line" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "tax_rate_id" TEXT,
    "code" TEXT NOT NULL,
    "rate" REAL NOT NULL,
    "provider_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "shipping_method_id" TEXT,

    CONSTRAINT "cart_shipping_method_tax_line_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "credit_line" (
    "id" TEXT NOT NULL,
    "cart_id" TEXT NOT NULL,
    "reference" TEXT,
    "reference_id" TEXT,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "credit_line_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "currency" (
    "code" TEXT NOT NULL,
    "symbol" TEXT NOT NULL,
    "symbol_native" TEXT NOT NULL,
    "decimal_digits" INTEGER NOT NULL DEFAULT 0,
    "rounding" DECIMAL NOT NULL DEFAULT 0,
    "raw_rounding" JSONB NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "currency_pkey" PRIMARY KEY ("code")
);

-- CreateTable
CREATE TABLE "customer" (
    "id" TEXT NOT NULL,
    "company_name" TEXT,
    "first_name" TEXT,
    "last_name" TEXT,
    "email" TEXT,
    "phone" TEXT,
    "has_account" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "created_by" TEXT,

    CONSTRAINT "customer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_account_holder" (
    "customer_id" VARCHAR(255) NOT NULL,
    "account_holder_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "customer_account_holder_pkey" PRIMARY KEY ("customer_id","account_holder_id")
);

-- CreateTable
CREATE TABLE "customer_address" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "address_name" TEXT,
    "is_default_shipping" BOOLEAN NOT NULL DEFAULT false,
    "is_default_billing" BOOLEAN NOT NULL DEFAULT false,
    "company" TEXT,
    "first_name" TEXT,
    "last_name" TEXT,
    "address_1" TEXT,
    "address_2" TEXT,
    "city" TEXT,
    "country_code" TEXT,
    "province" TEXT,
    "postal_code" TEXT,
    "phone" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "customer_address_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_group" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "metadata" JSONB,
    "created_by" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "customer_group_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customer_group_customer" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "customer_group_id" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_by" TEXT,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "customer_group_customer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fulfillment" (
    "id" TEXT NOT NULL,
    "location_id" TEXT NOT NULL,
    "packed_at" TIMESTAMPTZ(6),
    "shipped_at" TIMESTAMPTZ(6),
    "delivered_at" TIMESTAMPTZ(6),
    "canceled_at" TIMESTAMPTZ(6),
    "data" JSONB,
    "provider_id" TEXT,
    "shipping_option_id" TEXT,
    "metadata" JSONB,
    "delivery_address_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "marked_shipped_by" TEXT,
    "created_by" TEXT,
    "requires_shipping" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "fulfillment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fulfillment_address" (
    "id" TEXT NOT NULL,
    "company" TEXT,
    "first_name" TEXT,
    "last_name" TEXT,
    "address_1" TEXT,
    "address_2" TEXT,
    "city" TEXT,
    "country_code" TEXT,
    "province" TEXT,
    "postal_code" TEXT,
    "phone" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "fulfillment_address_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fulfillment_item" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "sku" TEXT NOT NULL,
    "barcode" TEXT NOT NULL,
    "quantity" DECIMAL NOT NULL,
    "raw_quantity" JSONB NOT NULL,
    "line_item_id" TEXT,
    "inventory_item_id" TEXT,
    "fulfillment_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "fulfillment_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fulfillment_label" (
    "id" TEXT NOT NULL,
    "tracking_number" TEXT NOT NULL,
    "tracking_url" TEXT NOT NULL,
    "label_url" TEXT NOT NULL,
    "fulfillment_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "fulfillment_label_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fulfillment_provider" (
    "id" TEXT NOT NULL,
    "is_enabled" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "fulfillment_provider_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fulfillment_set" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "fulfillment_set_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "image" (
    "id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "rank" INTEGER NOT NULL DEFAULT 0,
    "product_id" TEXT NOT NULL,

    CONSTRAINT "image_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inventory_item" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "sku" TEXT,
    "origin_country" TEXT,
    "hs_code" TEXT,
    "mid_code" TEXT,
    "material" TEXT,
    "weight" INTEGER,
    "length" INTEGER,
    "height" INTEGER,
    "width" INTEGER,
    "requires_shipping" BOOLEAN NOT NULL DEFAULT true,
    "description" TEXT,
    "title" TEXT,
    "thumbnail" TEXT,
    "metadata" JSONB,

    CONSTRAINT "inventory_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inventory_level" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "inventory_item_id" TEXT NOT NULL,
    "location_id" TEXT NOT NULL,
    "stocked_quantity" DECIMAL NOT NULL DEFAULT 0,
    "reserved_quantity" DECIMAL NOT NULL DEFAULT 0,
    "incoming_quantity" DECIMAL NOT NULL DEFAULT 0,
    "metadata" JSONB,
    "raw_stocked_quantity" JSONB,
    "raw_reserved_quantity" JSONB,
    "raw_incoming_quantity" JSONB,

    CONSTRAINT "inventory_level_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invite" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "accepted" BOOLEAN NOT NULL DEFAULT false,
    "token" TEXT NOT NULL,
    "expires_at" TIMESTAMPTZ(6) NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "invite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "link_module_migrations" (
    "id" SERIAL NOT NULL,
    "table_name" VARCHAR(255) NOT NULL,
    "link_descriptor" JSONB NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "link_module_migrations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "location_fulfillment_provider" (
    "stock_location_id" VARCHAR(255) NOT NULL,
    "fulfillment_provider_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "location_fulfillment_provider_pkey" PRIMARY KEY ("stock_location_id","fulfillment_provider_id")
);

-- CreateTable
CREATE TABLE "location_fulfillment_set" (
    "stock_location_id" VARCHAR(255) NOT NULL,
    "fulfillment_set_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "location_fulfillment_set_pkey" PRIMARY KEY ("stock_location_id","fulfillment_set_id")
);

-- CreateTable
CREATE TABLE "mikro_orm_migrations" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255),
    "executed_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "mikro_orm_migrations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification" (
    "id" TEXT NOT NULL,
    "to" TEXT NOT NULL,
    "channel" TEXT NOT NULL,
    "template" TEXT NOT NULL,
    "data" JSONB,
    "trigger_type" TEXT,
    "resource_id" TEXT,
    "resource_type" TEXT,
    "receiver_id" TEXT,
    "original_notification_id" TEXT,
    "idempotency_key" TEXT,
    "external_id" TEXT,
    "provider_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "status" TEXT NOT NULL DEFAULT 'pending',

    CONSTRAINT "notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_provider" (
    "id" TEXT NOT NULL,
    "handle" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_enabled" BOOLEAN NOT NULL DEFAULT true,
    "channels" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "notification_provider_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order" (
    "id" TEXT NOT NULL,
    "region_id" TEXT,
    "display_id" SERIAL,
    "customer_id" TEXT,
    "version" INTEGER NOT NULL DEFAULT 1,
    "sales_channel_id" TEXT,
    "status" "order_status_enum" NOT NULL DEFAULT 'pending',
    "is_draft_order" BOOLEAN NOT NULL DEFAULT false,
    "email" TEXT,
    "currency_code" TEXT NOT NULL,
    "shipping_address_id" TEXT,
    "billing_address_id" TEXT,
    "no_notification" BOOLEAN,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "canceled_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_address" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT,
    "company" TEXT,
    "first_name" TEXT,
    "last_name" TEXT,
    "address_1" TEXT,
    "address_2" TEXT,
    "city" TEXT,
    "country_code" TEXT,
    "province" TEXT,
    "postal_code" TEXT,
    "phone" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_address_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_cart" (
    "order_id" VARCHAR(255) NOT NULL,
    "cart_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_cart_pkey" PRIMARY KEY ("order_id","cart_id")
);

-- CreateTable
CREATE TABLE "order_change" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "description" TEXT,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "internal_note" TEXT,
    "created_by" TEXT,
    "requested_by" TEXT,
    "requested_at" TIMESTAMPTZ(6),
    "confirmed_by" TEXT,
    "confirmed_at" TIMESTAMPTZ(6),
    "declined_by" TEXT,
    "declined_reason" TEXT,
    "metadata" JSONB,
    "declined_at" TIMESTAMPTZ(6),
    "canceled_by" TEXT,
    "canceled_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "change_type" TEXT,
    "deleted_at" TIMESTAMPTZ(6),
    "return_id" TEXT,
    "claim_id" TEXT,
    "exchange_id" TEXT,

    CONSTRAINT "order_change_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_change_action" (
    "id" TEXT NOT NULL,
    "order_id" TEXT,
    "version" INTEGER,
    "ordering" BIGSERIAL NOT NULL,
    "order_change_id" TEXT,
    "reference" TEXT,
    "reference_id" TEXT,
    "action" TEXT NOT NULL,
    "details" JSONB,
    "amount" DECIMAL,
    "raw_amount" JSONB,
    "internal_note" TEXT,
    "applied" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "return_id" TEXT,
    "claim_id" TEXT,
    "exchange_id" TEXT,

    CONSTRAINT "order_change_action_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_claim" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "return_id" TEXT,
    "order_version" INTEGER NOT NULL,
    "display_id" SERIAL NOT NULL,
    "type" "order_claim_type_enum" NOT NULL,
    "no_notification" BOOLEAN,
    "refund_amount" DECIMAL,
    "raw_refund_amount" JSONB,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "canceled_at" TIMESTAMPTZ(6),
    "created_by" TEXT,

    CONSTRAINT "order_claim_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_claim_item" (
    "id" TEXT NOT NULL,
    "claim_id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "is_additional_item" BOOLEAN NOT NULL DEFAULT false,
    "reason" "claim_reason_enum",
    "quantity" DECIMAL NOT NULL,
    "raw_quantity" JSONB NOT NULL,
    "note" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_claim_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_claim_item_image" (
    "id" TEXT NOT NULL,
    "claim_item_id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_claim_item_image_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_credit_line" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "reference" TEXT,
    "reference_id" TEXT,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_credit_line_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_exchange" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "return_id" TEXT,
    "order_version" INTEGER NOT NULL,
    "display_id" SERIAL NOT NULL,
    "no_notification" BOOLEAN,
    "allow_backorder" BOOLEAN NOT NULL DEFAULT false,
    "difference_due" DECIMAL,
    "raw_difference_due" JSONB,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "canceled_at" TIMESTAMPTZ(6),
    "created_by" TEXT,

    CONSTRAINT "order_exchange_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_exchange_item" (
    "id" TEXT NOT NULL,
    "exchange_id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "quantity" DECIMAL NOT NULL,
    "raw_quantity" JSONB NOT NULL,
    "note" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_exchange_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_fulfillment" (
    "order_id" VARCHAR(255) NOT NULL,
    "fulfillment_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_fulfillment_pkey" PRIMARY KEY ("order_id","fulfillment_id")
);

-- CreateTable
CREATE TABLE "order_item" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "item_id" TEXT NOT NULL,
    "quantity" DECIMAL NOT NULL,
    "raw_quantity" JSONB NOT NULL,
    "fulfilled_quantity" DECIMAL NOT NULL,
    "raw_fulfilled_quantity" JSONB NOT NULL,
    "shipped_quantity" DECIMAL NOT NULL,
    "raw_shipped_quantity" JSONB NOT NULL,
    "return_requested_quantity" DECIMAL NOT NULL,
    "raw_return_requested_quantity" JSONB NOT NULL,
    "return_received_quantity" DECIMAL NOT NULL,
    "raw_return_received_quantity" JSONB NOT NULL,
    "return_dismissed_quantity" DECIMAL NOT NULL,
    "raw_return_dismissed_quantity" JSONB NOT NULL,
    "written_off_quantity" DECIMAL NOT NULL,
    "raw_written_off_quantity" JSONB NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "delivered_quantity" DECIMAL NOT NULL DEFAULT 0,
    "raw_delivered_quantity" JSONB NOT NULL,
    "unit_price" DECIMAL,
    "raw_unit_price" JSONB,
    "compare_at_unit_price" DECIMAL,
    "raw_compare_at_unit_price" JSONB,

    CONSTRAINT "order_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_line_item" (
    "id" TEXT NOT NULL,
    "totals_id" TEXT,
    "title" TEXT NOT NULL,
    "subtitle" TEXT,
    "thumbnail" TEXT,
    "variant_id" TEXT,
    "product_id" TEXT,
    "product_title" TEXT,
    "product_description" TEXT,
    "product_subtitle" TEXT,
    "product_type" TEXT,
    "product_collection" TEXT,
    "product_handle" TEXT,
    "variant_sku" TEXT,
    "variant_barcode" TEXT,
    "variant_title" TEXT,
    "variant_option_values" JSONB,
    "requires_shipping" BOOLEAN NOT NULL DEFAULT true,
    "is_discountable" BOOLEAN NOT NULL DEFAULT true,
    "is_tax_inclusive" BOOLEAN NOT NULL DEFAULT false,
    "compare_at_unit_price" DECIMAL,
    "raw_compare_at_unit_price" JSONB,
    "unit_price" DECIMAL NOT NULL,
    "raw_unit_price" JSONB NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "is_custom_price" BOOLEAN NOT NULL DEFAULT false,
    "product_type_id" TEXT,
    "is_giftcard" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "order_line_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_line_item_adjustment" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "promotion_id" TEXT,
    "code" TEXT,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "provider_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "item_id" TEXT NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_line_item_adjustment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_line_item_tax_line" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "tax_rate_id" TEXT,
    "code" TEXT NOT NULL,
    "rate" DECIMAL NOT NULL,
    "raw_rate" JSONB NOT NULL,
    "provider_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "item_id" TEXT NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_line_item_tax_line_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_order_store_store" (
    "order_id" VARCHAR(255) NOT NULL,
    "store_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_order_store_store_pkey" PRIMARY KEY ("order_id","store_id")
);

-- CreateTable
CREATE TABLE "order_payment_collection" (
    "order_id" VARCHAR(255) NOT NULL,
    "payment_collection_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_payment_collection_pkey" PRIMARY KEY ("order_id","payment_collection_id")
);

-- CreateTable
CREATE TABLE "order_promotion" (
    "order_id" VARCHAR(255) NOT NULL,
    "promotion_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_promotion_pkey" PRIMARY KEY ("order_id","promotion_id")
);

-- CreateTable
CREATE TABLE "order_shipping" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "shipping_method_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "return_id" TEXT,
    "claim_id" TEXT,
    "exchange_id" TEXT,

    CONSTRAINT "order_shipping_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_shipping_method" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" JSONB,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "is_tax_inclusive" BOOLEAN NOT NULL DEFAULT false,
    "shipping_option_id" TEXT,
    "data" JSONB,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "is_custom_amount" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "order_shipping_method_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_shipping_method_adjustment" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "promotion_id" TEXT,
    "code" TEXT,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "provider_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "shipping_method_id" TEXT NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_shipping_method_adjustment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_shipping_method_tax_line" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "tax_rate_id" TEXT,
    "code" TEXT NOT NULL,
    "rate" DECIMAL NOT NULL,
    "raw_rate" JSONB NOT NULL,
    "provider_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "shipping_method_id" TEXT NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_shipping_method_tax_line_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_summary" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 1,
    "totals" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "order_summary_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_transaction" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 1,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "currency_code" TEXT NOT NULL,
    "reference" TEXT,
    "reference_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "return_id" TEXT,
    "claim_id" TEXT,
    "exchange_id" TEXT,

    CONSTRAINT "order_transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment" (
    "id" TEXT NOT NULL,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "currency_code" TEXT NOT NULL,
    "provider_id" TEXT NOT NULL,
    "data" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "captured_at" TIMESTAMPTZ(6),
    "canceled_at" TIMESTAMPTZ(6),
    "payment_collection_id" TEXT NOT NULL,
    "payment_session_id" TEXT NOT NULL,
    "metadata" JSONB,

    CONSTRAINT "payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_collection" (
    "id" TEXT NOT NULL,
    "currency_code" TEXT NOT NULL,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "authorized_amount" DECIMAL,
    "raw_authorized_amount" JSONB,
    "captured_amount" DECIMAL,
    "raw_captured_amount" JSONB,
    "refunded_amount" DECIMAL,
    "raw_refunded_amount" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "completed_at" TIMESTAMPTZ(6),
    "status" TEXT NOT NULL DEFAULT 'not_paid',
    "metadata" JSONB,

    CONSTRAINT "payment_collection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_collection_payment_providers" (
    "payment_collection_id" TEXT NOT NULL,
    "payment_provider_id" TEXT NOT NULL,

    CONSTRAINT "payment_collection_payment_providers_pkey" PRIMARY KEY ("payment_collection_id","payment_provider_id")
);

-- CreateTable
CREATE TABLE "payment_provider" (
    "id" TEXT NOT NULL,
    "is_enabled" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "payment_provider_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_session" (
    "id" TEXT NOT NULL,
    "currency_code" TEXT NOT NULL,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "provider_id" TEXT NOT NULL,
    "data" JSONB NOT NULL DEFAULT '{}',
    "context" JSONB,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "authorized_at" TIMESTAMPTZ(6),
    "payment_collection_id" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "payment_session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "price" (
    "id" TEXT NOT NULL,
    "title" TEXT,
    "price_set_id" TEXT NOT NULL,
    "currency_code" TEXT NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "rules_count" INTEGER DEFAULT 0,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "price_list_id" TEXT,
    "amount" DECIMAL NOT NULL,
    "min_quantity" INTEGER,
    "max_quantity" INTEGER,

    CONSTRAINT "price_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "price_list" (
    "id" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "starts_at" TIMESTAMPTZ(6),
    "ends_at" TIMESTAMPTZ(6),
    "rules_count" INTEGER DEFAULT 0,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'sale',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "price_list_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "price_list_rule" (
    "id" TEXT NOT NULL,
    "price_list_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "value" JSONB,
    "attribute" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "price_list_rule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "price_preference" (
    "id" TEXT NOT NULL,
    "attribute" TEXT NOT NULL,
    "value" TEXT,
    "is_tax_inclusive" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "price_preference_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "price_rule" (
    "id" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "price_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "attribute" TEXT NOT NULL DEFAULT '',
    "operator" TEXT NOT NULL DEFAULT 'eq',

    CONSTRAINT "price_rule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "price_set" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "price_set_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "handle" TEXT NOT NULL,
    "subtitle" TEXT,
    "description" TEXT,
    "is_giftcard" BOOLEAN NOT NULL DEFAULT false,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "thumbnail" TEXT,
    "weight" TEXT,
    "length" TEXT,
    "height" TEXT,
    "width" TEXT,
    "origin_country" TEXT,
    "hs_code" TEXT,
    "mid_code" TEXT,
    "material" TEXT,
    "collection_id" TEXT,
    "type_id" TEXT,
    "discountable" BOOLEAN NOT NULL DEFAULT true,
    "external_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "metadata" JSONB,

    CONSTRAINT "product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_category" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "handle" TEXT NOT NULL,
    "mpath" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT false,
    "is_internal" BOOLEAN NOT NULL DEFAULT false,
    "rank" INTEGER NOT NULL DEFAULT 0,
    "parent_category_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "metadata" JSONB,

    CONSTRAINT "product_category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_category_product" (
    "product_id" TEXT NOT NULL,
    "product_category_id" TEXT NOT NULL,

    CONSTRAINT "product_category_product_pkey" PRIMARY KEY ("product_id","product_category_id")
);

-- CreateTable
CREATE TABLE "product_collection" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "handle" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "product_collection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_option" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "product_id" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "product_option_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_option_value" (
    "id" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "option_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "product_option_value_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_product_store_store" (
    "product_id" VARCHAR(255) NOT NULL,
    "store_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "product_product_store_store_pkey" PRIMARY KEY ("product_id","store_id")
);

-- CreateTable
CREATE TABLE "product_sales_channel" (
    "product_id" VARCHAR(255) NOT NULL,
    "sales_channel_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "product_sales_channel_pkey" PRIMARY KEY ("product_id","sales_channel_id")
);

-- CreateTable
CREATE TABLE "product_shipping_profile" (
    "product_id" VARCHAR(255) NOT NULL,
    "shipping_profile_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "product_shipping_profile_pkey" PRIMARY KEY ("product_id","shipping_profile_id")
);

-- CreateTable
CREATE TABLE "product_tag" (
    "id" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "product_tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_tags" (
    "product_id" TEXT NOT NULL,
    "product_tag_id" TEXT NOT NULL,

    CONSTRAINT "product_tags_pkey" PRIMARY KEY ("product_id","product_tag_id")
);

-- CreateTable
CREATE TABLE "product_type" (
    "id" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "metadata" JSON,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "product_type_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_variant" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "sku" TEXT,
    "barcode" TEXT,
    "ean" TEXT,
    "upc" TEXT,
    "allow_backorder" BOOLEAN NOT NULL DEFAULT false,
    "manage_inventory" BOOLEAN NOT NULL DEFAULT true,
    "hs_code" TEXT,
    "origin_country" TEXT,
    "mid_code" TEXT,
    "material" TEXT,
    "weight" INTEGER,
    "length" INTEGER,
    "height" INTEGER,
    "width" INTEGER,
    "metadata" JSONB,
    "variant_rank" INTEGER DEFAULT 0,
    "product_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "product_variant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_variant_inventory_item" (
    "variant_id" VARCHAR(255) NOT NULL,
    "inventory_item_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "required_quantity" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "product_variant_inventory_item_pkey" PRIMARY KEY ("variant_id","inventory_item_id")
);

-- CreateTable
CREATE TABLE "product_variant_option" (
    "variant_id" TEXT NOT NULL,
    "option_value_id" TEXT NOT NULL,

    CONSTRAINT "product_variant_option_pkey" PRIMARY KEY ("variant_id","option_value_id")
);

-- CreateTable
CREATE TABLE "product_variant_price_set" (
    "variant_id" VARCHAR(255) NOT NULL,
    "price_set_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "product_variant_price_set_pkey" PRIMARY KEY ("variant_id","price_set_id")
);

-- CreateTable
CREATE TABLE "promotion" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "campaign_id" TEXT,
    "is_automatic" BOOLEAN NOT NULL DEFAULT false,
    "type" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "status" TEXT NOT NULL DEFAULT 'draft',

    CONSTRAINT "promotion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promotion_application_method" (
    "id" TEXT NOT NULL,
    "value" DECIMAL,
    "raw_value" JSONB,
    "max_quantity" INTEGER,
    "apply_to_quantity" INTEGER,
    "buy_rules_min_quantity" INTEGER,
    "type" TEXT NOT NULL,
    "target_type" TEXT NOT NULL,
    "allocation" TEXT,
    "promotion_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "currency_code" TEXT,

    CONSTRAINT "promotion_application_method_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promotion_campaign" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "campaign_identifier" TEXT NOT NULL,
    "starts_at" TIMESTAMPTZ(6),
    "ends_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "promotion_campaign_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promotion_campaign_budget" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "campaign_id" TEXT NOT NULL,
    "limit" DECIMAL,
    "raw_limit" JSONB,
    "used" DECIMAL NOT NULL DEFAULT 0,
    "raw_used" JSONB NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "currency_code" TEXT,

    CONSTRAINT "promotion_campaign_budget_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promotion_promotion_rule" (
    "promotion_id" TEXT NOT NULL,
    "promotion_rule_id" TEXT NOT NULL,

    CONSTRAINT "promotion_promotion_rule_pkey" PRIMARY KEY ("promotion_id","promotion_rule_id")
);

-- CreateTable
CREATE TABLE "promotion_rule" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "attribute" TEXT NOT NULL,
    "operator" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "promotion_rule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promotion_rule_value" (
    "id" TEXT NOT NULL,
    "promotion_rule_id" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "promotion_rule_value_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "provider_identity" (
    "id" TEXT NOT NULL,
    "entity_id" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "auth_identity_id" TEXT NOT NULL,
    "user_metadata" JSONB,
    "provider_metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "provider_identity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "publishable_api_key_sales_channel" (
    "publishable_key_id" VARCHAR(255) NOT NULL,
    "sales_channel_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "publishable_api_key_sales_channel_pkey" PRIMARY KEY ("publishable_key_id","sales_channel_id")
);

-- CreateTable
CREATE TABLE "refund" (
    "id" TEXT NOT NULL,
    "amount" DECIMAL NOT NULL,
    "raw_amount" JSONB NOT NULL,
    "payment_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "created_by" TEXT,
    "metadata" JSONB,
    "refund_reason_id" TEXT,
    "note" TEXT,

    CONSTRAINT "refund_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refund_reason" (
    "id" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "description" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "refund_reason_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "region" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "currency_code" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "automatic_taxes" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "region_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "region_country" (
    "iso_2" TEXT NOT NULL,
    "iso_3" TEXT NOT NULL,
    "num_code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "display_name" TEXT NOT NULL,
    "region_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "region_country_pkey" PRIMARY KEY ("iso_2")
);

-- CreateTable
CREATE TABLE "region_payment_provider" (
    "region_id" VARCHAR(255) NOT NULL,
    "payment_provider_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "region_payment_provider_pkey" PRIMARY KEY ("region_id","payment_provider_id")
);

-- CreateTable
CREATE TABLE "reservation_item" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "line_item_id" TEXT,
    "location_id" TEXT NOT NULL,
    "quantity" DECIMAL NOT NULL,
    "external_id" TEXT,
    "description" TEXT,
    "created_by" TEXT,
    "metadata" JSONB,
    "inventory_item_id" TEXT NOT NULL,
    "allow_backorder" BOOLEAN DEFAULT false,
    "raw_quantity" JSONB,

    CONSTRAINT "reservation_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "return" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "claim_id" TEXT,
    "exchange_id" TEXT,
    "order_version" INTEGER NOT NULL,
    "display_id" SERIAL NOT NULL,
    "status" "return_status_enum" NOT NULL DEFAULT 'open',
    "no_notification" BOOLEAN,
    "refund_amount" DECIMAL,
    "raw_refund_amount" JSONB,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "received_at" TIMESTAMPTZ(6),
    "canceled_at" TIMESTAMPTZ(6),
    "location_id" TEXT,
    "requested_at" TIMESTAMPTZ(6),
    "created_by" TEXT,

    CONSTRAINT "return_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "return_fulfillment" (
    "return_id" VARCHAR(255) NOT NULL,
    "fulfillment_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "return_fulfillment_pkey" PRIMARY KEY ("return_id","fulfillment_id")
);

-- CreateTable
CREATE TABLE "return_item" (
    "id" TEXT NOT NULL,
    "return_id" TEXT NOT NULL,
    "reason_id" TEXT,
    "item_id" TEXT NOT NULL,
    "quantity" DECIMAL NOT NULL,
    "raw_quantity" JSONB NOT NULL,
    "received_quantity" DECIMAL NOT NULL DEFAULT 0,
    "raw_received_quantity" JSONB NOT NULL,
    "note" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "damaged_quantity" DECIMAL NOT NULL DEFAULT 0,
    "raw_damaged_quantity" JSONB NOT NULL,

    CONSTRAINT "return_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "return_reason" (
    "id" VARCHAR NOT NULL,
    "value" VARCHAR NOT NULL,
    "label" VARCHAR NOT NULL,
    "description" VARCHAR,
    "metadata" JSONB,
    "parent_return_reason_id" VARCHAR,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "return_reason_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sales_channel" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "is_disabled" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "sales_channel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sales_channel_stock_location" (
    "sales_channel_id" VARCHAR(255) NOT NULL,
    "stock_location_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "sales_channel_stock_location_pkey" PRIMARY KEY ("sales_channel_id","stock_location_id")
);

-- CreateTable
CREATE TABLE "script_migrations" (
    "id" SERIAL NOT NULL,
    "script_name" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "finished_at" TIMESTAMPTZ(6),

    CONSTRAINT "script_migrations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_zone" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "metadata" JSONB,
    "fulfillment_set_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "service_zone_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "shipping_option" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "price_type" TEXT NOT NULL DEFAULT 'flat',
    "service_zone_id" TEXT NOT NULL,
    "shipping_profile_id" TEXT,
    "provider_id" TEXT,
    "data" JSONB,
    "metadata" JSONB,
    "shipping_option_type_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "shipping_option_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "shipping_option_price_set" (
    "shipping_option_id" VARCHAR(255) NOT NULL,
    "price_set_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "shipping_option_price_set_pkey" PRIMARY KEY ("shipping_option_id","price_set_id")
);

-- CreateTable
CREATE TABLE "shipping_option_rule" (
    "id" TEXT NOT NULL,
    "attribute" TEXT NOT NULL,
    "operator" TEXT NOT NULL,
    "value" JSONB,
    "shipping_option_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "shipping_option_rule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "shipping_option_type" (
    "id" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "description" TEXT,
    "code" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "shipping_option_type_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "shipping_profile" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "shipping_profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stock_location" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "name" TEXT NOT NULL,
    "address_id" TEXT,
    "metadata" JSONB,

    CONSTRAINT "stock_location_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stock_location_address" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),
    "address_1" TEXT NOT NULL,
    "address_2" TEXT,
    "company" TEXT,
    "city" TEXT,
    "country_code" TEXT NOT NULL,
    "phone" TEXT,
    "province" TEXT,
    "postal_code" TEXT,
    "metadata" JSONB,

    CONSTRAINT "stock_location_address_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "store" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL DEFAULT 'Medusa Store',
    "default_sales_channel_id" TEXT,
    "default_region_id" TEXT,
    "default_location_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "store_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "store_currency" (
    "id" TEXT NOT NULL,
    "currency_code" TEXT NOT NULL,
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "store_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "store_currency_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tax_provider" (
    "id" TEXT NOT NULL,
    "is_enabled" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "tax_provider_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tax_rate" (
    "id" TEXT NOT NULL,
    "rate" REAL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "is_combinable" BOOLEAN NOT NULL DEFAULT false,
    "tax_region_id" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_by" TEXT,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "tax_rate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tax_rate_rule" (
    "id" TEXT NOT NULL,
    "tax_rate_id" TEXT NOT NULL,
    "reference_id" TEXT NOT NULL,
    "reference" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_by" TEXT,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "tax_rate_rule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tax_region" (
    "id" TEXT NOT NULL,
    "provider_id" TEXT,
    "country_code" TEXT NOT NULL,
    "province_code" TEXT,
    "parent_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_by" TEXT,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "tax_region_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "first_name" TEXT,
    "last_name" TEXT,
    "email" TEXT NOT NULL,
    "avatar_url" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_user_store_store" (
    "user_id" VARCHAR(255) NOT NULL,
    "store_id" VARCHAR(255) NOT NULL,
    "id" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "user_user_store_store_pkey" PRIMARY KEY ("user_id","store_id")
);

-- CreateTable
CREATE TABLE "workflow_execution" (
    "id" VARCHAR NOT NULL,
    "workflow_id" VARCHAR NOT NULL,
    "transaction_id" VARCHAR NOT NULL,
    "execution" JSONB,
    "context" JSONB,
    "state" VARCHAR NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMP(6),
    "retention_time" INTEGER,
    "run_id" TEXT NOT NULL DEFAULT '01JYPTPKTJCD9G9KM95BG2DY6A',

    CONSTRAINT "workflow_execution_pkey" PRIMARY KEY ("workflow_id","transaction_id","run_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON "api_key"("token");

-- CreateIndex
CREATE INDEX "IDX_api_key_type" ON "api_key"("type");

-- CreateIndex
CREATE INDEX "IDX_capture_deleted_at" ON "capture"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_cart_currency_code" ON "cart"("currency_code");

-- CreateIndex
CREATE INDEX "IDX_cart_id_-4a39f6c9" ON "cart_payment_collection"("cart_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON "cart_payment_collection"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_-4a39f6c9" ON "cart_payment_collection"("id");

-- CreateIndex
CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON "cart_payment_collection"("payment_collection_id");

-- CreateIndex
CREATE INDEX "IDX_cart_id_-a9d4a70b" ON "cart_promotion"("cart_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON "cart_promotion"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_-a9d4a70b" ON "cart_promotion"("id");

-- CreateIndex
CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON "cart_promotion"("promotion_id");

-- CreateIndex
CREATE INDEX "IDX_account_holder_id_5cb3a0c0" ON "customer_account_holder"("account_holder_id");

-- CreateIndex
CREATE INDEX "IDX_customer_id_5cb3a0c0" ON "customer_account_holder"("customer_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_5cb3a0c0" ON "customer_account_holder"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_5cb3a0c0" ON "customer_account_holder"("id");

-- CreateIndex
CREATE INDEX "IDX_customer_address_customer_id" ON "customer_address"("customer_id");

-- CreateIndex
CREATE INDEX "IDX_customer_group_customer_customer_id" ON "customer_group_customer"("customer_id");

-- CreateIndex
CREATE UNIQUE INDEX "link_module_migrations_table_name_key" ON "link_module_migrations"("table_name");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-1e5992737" ON "location_fulfillment_provider"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON "location_fulfillment_provider"("fulfillment_provider_id");

-- CreateIndex
CREATE INDEX "IDX_id_-1e5992737" ON "location_fulfillment_provider"("id");

-- CreateIndex
CREATE INDEX "IDX_stock_location_id_-1e5992737" ON "location_fulfillment_provider"("stock_location_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-e88adb96" ON "location_fulfillment_set"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON "location_fulfillment_set"("fulfillment_set_id");

-- CreateIndex
CREATE INDEX "IDX_id_-e88adb96" ON "location_fulfillment_set"("id");

-- CreateIndex
CREATE INDEX "IDX_stock_location_id_-e88adb96" ON "location_fulfillment_set"("stock_location_id");

-- CreateIndex
CREATE INDEX "IDX_notification_provider_id" ON "notification"("provider_id");

-- CreateIndex
CREATE INDEX "IDX_notification_receiver_id" ON "notification"("receiver_id");

-- CreateIndex
CREATE INDEX "IDX_order_deleted_at" ON "order"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_order_address_customer_id" ON "order_address"("customer_id");

-- CreateIndex
CREATE INDEX "IDX_cart_id_-71069c16" ON "order_cart"("cart_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-71069c16" ON "order_cart"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_-71069c16" ON "order_cart"("id");

-- CreateIndex
CREATE INDEX "IDX_order_id_-71069c16" ON "order_cart"("order_id");

-- CreateIndex
CREATE INDEX "IDX_order_change_change_type" ON "order_change"("change_type");

-- CreateIndex
CREATE INDEX "IDX_order_change_deleted_at" ON "order_change"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_order_change_order_id" ON "order_change"("order_id");

-- CreateIndex
CREATE INDEX "IDX_order_change_order_id_version" ON "order_change"("order_id", "version");

-- CreateIndex
CREATE INDEX "IDX_order_change_status" ON "order_change"("status");

-- CreateIndex
CREATE INDEX "IDX_order_change_action_deleted_at" ON "order_change_action"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_order_change_action_order_change_id" ON "order_change_action"("order_change_id");

-- CreateIndex
CREATE INDEX "IDX_order_change_action_order_id" ON "order_change_action"("order_id");

-- CreateIndex
CREATE INDEX "IDX_order_change_action_ordering" ON "order_change_action"("ordering");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-e8d2543e" ON "order_fulfillment"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON "order_fulfillment"("fulfillment_id");

-- CreateIndex
CREATE INDEX "IDX_id_-e8d2543e" ON "order_fulfillment"("id");

-- CreateIndex
CREATE INDEX "IDX_order_id_-e8d2543e" ON "order_fulfillment"("order_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-11e48e68c" ON "order_order_store_store"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_-11e48e68c" ON "order_order_store_store"("id");

-- CreateIndex
CREATE INDEX "IDX_order_id_-11e48e68c" ON "order_order_store_store"("order_id");

-- CreateIndex
CREATE INDEX "IDX_store_id_-11e48e68c" ON "order_order_store_store"("store_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_f42b9949" ON "order_payment_collection"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_f42b9949" ON "order_payment_collection"("id");

-- CreateIndex
CREATE INDEX "IDX_order_id_f42b9949" ON "order_payment_collection"("order_id");

-- CreateIndex
CREATE INDEX "IDX_payment_collection_id_f42b9949" ON "order_payment_collection"("payment_collection_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-71518339" ON "order_promotion"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_-71518339" ON "order_promotion"("id");

-- CreateIndex
CREATE INDEX "IDX_order_id_-71518339" ON "order_promotion"("order_id");

-- CreateIndex
CREATE INDEX "IDX_promotion_id_-71518339" ON "order_promotion"("promotion_id");

-- CreateIndex
CREATE INDEX "IDX_payment_payment_session_id" ON "payment"("payment_session_id");

-- CreateIndex
CREATE INDEX "IDX_payment_session_deleted_at" ON "payment_session"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_price_rule_operator" ON "price_rule"("operator");

-- CreateIndex
CREATE INDEX "IDX_product_deleted_at" ON "product"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_product_category_deleted_at" ON "product_collection"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_product_collection_deleted_at" ON "product_collection"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_product_option_deleted_at" ON "product_option"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_product_option_value_deleted_at" ON "product_option_value"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-225bdf82" ON "product_product_store_store"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_-225bdf82" ON "product_product_store_store"("id");

-- CreateIndex
CREATE INDEX "IDX_product_id_-225bdf82" ON "product_product_store_store"("product_id");

-- CreateIndex
CREATE INDEX "IDX_store_id_-225bdf82" ON "product_product_store_store"("store_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_20b454295" ON "product_sales_channel"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_20b454295" ON "product_sales_channel"("id");

-- CreateIndex
CREATE INDEX "IDX_product_id_20b454295" ON "product_sales_channel"("product_id");

-- CreateIndex
CREATE INDEX "IDX_sales_channel_id_20b454295" ON "product_sales_channel"("sales_channel_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_17a262437" ON "product_shipping_profile"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_17a262437" ON "product_shipping_profile"("id");

-- CreateIndex
CREATE INDEX "IDX_product_id_17a262437" ON "product_shipping_profile"("product_id");

-- CreateIndex
CREATE INDEX "IDX_shipping_profile_id_17a262437" ON "product_shipping_profile"("shipping_profile_id");

-- CreateIndex
CREATE INDEX "IDX_product_tag_deleted_at" ON "product_tag"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_product_type_deleted_at" ON "product_type"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_product_variant_deleted_at" ON "product_variant"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_17b4c4e35" ON "product_variant_inventory_item"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_17b4c4e35" ON "product_variant_inventory_item"("id");

-- CreateIndex
CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON "product_variant_inventory_item"("inventory_item_id");

-- CreateIndex
CREATE INDEX "IDX_variant_id_17b4c4e35" ON "product_variant_inventory_item"("variant_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_52b23597" ON "product_variant_price_set"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_52b23597" ON "product_variant_price_set"("id");

-- CreateIndex
CREATE INDEX "IDX_price_set_id_52b23597" ON "product_variant_price_set"("price_set_id");

-- CreateIndex
CREATE INDEX "IDX_variant_id_52b23597" ON "product_variant_price_set"("variant_id");

-- CreateIndex
CREATE INDEX "IDX_promotion_type" ON "promotion"("type");

-- CreateIndex
CREATE INDEX "IDX_application_method_allocation" ON "promotion_application_method"("allocation");

-- CreateIndex
CREATE INDEX "IDX_application_method_target_type" ON "promotion_application_method"("target_type");

-- CreateIndex
CREATE INDEX "IDX_application_method_type" ON "promotion_application_method"("type");

-- CreateIndex
CREATE INDEX "IDX_campaign_budget_type" ON "promotion_campaign_budget"("type");

-- CreateIndex
CREATE INDEX "IDX_promotion_rule_attribute" ON "promotion_rule"("attribute");

-- CreateIndex
CREATE INDEX "IDX_promotion_rule_operator" ON "promotion_rule"("operator");

-- CreateIndex
CREATE INDEX "IDX_provider_identity_auth_identity_id" ON "provider_identity"("auth_identity_id");

-- CreateIndex
CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON "provider_identity"("entity_id", "provider");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-1d67bae40" ON "publishable_api_key_sales_channel"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_-1d67bae40" ON "publishable_api_key_sales_channel"("id");

-- CreateIndex
CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON "publishable_api_key_sales_channel"("publishable_key_id");

-- CreateIndex
CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON "publishable_api_key_sales_channel"("sales_channel_id");

-- CreateIndex
CREATE INDEX "IDX_refund_deleted_at" ON "refund"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON "region_country"("region_id", "iso_2");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_1c934dab0" ON "region_payment_provider"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_1c934dab0" ON "region_payment_provider"("id");

-- CreateIndex
CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON "region_payment_provider"("payment_provider_id");

-- CreateIndex
CREATE INDEX "IDX_region_id_1c934dab0" ON "region_payment_provider"("region_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-31ea43a" ON "return_fulfillment"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON "return_fulfillment"("fulfillment_id");

-- CreateIndex
CREATE INDEX "IDX_id_-31ea43a" ON "return_fulfillment"("id");

-- CreateIndex
CREATE INDEX "IDX_return_id_-31ea43a" ON "return_fulfillment"("return_id");

-- CreateIndex
CREATE INDEX "IDX_sales_channel_deleted_at" ON "sales_channel"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_26d06f470" ON "sales_channel_stock_location"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_26d06f470" ON "sales_channel_stock_location"("id");

-- CreateIndex
CREATE INDEX "IDX_sales_channel_id_26d06f470" ON "sales_channel_stock_location"("sales_channel_id");

-- CreateIndex
CREATE INDEX "IDX_stock_location_id_26d06f470" ON "sales_channel_stock_location"("stock_location_id");

-- CreateIndex
CREATE UNIQUE INDEX "idx_script_name_unique" ON "script_migrations"("script_name");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_ba32fa9c" ON "shipping_option_price_set"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_ba32fa9c" ON "shipping_option_price_set"("id");

-- CreateIndex
CREATE INDEX "IDX_price_set_id_ba32fa9c" ON "shipping_option_price_set"("price_set_id");

-- CreateIndex
CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON "shipping_option_price_set"("shipping_option_id");

-- CreateIndex
CREATE INDEX "IDX_tax_region_parent_id" ON "tax_region"("parent_id");

-- CreateIndex
CREATE INDEX "IDX_deleted_at_-10b55d246" ON "user_user_store_store"("deleted_at");

-- CreateIndex
CREATE INDEX "IDX_id_-10b55d246" ON "user_user_store_store"("id");

-- CreateIndex
CREATE INDEX "IDX_store_id_-10b55d246" ON "user_user_store_store"("store_id");

-- CreateIndex
CREATE INDEX "IDX_user_id_-10b55d246" ON "user_user_store_store"("user_id");

-- AddForeignKey
ALTER TABLE "geofence" ADD CONSTRAINT "geo_zone_service_zone_id_foreign" FOREIGN KEY ("service_zone_id") REFERENCES "service_zone"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "application_method_buy_rules" ADD CONSTRAINT "application_method_buy_rules_application_method_id_foreign" FOREIGN KEY ("application_method_id") REFERENCES "promotion_application_method"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "application_method_buy_rules" ADD CONSTRAINT "application_method_buy_rules_promotion_rule_id_foreign" FOREIGN KEY ("promotion_rule_id") REFERENCES "promotion_rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "application_method_target_rules" ADD CONSTRAINT "application_method_target_rules_application_method_id_foreign" FOREIGN KEY ("application_method_id") REFERENCES "promotion_application_method"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "application_method_target_rules" ADD CONSTRAINT "application_method_target_rules_promotion_rule_id_foreign" FOREIGN KEY ("promotion_rule_id") REFERENCES "promotion_rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "capture" ADD CONSTRAINT "capture_payment_id_foreign" FOREIGN KEY ("payment_id") REFERENCES "payment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart" ADD CONSTRAINT "cart_billing_address_id_foreign" FOREIGN KEY ("billing_address_id") REFERENCES "cart_address"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart" ADD CONSTRAINT "cart_shipping_address_id_foreign" FOREIGN KEY ("shipping_address_id") REFERENCES "cart_address"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart_line_item" ADD CONSTRAINT "cart_line_item_cart_id_foreign" FOREIGN KEY ("cart_id") REFERENCES "cart"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart_line_item_adjustment" ADD CONSTRAINT "cart_line_item_adjustment_item_id_foreign" FOREIGN KEY ("item_id") REFERENCES "cart_line_item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart_line_item_tax_line" ADD CONSTRAINT "cart_line_item_tax_line_item_id_foreign" FOREIGN KEY ("item_id") REFERENCES "cart_line_item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart_shipping_method" ADD CONSTRAINT "cart_shipping_method_cart_id_foreign" FOREIGN KEY ("cart_id") REFERENCES "cart"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart_shipping_method_adjustment" ADD CONSTRAINT "cart_shipping_method_adjustment_shipping_method_id_foreign" FOREIGN KEY ("shipping_method_id") REFERENCES "cart_shipping_method"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart_shipping_method_tax_line" ADD CONSTRAINT "cart_shipping_method_tax_line_shipping_method_id_foreign" FOREIGN KEY ("shipping_method_id") REFERENCES "cart_shipping_method"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "credit_line" ADD CONSTRAINT "credit_line_cart_id_foreign" FOREIGN KEY ("cart_id") REFERENCES "cart"("id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_address" ADD CONSTRAINT "customer_address_customer_id_foreign" FOREIGN KEY ("customer_id") REFERENCES "customer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_group_customer" ADD CONSTRAINT "customer_group_customer_customer_group_id_foreign" FOREIGN KEY ("customer_group_id") REFERENCES "customer_group"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customer_group_customer" ADD CONSTRAINT "customer_group_customer_customer_id_foreign" FOREIGN KEY ("customer_id") REFERENCES "customer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fulfillment" ADD CONSTRAINT "fulfillment_delivery_address_id_foreign" FOREIGN KEY ("delivery_address_id") REFERENCES "fulfillment_address"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fulfillment" ADD CONSTRAINT "fulfillment_provider_id_foreign" FOREIGN KEY ("provider_id") REFERENCES "fulfillment_provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fulfillment" ADD CONSTRAINT "fulfillment_shipping_option_id_foreign" FOREIGN KEY ("shipping_option_id") REFERENCES "shipping_option"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fulfillment_item" ADD CONSTRAINT "fulfillment_item_fulfillment_id_foreign" FOREIGN KEY ("fulfillment_id") REFERENCES "fulfillment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fulfillment_label" ADD CONSTRAINT "fulfillment_label_fulfillment_id_foreign" FOREIGN KEY ("fulfillment_id") REFERENCES "fulfillment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "image" ADD CONSTRAINT "image_product_id_foreign" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_level" ADD CONSTRAINT "inventory_level_inventory_item_id_foreign" FOREIGN KEY ("inventory_item_id") REFERENCES "inventory_item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification" ADD CONSTRAINT "notification_provider_id_foreign" FOREIGN KEY ("provider_id") REFERENCES "notification_provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_billing_address_id_foreign" FOREIGN KEY ("billing_address_id") REFERENCES "order_address"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order" ADD CONSTRAINT "order_shipping_address_id_foreign" FOREIGN KEY ("shipping_address_id") REFERENCES "order_address"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_change" ADD CONSTRAINT "order_change_order_id_foreign" FOREIGN KEY ("order_id") REFERENCES "order"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_change_action" ADD CONSTRAINT "order_change_action_order_change_id_foreign" FOREIGN KEY ("order_change_id") REFERENCES "order_change"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_credit_line" ADD CONSTRAINT "order_credit_line_order_id_foreign" FOREIGN KEY ("order_id") REFERENCES "order"("id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_item_id_foreign" FOREIGN KEY ("item_id") REFERENCES "order_line_item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_order_id_foreign" FOREIGN KEY ("order_id") REFERENCES "order"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_line_item" ADD CONSTRAINT "order_line_item_totals_id_foreign" FOREIGN KEY ("totals_id") REFERENCES "order_item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_line_item_adjustment" ADD CONSTRAINT "order_line_item_adjustment_item_id_foreign" FOREIGN KEY ("item_id") REFERENCES "order_line_item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_line_item_tax_line" ADD CONSTRAINT "order_line_item_tax_line_item_id_foreign" FOREIGN KEY ("item_id") REFERENCES "order_line_item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_shipping" ADD CONSTRAINT "order_shipping_order_id_foreign" FOREIGN KEY ("order_id") REFERENCES "order"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_shipping_method_adjustment" ADD CONSTRAINT "order_shipping_method_adjustment_shipping_method_id_foreign" FOREIGN KEY ("shipping_method_id") REFERENCES "order_shipping_method"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_shipping_method_tax_line" ADD CONSTRAINT "order_shipping_method_tax_line_shipping_method_id_foreign" FOREIGN KEY ("shipping_method_id") REFERENCES "order_shipping_method"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_summary" ADD CONSTRAINT "order_summary_order_id_foreign" FOREIGN KEY ("order_id") REFERENCES "order"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_transaction" ADD CONSTRAINT "order_transaction_order_id_foreign" FOREIGN KEY ("order_id") REFERENCES "order"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_payment_collection_id_foreign" FOREIGN KEY ("payment_collection_id") REFERENCES "payment_collection"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_collection_payment_providers" ADD CONSTRAINT "payment_collection_payment_providers_payment_col_aa276_foreign" FOREIGN KEY ("payment_collection_id") REFERENCES "payment_collection"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_collection_payment_providers" ADD CONSTRAINT "payment_collection_payment_providers_payment_pro_2d555_foreign" FOREIGN KEY ("payment_provider_id") REFERENCES "payment_provider"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_session" ADD CONSTRAINT "payment_session_payment_collection_id_foreign" FOREIGN KEY ("payment_collection_id") REFERENCES "payment_collection"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "price" ADD CONSTRAINT "price_price_list_id_foreign" FOREIGN KEY ("price_list_id") REFERENCES "price_list"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "price" ADD CONSTRAINT "price_price_set_id_foreign" FOREIGN KEY ("price_set_id") REFERENCES "price_set"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "price_list_rule" ADD CONSTRAINT "price_list_rule_price_list_id_foreign" FOREIGN KEY ("price_list_id") REFERENCES "price_list"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "price_rule" ADD CONSTRAINT "price_rule_price_id_foreign" FOREIGN KEY ("price_id") REFERENCES "price"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_collection_id_foreign" FOREIGN KEY ("collection_id") REFERENCES "product_collection"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_type_id_foreign" FOREIGN KEY ("type_id") REFERENCES "product_type"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_category" ADD CONSTRAINT "product_category_parent_category_id_foreign" FOREIGN KEY ("parent_category_id") REFERENCES "product_category"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_category_product" ADD CONSTRAINT "product_category_product_product_category_id_foreign" FOREIGN KEY ("product_category_id") REFERENCES "product_category"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_category_product" ADD CONSTRAINT "product_category_product_product_id_foreign" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_option" ADD CONSTRAINT "product_option_product_id_foreign" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_option_value" ADD CONSTRAINT "product_option_value_option_id_foreign" FOREIGN KEY ("option_id") REFERENCES "product_option"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_tags" ADD CONSTRAINT "product_tags_product_id_foreign" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_tags" ADD CONSTRAINT "product_tags_product_tag_id_foreign" FOREIGN KEY ("product_tag_id") REFERENCES "product_tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_variant" ADD CONSTRAINT "product_variant_product_id_foreign" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_variant_option" ADD CONSTRAINT "product_variant_option_option_value_id_foreign" FOREIGN KEY ("option_value_id") REFERENCES "product_option_value"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_variant_option" ADD CONSTRAINT "product_variant_option_variant_id_foreign" FOREIGN KEY ("variant_id") REFERENCES "product_variant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "promotion" ADD CONSTRAINT "promotion_campaign_id_foreign" FOREIGN KEY ("campaign_id") REFERENCES "promotion_campaign"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "promotion_application_method" ADD CONSTRAINT "promotion_application_method_promotion_id_foreign" FOREIGN KEY ("promotion_id") REFERENCES "promotion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "promotion_campaign_budget" ADD CONSTRAINT "promotion_campaign_budget_campaign_id_foreign" FOREIGN KEY ("campaign_id") REFERENCES "promotion_campaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "promotion_promotion_rule" ADD CONSTRAINT "promotion_promotion_rule_promotion_id_foreign" FOREIGN KEY ("promotion_id") REFERENCES "promotion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "promotion_promotion_rule" ADD CONSTRAINT "promotion_promotion_rule_promotion_rule_id_foreign" FOREIGN KEY ("promotion_rule_id") REFERENCES "promotion_rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "promotion_rule_value" ADD CONSTRAINT "promotion_rule_value_promotion_rule_id_foreign" FOREIGN KEY ("promotion_rule_id") REFERENCES "promotion_rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_identity" ADD CONSTRAINT "provider_identity_auth_identity_id_foreign" FOREIGN KEY ("auth_identity_id") REFERENCES "auth_identity"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refund" ADD CONSTRAINT "refund_payment_id_foreign" FOREIGN KEY ("payment_id") REFERENCES "payment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "region_country" ADD CONSTRAINT "region_country_region_id_foreign" FOREIGN KEY ("region_id") REFERENCES "region"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservation_item" ADD CONSTRAINT "reservation_item_inventory_item_id_foreign" FOREIGN KEY ("inventory_item_id") REFERENCES "inventory_item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "return_reason" ADD CONSTRAINT "return_reason_parent_return_reason_id_foreign" FOREIGN KEY ("parent_return_reason_id") REFERENCES "return_reason"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "service_zone" ADD CONSTRAINT "service_zone_fulfillment_set_id_foreign" FOREIGN KEY ("fulfillment_set_id") REFERENCES "fulfillment_set"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "shipping_option" ADD CONSTRAINT "shipping_option_provider_id_foreign" FOREIGN KEY ("provider_id") REFERENCES "fulfillment_provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "shipping_option" ADD CONSTRAINT "shipping_option_service_zone_id_foreign" FOREIGN KEY ("service_zone_id") REFERENCES "service_zone"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "shipping_option" ADD CONSTRAINT "shipping_option_shipping_option_type_id_foreign" FOREIGN KEY ("shipping_option_type_id") REFERENCES "shipping_option_type"("id") ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "shipping_option" ADD CONSTRAINT "shipping_option_shipping_profile_id_foreign" FOREIGN KEY ("shipping_profile_id") REFERENCES "shipping_profile"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "shipping_option_rule" ADD CONSTRAINT "shipping_option_rule_shipping_option_id_foreign" FOREIGN KEY ("shipping_option_id") REFERENCES "shipping_option"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_location" ADD CONSTRAINT "stock_location_address_id_foreign" FOREIGN KEY ("address_id") REFERENCES "stock_location_address"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "store_currency" ADD CONSTRAINT "store_currency_store_id_foreign" FOREIGN KEY ("store_id") REFERENCES "store"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tax_rate" ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY ("tax_region_id") REFERENCES "tax_region"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "tax_rate_rule" ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY ("tax_rate_id") REFERENCES "tax_rate"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "tax_region" ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY ("parent_id") REFERENCES "tax_region"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "tax_region" ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY ("provider_id") REFERENCES "tax_provider"("id") ON DELETE SET NULL ON UPDATE NO ACTION;
