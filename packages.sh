#!/bin/bash

cat packages-list | grep "valide" | cut -d "|" -f1 >> choosen-packages.txt
while read p; do
  	apt install -y $p
done <choosen-packages.txt
rm choosen-packages.txt
