ARG OVERLEAF_VERSION=6.0.0

# Base image for Overleaf Community Edition. Override OVERLEAF_VERSION in Railway
# variables if you pin a different toolkit config/version.
FROM sharelatex/sharelatex:${OVERLEAF_VERSION}

# Reuse the toolkit start script that patches nginx to listen on $PORT (Railway
# provides this env var).
COPY start.sh /usr/local/bin/start-railway.sh

RUN chmod +x /usr/local/bin/start-railway.sh

CMD ["/usr/local/bin/start-railway.sh"]

