include:
  - zenoss.zenrepo

net-snmp:
  pkg.installed:
    - names:
      - net-snmp
      - net-snmp-devel
      - net-snmp-libs
      - net-snmp-utils
    - require:
      - sls: zenoss.zenrepo
  service:
    - running
    - name: snmpd
    - require:
      - pkg: net-snmp

/srv/.saltstack-actions/setup-snmp:
  file:
    - managed
    - contents: "SALTSTACK LOCK FILE\nRemoving this lock file will initiate the setup of the snmp user.\n"
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - pkg: net-snmp
      - service: net-snmp

stop-snmpd-service:
  cmd:
    - wait
    - name: /sbin/service snmpd stop
    - watch:
      - file: /srv/.saltstack-actions/setup-snmp
    - require:
      - pkg: net-snmp

create-snmp-user:
  cmd:
    - wait
    - name: /usr/bin/net-snmp-create-v3-user -ro -A {{pillar['zenoss']['snmp-zenoss-password'] }} -a SHA -x AES zenoss-svc
    - watch:
      - cmd: stop-snmpd-service
    - template: jinja
  
restart-snmp-service:
  cmd:
    - wait
    - name: /sbin/service snmpd start
    - watch:
      - cmd: create-snmp-user

