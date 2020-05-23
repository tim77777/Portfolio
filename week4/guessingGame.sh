#!/bin/bash
 
 #This function prints a given error
 printError()
 {
     echo -e "\033[31mERROR:\033[0m $1"
 }
 
 #This function will get a value between the 2nd and 3rd arguments
 getNumber()
 {
     while [ "$REPLY" != 42 ]
     do
        read -p "$1: "
        if [ "$REPLY" == 42 ]; then echo "Correct"
        elif [ "$REPLY" -lt "42" ]; then echo "Too Low"
        else echo "Too high"
        fi
    done

}
 
 echo "this is the start of the script"
 getNumber "Type  the lucky number between 1 and 100" 


 