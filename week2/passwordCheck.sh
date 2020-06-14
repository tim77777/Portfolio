#!/bin/bash
#Get a password entered from the command line. -p prompts for input; -s hides the entered string
read -sp 'Enter your password : ' passWord

echo -n $passWord | sha256sum > newhash.txt   #get the hash of the password and put it in newhash.txt
if cmp -s "secret.txt" "newhash.txt"          #compare the hash in newhash.txt with the hash in secret.txt
then                                          #and display 'access granted' if they are the same,  
    echo "Access Granted"                     #otherwise dispay 'access denied'
    #provide an exit status of 0 to signify that things have progressed as expected
    exit 0
else 
    echo "Access Denied"
    #Provide an exit status of 1 to signifiy that something untoward has occurred
    exit 1
fi

