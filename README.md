# cadvisor
cAdvisor docker image with multi-arch support

Based on the official Google cAdvisor: [https://github.com/google/cadvisor](google/cadvisor)

# Docker Compose

```yml
version: '3.8'

networks:
  monitoring:
    driver: bridge

volumes:
  prometheus_data: {}

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./config/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--web.enable-lifecycle'
    expose:
      - 9090
    networks:
      - monitoring

  cadvisor:
    image: hougaard/cadvisor
    container_name: cadvisor
    ports:
      - "8080:8080"
    command:
      - '--housekeeping_interval=15s'
      - '--docker_only=true'
      - '--disable_metrics=disk,tcp,udp,percpu,sched,process,referenced_memory'
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - monitoring

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - GF_PATHS_PROVISIONING=/etc/grafana/provisioning
      - GF_AUTH_ANONYMOUS_ENABLED=true
      - GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
    networks:
      - monitoring
```
## Prometheus config
```yml
global:
  scrape_interval: 1m

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 1m
    static_configs:
      - targets: ['localhost:9090']

  - job_name: cadvisor
    scrape_interval: 20s
    static_configs:
      - targets: ['cadvisor:8080']

  - job_name: 'node'
    scrape_interval: 20s
    static_configs:
      - targets: ['node-exporter:9100']
```