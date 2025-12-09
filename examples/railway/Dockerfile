# Minimal Overleaf CE image for Railway: adjust nginx to listen on $PORT
# Use a current Overleaf CE tag (matches toolkit seed version)
FROM sharelatex/sharelatex:6.0.1

ENV PORT=3000

CMD ["bash", "-lc", "\
  sed -i 's/listen 80;/listen ${PORT};/' /etc/nginx/sites-available/sharelatex && \
  sed -i 's/listen \\[::\\]:80;/listen \\[::\\]:${PORT};/' /etc/nginx/sites-available/sharelatex && \
  /sbin/my_init \
"]

