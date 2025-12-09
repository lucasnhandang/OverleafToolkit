FROM sharelatex/sharelatex:latest

ENV PORT=3000

# ✅ Xóa/vô hiệu hóa script kiểm tra MongoDB
RUN rm -f /etc/my_init.d/500_check_db_access.sh || true

# Configure nginx startup
RUN cat << 'EOF' > /start.sh
#!/bin/bash
set -e
PORT_RUN="${PORT:-3000}"
sed -i "s/listen 80;/listen ${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true
sed -i "s/listen \[::\]:80;/listen \[::\]:${PORT_RUN};/" /etc/nginx/sites-available/sharelatex || true
exec /sbin/my_init
EOF

RUN chmod +x /start.sh
EXPOSE 3000
CMD ["/start.sh"]