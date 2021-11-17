#!/bin/bash
read -p  "Introduce un usuario: " usuario
if [$usuario = ""]
then
	echo "ERROR: Ponga un usuario"
else
	echo "Generando contraseña"
	new_pwd=$(tr -dc 'a-zA-Z0-9.!\$' < /dev/random | head -c 8)

	echo "Tu contraseña es: " $new_pwd
	chpasswd $usuario:$new_pwd
fi
