#!/bin/bash


case $1 in
	tools)
		eval="db.tools.insert({name:\"$2\",package:\"$3\"})"
		echo $eval | mongo localhost:27017/DevEnvGen --quiet
	;;
	req)
		eval="db.devenv_request.insert({name:\"$2\",owner:\"$3\",package:\"$4\"})"
		echo $eval | mongo localhost:27017/DevEnvGen --quiet
	;;
	container)
		eval="db.devenv_container.insert({name:\"$2\",owner:\"$3\",package:\"$4\"})"
		echo $eval | mongo localhost:27017/DevEnvGen --quiet
	;;
esac

