# Gitolite
# DOCKER-VERSION 1.0.1
# VERSION 0.0.1

FROM ubuntu:14.04

MAINTAINER Ryan J. Geyer <me@ryangeyer.com>

RUN apt-get update

RUN apt-get -y install sudo
RUN apt-get -y install openssh-server
RUN apt-get -y install git

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

# To avoid annoying "perl: warning: Setting locale failed." errors,
# do not allow the client to pass custom locals, see:
# http://stackoverflow.com/a/2510548/15677
RUN sed -i 's/^AcceptEnv LANG LC_\*$//g' /etc/ssh/sshd_config

# Fix a PAM and SELinux issue with SSHD..
# http://stackoverflow.com/questions/22547939/docker-gitlab-container-ssh-git-login-error
RUN sed -i 's/^.*pam_loginuid.so$/# Nope/' /etc/pam.d/sshd

RUN mkdir /var/run/sshd

RUN adduser --system --group --shell /bin/sh git
RUN touch /home/git/DOCKER_EPHEMERAL_STORAGE
RUN mkdir -p /opt

RUN cd /opt; git clone git://github.com/sitaramc/gitolite;
RUN chown git:git -R /opt/gitolite

ADD ./init.sh /init
RUN chmod +x /init
ENTRYPOINT ["/init"]

EXPOSE 22
