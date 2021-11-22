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
	new_pwd=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c15; echo)

	echo "Tu contraseña es: " $new_pwd
	echo $usuario:$new_pwd | chpasswd

	echo "Instalando mailutils:"
	sudo apt-get install mailutils
	echo -n "Escriba la dirección de correo" correo
	mail -s "Su nueva contraseña es: $new_pwd" $correo
	echo "Realizado con exito"


./menu.sh
