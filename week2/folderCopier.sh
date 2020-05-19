#!/bin/bash
#!/bin/bash
 read -p "type the name of the folder you would like to copy: " folderName
 #if the name is a valid directory #-d true if file exists
 if [ -d "$folderName" ]; then
     #copy it to a new location
     read -p "type the name of the destination folder: " newFolderName
     #-r copy directories recursively
     cp -r "$folderName" "$newFolderName"
 else
     #otherwise, print an error
     echo "I couldn't find that folder"
 fi