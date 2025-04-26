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
while IFS= read -r -d '' file; do
  filename=$(basename "$file")
  file_ext="${filename##*.}"
  file_name="${filename%.*}"
  unique_name="$filename"
  while [ -e "$output_dir/$unique_name" ]; do
    file_count["$filename"]=$((file_count["$filename"] + 1))
    unique_name="${file_name}_${file_count["$filename"]}.$file_ext"
  done
  cp "$file" "$output_dir/$unique_name"
done < <(find "$input_dir" -type f -print0)
echo "Files have been successfully collected in '$output_dir'."

