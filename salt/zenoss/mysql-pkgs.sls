# This state installs MySQL for Zenos

include:
  - zenoss.zenrepo

mysql-libs:
  cmd.run:
    - name: yum remove mysql-libs -y

mysql-5.5.36:
  pkg.installed:
    - names:
      - MySQL-client
      - MySQL-server
      - MySQL-shared
      - MySQL-shared-compat
    - watch:
      - cmd: mysql-libs
    - require:
      - sls: zenoss.zenrepo
  service:
    - running
    - name: mysql
    - require:
        - pkg: mysql-5.5.36 
