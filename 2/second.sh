#!/bin/bash

is_valid() {
  pos1=$(($(echo $1 | awk -F"-" '{print $1}') - 1))
  pos2=$(($(echo $1 | awk -F"-" '{print $2}') - 1))
  required_symbol="${2:0:1}"
  pass=$3

  if [[ $(echo "${pass:$pos1:1}${pass:$pos2:1}" | awk -F"$required_symbol" '{print NF-1}') -eq 1 ]]
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
