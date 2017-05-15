#!/bin/bash

#req="db.devenv_container.find({owner:\"$1\",name:\"$2\"})"
#container=$(echo $req | mongo localhost:27017/DevEnvGen --quiet)

#containerName=$( echo $container | cut -d ',' -f2 | cut -d '"' -f4)
#owner=$( echo $container | cut -d ',' -f3 | cut -d '"' -f4)
#packages=$( echo $container | cut -d ',' -f4 | cut -d '"' -f4)

#echo $container
#echo $containerName
#echo $owner
#echo $packages

#port=$(/usr/bin/docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}}>{{(index $conf 0).HostPort}}|{{end}}' $containerName)
#echo $port

remove="db.devenv_request.remove({owner:\"$1\"})"
echo $remove
echo $remove-request | mongo localhost:27017/DevEnvGen --quiet
