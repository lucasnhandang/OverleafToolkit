# Minimal Overleaf CE image for Railway: adjust nginx to listen on $PORT
FROM sharelatex/sharelatex:latest

# Railway injects PORT via environment variable
ENV PORT=3000

# 🩹 Patch: Đừng để check Mongo kill container khi Atlas chặn getParameter
RUN sed -i 's/process.exit(1);/process.exit(0);/g' \
  /overleaf/services/web/modules/server-ce-scripts/scripts/check-mongodb.mjs || true

# Expose the port Railway will use
EXPOSE 3000

# Create startup script to configure nginx before starting my_init
RUN echo '#!/bin/bash
set -e
PORT_RUN="${PORT:-3000}"
echo "Configuring nginx to listen on port ${PORT_RUN}"
sed -i "s/listen 80;/listen ${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true
sed -i "s/listen \\[::\\]:80;/listen \\[::\\]:${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true
echo "Starting my_init..."
exec /sbin/my_init' > /start.sh && chmod +x /start.sh

# Use the startup script
CMD ["/start.sh"]