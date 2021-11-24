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

mkdir -p /var/www/$nombre
mkdir -p /var/www/$nombre/files
# CREAR USUARIO
adduser --gecos "$nombre" --no-create-home --home /var/www/$nombre --shell /bin/false $nombre

echo "Generando contraseña"
	new_pwd=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c15; echo)

	echo "Tu contraseña es: " $new_pwd
	echo $usuario:$new_pwd | chpasswd
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
mkdir -p /var/www/$nombre/web
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
mkdir -p /var/www/$nombre/blog
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

wget https://wordpress.org/latest.zip /var/www/$nombre/blog/
unzip /var/www/$nombre/blog/latest.zip
cp -r /var/www/$nombre/blog/wordpress/* /var/www/$nombre/blog/
cp /var/www/$nombre/blog/wp-config-sample.php /var/www/$nombre/blog/wp-config.php


mysql -u root -p -e "CREATE DATABASE db_wp_$nombre;"
mysql -u root -p -e "DROP USER IF EXISTS $nombre; CREATE USER '$nombre'@'%' IDENTIFIED BY '$new_pwd';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON db_wp_$nombre.* TO '$nombre'@'%' IDENTIFIED BY '$new_pwd';"
mysql -u root -p -e "FLUSH PRIVILEGES;"

echo
"/** The name of the database for WordPress */
define( 'DB_NAME', 'db_wp_$nombre' );

/** MySQL database username */
define( 'DB_USER', '$nombre' );

/** MySQL database password */
define( 'DB_PASSWORD', '$new_pwd' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );" >> /var/www/$nombre/blog/wp-config.php

mysql -u root -p -e "CREATE DATABASE db_wp_$nombre;"
mysql -u root -p -e "DROP USER IF EXISTS $nombre; CREATE USER '$nombre'@'%' IDENTIFIED BY '$new_pwd';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON db_wp_$nombre.* TO '$nombre'@'%' IDENTIFIED BY '$new_pwd';"
mysql -u root -p -e "FLUSH PRIVILEGES;"

# HABILITAR LOS SITIOS WEB AHORA?
    read -p "Quieres activar los sitios web de $nombre (y/n)" actw
        if [ $actw = "y" ]; then
            a2ensite web_$nombre.conf
            a2ensite blog_$nombre.conf
            systemctl reload-or-restart apache2
        else
            echo "No se activaron los sitios web"
        fi
