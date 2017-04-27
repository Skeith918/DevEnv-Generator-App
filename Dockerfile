# Set base image
FROM debian:jessie

# Set packages repository
RUN echo "deb http://ftp.fr.debian.org/debian/ jessie main" > /etc/apt/sources.list
RUN echo "deb-src http://ftp.fr.debian.org/debian/ jessie main" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list
RUN echo "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list
RUN echo "deb http://ftp.fr.debian.org/debian/ jessie-updates main" >> /etc/apt/sources.list
RUN echo "deb-src http://ftp.fr.debian.org/debian/ jessie-updates main" >> /etc/apt/sources.list
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
RUN echo "deb-src http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list

# Install minimal packages
RUN apt-get update
RUN apt-get install -y openssh-server mc nano less


# Set SSH Service and connection
RUN mkdir /var/run/sshd
RUN echo 'root:test' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN service ssh start
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

