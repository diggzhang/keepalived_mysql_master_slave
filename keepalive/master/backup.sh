#!/bin/bash

. /root/.bash_profile

mysql -uroot -p123456 -e "GRANT ALL PRIVILEGES ON *.* TO 'replica'@'%' IDENTIFIED BY '123456';flush privileges;"
mysql -uroot -p123456 -e "set global event_scheduler=0;"
mysql -uroot -p123456 -e "set global innodb_support_xa=0;"
mysql -uroot -p123456 -e "set global sync_binlog=0;"
mysql -uroot -p123456 -e "set global innodb_flush_log_at_trx_commit=0;"
