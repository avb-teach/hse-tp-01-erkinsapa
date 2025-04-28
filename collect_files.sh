#!/bin/bash

set -euo pipefail

input_dir=$(realpath "$1")
output_dir=$(realpath "$2")
shift 2

max_depth=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --max-depth)
            max_depth="$2"
            shift 2
            ;;
        *)
    esac
done


mkdir -p "$output_dir"

find "$input_dir" -type f | while read -r src_file; do
    relative_path="${src_file#$input_dir/}"
    depth=$(( $(grep -o '/' <<< "$relative_path" | wc -l) + 1 ))
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
            (--max_depth)
            if [[ ! "$2" =~ ^[0-9]+$ ]]; then
                exit 1
            fi
            max_depth="$2"
            shift 2
            ;;
        
    esac
done


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
            (--max_depth)
            if [[ ! "$2" =~ ^[0-9]+$ ]]; then
                exit 1
            fi
            max_depth="$2"
            shift 2
            ;;
        
    esac
done


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


    if [[ $max_depth -gt 0 && $depth -gt $max_depth ]]; then
        continue
    fi

    base_name=$(basename "$src_file")
    dest_file="$output_dir/$base_name"
    counter=1

    while [[ -e "$dest_file" ]]; do
        name_part="${base_name%.*}"
        ext_part="${base_name##*.}"
        
        if [[ "$name_part" != "$ext_part" ]]; then
            dest_file="$output_dir/${name_part}_$counter.$ext_part"
        else
            dest_file="$output_dir/${base_name}_$counter"
        fi
        
        ((counter++))
    done

    cp "$src_file" "$dest_file"
done
