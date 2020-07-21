#!/bin/bash

. /root/.bash_profile

Master_Log_File=$(mysql -uroot -p123456 -e "show slave status\G" | grep -w Master_Log_File | awk -F": " '{print $2}')
Relay_Master_Log_File=$(mysql -uroot -p123456 -e "show slave status\G" | grep -w Relay_Master_Log_File | awk -F": " '{print $2}')
Read_Master_Log_Pos=$(mysql -uroot -p123456 -e "show slave status\G" | grep -w Read_Master_Log_Pos | awk -F": " '{print $2}')
Exec_Master_Log_Pos=$(mysql -uroot -p123456 -e "show slave status\G" | grep -w Exec_Master_Log_Pos | awk -F": " '{print $2}')

i=1

while true
do

if [ $Master_Log_File = $Relay_Master_Log_File ] && [ $Read_Master_Log_Pos -eq $Exec_Master_Log_Pos ]
then
   echo "ok"
   break
else
   sleep 1

   if [ $i -gt 60 ]
   then
      break
   fi
   continue
   let i++
fi
done

mysql -uroot -p123456 -e "stop slave;"
mysql -uroot -p123456 -e "set global innodb_support_xa=0;"
mysql -uroot -p123456 -e "set global sync_binlog=0;"
mysql -uroot -p123456 -e "set global innodb_flush_log_at_trx_commit=0;"
mysql -uroot -p123456 -e "flush logs;GRANT ALL PRIVILEGES ON *.* TO 'replica'@'%' IDENTIFIED BY '123456';flush privileges;"
mysql -uroot -p123456 -e "show master status;" > /tmp/master_status_$(date "+%y%m%d-%H%M").txt

curl 'https://oapi.dingtalk.com/robot/send?access_token=2c0247a604d7201cc804c67fff097405efadc5b7cb3e611437c51d5dc9e4d4bf' \
   -H 'Content-Type: application/json' \
   -d '
  {"msgtype": "text",
    "text": {
        "content": "master.sh生产环境mysql主节点触发"
     }
  }'

