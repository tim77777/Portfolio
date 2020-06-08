<<<<<<< HEAD
#!/bin/bash 
#The script takes a hardcoded selection of html data from www.cyber.gov.au, converts it to text for later searching and stores both the downloaded html and 
#converted text files. An option is provided to search the converted text files for string matches such as “DDoS” and “threat actor”. When a match is 
#found the hosting file name is displayed along with the line/s of text containing the string and a reference line number. The amount of matching lines gives 
#an indication of the value of that document in learning about the search phrase. Entering the reference line number opens the hosting file in a text editor for reading. 
#Further script action shows the URL associated with the document along with a number showing the frequency of hits for the search phrase for that URL.  This also therefore 
#gives an indication of the value of the URL in learning about the search phrase. The URL provides a better display for reading the information than a text editor, 
#including viewing of images if provided. #The script relies on the installation of html2text, curl, wget and nano. 

#function 'getWebLInks' takes in URLs from a file and displays them, formatted with space, borders and colors
#$searchString holds the phrase being searched for and LInks2 contains the URLs to which matches were found 
=======
#!/bin/bash
#One part of script scrapes a selection of HTML data from www.cyber.gov.au, converts it to text and stores it
#Second part of script requires prior downloading of webpages, and prior html to text translation of those pages as done by part one
#Second part of the script searches for matches between an entered word and prior downloaded files, displays those filenames and the URLS those filenames can be found on.
#Displays how frequently matches were found in each file. There is an option to open the files that contain the search matches using nano text editor
#The script output is provided as a method of learning about cyber security terms, procedures and the like, as prepartion for a job interview, or curiosity

#function takes in URLs from a file and displays them, formatted with space, borders and colors
#$searchString holds the phrase being searched for within the script
>>>>>>> 55efbe0... backup 080620
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
#The file links2, above, holds names of URLS that the search prhase is found in, as well as the frequency of the search phrase match for each URL

while true
do
    #clear the screen and show the main menu
    clear
    echo -e "\e[33mMAIN MENU\e[0m" 
    echo -e "\e[32m1. Search data\e[0m" 
    echo -e "\e[32m2. Scrape cyber.gov.au\e[0m" 
    echo -e "\e[31mPress Enter to exit menu\e[0m"
    read -p "Choose 1, 2 or Enter : " choice 
    
    #check if directory mix exists as a way of determining if data is available for searching as directory 'mix' is created during website scraping
    DIR="mix"
    if [ ! -d "$DIR" -a "$choice" == 1 ]; then
        # Take action if $DIR does not exist
<<<<<<< HEAD
        echo "Directory to search does not exist. Press Enter to access main menu and scrape site before searching data"
        #pause to press enter and return to main menu
=======
        echo "Directory to search does not exist. Press Enter to access main menu and scrape site"
        #press enter and return to main menu
>>>>>>> 55efbe0... backup 080620
        read
        continue
    fi
    #exit from main menu if enter is pressed
    if [ "$choice" == "" ]; then break; 
#Search scraped data   
    elif [ "$choice" == 1 ]; then 
        while true
            do
            #Read in the search string from the keyboard 
<<<<<<< HEAD
            read -p "Press enter to quit, or input search phrase and press Enter  e.g ddos attack e.g ddos : " searchString
=======
            read -p "Press enter to quit, or input search phrase and press Enter : " searchString
>>>>>>> 55efbe0... backup 080620
            #if 'enter' is pressed, exit the program
            if [ "$searchString" == "" ]; then break; fi 
            #search all documents in 'mix/text' for the search string. In color for display. -r recursive -i ignore case -a treat binary files as text. nl add line numbers
            grep --color=always -ria "$searchString" mix/text  | nl 
            #Repeat search but direct it into a file and don't use color else the file will contain color formatting code
            grep --color=never -ria "$searchString" mix/text  | nl > searchData
            #count the number of lines that the search phrase was found in, and place in variable 'count' for use later to prevent opening files that do not exist if the number of lines equals zero
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
            #otherwise open a file in which the search phrase was found by entering its linenumber 
            if [ "$lineCount" == 0 ]; then echo -e "\e[31mNo results found\e[0m"; continue; fi
<<<<<<< HEAD
            
            #set lineNumber to a numeral so that while loop is entered
            lineNumber=1
            #repeat unless 'enter' or something other than a numeral is pressed
            while [ -n "$lineNumber" ] && [ "$lineNumber" -eq "$lineNumber" ] 2>/dev/null
            do 
                #Read in from the keyboard the line number of the document to be read
                    echo 
                    read -p "enter line number to read document or any other key to display weblinks and continue search: " lineNumber
                #if the variable is a numeral allow checing of its numeric value, otherwise display weblinks and return to start of script
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
                            grep --color=never -ria "$searchString" mix/text  | nl > searchData
                        elif [ "$lineNumber" -gt "$lineCount" ]; then  echo "Number too high. Document does not exist"; 
                        fi
              
                fi
            done
=======
            #Read in from the keyboard the line number of the document to be read
                echo 
                read -p "enter line number to read document or any other key to display weblinks and continue search: " lineNumber
            #if the variable is a numeral allow checing of its numeric value, otherwise display weblinks and return to start of script
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
>>>>>>> 55efbe0... backup 080620
            #Show weblinks related to the search phrase
            getWebLinks            
        done

#scrape site
    elif [ "$choice" == 2 ]; then 
    #Scrapes a selection of HTML data from www.cyber.gov.au, converts it to text and saves it for later use

        # Download HTML files from various www.cyber.gov.au pages, covert to text and store them
        for x in news advice programs threats publications #ism reportcyber covid-19
        do
            #Get all the links listed on the pages stated in the for loop ($x). Find the line on each page with the string "href=" and replace it 
            #with www.cyber.gov.au, and delete  everything after " href. This leaves only the URL which is directed into urls.txt
            curl https://www.cyber.gov.au/$x | grep "hreflang" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\" href.*//" > urls.txt 
            #Download HTML files, covert to text and store them
            while read -r urls  
            do  #remove the FQDN for each line in urls.txt, leaving only the name of the file
                publicationNames=$(basename "$urls")
                #Download the html file at each URL in urls.txt and put it in a directory named with its origin page (i.e. news, advice etc)
                #-N prevents overwrite if the timestamps match between download files and existing local files
                wget -N --no-hsts -P ./mix/html/$x/ "$urls" 
                #Make a directory to place 'html to text' files. A directory is named with its origin page (i.e. news, advice etc)
                mkdir -p `echo ./mix/text/$x`
                #convert downloaded html files to text files using utf8 format, remove irrelevant information from start and finish of text file and store in relative directory
                html2text -utf8  ./mix/html/$x/$publicationNames | sed -n '/1. /,$p' | sed -n '/Need help/q;p' > ./mix/text/$x/$publicationNames
            done < urls.txt
        done

        #Comments are the same as above, but the ISM web page has different HTML and so 'grep "hreflang"' as used for the previous scrapes is not relevant and has been replaced with grep "href=\"\/ism\/"
        curl https://www.cyber.gov.au/ism | grep "href=\"\/ism\/" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\">.*//" > urls.txt 
        while read -r urls  
        do
            publicationNames=$(basename "$urls")
            wget -N --no-hsts -P ./mix/html/ism/ "$urls" 
            mkdir -p `echo ./mix/text/ism`
            html2text -utf8  ./mix/html/ism/$publicationNames | sed -n '/1. /,$p' | sed -n '/Need help/q;p' > ./mix/text/ism/$publicationNames
        done < urls.txt
        #notifiy that scrape is completed and wait for key press to return to main menu
        echo -e "\e[31mScrape completed. Press enter to return to main menu\e[0m" 
        read 
    else break
    fi
done