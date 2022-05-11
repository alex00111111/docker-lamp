alex00111111/docker-lamp
==========

This Project is forked and inspired from [fauria/lamp](https://github.com/fauria/docker-lamp/).

Main Goal is to build a LAMP-stack for simple semi-dynamic Websites as a monolithic Container. 

The Container is static, Database/Filesystem changes on Runtime will be lost on restart.


Just replace the setup.sql with your datafile and set the link to your WebProject-git (Dockerfile: ENV GITREPO). Customize DB Credentials and Database settings at Dockerfile ENVs ( DATABASE, DATABASE_USER, DATABASE_PW ).



Includes the following components:

 * Debian slim latest
 * Apache HTTP Server 2.4
 * MariaDB 10.x
 * PHP 7.4
 * git


Usage
----


```bash
# build
docker build -t docker-lamp . --no-cache=true

# run
docker run -d -p 8080:80 docker-lamp 

# phpinfo
curl "http://$(docker-machine ip):8080/info.php"

# example Sql-Connection
curl "http://$(docker-machine ip):8080/dbexample.php"

# example PHP-Project
curl "http://$(docker-machine ip):8080/"
```


This image uses environment variables to allow the configuration of some parameteres at run time:

* Variable name: LOG_STDOUT
* Default value: Empty string.
* Accepted values: Any string to enable, empty string or not defined to disable.
* Description: Output Apache access log through STDOUT, so that it can be accessed through the [container logs](https://docs.docker.com/reference/commandline/logs/).

----

* Variable name: LOG_STDERR
* Default value: Empty string.
* Accepted values: Any string to enable, empty string or not defined to disable.
* Description: Output Apache error log through STDERR, so that it can be accessed through the [container logs](https://docs.docker.com/reference/commandline/logs/).

----

* Variable name: LOG_LEVEL
* Default value: warn
* Accepted values: debug, info, notice, warn, error, crit, alert, emerg
* Description: Value for Apache's [LogLevel directive](http://httpd.apache.org/docs/2.4/en/mod/core.html#loglevel).

----

* Variable name: ALLOW_OVERRIDE
* Default value: All
* All, None
* Accepted values: Value for Apache's [AllowOverride directive](http://httpd.apache.org/docs/2.4/en/mod/core.html#allowoverride).
* Description: Used to enable (`All`) or disable (`None`) the usage of an `.htaccess` file.

----

* Variable name: DATE_TIMEZONE
* Default value: UTC
* Accepted values: Any of PHP's [supported timezones](http://php.net/manual/en/timezones.php)
* Description: Set php.ini default date.timezone directive and sets MariaDB as well.

----

* Variable name: TERM
* Default value: dumb
* Accepted values: dumb
* Description: Allow usage of terminal programs inside the container, such as `mysql` or `nano`.

----

* Variable name: DATABASE
* Default value: testdb
* Accepted values: any string which is a valid MariaDB Database name
* Description: set the Database which will be created and where the data from the setup.sql are imported.

----

* Variable name: DATABASE_CHARSET
* Default value: utf8
* Accepted values: any supported character set [supported character sets](https://mariadb.com/kb/en/supported-character-sets-and-collations/)
* Description: set the default character set for the given Database.

----

* Variable name: DATABASE_USER
* Default value: reader
* Accepted values: any string which is a valid MariaDB Username
* Description: set the Username which your PHP files are use for retriving data from MariaDB.

----

* Variable name: DATABASE_PW
* Default value: testtest
* Accepted values: any string which is a valid MariaDB password
* Description: set the password which your PHP files use for retriving data from MariaDB

----

* Variable name: GITREPO
* Default value: https://github.com/banago/simple-php-website
* Accepted values: any reachable GIT-Repository via HTTP
* Description: Link to GIT-Repository which will be deployed at /var/www/html/


Exposed port
----

The image exposes ports `80`:

The user and group owner id for the DocumentRoot directory `/var/www/html` are both 33 (`uid=33(www-data) gid=33(www-data) groups=33(www-data)`).

The user and group owner id for the MariaDB directory `/var/log/mysql` are 105 and 108 repectively (`uid=105(mysql) gid=108(mysql) groups=108(mysql)`).

Use cases
----


#### Create a temporary container to debug a web app:

```
	docker run --rm -p 8080:80 -e LOG_STDOUT=true -e LOG_STDERR=true -e LOG_LEVEL=debug docker-lamp
```

#### Get inside a running container and open a MariaDB console:

```
	docker exec -i -t docker-lamp bash
	mysql -u root
```
