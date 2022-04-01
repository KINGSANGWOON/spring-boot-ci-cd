#!/bin/bash



CURRENT_PID=$(pgrep -f lim-java-0.0.1-SNAPSHOT.jar)
if [ -z $CURRENT_PID ]
then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다." >> /webapp/deploy.log
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

sudo nohup java -jar /webapp/lim-java-0.0.1-SNAPSHOT.jar >> /webapp/deploy.log 2>/webapp/deploy_err.log &


for i in $(seq 1 6)
do
    HTTP_CODE=$(curl --write-out '%{http_code}' -o /dev/null -m 10 -q -s http://localhost:8080/)
    if [ "${HTTP_CODE}" == "200" ]; then
        echo "good"
        exit 0
    fi
    echo "return status code ${HTTP_CODE}"
    sleep 10
done
echo "fail start application"
exit 1