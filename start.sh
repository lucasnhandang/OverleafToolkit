#!/bin/bash
set -e

PORT_RUN="${PORT:-3000}"
echo "==> Overleaf starting on port ${PORT_RUN}"

# Đợi nginx config được generate xong từ my_init scripts
# Sau đó patch nó trước khi nginx start
cat > /etc/my_init.d/001_patch_nginx_port.sh << INNERSCRIPT
#!/bin/bash
PORT_VAL="\${PORT:-3000}"
echo "Patching nginx to listen on port \${PORT_VAL}"

# Đợi file config được tạo
while [ ! -f /etc/nginx/sites-enabled/sharelatex ]; do
  sleep 1
done

# Patch nginx config
sed -i "s/listen 80;/listen \${PORT_VAL};/" /etc/nginx/sites-enabled/sharelatex
sed -i "s/listen \[::\]:80;/listen \[::\]:\${PORT_VAL};/" /etc/nginx/sites-enabled/sharelatex

echo "Nginx patched successfully"
INNERSCRIPT

chmod +x /etc/my_init.d/001_patch_nginx_port.sh

# Start my_init như bình thường
exec /sbin/my_init