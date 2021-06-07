#!/bin/bash
cd "$(dirname "${0}")/../" || exit
for fileIn in $(find . -type f|sed -e '/DS_Store/d');do
	chmod +x "$fileIn"
done