#!/bin/bash

input_dir="$1"
output_dir="$2"
max_depth=-1
shift 2

while [ $# -gt 0 ]; do
    if [ "$1" = "--max_depth" ]; then
        if ! [[ "$2" =~ ^[0-9]+$ ]]; then
            exit 1
        fi
        max_depth="\$2"
        shift 2
    else
        exit 1
    fi
done

mkdir -p "$output_dir"

declare -A file_counters

find_args=(-type f)
if [ $max_depth -ge 0 ]; then
    find_args+=(-maxdepth "$max_depth")
fi

find "$input_dir" "${find_args[@]}" | while IFS= read -r file; do
    relative_path="${file#$input_dir/}"
    destination="$output_dir/$relative_path"

    if [ -e "$destination" ]; then
        filename=$(basename "$destination")
        dir=$(dirname "$destination")
        base_name="${filename%.*}"
        extension="${filename##*.}"

        if [ "$base_name" = "$extension" ]; then
            base_name="${filename}"
            extension=""
        fi

        if [ -z ${file_counters["$filename"]} ]; then
            file_counters["$filename"]=1
        else
            file_counters["$filename"]=$((file_counters["$filename"] + 1))
        fi

        suffix=${file_counters["$filename"]}
        if [ -n "$extension" ]; then
            destination="$dir/${base_name}_$suffix.$extension"
        else
            destination="$dir/${base_name}_$suffix"
        fi
    fi

    mkdir -p "$(dirname "$destination")"
    cp "$file" "$destination"
done
