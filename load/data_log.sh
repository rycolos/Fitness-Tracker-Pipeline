#!/bin/bash
FILE=raw_data/raw.csv

TIMESTAMP=$(date +"%Y-%m-%d %T %z")

if [ -f "$FILE" ]; then
    echo "$FILE exists. Appending record."
else 
    echo "$FILE does not exist. Creating file."
    touch $FILE
    echo "Appending record."
    echo "record__ts,weight" > $FILE
fi

echo ${TIMESTAMP},$1 >> $FILE
echo "Entry $1 uploaded at ${TIMESTAMP}"
