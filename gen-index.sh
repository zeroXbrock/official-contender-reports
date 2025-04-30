#!/bin/bash

OUTPUT="reports/index.html"
REPORTS_DIR="reports"

echo "<!DOCTYPE html><html><head><title>Contender Reports Index</title></head><body>" > "$OUTPUT"
echo "<h1>Contender Reports</h1>" >> "$OUTPUT"

for dir in "$REPORTS_DIR"/*/; do
    dirname=$(basename "$dir")
    echo "<h2>$dirname</h2><ul>" >> "$OUTPUT"

    find "$dir" -maxdepth 1 -name '*.html' | sort | while read -r file; do
        filename=$(basename "$file")
        filepath="$filename"
        echo "<li><a href=\"/$dirname/$filepath\">$filename</a></li>" >> "$OUTPUT"
    done

    echo "</ul>" >> "$OUTPUT"
done

echo "</body></html>" >> "$OUTPUT"