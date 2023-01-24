#!/bin/bash
set -e

if [ $RESTORE = true ]; then
    # Restore the database if it does not already exist.
    # Use the directory our binary is in `/usr/local/bin/` to properly replicate
    # and restore with PocketBase's default locaiton for the database.
    if [ -f /usr/local/bin/pb_data/data.db ]; then
        echo "Skipping restore"
    else
        echo "No database found, restoring from replica if exists"
        litestream restore -v -if-replica-exists -o /usr/local/bin/pb_data/data.db "${REPLICA_URL}"
    fi
fi

if [ $REPLICATE = true ]; then
    # # Run litestream with your app as the subprocess.
    # # Use port 8080 for deploying to Fly.io, GCP Cloud Run, or AWS App Runner easily.
    exec litestream replicate -exec "/usr/local/bin/app serve --http 0.0.0.0:8080"
else
    exec /usr/local/bin/app serve --http 0.0.0.0:8080
fi
