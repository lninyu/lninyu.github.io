#!/bin/bash
g=0;for L in xxd gunzip base64 sed;do type $L&>/dev/null;[ $? != 0 ]&&{ echo "require $L";g=1;};done;[ $g = 1 ]&&exit 1;A=($(cat<<'takada'|base64 -d|gunzip
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
takada
));B=$(cat<<'takada'|base64 -d|gunzip
H4sIAAAAAAACA3u5esbzKRueNi59un/6szkNT/dsf7+n8SVlglxooo8bSEbYDcWj4f3e/vd7J7zfO+X93k4wuw+/BVBDFRAgJTUtsTSnRMFKoSgxLyU/F1nOQKFOQU9PDyhXUJSZV6KQkVmskJOanpqXgqwqMScHTMNUgfjYVWak5hQoZIBUFmfklyuUAFUR8B+piMYxQfU0AwAq70d9iAIAAA==
takada
);case $1 in [0-9]*)[ $1 -lt ${#A[@]} ]&&echo -n "${A[$1]}@"|sed 's/@/\n/g'|sed 's/§/ /g'||{ echo "Input is less than ${#A[@]} (${1})";};;"all")for C in $(seq ${#A[@]});do echo -n "${A[$C]}@@@"|tr '@' '\n'|sed 's/§/ /g';done;;"help"|"h")echo "${B}";;*)echo -n "${A[$(($RANDOM%${#A[@]}))]}@"|tr '@' '\n'|sed 's/§/ /g';;esac 2>/dev/null