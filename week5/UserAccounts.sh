#!/bin/bash
#script structres parts of /etc/passwd into columns. Colors are used
#the /bash/ line ensures that only those accounts using the bash shell are listed
#FS is a delimiting character
#$1, $3, $4, $6, $7 denote the files within passwd that are displayed

awk 'BEGIN{ 
     FS=":"; 
     print "_______________________________________________________________________________________________";
     printf("| \033[36m%-16s\033[0m  | \033[36m%-10s\033[0m | \033[36m%-10s\033[0m | \033[36m%-24s\033[0m | \033[36m%-19s\033[0m |\n", "Username", "UserID", "GroupID", "Home", "Shell");
     print "_______________________________________________________________________________________________";
} 
 
/bash/{     
     printf("| \033[33m%-16s\033[0m  | \033[35m%-10s\033[0m | \033[35m%-10s\033[0m | \033[35m%-24s\033[0m | \033[35m%-19s\033[0m |\n", $1, $3, $4, $6, $7);
 }
 END {
     print("_______________________________________________________________________________________________");
 }' /etc/passwd
 