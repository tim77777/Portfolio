#!/bin/bash
#Get a folder name entered from the command line
read -p 'Enter folder name : ' folderName

#Get a password entered from the command line
read -sp 'Enter your password : ' passWord

#make a directory of the name originally entered on the command line
mkdir $folderName

#create file called secret.txt inside the folder, named on the command line
touch $folderName/secret.txt

#copy the password entered on the command line into the file called secret.txt
echo $passWord > $folderName/secret.txt

