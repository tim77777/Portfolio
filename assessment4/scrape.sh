#scrape publications site, and filter and add to leave only the URL of the sites containing PDFs
#replace href=" with https://www.cyber.gov.au     and replace everyting after " href with nothing
#curl https://www.cyber.gov.au/publications | grep "href=\"/publications/" | sed "s/^.*href=\"/https\:\/\/www\.cyber\.gov\.au/" | sed "s/\" href.*//" > urls.txt 

#get the html code from the URLs listed in urls.txt
#output has correct file name. if a '\' is added to curl, the outuput is randomly named html files
#e.g curl https://www.cyber.gov.au/publications | grep "href=\"/publications/" | sed "s/^.*href=\"/https\:\/\/www\.cyber\.gov\.au/" | sed "s/\" href.*/\//" > urls.txt 
# put the download files in ./files directory. 
#wget -P ./files -i urls.txt  #this was the original 
#reads each line from urls.txt gets the html file from the address in the file and puts it in a 
#directory of the same name
while read -r line 
do
    wget -P ./$line $line
done < test.txt

# get PDFs and docx at this site
#wget -r -A.pdf,docx https://www.cyber.gov.au/publications/domain-name-system-security  

#input=./urls.txt
#  while read -r line
#  do 

# wget --no-hsts -r -A.pdf,docx "$line"

#  done < urls.txt

