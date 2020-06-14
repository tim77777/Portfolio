#!/bin/bash
#set text color to green
tput setaf 2

#ask for password
./passwordCheck.sh
#if the exit status from passwordCheck is 0, provide access to the menu
if [ $? == 0 ]
then 
while :
    do  #Menu structure with colors      
        echo -e "\e[34m1. create a folder\e[0m" 
        echo -e "\e[34m2. copy a folder\e[0m" 
        echo -e "\e[34m3. set a password\e[0m" 
        echo -e "\e[34m4. Calculator\e[0m" 
        echo -e "\e[34m5. Create week folders\e[0m" 
        echo -e "\e[34m6. Check filenames\e[0m" 
        echo -e "\e[34m7. Download a file\e[0m" 
        echo -e "\e[31m8. Exit menu\e[0m"
        read -p 'Enter your choice ' choice
    
        #compare the menu choice with a range of matching possibilities and run the scripts in the selected choice
        case $choice in
            1)
            ..week2/foldermaker.sh
            ;;
            2)
            ./week2/folderCopier.sh
            ;;
            3)
            .week2/setPassword.sh
            ;;
            4)
            ./calc.sh
            ;;
            5)
            ./megafoldermaker.sh
            ;;
            6)
            ./filenames.sh
            ;;
            7)
            ./downloader.sh
            ;;
            8)
            break # exit menu
            ;;
            *)
            echo
            echo "invalid selection"
            ;;
        esac
    done

else 

echo "bye"
fi