#!/bin/bash

. /root/.bash_profile

mysql -uroot -p123456 -e "GRANT ALL PRIVILEGES ON *.* TO 'replica'@'%' IDENTIFIED BY '123456';flush privileges;"
mysql -uroot -p123456 -e "set global innodb_support_xa=1;"
mysql -uroot -p123456 -e "set global sync_binlog=1;"
mysql -uroot -p123456 -e "set global innodb_flush_log_at_trx_commit=1;"

M_File1=$(mysql -uroot -p123456 -e "show master status\G" | awk -F': ' '/File/{print $2}')
M_Position1=$(mysql -uroot -p123456 -e "show master status\G" | awk -F': ' '/Position/{print $2}')
sleep 1
M_File2=$(mysql -uroot -p123456 -e "show master status\G" | awk -F': ' '/File/{print $2}')
M_Position2=$(mysql -uroot -p123456 -e "show master status\G" | awk -F': ' '/Position/{print $2}')

i=1

while true
do

if [ $M_File1 = $M_File1 ] && [ $M_Position1 -eq $M_Position2 ]
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
