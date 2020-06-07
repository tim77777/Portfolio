#!/bin/bash
rm urls.txt
curl https://www.cyber.gov.au/advice | grep "hreflang" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\" href.*//" >> urls.txt  
curl https://www.cyber.gov.au/programs | grep "hreflang" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\" href.*//" >> urls.txt 
curl https://www.cyber.gov.au/threats | grep "hreflang" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\" href.*//" >> urls.txt 
curl https://www.cyber.gov.au/publications | grep "hreflang" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\" href.*//" >> urls.txt 
curl https://www.cyber.gov.au/ism | grep "hreflang" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\" href.*//" >> urls.txt 
curl https://www.cyber.gov.au/reportcyber | grep "hreflang" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\" href.*//" >> urls.txt 
curl https://www.cyber.gov.au/covid-19 | grep "hreflang" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\" href.*//" >> urls.txt 

for x in news advice programs threats publications #ism reportcyber covid-19
do
    curl https://www.cyber.gov.au/$x | grep "hreflang" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\" href.*//" > urls.txt 
    while read -r urls #line1 
    do
        publicationNames=$(basename "$urls")
        wget -N --no-hsts -P ./mix/html/$x/ "$urls" 
        mkdir -p `echo ./mix/text/$x`
        html2text -utf8  ./mix/html/$x/$publicationNames | sed -n '/1. /,$p' | sed -n '/Need help/q;p' > ./mix/text/$x/$publicationNames
    done < urls.txt
done


    curl https://www.cyber.gov.au/ism | grep "href=\"\/ism\/" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\">.*//" > urls.txt 
    while read -r urls #line1 
    do

        publicationNames=$(basename "$urls")
        wget -N --no-hsts -P ./mix/html/ism/ "$urls" 
        mkdir -p `echo ./mix/text/ism`
        html2text -utf8  ./mix/html/ism/$publicationNames | sed -n '/1. /,$p' | sed -n '/Need help/q;p' > ./mix/text/ism/$publicationNames
    done < urls.txt





# while read -r urls #line1 
# do
#     #Remove some URL text leaving only the publication name which can then be used to name directories and files
#     publicationNames=$(basename "$urls")
#     #get the html pages using the URLs in publicationURLs.txt and place the html files in appropriately named directories
#     #create directories based on prefix (-P). There is no hsts database so disable that option (--no-hosts). 
#     #Do not download file if it has the same timestamp as the local file (-N) 
#     wget -N --no-hsts -P ./mix/html/$publicationNames "$urls" 
   
#     #sha256sum ./store/html/$publicationNames/$publicationNames >> testhashes.txt
#     #make directories for storing  text converted html files
#     mkdir -p `echo ./mix/text/$publicationNames`
#     #convert html files to text (html2text), remove some offending characters (-ascii), filter to remove the meaningless top and bottom sections and store in an appropriate folder
#     html2text -ascii  ./mix/html/$publicationNames/$publicationNames | sed -n '/1. /,$p' | sed -n '/Need help/q;p' > ./mix/text/$publicationNames/$publicationNames
# done < urls.txt