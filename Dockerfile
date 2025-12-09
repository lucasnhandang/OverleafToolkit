FROM sharelatex/sharelatex:latest

ENV PORT=3000

# ✅ Xóa script kiểm tra MongoDB
RUN rm -f /etc/my_init.d/500_check_db_access.sh || true

# ✅ Tạo script khởi động đúng cách - chạy TRƯỚC my_init
RUN cat << 'EOF' > /etc/my_init.d/001_configure_port.sh
#!/bin/bash
PORT_RUN="${PORT:-3000}"
echo "Configuring nginx to listen on port ${PORT_RUN}"

# Tìm và patch file nginx config
NGINX_CONF="/etc/nginx/sites-enabled/sharelatex"
if [ ! -f "$NGINX_CONF" ]; then
  NGINX_CONF="/etc/nginx/sites-available/sharelatex"
fi

if [ -f "$NGINX_CONF" ]; then
  sed -i "s/listen 80;/listen ${PORT_RUN};/" "$NGINX_CONF"
  sed -i "s/listen \[::\]:80;/listen \[::\]:${PORT_RUN};/" "$NGINX_CONF"
  echo "Nginx configured successfully"
else
  echo "Warning: Nginx config not found at expected locations"
fi
EOF

RUN chmod +x /etc/my_init.d/001_configure_port.sh

EXPOSE 3000

# ✅ Giữ nguyên CMD mặc định
CMD ["/sbin/my_init"]