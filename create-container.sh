#!/bin/bash

#tirage d'un nombre aléatoire pour être utilisé plus tard
num=$[($RANDOM % ($[99 - 10] + 1)) + 10]

#Lecture de la base de donnée pour récupérer le document mongodb correspondant à la demande de déploiement.
req="db.demande.find({owner:\"$1\",name:\"$2\"})"
container=$(echo $req | mongo localhost:27017/devenvgen --quiet)

#Formattage du document mongodb pour affecter les éléments clés de la demande dans des variables.
owner=$( echo $container | cut -d '"' -f8)
containername=$( echo $container | cut -d '"' -f12)
os=$( echo $container | cut -d '"' -f16)
tools=$( echo $container | cut -d '"' -f20)


imagename=$(echo $tools | sed s/','/'-'/g)
toolslist=$(echo $tools | sed s/','/' '/g)


reqimage="db.image.find({name:\"$imagename\",os:\"$os\"})"
resimage=$(echo $req | mongo localhost:27017/devenvgen --quiet)

if test -z $resimage
then
	bash-lc "./mongo-insert image $imagename $os $tools"
	bash -lc "/usr/bin/docker build -t $imagename --build-arg tools=$toolslist . "
	bash -lc "/usr/bin/docker run -i -t -d -P --name $containerName $imagename $tools"
else
	echo $resimage
	bash -lc "/usr/bin/docker run -i -t -d -P --name $containerName $imagename $tools"
fi

