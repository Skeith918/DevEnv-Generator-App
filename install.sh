#!/bin/bash

#tirage d'un nombre aléatoire pour être utilisé plus tard
num=$[($RANDOM % ($[99 - 10] + 1)) + 10]

#Lecture de la base de donnée pour récupérer le document mongodb correspondant à la demande de déploiement.
req="db.devenv_request.find({owner:\"$1\",name:\"$2\"})"
container=$(echo $req | mongo localhost:27017/DevEnvGen --quiet)

#Formattage du document mongodb pour affecter les éléments clés de la demande dans des variables.
containerName=$( echo $container | cut -d ',' -f2 | cut -d '"' -f4)
owner=$( echo $container | cut -d ',' -f3 | cut -d '"' -f4)
packages=$( echo $container | cut -d ',' -f4 | cut -d '"' -f4)

#Écrit le nom du container et son propriétaire dans un fichier, la liste des paquets est formaté et écrit dans un autre fichier, ces fichiers seront transférer dans l'image.
echo $containerName" | " > infocontainer.txt
echo $owner >> infocontainer.txt
echo $packages > packages.txt
sed -i 's/,/\n/g' packages.txt

#création du nom de l'image qui est la concaténation du nom du propriétaire avec le nom du container.
imageName=$owner"-"$containerName

#cherche si le nom choisi pour l'image existe déjà, si tel est le cas le nouveau nom de l'image sera le concaténation du nom actuel de l'image avec le nombre aléatoire tiré en début de script.
#L'image est ensuite construite est le container est lancé.
search=$(bash -lc "/usr/bin/docker image ls | grep $imageName | cut -d ' ' -f1")
if  [ $search == $imageName ]
then
	imageName=$imageName$num
	bash -lc "cd ~/DevEnv-Generator-App/ && /usr/bin/docker build -t $imageName . "
	containerName=$imageName"-"$owner
	bash -lc "/usr/bin/docker run -d -P --name $containerName $imageName"
else
	bash -lc "cd ~/DevEnv-Generator-App/ && /usr/bin/docker build -t $imageName . "
	containerName=$imageName"-"$owner
	bash -lc "/usr/bin/docker run -d -P --name $containerName $imageName"
fi

#récupère le mapping des ports pour savoir sur quels ports locaux sont mappés les ports du container lancé et
#ajoute les données informations du container lancé (nom, propriétaire, paquets, ports mappés) dans la base de donnée.
port=$(/usr/bin/docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}}>{{(index $conf 0).HostPort}}|{{end}}' $containerName)
inject="db.devenv_container.insert({name:\"$containerName\",owner:\"$owner\",package:\"$packages\",port:\"$port\"})"
echo $inject | mongo localhost:27017/DevEnvGen --quiet

#Supprime la demande de container
remove-request="db.devenv_request.removeOne({owner:\"$owner\"})"
echo $remove-request | mongo localhost:27017/DevEnvGen --quiet
rm infocontainer.txt packages.txt
