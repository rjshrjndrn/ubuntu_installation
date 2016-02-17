#!/bin/bash

filename=$1
while read -r line
do
 echo "scanning the $line"
 ssh-keyscan -t rsa $line >> file.host 
 trap echo $? ERR
done < "$filename"
