#!/bin/bash

read -p "Enter the sequence to be replaced: " string1
read -p "Enter the new sequence: " string2

for file in *"$string1"*.*; do
  if [[ -e "$file" ]]; then
    new_file="${file//$string1/$string2}"
    mv "$file" "$new_file"
  fi
done