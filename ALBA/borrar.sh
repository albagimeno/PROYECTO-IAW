#!/bin/bash
read -p "introduzca un usuario: " usuario
if  [ "$usuario" != "" ]
then
	userdel $usuario -r
	a2dissite web_$usuario.conf
	rm /etc/apache2/sites-available/web_$usuario.conf
	systemctl reload apache2
	echo "drop database $usuario" | mariadb
else
	echo "ERROR:no has introducido un usuario"
fi
./menu.sh
