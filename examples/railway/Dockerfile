# Minimal Overleaf CE image for Railway: adjust nginx to listen on $PORT
# Use a current Overleaf CE tag (matches toolkit seed version)
FROM sharelatex/sharelatex:6.0.1

ENV PORT=3000

# Override entrypoint so we can edit nginx config before starting my_init
ENTRYPOINT ["/bin/bash", "-lc"]
CMD "PORT_RUN=\"${PORT:-3000}\" && \
 sed -i \"s/listen 80;/listen ${PORT_RUN};/\" /etc/nginx/sites-available/sharelatex && \
 sed -i \"s/listen \\[::\\]:80;/listen \\[::\\]:${PORT_RUN};/\" /etc/nginx/sites-available/sharelatex && \
 exec /sbin/my_init"

