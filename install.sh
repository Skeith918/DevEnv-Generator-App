#!/bin/bash

num=$[($RANDOM % ($[99 - 10] + 1)) + 10]
req="db.devenv_request.find({owner:\"$1\",name:\"$2\"})"
container=$(echo $req | mongo localhost:27017/DevEnvGen --quiet)

containerName=$( echo $container | cut -d ',' -f2 | cut -d '"' -f4)
owner=$( echo $container | cut -d ',' -f3 | cut -d '"' -f4)
packages=$( echo $container | cut -d ',' -f4 | cut -d '"' -f4)

echo $containerName" | " > infocontainer.txt
echo $owner >> infocontainer.txt
echo $packages > packages.txt
sed -i 's/,/\n/g' packages.txt 
imageName=$owner"-"$containerName
containerName=$containerName"-"$owner

search=$(bash -lc "/usr/bin/docker image ls | grep $imageName | cut -d ' ' -f1")
if  [ $search == $imageName ]
then
	imageName=$imageName$num
	bash -lc "cd ~/DevEnv-Generator-App/ && /usr/bin/docker build -t $imageName . "
	bash -lc "/usr/bin/docker run -d -P --name $containerName $imageName"
else
	bash -lc "cd ~/DevEnv-Generator-App/ && /usr/bin/docker build -t $imageName . "
	bash -lc "/usr/bin/docker run -d -P --name $containerName $imageName"
fi
port=$(/usr/bin/docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}}>{{(index $conf 0).HostPort}}|{{end}}' $containerName)
inject="db.devenv_container.insert({name:\"$containerName\",owner:\"$owner\",package:\"$packages\",port:\"$port\"})"
echo $inject | mongo localhost:27017/DevEnvGen --quiet

remove-request="db.devenv_request.removeOne({owner:\"$owner\"})"
echo $remove-request | mongo localhost:27017/DevEnvGen --quiet
rm infocontainer.txt packages.txt
