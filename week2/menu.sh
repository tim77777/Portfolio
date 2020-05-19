#!/bin/bash
./passwordCheck.sh
if [ $? == 0 ]
then 
echo "1. create a folder"
echo "2. copy a folder"
echo "3. set a password"
read -p 'Enter your choice ' choice

case $choice in
    1)
    ./foldermaker.sh
    ;;
    2)
    ./folderCopier.sh
    ;;
    3)
    ./setPassword.sh
    ;;
    *)
    echo
    echo "invalid selection"
    ;;
esac


else 
echo "bye"
fi