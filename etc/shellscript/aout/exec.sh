#!/bin/bash
function ex(){ echo "command: $*" ; "$@" ; echo ; }
ex uname -sm
ex cat eg.c
ex cc -o eg eg.c
ex xxd eg
ex xxd -p eg
ex ./countbyte.sh eg
ex ./countbyte.sh -x eg