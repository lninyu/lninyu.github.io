#!/bin/bash
function dale:encode(){
    echo -n "$@" | xxd -p
}

function dale:hash(){
    md5 "$@"
}

function dale:set(){

}
dale:set "$@"