#!/bin/bash

filter_lshw_section() {
    local section=$1
    IFS=',' read -r -a keywords <<< "$2"  # Convert input string to array based on commas
    local awk_script=""

    # Initialize capture flag and seen array for keywords
    awk_script+="BEGIN {capture=0; split(\"\", seen)} "

    # Start capturing when the specified section starts
    awk_script+="/\\*-${section}/ {capture=1} "

    # Stop capturing when another section starts
    awk_script+="/^\\*/ && !/\\*-${section}/ {capture=0} "

    # For each keyword, add logic to print the first occurrence within the specified section
    for keyword in "${keywords[@]}"; do
        # Escape special characters that might be interpreted by awk
        local escaped_keyword=$(printf '%s\n' "$keyword" | sed 's:[][\/.^$*]:\\&:g')
        awk_script+="{ if (capture && /${escaped_keyword}/ && !seen[\"${escaped_keyword}\"]++) print } "
    done

    # Execute lshw, then filter with the dynamically built awk script
    lshw | awk "$awk_script"
}

section="cpu"
keywords="product,vendor,physical id,bus info,width"
echo "$section"
filter_lshw_section "$section" "$keywords"

section="memory"
keywords="description,physical id,size"
echo "$section"
filter_lshw_section "$section" "$keywords"

section="display"
keywords="description,product,vendor,physical id,bus info,width,clock,capabilities,configuration,resources"
echo "$section"
filter_lshw_section "$section" "$keywords"

section="network"
keywords="description,product,vendor,physical id,bus info,logical name,version,serial,size,capacity,width,clock,capabilities,configuration,resources"
echo "$section"
filter_lshw_section "$section" "$keywords"
