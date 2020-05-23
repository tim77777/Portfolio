#!/bin/bash

#while IFS= read -r line
# input="filenames.txt"
#for i in $(cat filenames.txt) 
echo "Enter name of file to search and press enter e.g filenames.txt"
read name
for i in $(cat $name)
do
   # echo $i
    if test -f "$i" 
    then
        echo "$i as a file, exists"
    elif [ -d "$i" ]
    then
         echo "$i as a directory, exists"
    else echo "I don't know what this is"
    fi    
done 

# file="filenames.txt"
# while IFS= read line
# do
#         # display $line or do something with $line
# 	echo "$line"
# done <"$file"