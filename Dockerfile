# Minimal Overleaf CE image for Railway: adjust nginx to listen on $PORT
# Use latest Overleaf CE tag (Railway may have issues with specific version tags)
FROM sharelatex/sharelatex:latest

# Railway injects PORT via environment variable
ENV PORT=3000

# Expose the port Railway will use
EXPOSE 3000

# Create startup script to configure nginx before starting my_init
RUN echo '#!/bin/bash\n\
set -e\n\
PORT_RUN="${PORT:-3000}"\n\
echo "Configuring nginx to listen on port ${PORT_RUN}"\n\
sed -i "s/listen 80;/listen ${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true\n\
sed -i "s/listen \\[::\\]:80;/listen \\[::\\]:${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true\n\
echo "Starting my_init..."\n\
exec /sbin/my_init' > /start.sh && chmod +x /start.sh

# Use the startup script
CMD ["/start.sh"]

