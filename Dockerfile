ARG tools
ARG users

# Set base image
FROM debian:latest


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
RUN apt update 
RUN apt install -y openssh-server mc nano less 
RUN apt install -y $tools

# Install requested packages
ADD init.sh /opt/init.sh
RUN chmod a+x /opt/init.sh

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
