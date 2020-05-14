#!/bin/bash
#Get a password entered from the command line
read -sp 'Enter your password : ' passWord

echo -n $passWord | sha256sum > newhash.txt   #get the hash of the password and put it in newhash.txt
if cmp -s "secret.txt" "newhash.txt"          #compare the hash in newhash.txt with the hash in secret.txt
then                                          #and display 'access granted' if they are the same,  
    echo "Access Granted"                     #otherwise dispay 'access denied'
    exit 0
else 
    echo "Access Denied"
    exit 1
fi

