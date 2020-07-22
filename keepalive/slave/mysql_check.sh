#!/bin/bash

. /root/.bash_profile

count=1
while true
do
mysql -uroot -p123456 -e "show status;" > /dev/null 2>&1
i=$?
ps aux | grep mysqld | grep -v grep > /dev/null 2>&1
j=$?
if [ $i = 0 ] && [ $j = 0 ]
then
   exit 0
else
   if [ $i = 1 ] && [ $j = 0 ]
   then
       exit 0
   else
        if [ $count -gt 5 ]
        then
              break
        fi
   let count++
   continue
   fi
fi
done



curl 'https://oapi.dingtalk.com/robot/send?access_token=2c0247a604d7201cc804c67fff097405efadc5b7cb3e611437c51d5dc9e4d4bf' \
   -H 'Content-Type: application/json' \
   -d '
  {"msgtype": "text",
    "text": {
        "content": "SLAVE ALERT: <mysql_check.sh> 从节点 mysql 宕机。"
     }
  }'

pkill keepalived
