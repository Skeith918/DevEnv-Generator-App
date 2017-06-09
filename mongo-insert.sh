#!/bin/bash

# Method to launch script
#./mongo-inject.sh request test1 steven nginx\ postgresql\ php5\ php5-fpm
case $1 in
	tools)
		eval="db.outils.insert({name: \'$2\', tag: \'$3\', type: \'$4\', os: \'$5\'})"
		echo $eval | mongo localhost:27017/devenvgen --quiet
	;;
	request)
		eval="db.demande.insert({owner: \"$2\", name: \"$3\", os: \"$4\", tools: \"$5\"})"
		echo $eval | mongo localhost:27017/devenvgen --quiet
	;;
	container)
		eval="db.container.insert({owner: \"$2\", name: \"$3\", os: \"$4\", tools: \"$5\", ip: \"$6\", port: \"$7\"})"
		echo $eval | mongo localhost:27017/devenvgen --quiet
	;;
esac

