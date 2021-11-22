#!/bin/bash
read -p  "Introduce un usuario: " usuario

while [ $? -eq 0 ]
do 
    	echo "ERROR: Escriba de nuevo el nombre de usuario"
    	echo -n "Escriba el nombre de usuario: "
    	read usuario
	egrep "$usuario" /etc/passwd >/dev/null
done

	echo "Generando contraseña"
	new_pwd=$(tr -dc 'a-zA-Z0-9.!\$' < /dev/random | head -c 8)

	echo "Tu contraseña es: " $new_pwd
	echo $usuario:$new_pwd | chpasswd
./menu.sh
