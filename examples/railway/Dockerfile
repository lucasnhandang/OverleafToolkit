# Minimal Overleaf CE image for Railway: adjust nginx to listen on $PORT
FROM sharelatex/sharelatex:3.0.3

ENV PORT=3000

CMD ["bash", "-lc", "\
  sed -i 's/listen 80;/listen ${PORT};/' /etc/nginx/sites-available/sharelatex && \
  sed -i 's/listen \\[::\\]:80;/listen \\[::\\]:${PORT};/' /etc/nginx/sites-available/sharelatex && \
  /sbin/my_init \
"]

