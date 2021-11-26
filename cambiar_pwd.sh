#!/bin/bash
read -p  "Introduce un usuario: " usuario

	echo "Generando contraseña"
	new_pwd=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c15; echo)

	echo "Tu contraseña es: " $new_pwd
	echo $usuario:$new_pwd | chpasswd

./menu.sh