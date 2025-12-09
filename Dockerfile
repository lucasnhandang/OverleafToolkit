FROM sharelatex/sharelatex:latest
ENV PORT=3000
RUN sed -i 's/process.exit(1);/process.exit(0);/g' \
  /overleaf/services/web/modules/server-ce-scripts/scripts/check-mongodb.mjs || true
EXPOSE 3000
RUN cat << 'EOF' > /start.sh
#!/bin/bash
set -e
PORT_RUN="${PORT:-3000}"
echo "🔧 Configuring Nginx to listen on port ${PORT_RUN} ..."
sed -i "s/listen 80;/listen ${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true
sed -i "s/listen \[::\]:80;/listen \[::\]:${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true
echo "🚀 Starting Overleaf CE (my_init)..."
exec /sbin/my_init
EOF
RUN chmod +x /start.sh
CMD ["/start.sh"]