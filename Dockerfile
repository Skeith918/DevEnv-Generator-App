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
ADD init.sh /opt/init.sh
ADD install-packages.sh /opt/install-packages.sh
ADD infocontainer.txt /opt/infocontainer.txt
ADD packages.txt /opt/packages.txt
RUN chmod a+x /opt/install-packages.sh
RUN chmod a+x /opt/init.sh
RUN ./opt/install-packages.sh

# Set SSH Service and connection
RUN mkdir /var/run/sshd
RUN echo 'root:test' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN service ssh start
EXPOSE 22

#Configure
EXPOSE 80
EXPOSE 3000
EXPOSE 27017
EXPOSE 443
EXPOSE 25
EXPOSE 587

# Launch service
CMD ["./opt/init.sh"]
