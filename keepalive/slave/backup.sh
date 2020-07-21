#!/bin/bash

. /root/.bash_profile

mysql -uroot -p123456 -S /var/lib/mysql/mysql.sock -e "SET GLOBAL read_only = OFF;"
mysql -uroot -p123456 -S /var/lib/mysql/mysql.sock -e "UNLOCK TABLES;"
mysql -uroot -p123456 -e "GRANT ALL PRIVILEGES ON *.* TO 'replica'@'%' IDENTIFIED BY '123456';flush privileges;"
mysql -uroot -p123456 -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456';flush privileges;"
mysql -uroot -p123456 -e "set global event_scheduler=0;"
mysql -uroot -p123456 -e "set global innodb_support_xa=0;"
mysql -uroot -p123456 -e "set global sync_binlog=0;"
mysql -uroot -p123456 -e "set global innodb_flush_log_at_trx_commit=0;"

curl 'https://oapi.dingtalk.com/robot/send?access_token=2c0247a604d7201cc804c67fff097405efadc5b7cb3e611437c51d5dc9e4d4bf' \
   -H 'Content-Type: application/json' \
   -d '
  {"msgtype": "text",
    "text": {
        "content": "SLAVE: backup.sh mysql slave节点进入backup状态。"
     }
  }'
