FROM ubuntu:bionic
LABEL Description="Dockerized pwnable" Maintainer="mk@elakkod.se" Version="1.0"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --fix-missing && apt-get -qy upgrade
COPY ./data/apt.deps /tmp/apt.deps
RUN apt-get install -qy $(cat /tmp/apt.deps) && rm /tmp/apt.deps

RUN groupadd -r ctf && useradd -r -g ctf ctf
COPY ./data/ctf.xinetd /etc/xinetd.d/ctf
COPY ./data/run /home/ctf/run
COPY ./data/ctf /home/ctf/

RUN chmod 440 /home/ctf/*
RUN chown -R root:ctf /home/ctf
RUN chmod 750 /home/ctf/run
RUN chmod 750 /home/ctf/chall

RUN service xinetd restart
CMD ["/usr/sbin/xinetd", "-dontfork"]
