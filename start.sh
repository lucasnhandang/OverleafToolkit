#!/bin/bash
set -e

PORT_RUN="${PORT:-3000}"
echo "Configuring nginx to listen on port ${PORT_RUN}"

sed -i "s/listen 80;/listen ${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true
sed -i "s/listen \[::\]:80;/listen \[::\]:${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true

echo "Starting my_init..."
exec /sbin/my_init