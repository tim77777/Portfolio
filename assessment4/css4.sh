#!/bin/bash 
#The script takes a hardcoded selection of html data from www.cyber.gov.au, converts it to text for later searching and stores the converted text files. 
#An option is provided to search the converted text files for string matches such as “DDoS” and “threat actor”. When a match is 
#found the hosting file name is displayed along with the line/s of text containing the string and a reference line number. The amount of matching lines gives 
#an indication of the value of that document in learning about the search phrase. Entering the reference line number opens the hosting file in a text editor for reading. 
#Further script execution shows the URL associated with the document along with a number showing the frequency of hits for the search phrase for that URL.  This gives 
# an indication of the value of the URL in learning about the search phrase. The URL provides a better display for reading the information than a text editor, 
#including viewing of images if provided. 
#The script relies on the installation of html2text, curl and a text editor. A text editor is entered as the first command line argument, and nano is the default if no
#argument is given. 

#function checkPrereqs() checks to see if the prerequisite programs are installed (html2text; curl and nano)
function checkPrereqs()
{
    #command returns exit status of 0 if the command exists, or 1 otherwise. redirect to null to prevent screen display    
    command -v html2text > /dev/null
        if [ $? == 1 ]; then read  -p "html2text appears to not be installed. Press 'ENTER' to exit or any other key and 'ENTER' to continue " prereqs
            #exit the script if enter is pressed otherwise continue
            if [ "$prereqs" == "" ]
            then exit 1 
            fi 
        fi
    command -v curl > /dev/null   
    if [ $? == 1 ]; then read  -p "Curl appears to not be installed. Press 'ENTER' to exit or any other key and 'ENTER' to continue " prereqs
            if [ "$prereqs" == "" ]
            then exit 1 
            fi 
        fi
    command -v nano > /dev/null
    if [ $? == 1 ]; then read  -p "Nano appears to not be installed. Press 'ENTER' to exit or any other key and 'ENTER' to continue " prereqs
            if [ "$prereqs" == "" ]
            then exit 1 
            fi 
        fi    
}

#function 'getWebLinks' takes in URLs from a file and displays them, formatted with space, borders and colors
#$searchString holds the phrase being searched for and 'links' contains the URLs to which matches were found 
function getWebLinks()
{   
    awk -v var="$searchString" 'BEGIN{ 
     FS=":[a-zA-z0-9]"; 
     print "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
     printf(" \033[31m%s\033[0m \033[36m%s\033[0m  \033[31m%-137s\033[0m\n", "   Hits", "Web addresses for search phrase:", var);
     print "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
} 
{     
     printf(" \033[33m%-177s\033[0m   \n", $1);
 }
 END {
     print "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
 }' links
}
#The file links, above, holds names of URLS that the search prhase is found in, as well as the frequency of the search phrase match for each URL

while true
do
    #check that prerequisite programs are installed
    checkPrereqs
    #clear the screen and show the main menu
    
    clear
    echo "Best display is achieved at > 180 COLUMNS"
    echo
    echo -e "\e[33mMAIN MENU\e[0m" 
    echo -e "\e[32m1. Search data\e[0m" 
    echo -e "\e[32m2. Scrape cyber.gov.au\e[0m" 
    echo -e "\e[31mPress Enter to exit menu\e[0m"
    echo
    read -p "Choose 1, 2 or Enter : " choice 
    
    #check if directory mix exists as a way of determining if data is available for searching as directory 'mix' is created during website scraping
    DIR="mix"
    if [ ! -d "$DIR" -a "$choice" == 1 ]; then
        # Take action if $DIR does not exist
        echo "Directory to search does not exist. Press Enter to return to  main menu and scrape site before searching data"
        #pause to press enter and return to main menu
        read
        continue
    fi
    #exit from main menu if enter is pressed
    if [ "$choice" == "" ]; then break;         
#Search scraped data   
    elif [ "$choice" == 1 ]; then 
        while true
        do
            #remove hidden swap files that can be created when the editor is not correctly exited
            for x in news advice programs threats publications ism #reportcyber covid-19
            do
                #remove hidden swap files; If no files exist, send the error message to stderr, so it does not display
                rm mix/text/$x/.*.swp > out 2>&1
            done
            
            #Read in the search string from the keyboard 
            read -p "Press ENTER to quit search, or input search phrase and press ENTER  e.g ddos attack e.g ddos : " searchString
            #if 'enter' is pressed, return to main menu
            if [ "$searchString" == "" ]; then break; fi 
            #search all documents recursively in 'mix/text' for the search string. In color for display. -r recursive -i ignore case -a treat binary files as text. nl add line numbers
            grep --color=always -ria "$searchString" mix/text  | nl  
            #Repeat search but direct it into a file and don't use color else the file will contain color formatting code
            grep --color=never -ria "$searchString" mix/text  | nl > searchData
            #count the number of lines that the search phrase was found in, and place in variable 'count' for use later to prevent opening files that do not exist 
            lineCount=$(cat searchData | wc -l)
            
            #Replace the file location string with a FQDN string, cut the line numbers out of the file and direct the file into 'links' to create URL list
            cat searchData | sed "s/mix\/text\//http:\/\/www.cyber.gov.au\//" > links 
            # #remove leading whites spaces including tabs; remove leading digits; remove all characters after the second full colon
            sed -i 's/^[ \t]*//; s/^ *[0-9]\+.//; s/:[^:]*//2g' links
            #Count duplicate URLs, remove duplicate URLs, number the remaining links with their duplicated frequency
            sort links | uniq -c | sort -nr -o links 
            #If there were no search pattern matches, return to the beginning of the search script and try again, 
            if [ "$lineCount" == 0 ]; then echo -e "\e[31mNo results found\e[0m"; continue; fi
            
            #Open a file in which the search phrase was found by entering the files corresponding line number 
            while : 
            do 
                #Read in from the keyboard the line number of the document to be read
                echo 
                read -p "Enter line number and press ENTER to read document; or press ENTER to display weblinks and search again: " lineNumber
                #if lineNumber is between 1 and the maximum lineCount, filter unneeded syntax and open the corresponding file
                if [[ $lineNumber -gt 0 && $lineNumber -lt $lineCount || $lineNumber -eq $lineCount ]]  #2>/dev/null
                then 
                        #remove all content from file except the line with the local file location that matches the line number
                        sed -i "${lineNumber}q;d" searchData 
                        #delete the first field after the colon; delete leading blank spaces including tab; delete leading digits; delete remaining leading blank spaces
                        sed -i 's/:.*//; s/^[ \t]*//; s/^ *[0-9]\+.//; s/^[ \t]*//' searchData 
                        #open file for reading using the editor specified on the command line, or the default nano editor if no command line argument is specified
                        if [ "$1" == "" ]; then nano $(cat searchData)
                            else $1 $(cat searchData)
                        fi                            
                        #search all documents recursively in 'mix/text' for the search string again. This replaces search data, ready for the next iteration of file reading
                        grep --color=never -ria "$searchString" mix/text  | nl > searchData
                fi
                #exit to main menu if ENTER is pressed
                if [[ $lineNumber == "" ]]; then break; fi
                #Message stating that a line number higher than the number of available lines has been entered. 
                if [[ $lineNumber -gt $lineCount ]]; then  echo -e "\e[31mLine number too high. Document does not exist\e[0m"; fi
            done
            #Show weblinks related to the search phrase
            getWebLinks            
        done


#scrape site
    elif [ "$choice" == 2 ]; then 
    #Scrapes a selection of HTML data from www.cyber.gov.au, converts it to text and saves it for searching

        # Download HTML files from various www.cyber.gov.au pages, covert to text and store them
        for x in news advice programs threats publications ism #reportcyber covid-19
        do
            #Get all the links listed on the pages stated in the for loop ($x). Find the line on each page with the string "href=" and replace it 
            #with www.cyber.gov.au, and delete  everything after " href. This leaves only the URL which is directed into urls.txt
            #The grep search and sed filter below was derived from Tomi Mester's code at https://data36.com/web-scraping-tutorial-episode-1-scraping-a-webpage-with-bash/ 
            if [ "$x" == "ism" ]; then
                curl https://www.cyber.gov.au/ism | grep "href=\"\/ism\/" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\">.*//" > urls.txt 
                else curl https://www.cyber.gov.au/$x | grep "hreflang" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\" href.*//" > urls.txt 
            fi
            #Download HTML files, covert to text and store them
            while read -r urls  
            do  #remove the FQDN for each line in urls.txt, leaving only the name of the file
                publicationNames=$(basename "$urls")
                #Make a directory to place 'html to text' files. A directory is named with its origin page (i.e. news, advice etc). -p creates the whole hierarchcy 
                mkdir -p `echo ./mix/text/$x`
                #convert downloaded html files to text files using utf8 format, remove irrelevant information from header and footer of text file and store in relevant directory
                curl "$urls" | html2text -utf8 | sed -n '/1. /,$p' | sed -n '/Need help/q;p' > ./mix/text/$x/$publicationNames
            done < urls.txt
        done

        #notifiy that scrape is completed and wait for key press to return to main menu
        echo -e "\e[31mScrape completed. Press enter to return to main menu\e[0m" 
        read 
    else break
    fi
done
exit 0

