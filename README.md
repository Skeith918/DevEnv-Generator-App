# DevEnv-Generator-App
## About DevEnv-Generator-App
This is the back side of the DevEnv-Generator Application, he's create and deploy the Docker container requested in [DevEnv-Generator-Website](https://github.com/Skeith918/DevEnv-Generator-Website).

## Application working steps:
- Extract request information from mongo database sent by [DevEnv-Generator-Website](https://github.com/Skeith918/DevEnv-Generator-Website).
- Inject information in Dockerfile
- Create requested container image
- Run an container with the created image
- Insert container information (name, owner, IP) in the mongo database

## Installation and deployment in production
- Install and deploy [DevEnv-Generator-Website](https://github.com/Skeith918/DevEnv-Generator-Website).
- Clone this repository
```
git clone https://github.com/Skeith918/DevEnv-Generator-App
```
- Install mongoDB
```
echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.2 main" >> /etc/apt/sources.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
apt update
apt install -y mongodb-org
```
- Install [Docker](https://docs.docker.com/engine/installation/linux/debian/)
- Give execution right to install.sh
```
chmod a+x ./DevEnv-Generator-App/install.sh
```
- All is done !
