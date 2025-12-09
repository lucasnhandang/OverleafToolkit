FROM overleaf/overleaf:latest

RUN rm -f /etc/my_init.d/500_check_db_access.sh || true

RUN mkdir -p /var/run/supervise && \
    chmod 755 /var/run/supervise

ENV OVERLEAF_LISTEN_IP=0.0.0.0
ENV OVERLEAF_PORT=80

EXPOSE 80

CMD ["/sbin/my_init"]