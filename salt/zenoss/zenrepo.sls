zenoss-repo-file:
  file.managed:
    - name: /etc/yum.repos/ZENOSS-4.2.4.repo
    - source: salt://files/ZENOSS-4.2.4.repo
    - user: root
    - group: root
    - mode: '0644'
