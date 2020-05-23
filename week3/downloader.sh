#!/bin/bash

# URL=0
# while [ "$URL" != "exit" ]
# do
#     read -p "type a website URL to download or type \"exit\" to quit " URL
#     if [ "$URL" != "exit" ]; then wget $URL; fi 
# done


until [ "$URL" = "exit" ]
do
    read -p "type a website URL to download or type \"exit\" to quit " URL
    if [ "$URL" != "exit" ]; then wget $URL; fi 
done

