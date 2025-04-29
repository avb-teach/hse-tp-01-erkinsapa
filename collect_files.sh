#!/bin/bash

input_dir="$1"
output_dir="$2"
max_depth=-1
shift 2

while [ $# -gt 0 ]; do
    if [ "$1" = "--max_depth" ]; then
        max_depth="\$2"
        shift 2
    else
        exit 1
    fi
done

mkdir -p "$output_dir"

declare -A filec

find "$input_dir" ${max_depth:+-maxdepth "$max_depth"} | while IFS= read -r entry; do
    if [[ -d "$entry" ]]; then
        rel="${entry#$input_dir/}"
        mkdir -p "$output_dir/$rel"
    elif [[ -f "$entry" ]]; then
        rel="${entry#$input_dir/}"
        dest="$output_dir/$rel"
        filename=$(basename "$dest")
        dir==$(dirname "$dest")
        mkdir -p "$dir"

        if [[ -e "$dest" ]]; then
            base="${filename%.*}"
            ext="${filename##*.}"

            if [[ "$base" == "$ext" ]]; then
                base="$filename"
                ext=""
            fi

            filec["$filename"]=$((fileс["$filename"] + 1))
            suffix=${filec["$filename"]}

            if [[ -n "$ext" ]]; then
                dest="$dir_path/${base}_$suffix.$ext"
            else
                dest="$dir_path/${base}_$suffix"
            fi
        fi

        cp "$entry" "$dest"
    fi
done

