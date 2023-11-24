#!/bin/bash

# Atualiza o sistema
sudo apt update
sudo apt upgrade -y

# Instalação do LAMP Stack
sudo apt install -y apache2 mariadb-server php libapache2-mod-php php-mysql

# Configuração do MySQL
sudo mysql -u root -p -e "CREATE DATABASE wordpress;"
sudo mysql -u root -p -e "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'senha';"
sudo mysql -u root -p -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';"
sudo mysql -u root -p -e "FLUSH PRIVILEGES;"

# Download e configuração do WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo rsync -avP /tmp/wordpress/ /var/www/html/
sudo chown -R www-data:www-data /var/www/html/

# Configuração do WordPress
cd /var/www/html/
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/wordpress/" wp-config.php
sudo sed -i "s/username_here/wordpressuser/" wp-config.php
sudo sed -i "s/password_here/senha/" wp-config.php

# Configuração do Apache
sudo a2enmod rewrite
sudo sh -c 'echo "<Directory /var/www/html/>" >> /etc/apache2/sites-available/000-default.conf'
sudo sh -c 'echo "    AllowOverride All" >> /etc/apache2/sites-available/000-default.conf'
sudo sh -c 'echo "</Directory>" >> /etc/apache2/sites-available/000-default.conf'
sudo systemctl restart apache2

# Mensagem de conclusão
echo "Instalação do WordPress concluída. Acesse o WordPress através do seu navegador."
