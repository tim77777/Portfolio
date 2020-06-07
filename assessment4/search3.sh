#!/bin/bash
#awk 'BEGINFILE{f=0;g=0} /phishing/{f=1} /threats/{g=1} f && g{print FILENAME; nextfile}' /home/user1/mix/text/threats/*
#function takes in weblinks from a file and displays them nicely
function getWebLinks()
{
    awk -v var="$searchString" 'BEGIN{ 
     FS=":[a-zA-z0-9+]"; 
     print "_______________________________________________________________________________________________________________________________________________________________________________";
     printf("| \033[36m%-6s\033[0m \033[36m%-6s\033[0m  \033[31m%-6s\033[0m\n", "Web addresses", "for search phrase", var);
     print "_______________________________________________________________________________________________________________________________________________________________________________";
} 
 
{     
     printf("| \033[33m%-172s\033[0m  | \n", $1);
 }
 END {
     print("______________________________________________________________________________________________________________________________________________________________________________");
 }' links2
}

while true
do
    #Read in the search string from the keyboard 
    read -p "Enter string to search or 'q' to quit: " searchString
    #if 'q' is entered, exit the program
    if [ "$searchString" == "q" ]; then break; fi 
    #search all documents in 'mix/text' for the search string. In color for display. -r recursive -i ignore case -a treat binary files as text. nl add line numbers
    grep --color=always -ria "$searchString" mix/text  | nl 
    #Repeat search but direct it into a file and don't use color else the file will contain color formatting code
    grep --color=never -ria "$searchString" mix/text  | nl > searchData
    #count the number of lines and place in variable 'count' for use later to prevent opening files that do not exist
    lineCount=$(cat searchData | wc -l)
   
    #Replace file location data with weblink data and cut the line numbers out
    cat searchData | sed "s/mix\/text\//http:\/\/www.cyber.gov.au\//" | cut --complement -c1-6 > links
    
    #remove leading whites spaces including tabs
    sed -i 's/^[ \t]*//' links
    #remove all characters after the weblink
    sed -i 's/:[a-zA-Z" *"].*//' links 
    #remove duplicate weblinks
    sort links | uniq > links2
    
     #Read in from the keyboard the line number of the document to be read
     read -p "enter line number to read document or 'q' to quit and print weblinks: " lineNumber
     #If 'q' is pressed rather than a number then display the weblinks and exit the program
     if [ "$lineNumber" == "q" ]; then getWebLinks; break; fi
     #remove all content from  
     sed -i "${lineNumber}q;d" searchData #> test4
     cut -d: -f1 searchData > searchData2
     cut --complement -c1-6 searchData2 > searchData3
     if [ "$lineNumber" -lt "$lineCount" -o "$lineNumber" == "$lineCount"  ]; then nano $(cat searchData3); else echo "Number too high. Document does not exist"; fi
     #Show weblinks realted to the search phrase
     getWebLinks

    done

