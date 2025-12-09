# Minimal Overleaf CE image for Fly.io
FROM sharelatex/sharelatex:latest

# Fly will set PORT, but default to 3000 for safety
ENV PORT=3000

# Patch: don't let Mongo featureCompatibilityVersion check kill the container
# (MongoDB Atlas Free tier blocks getParameter)
RUN sed -i 's/process.exit(1);/process.exit(0);/g' \
  /overleaf/services/web/modules/server-ce-scripts/scripts/check-mongodb.mjs || true

# Expose the same port as fly.toml internal_port
EXPOSE 3000

# Create startup script via heredoc so Docker doesn't misinterpret "set -e"
RUN cat << 'EOF' > /start.sh
#!/bin/bash
set -e

PORT_RUN="${PORT:-3000}"
echo "Configuring nginx to listen on port ${PORT_RUN}"

# Update nginx to listen on the Fly.io internal port
sed -i "s/listen 80;/listen ${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true
sed -i "s/listen \[::\]:80;/listen \[::\]:${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true

echo "Starting my_init..."
exec /sbin/my_init
EOF

RUN chmod +x /start.sh

# Entry point
CMD ["/start.sh"]
