#!/bin/bash

############# EXTRACTION mongo

##################################################################

echo $packages > packagescontainer.txt
echo $containerName" | " > infocontainer.txt
echo $owner >> infocontainer.txt
imageName="$ower-$containerName"

bash -lc "cd /opt/DevEnv-Generator-App/ && /usr/bin/docker build -t $imageName . "
bash -lc "/usr/bin/docker run -d -P --name $containerName $imageName"

############## mongo REQUEST TO PUSH INFORMATION INTO REAL DB TABLE
