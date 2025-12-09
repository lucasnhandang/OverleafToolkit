FROM sharelatex/sharelatex:latest

# Xóa script kiểm tra MongoDB
RUN rm -f /etc/my_init.d/500_check_db_access.sh

# Không patch nginx, để Railway Port Proxy xử lý
ENV OVERLEAF_LISTEN_IP=0.0.0.0
ENV OVERLEAF_PORT=80

EXPOSE 80

CMD ["/sbin/my_init"]