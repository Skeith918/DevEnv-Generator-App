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

# Install requested packages
ADD packages-list /opt/packages-list
ADD packages.sh /opt/packages.sh
ADD init.sh /opt/init.sh
RUN chmod a+x /opt/init.sh
RUN chmod a+x /opt/packages.sh
RUN ./opt/packages.sh

# Set SSH Service and connection
RUN mkdir /var/run/sshd
RUN echo 'root:test' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN service ssh start
EXPOSE 22

# Launch service 
CMD ["./opt/init.sh"]

