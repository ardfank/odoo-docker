#!/bin/bash
set -e

DB_NAME=$(awk -F '=' '/db_name/ {gsub(/ /,"",$2); print $2}' "$ODOO_RC")
DB_USER=$(awk -F '=' '/db_user/ {gsub(/ /,"",$2); print $2}' "$ODOO_RC")
DB_PASS=$(awk -F '=' '/db_password/ {gsub(/ /,"",$2); print $2}' "$ODOO_RC")
DB_HOST=$(awk -F '=' '/db_host/ {gsub(/ /,"",$2); print $2}' "$ODOO_RC")
DB_PORT=$(awk -F '=' '/db_port/ {gsub(/ /,"",$2); print $2}' "$ODOO_RC")

DB_NAME=${DB_NAME:-"odoo"}
DB_USER=${DB_USER:-"odoo"}
DB_PASS=${DB_PASS:-"odoo"}
DB_HOST=${DB_HOST:-"db"}
DB_PORT=${DB_PORT:-5432}

echo "Checking if DB $DB_NAME $DB_USER $DB_PASS $DB_PORT is initialized..."

if PGPASSWORD="$DB_PASS" psql -qtAX -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1 FROM ir_module_module WHERE name = 'base';" | grep -q "^1$"; then
  echo "Database already initialized."
else
  echo "Initializing database with base module..."
  odoo -c /etc/odoo/odoo.conf -i base --stop-after-init
fi

echo "Starting Odoo..."
exec odoo -c /etc/odoo/odoo.conf
# exit 1