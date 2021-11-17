 #!/bin/bash
echo -e "1. Listar usuarios. \n2. Crear usuario \n3. Borrar usuario \n4. Modificar password \n"

echo -n "Seleccione una opcion: "
read op
echo -e "\n"

if [ $op==1 ]; then
    
    echo -e "\e[31m1. Listado de usuarios\e[0m"
    echo -e "\e[31m======================\e[0m"
    ./listar_usuarios.sh
elif [ $op==2]; then
    
fi
