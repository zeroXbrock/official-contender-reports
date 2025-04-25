#!/bin/bash

# This script takes report IDs as input and copies the corresponding report files from your machine to this project.
# Usage: ./import.sh <report_id> [name]
# Example: ./import.sh 12-13 "local reth april 2025"

CONTENDER_DIR="$HOME/.contender"
# Check if the contender directory exists
if [ ! -d "$CONTENDER_DIR" ]; then
    echo "Contender directory does not exist. Please run contender and generate at least one report first."
    exit 1
fi

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <report_id> [name]"
    echo "Example: $0 12-13 \"local reth april 2025\""
    exit 1
fi

REPORT_ID="$1"
if [ -z "$2" ]; then
    echo "Please provide a report ID."
    NAME="$REPORT_ID"
else
    NAME="$2"
fi

# create a local directory to store the copied files
LOCAL_DIR="reports/${NAME}"
mkdir -p "$LOCAL_DIR"

# copy the html report file to the local directory
HTML_FILE=$(find "$CONTENDER_DIR" -type f -name "*${REPORT_ID}*.html")
if [ -n "$HTML_FILE" ]; then
    cp "$HTML_FILE" "$LOCAL_DIR/"
else
    echo "No HTML file found for report ID: $REPORT_ID"
    exit 1
fi

# replace "$HOME/.contender" with "." in the local HTML file
sed -i "s|$HOME/.contender/reports|.|g" "$LOCAL_DIR/$(basename "$HTML_FILE")"

# Find all PNG files with the report ID in their name
PNG_FILES=$(find "$CONTENDER_DIR" -type f -name "*${REPORT_ID}*.png")

if [ -z "$PNG_FILES" ]; then
    echo "No PNG files found for report ID: $REPORT_ID"
    exit 1
fi
echo "Found the following PNG files:"
echo "$PNG_FILES"

# Copy the files to the local directory
for FILE in $PNG_FILES; do
    cp "$FILE" "$LOCAL_DIR/"
done

# append a link to the REAMDE
echo "- [${NAME} (id $REPORT_ID)](https://htmlpreview.github.io/?https://github.com/zeroxbrock/official-contender-reports/blob/main/reports/${NAME}/$(basename "$HTML_FILE"))" >> README.md
