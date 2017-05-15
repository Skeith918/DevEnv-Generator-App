#!/bin/bash

num=$[($RANDOM % ($[999 - 1] + 1)) + 1]
req="db.devenv_request.find({owner:\"$1\"})"
container=$(echo $req | mongo localhost:27017/DevEnvGen --quiet)

containerName=$( echo $container | cut -d ',' -f3 | cut -d '"' -f4)
owner=$( echo $container | cut -d ',' -f4 | cut -d '"' -f4)
packages=$( echo $container | cut -d ',' -f5 | cut -d '"' -f4)

echo $containerName" | " > infocontainer.txt
echo $owner >> infocontainer.txt
echo $packages > packagescontainer.txt
imageName=$ower"-"$containerName

search=$(bash -lc "/usr/bin/docker images ls | grep $imageName ")
if  [ $search == $imageName ]
then
	imageName=$imageName$num
	bash -lc "cd /opt/DevEnv-Generator-App/ && /usr/bin/docker build -t $imageName . "
	bash -lc "/usr/bin/docker run -d -P --name $containerName $imageName"
else
	bash -lc "cd /opt/DevEnv-Generator-App/ && /usr/bin/docker build -t $imageName . "
	bash -lc "/usr/bin/docker run -d -P --name $containerName $imageName"
fi
inject="db.devenv_container.insert({name:\"$containerName\",owner:\"$owner\",package:\"$packages\"})"
echo $inject | mongo localhost:27017/DevEnvGen --quiet

