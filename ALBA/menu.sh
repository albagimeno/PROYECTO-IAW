#!/bin/bash
echo -e "\n"
echo -e "1. Listar usuarios. \n2. Crear usuario. \n3. Borrar usuario. \n4. Deshabilitar usuario. \n5. Modificar password. \n"

echo -n "Seleccione una opcion: "
read op
echo -e "\n"

if [ $op = 1 ]; then
    echo -e "\e[31m1. Listado de usuarios\e[0m"
    echo -e "\e[31m======================\e[0m"
    ./listar_usuarios.sh
elif [ $op = 2 ]; then
    echo -e "\e[31m2. Crear usuarios\e[0m"
    echo -e "\e[31m=================\e[0m"
    ./crear_usuarios.sh
elif [ $op = 3 ]; then
    echo -e "\e[31m3. Borrar usuario\e[0m"
    echo -e "\e[31m=================\e[0m"
    ./borrar.sh
elif [ $op = 4 ]; then
    echo -e "\e[31m4. Deshabilitar usuario\e[0m"
    echo -e "\e[31m=================\e[0m"
    ./deshabilitar.sh
elif [ $op = 5 ]; then
    echo -e "\e[31m5. Cambiar contraseña\e[0m"
    echo -e "\e[31m=================\e[0m"
    ./cambiar_pwd.sh
fi
