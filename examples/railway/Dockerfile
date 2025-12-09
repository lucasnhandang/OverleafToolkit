ARG OVERLEAF_VERSION=6.0.0

# Base Overleaf CE image; override OVERLEAF_VERSION in Railway Variables if needed.
FROM sharelatex/sharelatex:${OVERLEAF_VERSION}

# Reuse toolkit start script to patch nginx to listen on $PORT (Railway sets this).
COPY start.sh /usr/local/bin/start-railway.sh
RUN chmod +x /usr/local/bin/start-railway.sh

CMD ["/usr/local/bin/start-railway.sh"]

