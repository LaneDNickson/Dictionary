#!/usr/bin/env bash

# Date: 06/08/2023
# Author: Lane Nickson
# Uses the Free Dictionary API to get the definitions for a given word.
# Usage: $ ./dictionary.sh [word]

# No args provided?
if [ $# -eq 0 ]; then
	echo "Usage: $ ./dictionary.sh [word]"
	exit 0
fi

# Get the html/js response using curl
response=$(curl -s https://api.dictionaryapi.dev/api/v2/entries/en/$1)

# Print requested word
printf "${1^}: \n"

# Interpret sent JSON, send any error messages to /dev/null
definition=$(echo "$response" | jq -r '.[].meanings[].definitions[].definition' 2>/dev/null)

# Error handling (jq's response should be 1 if curl returns bad JSON)
if [ $? -eq 0 ]; then
	# Add line numbers to the definition
	definition=$(echo "$definition" | nl -s ". ")
	printf "$definition\n"
else
	echo "No definitions found."
fi
