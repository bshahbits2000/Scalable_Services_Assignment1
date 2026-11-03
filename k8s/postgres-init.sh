#!/bin/sh
set -eu
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname postgres \
  --set=bpass="$BOOKING_PASSWORD" --set=ipass="$INVENTORY_PASSWORD" \
  --set=ppass="$PAYMENT_PASSWORD" --set=npass="$NOTIFICATION_PASSWORD" <<'SQL'
CREATE ROLE sf_booking LOGIN PASSWORD :'bpass';
CREATE ROLE sf_inventory LOGIN PASSWORD :'ipass';
CREATE ROLE sf_payment LOGIN PASSWORD :'ppass';
CREATE ROLE sf_notification LOGIN PASSWORD :'npass';
CREATE DATABASE sf_booking OWNER sf_booking;
CREATE DATABASE sf_inventory OWNER sf_inventory;
CREATE DATABASE sf_payment OWNER sf_payment;
CREATE DATABASE sf_notification OWNER sf_notification;
REVOKE ALL ON DATABASE sf_booking FROM PUBLIC;
REVOKE ALL ON DATABASE sf_inventory FROM PUBLIC;
REVOKE ALL ON DATABASE sf_payment FROM PUBLIC;
REVOKE ALL ON DATABASE sf_notification FROM PUBLIC;
GRANT CONNECT ON DATABASE sf_booking TO sf_booking;
GRANT CONNECT ON DATABASE sf_inventory TO sf_inventory;
GRANT CONNECT ON DATABASE sf_payment TO sf_payment;
GRANT CONNECT ON DATABASE sf_notification TO sf_notification;
SQL
