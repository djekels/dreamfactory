#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

echo ">>> Updating apt-get"

sudo apt-get -qq update > afterScriptLog.txt

echo ">>> Installing php ldap extension"

sudo apt-get install -qq -y php-ldap > afterScriptLog.txt

#echo ">>> Installing php mssql extension"

#sudo apt-get install -qq -y php5-mssql > afterScriptLog.txt

echo ">>> Installing mongodb driver"

sudo apt-get install -qq -y autoconf g++ make openssl libssl-dev libcurl4-openssl-dev > afterScriptLog.txt
sudo apt-get install -qq -y libcurl4-openssl-dev pkg-config > afterScriptLog.txt
sudo apt-get install -qq -y libsasl2-dev > afterScriptLog.txt
sudo pecl install mongodb > afterScriptLog.txt
sudo echo "extension=mongodb.so" > /etc/php/7.0/mods-available/mongodb.ini
sudo ln -s /etc/php/7.0/mods-available/mongodb.ini /etc/php/7.0/cli/conf.d/99-mongodb.ini
sudo ln -s /etc/php/7.0/mods-available/mongodb.ini /etc/php/7.0/fpm/conf.d/99-mongodb.ini

#echo ">>> Installing v8js extension"

#sudo apt-get install -qq -y libv8-dev > afterScriptLog.txt
#sudo pecl install v8js-0.1.3 > afterScriptLog.txt
#sudo echo "extension=v8js.so" > /etc/php/7.0/mods-available/v8js.ini
#sudo ln -s /etc/php/7.0/mods-available/v8js.ini /etc/php/7.0/cli/conf.d/99-v8js.ini
#sudo ln -s /etc/php/7.0/mods-available/v8js.ini /etc/php/7.0/fpm/conf.d/99-v8js.ini

echo ">>> Installing 'zip' command"

sudo apt-get install -qq -y zip > afterScriptLog.txt

echo ">>> Setting up dreamfactory .env with homestead mysql database"

cd */.
sudo php artisan cache:clear
sudo php artisan config:clear
sudo php artisan clear-compiled
cp .env .env-backup-homestead
rm .env
php artisan dreamfactory:setup --db_driver=mysql --db_host=127.0.0.1 --db_database=homestead --db_username=homestead --db_password=secret --cache_driver=file > ../afterScriptLog.txt

sudo service php5-fpm restart
sudo service nginx restart

echo ">>> Setup complete. Launch your instance."