#!/bin/bash
read -p "introduzca un usuario: " usuario
if  [ "$usuario" != "" ]
then
	echo "$usuario:DESHABILITADO" | chpasswd
fi
