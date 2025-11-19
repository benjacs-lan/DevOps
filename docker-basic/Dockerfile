FROM grafana/grafana

USER root
RUN for i in $(seq 1 5); do apk update && break || sleep 1; done && \
    apk add --no-cache curl
USER grafana

CMD ["bash"]
