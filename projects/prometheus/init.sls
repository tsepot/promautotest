install packages for prometheus_client:
  pkg.installed:
  - pkgs:
    - 'supervisor'

prometheus:
  archive.extracted:
    - name: /var/praekelt/prometheus/
    - source: https://github.com/prometheus/prometheus/releases/download/0.15.1/prometheus-0.15.1.linux-amd64.tar.gz
    - source_hash : md5=d8db9d3b100ed69cf3456ab5399a5cb4
    - archive_format: tar
    - user: root
    - group: root
    - if_missing: /var/praekelt/prometheus/


/etc/supervisor/conf.d/prometheus.conf:
  file.managed:
    - source: salt://projects/prometheus/files/prometheus.conf
    - user: root

supervisor_prometheus:
  supervisord.running:
    - name: prometheus
    - conf_file: /etc/supervisor/conf.d/prometheus.conf
    - watch:
      - file: /etc/supervisor/conf.d/prometheus.conf


add minions to .yml:
  file.managed:
    - name: /var/praekelt/prometheus/prometheus.yml
    - user: root
    - source: salt://projects/prometheus/files/prometheus.yml.j2
    - template: jinja

/var/praekelt/prometheus/prometheus.yml:
  file.managed:
    - user: root
    - source: salt://projects/prometheus/files/prometheus.yml.j2
    - template: jinja

Reload supervisor:
  cmd.run:
    - name: sudo service supervisor restart


