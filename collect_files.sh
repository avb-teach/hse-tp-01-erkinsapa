#!/bin/bash

set -euo pipefail

if [[ $# -lt 2 ]]; then
    echo "Ошибка: Необходимо указать входную и выходную директории" >&2
    echo "Использование: $0 <входная_директория> <выходная_директория> [--max-depth N]" >&2
    exit 1
fi

input_dir=$(realpath "$1")
output_dir=$(realpath "$2")
shift 2

max_depth=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --max-depth)
            if [[ ! "$2" =~ ^[0-9]+$ || "$2" -le 0 ]]; then
                echo "Ошибка: --max-depth требует положительное целое число" >&2
                exit 1
            fi
            max_depth="$2"
            shift 2
            ;;
        *)
            echo "Неизвестный параметр: $1" >&2
            exit 1
            ;;
    esac
done

if [[ ! -d "$input_dir" ]]; then
    echo "Ошибка: Входная директория не существует: $input_dir" >&2
    exit 1
fi

mkdir -p "$output_dir"

find "$input_dir" -type f | while read -r src_file; do
    relative_path="${src_file#$input_dir/}"
    depth=$(( $(grep -o '/' <<< "$relative_path" | wc -l) + 1 ))

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

echo "Файлы успешно скопированы в $output_dir"

