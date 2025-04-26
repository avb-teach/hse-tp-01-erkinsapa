#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <input_dir> <output_dir> [--max_depth N]"
    exit 1
fi

input_dir="$1"
output_dir="$2"
max_depth=0
shift 2

while [[ $# -gt 0 ]]; do
    case "$1" in
        --max_depth)
            if [[ ! "$2" =~ ^[0-9]+$ ]]; then
                echo "Error: --max_depth requires positive number"
                exit 1
            fi
            max_depth="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ ! -d "$input_dir" ]]; then
    echo "Error: Input directory not found"
    exit 1
fi

mkdir -p "$output_dir"

find "$input_dir" -type f | while read -r file; do
    rel_path="${file#$input_dir/}"
    depth=$(( $(tr -cd '/' <<< "$rel_path" | wc -c) + 1 ))
    
    if [[ $max_depth -gt 0 && $depth -gt $max_depth ]]; then
        continue
    fi
    
    filename=$(basename "$file")
    dest="$output_dir/$filename"
    counter=1
    
    while [[ -e "$dest" ]]; do
        name="${filename%.*}"
        ext="${filename##*.}"
        
        if [[ "$name" != "$ext" ]]; then
            dest="$output_dir/${name}_$counter.$ext"
        else
            dest="$output_dir/${name}_$counter"
        fi
        
        ((counter++))
    done
    
    cp "$file" "$dest"
done

echo "Copied all files to $output_dir"

