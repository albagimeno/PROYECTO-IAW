#!/bin/bash
# PREGUNTAS

echo -n "Escriba el nombre de usuario: "
read nombre
egrep "$nombre" /etc/passwd >/dev/null


while [ $? -eq 0 ]
do    
	echo "El usuario $nombre ya existe"
    echo -n "Escriba el nombre de usuario: "
    read nombre
    egrep "$nombre" /etc/passwd >/dev/null
done
# CONTRASEÑA USUARIO
echo "Generando contraseña"
new_pwd=$(tr -dc 'a-zA-Z0-9.!\$' < /dev/random | head -c 8)
# CREAR USUARIO
adduser --gecos "$nombre" --no-create-home --home /var/www/$nombre --shell /bin/false $nombre
# CREAR DIRECTORIOS DE USUARIO
mkdir -p /var/www/$nombre/{web,blog,files}
# PERMISOS Y CHROOT
chown root:root /var/www/$nombre
chmod 770 /var/www/$nombre
chown -R $nombre:$nombre /var/www/$nombre/*
# CHROOT JAULA SFTP SSH
echo "Match User $nombre
        ChrootDirectory /var/www/$nombre/
        PasswordAuthentication yes"\n >> /etc/ssh/sshd_config
# CONFIG APACHE
touch /etc/apache2/sites-available/web_$nombre.conf
echo "<VirtualHost *:80>
    ServerName $nombre.iaw.com
    ServerAdmin root@localhost
    DocumentRoot "/var/www/$nombre/web"
    <Directory "/var/www/$nombre/web">
        Options -Indexes
        DirectoryIndex index.html
        AllowOverride None
    </Directory>
        AssignUserID $nombre $nombre
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> /etc/apache2/sites-available/web_$nombre.conf

touch /etc/apache2/sites-available/blog_$nombre.conf
echo "<VirtualHost *:80>
    ServerName blog.$nombre.iaw.com
    ServerAdmin root@localhost
    DocumentRoot "/var/www/$nombre/blog"
    <Directory "/var/www/$nombre/blog">
        Options -Indexes
        DirectoryIndex index.html
        AllowOverride None
    </Directory>
        AssignUserID $nombre $nombre
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> /etc/apache2/sites-available/blog_$nombre.conf