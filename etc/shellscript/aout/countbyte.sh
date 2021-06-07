#!/bin/bash
f='%6d'
case $1 in
    ('-x') f='%6x';shift;;
    ('-o') f='%6o';shift;;
esac

[[ -z $1 ]] && echo "Usage: $0 [-ox] <file>" && exit 1

# shellcheck disable=SC2207
a=($({ echo {0..255}|xargs printf %02x;xxd -p "${1}"|tr -d '\n';}|fold -w2|sort|uniq -c|sed -e's/ [0-9a-f][0-9a-f]$//g'))
echo -en '[--] ' '[0'{0..9}'] ' '[0'{a..f}'] '
for b in {0..255};do
    [[ $((b%16)) == 0 ]] && printf "\n[%02x]" "$b"
    printf "$f" $((a[((c++))]-1)) 
done | sed -e 's/ 0/ -/g'