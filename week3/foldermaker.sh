#!/bin/bash
 read -p "type the name of the folder you would like to create " folderName
 mkdir portfolio/"$folderName"
 mv $0 portfolio/"$folderName"