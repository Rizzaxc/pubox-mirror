#!/bin/bash

# --- Configuration ---
# Replace with your remote database connection details
DB_HOST="aws-0-ap-southeast-1.pooler.supabase.com"
DB_PORT="6543"
DB_NAME="postgres"
DB_USER="postgres.qlezbnjfuabcxlsxxnrw"
# It's recommended to use a .pgpass file for password management
# or to be prompted for the password.
# If you must include the password here (not recommended for security):
# DB_PASSWORD="your_password"

# Output file for the schema dump
OUTPUT_FILE="../schema/pubox.sql"

# --- Script Logic ---

# Check if psql is installed
if ! command -v psql &> /dev/null
then
    echo "psql could not be found. Please install PostgreSQL client tools."
    exit 1
fi

echo "Starting schema dump for database '$DB_NAME' on host '$DB_HOST'..."

# Set the PGPASSWORD environment variable if DB_PASSWORD is set
# (Again, using .pgpass is more secure)
if [ ! -z "$DB_PASSWORD" ]; then
  export PGPASSWORD="$DB_PASSWORD"
fi

# The pg_dump command for schema-only
# -s, --schema-only: Dump only the schema (data definitions), not data.
# -h, --host: Specifies the host name of the machine on which the server is running.
# -p, --port: Specifies the TCP port or local Unix domain socket file extension on which the server is listening for connections.
# -U, --username: Connect as the specified user.
# -d, --dbname: Specifies the name of the database to connect to.
# -f, --file: Send output to the specified file.
# --no-owner: Do not output commands to set ownership of objects to match the original database.
# --no-privileges (or --no-acl): Prevent dumping of access privileges (grant/revoke commands).
pg_dump -s -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" --no-owner --no-privileges -f "$OUTPUT_FILE"

# Unset PGPASSWORD if it was set
if [ ! -z "$DB_PASSWORD" ]; then
  unset PGPASSWORD
fi

# Check if the dump was successful
if [ $? -eq 0 ]; then
  echo "Schema dump completed successfully."
  echo "Output file: $OUTPUT_FILE"
else
  echo "Error during schema dump. Please check the output and logs."
  # Optionally remove the (likely empty or partial) output file on error
  # rm -f "$OUTPUT_FILE"
  exit 1
fi

exit 0
