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

wget https://wordpress.org/latest.tar.gz /var/www/$nombre/blog/
tar xvzf latest.tar.gz /var/www/$nombre/blog/
sudo cp -r /var/www/$nombre/blog/wordpress/* /var/www/$nombre/blog/
cp /var/www/$nombre/blog/wp-config-sample.php /var/www/$nombre/blog/wp-config.php


echo
"/** The name of the database for WordPress */
define( 'DB_NAME', 'database_name_here' );

/** MySQL database username */
define( 'DB_USER', 'username_here' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password_here' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );" >> /var/www/$nombre/blog/wp-config.php



a2ensite web_$nombre.conf
a2ensite blog_$nombre.conf
systemctl reload apache2