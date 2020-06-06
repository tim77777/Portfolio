#scrape publications html page of cyber.gov.au and direct links to individual publication pages into a text file
#search the page looking for lines containing the text 'hreflang' and then filter those lines by
#replacing href=" with https://www.cyber.gov.au  and replacing everyting after " href with blank space
#this leaves the URLs for all the individual publication pages, which are then directed into publicationURLs.txt
curl https://www.cyber.gov.au/publications | grep "hreflang" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\" href.*//" > publicationURLs.txt 

#repeat until all enties in publicationURLs.txt have been read
while read -r publicationURLs #line1 
do
    #Remove some URL text leaving only the publication name which can then be used to name directories and files
    publicationNames=$(basename "$publicationURLs")
    #get the html pages using the URLs in publicationURLs.txt and place the html files in appropriately named directories
    #create directories based on prefix (-P). There is no hsts database so disable that option (--no-hosts). 
    #Do not download file if it has the same timestamp as the local file (-N) 
    wget -N --no-hsts -P ./store/html/$publicationNames "$publicationURLs" 
   
    #sha256sum ./store/html/$publicationNames/$publicationNames >> testhashes.txt
    #make directories for storing  text converted html files
    mkdir -p `echo ./store/text/$publicationNames`
    #convert html files to text (html2text), remove some offending characters (-ascii), filter to remove the meaningless top and bottom sections and store in an appropriate folder
    html2text -ascii  ./store/html/$publicationNames/$publicationNames | sed -n '/1. /,$p' | sed -n '/Need help/q;p' > ./store/text/$publicationNames/$publicationNames

    #get any PDF and docx files that are referenced on the publication pages and store in appropriate directories. -robots=off, prevents downloading of robot.txt files
    #Do not download file if it has the same timestamp as the local file (-N) 
    wget -N --no-hsts -e -robots=off -r -A.pdf -P ./store/pdfs "$publicationURLs" 
    wget -N --no-hsts -e -robots=off -r -A.docx,doc -P ./store/docs "$publicationURLs" 
    
    #Each publication page has a related information area that links to related information. The related information links begin with one of eight strings
    #search each publication page for those matching strings and add and remove text to produce a URL that is then directed into relatedDocsURLs.txt
    curl "$publicationURLs" | grep "href=\"/publications/" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\">.*//"  > relatedDocsURLs.txt
    curl "$publicationURLs" | grep "href=\"/news/" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\">.*//"  >> relatedDocsURLs.txt
    curl "$publicationURLs" | grep "href=\"/advice/" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\">.*//"  >> relatedDocsURLs.txt
    curl "$publicationURLs" | grep "href=\"/programs/" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\">.*//"  >> relatedDocsURLs.txt
    curl "$publicationURLs" | grep "href=\"/threats/" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\">.*//"  >> relatedDocsURLs.txt
    curl "$publicationURLs" | grep "href=\"/ism/" | sed "s/^.*href=\"/https\:\/\/www\.cyber.gov.au/" | sed "s/\">.*//"  >> relatedDocsURLs.txt
    curl "$publicationURLs" | grep "href=\"/reportcyber/" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\">.*//"  >> relatedDocsURLs.txt
    curl "$publicationURLs" | grep "href=\"/covid-19/" | sed "s/^.*href=\"/https\:\/\/www.cyber.gov.au/" | sed "s/\">.*//"  >> relatedDocsURLs.txt

    #repeat until all URLs in relatedDocsURLs has been read 
    while read -r relatedDocsURLs
    do
         #Remove some URL text leaving only the publication name which can then be used to reference directories and name files
         relatedDocsNames=$(basename "$relatedDocsURLs")
         #get the html pages using the URLs in relatedDocsURLS.txt and place the html files in appropriately named directories
         #create directories based on a prefix (-P). There is no hsts database so disable that option (--no-hosts)
         #Do not download file if it has the same timestamp as the local file (-N) 
         wget -N --no-hsts -P ./store/html/$publicationNames/related $relatedDocsURLs
         #convert html files to text (html2text), remove some offending characters (-ascii), filter to remove the meaningless top and bottom sections and store in an appropriate folder
         #overwrites existing file if it has the same name
         html2text -ascii  ./store/html/$publicationNames/related/$relatedDocsNames | sed -n '/1. /,$p' | sed -n '/Need help/q;p' > ./store/text/$publicationNames/$relatedDocsNames-related
     done < relatedDocsURLs.txt #contains the URLs listed on each individual publication page under the 'related informaiton' area
   
done < publicationURLs.txt #contains the URLs listed at www.cyber.gov.au/publications