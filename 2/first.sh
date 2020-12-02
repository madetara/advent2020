#!/bin/bash

is_valid() {
  min=$(echo $1 | awk -F"-" '{print $1}')
  max=$(echo $1 | awk -F"-" '{print $2}')
  required_symbol="${2:0:1}"
  pass=$3

  # splitting by required symbol and  returning number of fields-1
  char_count=$(echo "$pass" | awk -F"$required_symbol" '{print NF-1}')
  if [ $char_count -ge $(($min)) ] && [ $char_count -le $(($max)) ]
  then
    return
  fi

  false
}

valid=0

while IFS= read -r line
do
  if is_valid $line; then
    ((valid++))
  fi
done < "input.txt"

echo $valid
