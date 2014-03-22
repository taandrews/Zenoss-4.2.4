#Installing Zenoss 4.2.4

iptables:
  service:
    - dead
    - enable: false

zenoss-4.2.4:
  pkg.installed:
    - name: zenoss

socket-pyraw-nmap:
  file.managed:
    - names:
      {% for file in ['zensocket','pyraw','namp'] -%}
      - /opt/zenoss/bin/{{file}}
      {% endfor %}
    - user: root
    - group: zenoss
    - mode: '4750'

zenpack-move:
  cmd.run:
    - name: mv /opt/zenoss/var/zenpack_actions.txt zenpack_actions.txt.bak

zenoss-start:
  service:
    - running
    - enable: true
    - name: zenoss
    - require:
      - pkg: zenoss-4.2.4
