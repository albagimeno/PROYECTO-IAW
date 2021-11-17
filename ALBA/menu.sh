 #!/bin/bash
echo -e "1. Listar usuarios. \n2. Crear usuario \n3. Borrar usuario \n4. Modificar password \n"

echo -n "Seleccione una opcion: "
read var
echo -e "\n"

if [ $op==1 ]; then
    ./listar_usuarios.sh
fi
