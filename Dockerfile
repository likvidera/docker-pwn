FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --fix-missing && apt-get -y upgrade
RUN apt-get install -y xinetd
# uncomment for 32bit support
#RUN apt-get install -y lib32z1

RUN groupadd -r ctf && useradd -r -g ctf ctf
ADD ctf.xinetd /etc/xinetd.d/ctf
ADD ./files/ /home/ctf/

RUN chmod 440 /home/ctf/*
RUN chown -R root:ctf /home/ctf
RUN chmod 750 /home/ctf/redir.sh
RUN chmod 750 /home/ctf/chall

RUN service xinetd restart
CMD ["/usr/sbin/xinetd", "-dontfork"]
