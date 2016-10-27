install packages for node_exporter:
  pkg.installed:
  - pkgs:
    - 'supervisor'

node_exporter:
  archive.extracted:
    - name: /var/praekelt/prometheus/
    - source: https://github.com/prometheus/node_exporter/releases/download/0.12.0/node_exporter-0.12.0.linux-amd64.tar.gz
    - source_hash : md5=efe49b6fae4b1a5cb75b24a60a35e1fc
    - archive_format: tar
    - user: root
    - group: root
    - if_missing: /var/praekelt/prometheus/node_exporter-0.12.0.linux-amd64/

remane_file:
  file.rename:
    - name: /var/praekelt/prometheus/node_exporter-0.12.0.linux-amd64/prometheus_client
    - source: /var/praekelt/prometheus/node_exporter-0.12.0.linux-amd64/node_exporter
    - force: True

/etc/supervisor/conf.d/prometheus_client.conf:
  file.managed:
    - source: salt://projects/slack/file/prometheus_client.conf
    - user: root

supervisor_prometheus_client:
  supervisord.running:
    - name: prometheus_client
    - conf_file: /etc/supervisor/conf.d/prometheus_client.conf
    - watch:
      - file: /etc/supervisor/conf.d/prometheus_client.conf

Reload supervisor:
  cmd.run:
    - name: sudo service supervisor restart

