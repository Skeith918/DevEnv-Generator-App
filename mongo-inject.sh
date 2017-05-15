#!/bin/bash

# Method to launch script
#./mongo-inject.sh request test1 steven nginx\ postgresql\ php5\ php5-fpm
case $1 in
	tools)
		eval="db.tools.insert({name:\"$2\",package:\"$3\"})"
		echo $eval | mongo localhost:27017/DevEnvGen --quiet
	;;
	request)
		eval="db.devenv_request.insert({name:\"$2\",owner:\"$3\",package:\"$4\"})"
		echo $eval | mongo localhost:27017/DevEnvGen --quiet
	;;
	container)
		eval="db.devenv_container.insert({name:\"$2\",owner:\"$3\",package:\"$4\"})"
		echo $eval | mongo localhost:27017/DevEnvGen --quiet
	;;
esac

