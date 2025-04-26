#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <input_directory> <output_directory> [--max_depth <depth>]"
    exit 1
fi

input_dir="$1"
output_dir="$2"
max_depth=""
handle_duplicates=true

shift 2
while [ "$#" -gt 0 ]; do
    case "$1" in
        --max_depth)
            if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
                echo "Error: --max_depth requires a positive integer"
                exit 1
            fi
            max_depth="$2"
            shift 2
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
done

if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory does not exist"
    exit 1
fi

mkdir -p "$output_dir"

copy_file() {
    local src="$1"
    local dest_dir="$2"
    local filename=$(basename "$src")
    local dest_path="$dest_dir/$filename"
    local counter=1
    
    if [ "$handle_duplicates" = true ] && [ -e "$dest_path" ]; then
        local name="${filename%.*}"
        local extension="${filename##*.}"
        
        if [ "$name" != "$extension" ]; then
            while [ -e "$dest_dir/${name}${counter}.${extension}" ]; do
                ((counter++))
            done
            dest_path="$dest_dir/${name}${counter}.${extension}"
        else
            while [ -e "$dest_dir/${name}${counter}" ]; do
                ((counter++))
            done
            dest_path="$dest_dir/${name}${counter}"
        fi
    fi
    
    cp "$src" "$dest_path"
}

process_directory() {
    local current_dir="$1"
    local current_depth="$2"
    
    if [ -n "$max_depth" ] && [ "$current_depth" -gt "$max_depth" ]; then
        return
    fi
    
    for item in "$current_dir"/*; do
        if [ -f "$item" ]; then
            copy_file "$item" "$output_dir"
        elif [ -d "$item" ]; then
            process_directory "$item" $((current_depth + 1))
        fi
    done
}

process_directory "$input_dir" 1

echo "Files collected successfully to $output_dir"
