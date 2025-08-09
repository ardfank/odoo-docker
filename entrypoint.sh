#!/bin/bash
set -e

ENV_NAME=$(awk -F '=' '/db_name/ {gsub(/ /,"",$2); print $2}' "$ODOO_RC")
ENV_USER=$(awk -F '=' '/db_user/ {gsub(/ /,"",$2); print $2}' "$ODOO_RC")
ENV_PASS=$(awk -F '=' '/db_password/ {gsub(/ /,"",$2); print $2}' "$ODOO_RC")
ENV_HOST=$(awk -F '=' '/db_host/ {gsub(/ /,"",$2); print $2}' "$ODOO_RC")
ENV_PORT=$(awk -F '=' '/db_port/ {gsub(/ /,"",$2); print $2}' "$ODOO_RC")

: ${DB_NAME:=${ENV_NAME:='odoo'}}
: ${DB_USER:=${ENV_USER:='odoo'}}
: ${DB_PASS:=${ENV_PASS:='odoo'}}
: ${DB_HOST:=${ENV_HOST:='odoo'}}
: ${DB_PORT:=${ENV_PORT:=5432}}

echo "Checking if DB $DB_NAME $DB_USER $DB_PASS $DB_PORT is initialized..."

if PGPASSWORD="$DB_PASS" psql -qtAX -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1 FROM ir_module_module WHERE name = 'base';" | grep -q "^1$"; then
  echo "Database already initialized."
else
  echo "Initializing database with base module..."
  sleep 5
  odoo -d $DB_NAME --db_user $DB_USER --db_password $DB_PASS --db_host $DB_HOST --db_port $DB_PORT -i base --stop-after-init
fi
chown odoo:odoo -R /var/lib/odoo 
# chown odoo:odoo -R /mnt/extra-addons
# echo "Starting Odoo..."
exec odoo -c /etc/odoo/odoo.conf -d $DB_NAME --db_user $DB_USER --db_password $DB_PASS --db_host $DB_HOST --db_port $DB_PORT
# exit 1