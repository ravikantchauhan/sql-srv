#!/bin/bash
# Detect OS
#Copyright (c) 2022 Ravikant.
os_version=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2)
echo This is Ubuntu $os_version
##For Check php version
PHP_V=$(php -v | grep cli  | awk '{print $2}' | cut  -b 1,2,3)
echo php$PHP_V already install
###
if [[ $PHP_V < 5 ]]; then
        echo "PHP not found, please install required version"
    # echo "Do you want to install php"

read -r -p "Do you want to install php? [Y/n] " input
case $input in
      [yY][eE][sS]|[yY])
            echo "You say Yes"
            echo "Please Enter php-verions? "
            read PHP_V
            ####
            sudo add-apt-repository -y ppa:ondrej/php
            #sudo apt-get update
            echo "Installing php$PHP_V"
            sudo apt install -y php$PHP_V
            sudo apt-get install -y $PHP_V-{bcmath,bz2,intl,gd,mbstring,mysql,zip,common,dom}
            sudo service apache2 restart
            echo php$(php -v | grep cli  | awk '{print $2}' | cut  -b 1,2,3) installed successfully
            ####
            ;;
      [nN][oO]|[nN])
            echo "You say No"
            exit
            ;;
      *)
            echo "Invalid input..."
            exit 1
            ;;
esac
       
fi
######
echo "pass to next line done"

sudo apt install software-properties-common
add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get install php$PHP_V php$PHP_V-dev php$PHP_V-xml -y --allow-unauthenticated
##########################
#Install the Microsoft ODBC driver for SQL
#Microsoft ODBC 17

########
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/$os_version/prod.list > /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install msodbcsql17
sudo apt-get install unixodbc-dev
###########
sudo apt-get -y install php-pear php$PHP_V-dev
sudo update-alternatives --set php /usr/bin/php$PHP_V
sudo update-alternatives --set phar /usr/bin/phar$PHP_V
sudo update-alternatives --set phar.phar /usr/bin/phar.phar$PHP_V
sudo update-alternatives --set phpize /usr/bin/phpize$PHP_V
sudo update-alternatives --set php-config /usr/bin/php-config$PHP_V
##########
######sqlsrv
sudo pecl uninstall -r sqlsrv
sudo pecl uninstall -r pdo_sqlsrv
sudo pecl -d php_suffix=$PHP_V install sqlsrv
sudo pecl -d php_suffix=$PHP_V install pdo_sqlsrv
#####
printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/$PHP_V/mods-available/sqlsrv.ini
printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/$PHP_V/mods-available/pdo_sqlsrv.ini
sudo phpenmod -v $PHP_V sqlsrv pdo_sqlsrv
sudo service apache2 restart
echo "Done Pleash check"
#########