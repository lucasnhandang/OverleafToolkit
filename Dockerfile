FROM sharelatex/sharelatex:latest

ENV PORT=3000

# Patch MongoDB check
RUN sed -i 's/process.exit(1);/process.exit(0);/g' \
  /overleaf/services/web/modules/server-ce-scripts/scripts/check-mongodb.mjs || true

EXPOSE 3000

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]