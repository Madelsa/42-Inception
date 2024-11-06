#!/bin/sh

# Check if MariaDB has been initialized (system tables are missing)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    chown -R mysql:mysql /var/lib/mysql  # Set correct ownership for MySQL directories

    # Initialize MariaDB data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Check if the WordPress database exists
if [ ! -d "/var/lib/mysql/wordpress" ]; then
    # SQL script to set up MariaDB, secure root, and create WordPress DB/user
    cat << EOF | /usr/bin/mysqld --user=mysql --bootstrap
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
fi
