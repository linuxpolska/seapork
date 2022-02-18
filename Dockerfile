FROM quay.io/operator-framework/ansible-operator:v1.1.0

RUN curl -oopenssh.tgz -L -k https://github.com/bol-van/bins/raw/master/x86_64/static/openssh.tgz && \
    tar zxvf openssh.tgz && echo "export PATH=\$PATH:/opt/ansible/system/xbin" >> .bashrc && \
    rm -f openssh.tgz && \
    cat /etc/ansible/ansible.cfg >.ansible.cfg && \
    echo "[ssh_connection]" >>.ansible.cfg && \
    echo "ssh_executable = /opt/ansible/system/xbin/ssh" >>.ansible.cfg && \
    echo "scp_executable = /opt/ansible/system/xbin/scp" >>.ansible.cfg && \
    echo "sftp_executable = /opt/ansible/system/xbin/sftp" >>.ansible.cfg

COPY requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml \
 && chmod -R ug+rwx ${HOME}/.ansible

COPY watches.yaml ${HOME}/watches.yaml
COPY roles/ ${HOME}/roles/
COPY playbooks/ ${HOME}/playbooks/
