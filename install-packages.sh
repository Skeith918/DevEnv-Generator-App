#!/bin/bash
while read line; do
   apt install -y $line
done </opt/packages.txt

