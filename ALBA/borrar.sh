#!/bin/bash
read -p "introduzca un usuario: " usuario
if  [ "$usuario" != "" ]
then
	userdel $usuario -r
	a2dissite web_$usuario.conf
	a2dissite blog_$usuario.conf
	rm /etc/apache2/sites-available/web_$usuario.conf
	rm /etc/apache2/sites-available/blog_$usuario.conf
	rm -R /var/www/$usuario
	systemctl reload apache2
	mysql -u root -p -e "drop database db_wp_$usuario"
else
	echo "ERROR:no has introducido un usuario"
fi
./menu.sh
