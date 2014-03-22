# Run this script after the installation of Zenoss but before starting the zenoss service.  This script will setup RabbitMQ with proper permissions.


{% set vhost= pillar['zenoss']['rabbitmq-vhost'] -%}
{% set pass= pillar['zenoss']['rabbitmq-pass'] -%}
{% set user= pillar['zenoss']['rabbitmq-user'] -%}

rabbitmq:
  pkg.installed:
    - names:
      - rabbitmq-server

rabbitmq-stop-server:
  service:
    - dead
    - name: rabbitmq-server
    - watch:
      - pkg: rabbitmq


rabbitmq-env:
  file.managed:
    - name: /etc/rabbitmq/rabbitmq-env.conf
    - source: salt://files/rabbitmq-env.conf
    - user: root
    - group: root
    - mode: '0777'

rabbitmq-profile:
  file.managed:
    - name: /etc/profile.d/zenoss.sh
    - source: /srv/salt/zenoss.sh
    - source: salt://files/zenoss.sh

rabbitmqctl-stop:
  cmd.run:
    - name: rabbitmqctl stop_app

rabbitmqctl-reset:
  cmd.run:
    - name: rabbitmqctl reset
    - watch:
      - cmd: rabbitmqctl-stop

rabbitmqctl-start:
  cmd.run:
    - name: rabbitmqctl start_app
    - watch:
      - cmd: rabbitmqctl-reset

rabbitmqctl-add-vhost:
  cmd.run:
    - name: rabbitmqctl add_vhost {{ vhost }}
    - watch:
      - cmd: rabbitmqctl-start

rabbitmqctl-add-user:
  cmd.run:
    - name: rabbitmqctl add_user {{ user }} {{ pass }}
    - watch:
      - cmd: rabbitmqctl-add-vhost

rabbitmqctl-set-perms:
  cmd.run:
    - name: rabbitmqctl set_permissions -p {{ vhost }} {{ user }} '.*' '.*' '.*'
    - watch:
      - cmd: rabbitmqctl-add-user

rabbitmq-start-server:
  service:
    - running
    - enable: true
    - name: rabbitmq-server
    - watch:
      - pkg: rabbitmq 
