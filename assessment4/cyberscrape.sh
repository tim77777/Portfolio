#!/bin/bash
#script scrapes HTML data from www.cyber.gov.au, converts it to text and stores it

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

#Comments are the same as above, but the ISM web page has different HTML and so 'grep "hreflang"' is not relevant and has been replaced with grep "href=\"\/ism\/"
curl https://www.cyber.gov.au/ism | grep "href=\"\/ism\/" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\">.*//" > urls.txt 
while read -r urls  
do
    publicationNames=$(basename "$urls")
    wget -N --no-hsts -P ./mix/html/ism/ "$urls" 
    mkdir -p `echo ./mix/text/ism`
    html2text -utf8  ./mix/html/ism/$publicationNames | sed -n '/1. /,$p' | sed -n '/Need help/q;p' > ./mix/text/ism/$publicationNames
done < urls.txt


