#!/bin/bash
function dale:optcheck(){
    for loop in "$@";do
        if [[ ${loop} =~ ^-$ ]];then
            eval "${OPTVAR}"="${loop#''}"
        elif [[ ${loop} =~ ^--$ ]];then
            eval "${OPTVAR}"="${loop#''}"
        elif [[ ${loop}  ]];then
            shift
            eval "${OPTVAR}"="${2}"
        elif [[ ${loop} ]];then
            shift
            eval "${OPTVAR}"="${2}"
        else
            eval "${OPTVAR}"='?'
        fi
        shift
    done
}
dale:optcheck "$@"


# dale:optcheck <var> -0aa -1bb -2cc =0dd =1ee =2ff
#  -a<value>  |  --aa=<value>  |  -a <value>  |  --aa <value>  ->  var=aa
#  -b<value>  |  --bb=<value>  |              |                ->  var=bb
#             |                |  -c <value>  |  --cc <value>  ->  var=cc
#             |  --dd=<value>  |              |  --dd <value>  ->  var=dd
#             |  --ee=<value>  |              |                ->  var=ee
#             |                |              |  --ff <value>  ->  var=ff
