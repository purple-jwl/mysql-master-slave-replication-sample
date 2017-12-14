#!/bin/bash

until mysqladmin ping -h master --silent; do
    sleep 1
done

log_file=`mysql -u root -h master -e 'SHOW MASTER STATUS \G' | grep File: | awk '{print $2}'`
pos=`mysql -u root -h master -e 'SHOW MASTER STATUS \G' | grep Position: | awk '{print $2}'`

mysql -u root -e "CHANGE MASTER TO MASTER_HOST='master', MASTER_USER='repl', MASTER_PASSWORD='repl', MASTER_LOG_FILE='${log_file}', MASTER_LOG_POS=${pos}"

mysql -u root -e 'START SLAVE'
