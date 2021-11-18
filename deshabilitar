#!/bin/bash
read -p "introduzca un usuario: " usuario
if  [ "$usuario" != "" ]
then
	echo "$usuario:DESHABILITADO" | chpasswd
	a2dissite web_$usuario.conf
	systemctl reload apache2
else
	echo "ERROR:no has introducido un usuario"
fi
./menu.sh
