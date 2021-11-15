#!/bin/bash
read var

echo -e "1. Listar usuarios. \n2. Crear usuario \n3. Borrar usuario \n4. Modificar password \n"

echo -e "\n Seleccione una opcion:"

read var

echo $var

if [ $op == 1 ]; then
    ./listar_usuarios.sh
fi
