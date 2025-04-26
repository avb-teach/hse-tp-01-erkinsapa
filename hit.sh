#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 /path/to/input_dir /path/to/output_dir"
  exit 1
fi

input_dir="$1"
output_dir="\$2"

if [ ! -d "$input_dir" ]; then
  echo "Error: Input directory '$input_dir' does not exist."
  exit 1
fi

mkdir -p "$output_dir"

find "$input_dir" -type f | while read -r file; do
  filename=$(basename "$file")
  
  if [ -e "$output_dir/$filename" ]; then
    extension="${filename##*.}"
    name="${filename%.*}"
    count=1
    new_filename="${name}_${count}.${extension}"
    while [ -e "$output_dir/$new_filename" ]; do
      count=$((count + 1))
      new_filename="${name}_${count}.${extension}"
    done
    cp "$file" "$output_dir/$new_filename"
  else
    cp "$file" "$output_dir/$filename"
  fi
done
