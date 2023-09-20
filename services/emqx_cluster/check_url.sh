#!/bin/bash
set -e

# Define the URL to check
url=$1

# Check if the URL ends with tar.gz or zip
if [[ "$url" =~ ubuntu20.04-amd64\.[zt]ip|tar\.gz$ ]]; then
	echo "URL suffix is valid (ubuntu20.04-amd64.tar.gz or ubuntu20.04-amd64.zip)."

	# Attempt to download the package
	code=$(curl --write-out '%{http_code}' --silent --output /dev/null "$url")

	if [ $? -eq 0 ] && [ "$code" -ne "404" ]; then
		echo "Package can be downloaded."
	else
		echo "Package download failed."
		exit 1
	fi
else
	echo "Invalid URL suffix. URL should end with ubuntu20.04-amd64.tar.gz or ubuntu20.04-amd64.zip."
	exit 1
fi
