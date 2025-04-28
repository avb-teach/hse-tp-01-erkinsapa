#!/bin/bash


input_dir="$1"
output_dir="$2"
max_depth=0
shift 2

while [[ $# -gt 0 ]]; do
    case "\$1" in
        --max_depth)
            if [[ ! "$2" =~ ^[0-9]+$ ]]; then
                echo "Error: --max_depth must be a positive integer"
                exit 1
            fi
            max_depth="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: \$1"
            exit 1
            ;;
    esac
done

mkdir -p "$output_dir"
declare -A file_counters

find_args=(-type f)

if [[ $max_depth -gt 0 ]]; then
    find_args+=(-maxdepth "$max_depth")
fi

find "$input_dir" "${find_args[@]}" | while read -r file; do
    filename=$(basename "$file")
    dest="$output_dir/$filename"

    if [[ -e "$dest" ]]; then
        if [[ -z "${file_counters[$filename]}" ]]; then
            file_counters[$filename]=1
        fi
        counter=${file_counters[$filename]}
        name="${filename%.*}"
        ext="${filename##*.}"

        if [[ "$name" != "$ext" ]]; then
            dest="$output_dir/${name}_$counter.$ext"
        else
            dest="$output_dir/${name}_$counter"
        fi
        ((file_counters[$filename]++))
    fi

    cp "$file" "$dest"
done

echo "Files copied successfully to $output_dir"

