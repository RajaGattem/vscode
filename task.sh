#!/bin/bash

######################################################
#      	Author 	: Raja Gattem                        #
#	Date	: 13-11-2024			     #
#						     #
#	This scripts outputs checks directory        #
#	if it is found , it prints directory	     # 
#	already exits ,				     #
#	If not found it will create the directory    #
#	and file called index.html		     #
#						     #
#	Version	: v1				     #
#	This is metadata information		     #
######################################################       



set +e # Error Mode
set +x # Debug mode

DIRECTORY='/home/fl_lpt-369/Desktop/Key_pairs/pem_keys' # Assigning the path into variable


if [ ! -d "$DIRECTORY" ];   # Here the condition satisify  
then 
    echo "directory does not exists. Creating directory..." # It prints
    mkdir -p "$DIRECTORY"  # Its will create a new directory

    touch "$DIRECTORY/index.html"  # It will create file inside the directory

    echo "The directory and file has created succesfully" # It will print the status 

else 
    echo "directory exists.not Creating directory..." # If the directory allready exists, it print directory already exists


fi  
