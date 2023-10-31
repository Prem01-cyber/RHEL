#!/bin/bash
markdown_file="a.md"
markdown_file_length=$(wc -l < "$markdown_file")



if [ -f "$markdown_file" ]; then
    echo "File $markdown_file exists."
    if [ "$markdown_file_length" -gt 0 ]; then
        echo "File $markdown_file is not empty."
        echo "" > "$markdown_file"
        
    else
        echo "File $markdown_file is empty."
    fi
    find . -type f -printf '%T@ %p\n' | sort -n | while read -r line; do
    file_name="$(echo "$line" | cut -d' ' -f2-)"
    if [ "$file_name" == "./a.sh" ] || [ "$file_name" == "./a.md" ]; then
        continue
    else
        echo "- [$file_name]($file_name)" >> a.md
    fi
    done
else
    echo "File $markdown_file does not exist."
fi