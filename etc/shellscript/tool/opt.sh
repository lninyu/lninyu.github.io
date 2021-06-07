#!/bin/bash -x
# cd "$(dirname "${0}")/.." || exit
# grep 'function .*(){' dale/dale.sh | tr -d ':(){'| sed -e 's/^.* dale//g' -e '/^$/d' | tr '\n' ','

# count=0
# function opt_check(){
# 	local LOOPEXIT='no'
# 	local ARRAY_OPT=(aaa bbb ccc ddd eee fff ggg hhh iii jjj kkk lll mmm nnn ooo ppp qqq rrr sss ttt uuu vvv www xxx yyy zzz)
# 	#local OPT_S
# 	#local OPT_L
# 	while [[ $LOOPEXIT == 'no' ]];do
# 		((count++))
# 		COUNT_FAIL=0
# 		for opt in "${ARRAY_OPT[@]}";do
# 			#OPT_L=$(echo -n "${opt}"|sed -e "y/$(echo -n {A..Z}|tr -d ' ')/$(echo -n {a..z}|tr -d ' ')/")
# 			#OPT_S=$(echo -n "${opt}"|sed -e 's/[a-z]//g' -e "y/$(echo -n {A..Z}|tr -d ' ')/$(echo -n {a..z}|tr -d ' ')/")	
# 			if [[ ${1} =~ ^(-(${opt:0:1}|-${opt}=).+|-(${opt:0:1}|-${opt}))$ ]];then
# 				if [[ ${1} =~ ^-${opt:0:1}.+$ ]];then
# 					echo "${count}:${opt}:${1#-${opt:0:1}}"
# 				elif [[ ${1} =~ ^--${opt}=.+$ ]];then
# 					echo "${count}:${opt}:${1#--${opt}=}"
# 				elif [[ ${1} =~ ^-(${opt:0:1}|-${opt})$ ]];then
# 					echo "${count}:${opt}:${2}"
# 					shift
# 				fi
# 			else
# 				((COUNT_FAIL++))
# 			fi
# 		done
# 		if ! [[ $COUNT_FAIL < ${#ARRAY_OPT[@]} ]];then
# 			echo "FINISH:${1}"
# 			LOOPEXIT='yes'
# 		fi
# 	shift
# 	done
# }

count=0
optnone="--$(md5 -qs "$(date)")"

function opt_check(){
    local LOOPEXIT='no'
    local OPT_L=('longa' 'longb' 'longc' 'longd' 'longe' 'longf'    )
    local OPT_S=('a'     'b'     'c'     'd'     'e'      "$optnone")
    while [[ $LOOPEXIT == 'no' ]];do
        ((count++))
        COUNT_FAIL=0
        for i in $(seq 0 1 ${#OPT_L});do
            if [[ ${1} =~ ^(-(${OPT_S[$i]}|-${OPT_L[$i]}=).+|-(${OPT_S[$i]}|-${OPT_L[$i]}))$ ]];then
                if [[ ${1} =~ ^-${OPT_S[$i]}.+$ ]];then
                    echo "${count}:${OPT_L[$i]}:${1#-${OPT_S[$i]}}"
                elif [[ ${1} =~ ^--${OPT_L[$i]}=.+$ ]];then
                    echo "${count}:${OPT_L[$i]}:${1#--${OPT_L[$i]}=}"
                elif [[ ${1} =~ ^-(${OPT_S[$i]}|-${OPT_L[$i]})$ ]];then
                    echo "${count}:${OPT_L[$i]}:${2}"
                    shift
                fi
            else
                ((COUNT_FAIL++))
            fi
        done
        if ! [[ $COUNT_FAIL < ${#OPT_L[@]} ]];then
            echo "FINISH:${1}"
            LOOPEXIT='yes'
        fi
        shift
    done
}

function ughhhtestughhhhhh(){
    local ugh ughh ughhh ughhhh
    ug_=('longa' 'longb' 'longc' 'longd' 'longe' 'longf')
    # ugh=('a'     'b'     'c'     'd'     'e'     'f'    )
    ugh=('a'     'b'     'c'     'd'     'e'     "$optnone")
    ughh+='opt_check'
    for _ in $(seq "${1:-10}");do
        ughhh=${ugh[$((RANDOM%6))]}
        ughhhh=${ug_[$((RANDOM%6))]}
        case $((RANDOM%4)) in
            (0) ughh+=" -${ughhh}${RANDOM}";;
            (1) ughh+=" --${ughhhh}=${RANDOM}";;
            (2) ughh+=" -${ughhh} ${RANDOM}";;
            (3) ughh+=" --${ughhhh} ${RANDOM}";;
        esac
    done
    echo "run: ${ughh}"
    ${ughh} | column -s: -t
}
# opt_check -d optd
# ughhhtestughhhhhh "$1" #num
time ughhhtestughhhhhh 100 #num