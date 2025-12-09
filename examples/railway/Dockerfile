ARG OVERLEAF_VERSION=6.0.0

# Base Overleaf CE image; override OVERLEAF_VERSION in Railway Variables if needed.
FROM sharelatex/sharelatex:${OVERLEAF_VERSION}

# Inline start script (no external COPY) to patch nginx listen port from $PORT.
RUN cat >/usr/local/bin/start-railway.sh <<'EOS' && chmod +x /usr/local/bin/start-railway.sh
#!/bin/bash
set -e
PORT_RUN="${PORT:-3000}"
echo "==> Overleaf starting on port ${PORT_RUN}"

# Wait for my_init to generate nginx config, then patch the listen port.
cat > /etc/my_init.d/001_patch_nginx_port.sh << 'INNERSCRIPT'
#!/bin/bash
PORT_VAL="${PORT:-3000}"
echo "Patching nginx to listen on port ${PORT_VAL}"
while [ ! -f /etc/nginx/sites-enabled/sharelatex ]; do
  sleep 1
done
sed -i "s/listen 80;/listen ${PORT_VAL};/" /etc/nginx/sites-enabled/sharelatex
sed -i "s/listen \[::\]:80;/listen \[::\]:${PORT_VAL};/" /etc/nginx/sites-enabled/sharelatex
echo "Nginx patched successfully"
INNERSCRIPT
chmod +x /etc/my_init.d/001_patch_nginx_port.sh

exec /sbin/my_init
EOS

CMD ["/usr/local/bin/start-railway.sh"]

