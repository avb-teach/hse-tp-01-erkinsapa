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

declare -A file_count

find "$input_dir" -type f | while read -r file; do
  filename=$(basename "$file")
  
  if [ -e "$output_dir/$filename" ]; then
    count=${file_count["$filename"]}
    count=$((count + 1))
    file_count["$filename"]=$count
    extension="${filename##*.}"
    name="${filename%.*}"
    new_filename="${name}_${count}.${extension}"
    cp "$file" "$output_dir/$new_filename"
  else
    file_count["$filename"]=0
    cp "$file" "$output_dir/$filename"
  fi
done

echo "Files have been successfully collected in $output_dir."

