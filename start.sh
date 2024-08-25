#!/bin/sh

set -e

echo "run db migration"
source /app/app.env

# Debugging: Print environment variables
echo "DB_DRIVER: $DB_DRIVER"
echo "DB_SOURCE: $DB_SOURCE"

/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
