#!/bin/bash

cmd_adb=C:/Users/leona/Android/Sdk/platform-tools/adb

for i in {584..719}
do
  cmd_install='./gradlew installDebug'
  cmd_run=$cmd_adb' shell am start -n com.example.myapplication/com.example.myapplication.MainActivity --ei i '$i
  eval $cmd_install
  eval $cmd_run
  while [ true ]
    do
        cmd_pull=$cmd_adb' pull //storage/emulated/0/Documents/MyApplication/target_res.csv ./target_res.csv'
        eval $cmd_pull
        nrows=$(cat ./target_res.csv | wc -l)
        if [ $nrows -eq $(( i+2 )) ]
        then
            break
        fi
        sleep 5
    done
done