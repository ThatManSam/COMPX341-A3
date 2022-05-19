#!/usr/bin/bash

COMMENT="// Name: Joel Shepherd | ID: 1535837
"

# Checking is a directory was specified
if [[ "$1" != '' ]]; then
    DIR=$1
else
    DIR='.'
fi

COUNT=0

# Find all the TypeScript files .ts (ignoring .tsx)
for FILE in $(find $DIR | grep -E .*\.ts$); do
    # Omit the build and node_modules directories
    if [[ $(echo $FILE | grep -E "(\.|\/)*(build\/|node_modules\/).*") != '' ]]; then
        echo "Omitting $FILE"
    else
        echo "Adding to $FILE"
        TEMP_FILE="/tmp/_maintainence.tmp"
        # Add the comment to a temporary file
        { echo "$COMMENT"; cat "$FILE"; } >> "$TEMP_FILE" &&
        # Overwrite the old file with the tmp file
        mv "$TEMP_FILE" "$FILE"
        COUNT=$((COUNT+1))
    fi
done

echo "Changed $COUNT files"