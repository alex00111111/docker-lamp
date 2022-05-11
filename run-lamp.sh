#!/bin/bash

function exportBoolean {
    if [ "${!1}" = "**Boolean**" ]; then
            export ${1}=''
    else 
            export ${1}='Yes.'
    fi
}

exportBoolean LOG_STDOUT
exportBoolean LOG_STDERR

if [ $LOG_STDERR ]; then
    /bin/ln -sf /dev/stderr /var/log/apache2/error.log
else
	LOG_STDERR='No.'
fi

if [ $ALLOW_OVERRIDE == 'All' ]; then
    /bin/sed -i 's/AllowOverride\ None/AllowOverride\ All/g' /etc/apache2/apache2.conf
fi

if [ $LOG_LEVEL != 'warn' ]; then
    /bin/sed -i "s/LogLevel\ warn/LogLevel\ ${LOG_LEVEL}/g" /etc/apache2/apache2.conf
fi

#remove index.html
rm /var/www/html/index.html

# stdout server info:
if [ ! $LOG_STDOUT ]; then
cat << EOB
    
    **********************************************
    *                                            *
    *    Docker image: fauria/lamp               *
    *    https://github.com/fauria/docker-lamp   *
    *                                            *
    **********************************************

    SERVER SETTINGS
    ---------------
    · Redirect Apache access_log to STDOUT [LOG_STDOUT]: No.
    · Redirect Apache error_log to STDERR [LOG_STDERR]: $LOG_STDERR
    · Log Level [LOG_LEVEL]: $LOG_LEVEL
    · Allow override [ALLOW_OVERRIDE]: $ALLOW_OVERRIDE
    · PHP date timezone [DATE_TIMEZONE]: $DATE_TIMEZONE
    · MariaDB Database: $DATABASE
    · MariaDB Database Default Character Set: $DATABASE_CHARSET
    · MariaDB user: $DATABASE_USER
    · MariaDB pw: $DATABASE_PW
    · WebProject Git Url: $GITREPO
    

EOB
else
    /bin/ln -sf /dev/stdout /var/log/apache2/access.log
fi

# Set PHP timezone
/bin/sed -i "s/\;date\.timezone\ \=/date\.timezone\ \=\ ${DATE_TIMEZONE}/" /etc/php/7.4/apache2/php.ini

#clone your webproject and move it to /var/www/html/
mkdir /opt/tmp/
git clone ${GITREPO} /opt/tmp/
cp /opt/tmp/* /var/www/html/
rm /var/www/html/README.md
rm -r /var/www/html/.git/
rm /var/www/html/.gitignore
rm readme.md
rm -r /opt/tmp
# Run MariaDB
/usr/bin/mysqld_safe --timezone=${DATE_TIMEZONE}&

#mariadb create db and user, import data
sleep 5
mysql -uroot  -e "CREATE DATABASE ${DATABASE} /*\!40100 DEFAULT CHARACTER SET ${DATABASE_CHARSET} */;"
mysql -uroot ${DATABASE} < /opt/setup.sql
mysql -uroot -e 'CREATE USER '${DATABASE_USER}'@localhost IDENTIFIED BY "'${DATABASE_PW}'";'
mysql -uroot -e "GRANT SELECT on ${DATABASE}.* to ${DATABASE_USER}@localhost;"
mysql -uroot -e "FLUSH PRIVILEGES;"
rm /opt/setup.sql

# Run Apache:
if [ $LOG_LEVEL == 'debug' ]; then
    /usr/sbin/apachectl -DFOREGROUND -k start -e debug
else
    &>/dev/null /usr/sbin/apachectl -DFOREGROUND -k start
fi
