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

if [ $max_depth -ge 0 ]; then
    find "$input_dir" -mindepth 1 -maxdepth "$max_depth" | while IFS= read -r path; do
        rel_path="${path#$input_dir/}"
        dest="$output_dir/$rel_path"
        if [ -d "$path" ]; then
            mkdir -p "$dest"
        else
            mkdir -p "$(dirname "$dest")"
            cp "$path" "$dest"
        fi
    done
else
    find "$input_dir" -mindepth 1 | while IFS= read -r path; do
        rel_path="${path#$input_dir/}"
        dest="$output_dir/$rel_path"
        if [ -d "$path" ]; then
            mkdir -p "$dest"
        else
            mkdir -p "$(dirname "$dest")"
            cp "$path" "$dest"
        fi
    done
fi

