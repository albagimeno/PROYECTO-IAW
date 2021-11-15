#!/bin/bash


awk -F: '{if($3 >= 1000 && $3 < 65534) {print "("$3")> "$1}}' /etc/passwd 
