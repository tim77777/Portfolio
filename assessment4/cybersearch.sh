#!/bin/bash
#Requires prior downloading of webpages, and html to text translation of those pages as done by cyberscrape.sh
#The script searchs matches between an entered word and prior downloaded files, displays those files and the URLS those files can be found on
#including how frequently matches were found in each file

#awk 'BEGINFILE{f=0;g=0} /phishing/{f=1} /threats/{g=1} f && g{print FILENAME; nextfile}' /home/user1/mix/text/threats/*
#function takes in weblinks from a file and displays them, formatted with space, borders and colors
#$searchString holds the phrase being searched for 
function getWebLinks()
{   
    awk -v var="$searchString" 'BEGIN{ 
     FS=":[a-zA-z0-9]"; 
     print "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
     printf("| \033[31m%s\033[0m \033[36m%s\033[0m  \033[31m%-137s\033[0m|\n", "   Hits", "Web addresses for search phrase:", var);
     print "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
} 
{     
     printf("| \033[33m%-177s\033[0m  | \n", $1);
 }
 END {
     print "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
 }' links2
}
#The file links2, above, holds names of URLS that the search prhase is found in

while true
do
    #Read in the search string from the keyboard 
    read -p "Press enter to quit, or input search phrase and press Enter : " searchString
    #if 'enter' is pressed, exit the program
    if [ "$searchString" == "" ]; then break; fi 
    #search all documents in 'mix/text' for the search string. In color for display. -r recursive -i ignore case -a treat binary files as text. nl add line numbers
    grep --color=always -ria "$searchString" mix/text  | nl 
    #Repeat search but direct it into a file and don't use color else the file will contain color formatting code
    grep --color=never -ria "$searchString" mix/text  | nl > searchData
    #count the number of lines that the search phrase was found in, and place in variable 'count' for use later to prevent opening files that do not exist
    lineCount=$(cat searchData | wc -l)
    #Replace the file location string with a FQDN string, cut the line numbers out of the file and direct it into 'links'
    cat searchData | sed "s/mix\/text\//http:\/\/www.cyber.gov.au\//" | cut --complement -c1-6 > links
    #remove leading whites spaces including tabs
    sed -i 's/^[ \t]*//' links
    #remove all characters after the URL
    cut -d: -f1-2 links > links2
    #Count duplicate URLs, remove duplicate URLs, number the remaining links with their duplicated frequency
    sort links2 | uniq -c | sort -nr -o links2 
    
     #If there were no search matches, return to the beginning of the script and try again, 
     #otherwise open the file in which the search phrase was found by entering its linenumber 
     if [ "$lineCount" == 0 ]; then echo -e "\e[31mNo results found\e[0m"; continue; fi
     #Read in from the keyboard the line number of the document to be read
        echo 
        read -p "enter line number to read document or any other key to display weblinks and continue search: " lineNumber
    #if the variable is a numeral allow checing of its numeral value, otherwise display weblinks and return to start of script
    if [ -n "$lineNumber" ] && [ "$lineNumber" -eq "$lineNumber" ] 2>/dev/null
        then
            #if the lineNumber is equal to or less than the lineCount, open file for viewing
            if [ "$lineNumber" -lt "$lineCount" -o "$lineNumber" == "$lineCount"  ]; then
                #remove all content from file except the line with the data to be read 
                sed -i "${lineNumber}q;d" searchData 
                #delete out the first field after the colon
                cut -d: -f1 searchData > searchData2
                #cut the blank space at front of line
                cut --complement -c1-6 searchData2 > searchData3
                #cat $(cat searchData3);
                #open file for reading
                nano $(cat searchData3); 
            elif [ "$lineNumber" -gt "$lineCount" ]; then  echo "Number too high. Document does not exist"; 
            fi
        
     fi
     #Show weblinks related to the search phrase
     getWebLinks
    
done

