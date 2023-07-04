FROM ubuntu:latest

RUN apt-get update && apt-get install openssh-server zip sudo tzdata  -y

# Set the correct timezone so the PAM accouts don't randomly expire
ENV TZ="Europe/Ljubljana"

WORKDIR /usr/local/bin

RUN wget https://releases.hashicorp.com/vault-ssh-helper/0.2.1/vault-ssh-helper_0.2.1_linux_amd64.zip \
    -O tmp.zip && unzip tmp.zip && rm tmp.zip

COPY files/config.hcl /etc/vault-ssh-helper.d/
COPY files/sshd /etc/pam.d/
COPY files/sshd_config /etc/ssh/sshd_config

RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -ms /bin/bash ubuntu
RUN usermod -aG sudo ubuntu

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D", "-E", "/var/log/sshd.log"]

# ssh -o PubkeyAuthentication=no ubuntu@10.1.0.104
# cat /var/log/vault-ssh.log
# cat /var/log/sshd.log