#This state installs JRE 

fetch-jre-bin:
    file.managed:
      - name: /tmp/jre-6u31-linux-x64-rpm.bin
      - source: salt://files/jre-6u31-linux-x64-rpm.bin
      - user: root
      - group: root
      - mode: '0755'

install-jre:
    cmd.run:
        - watch:
          - file: fetch-jre-bin
        - name: /bin/sh /tmp/jre-6u31-linux-x64-rpm.bin  
