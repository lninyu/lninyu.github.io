count=0
function opt_check(){
    local LOOPEXIT='no'
    # local ARRAY_OPT=(Aaa Bbb Ccc Ddd Eee Fff Ggg Hhh Iii Jjj Kkk Lll Mmm Nnn Ooo Ppp Qqq Rrr Sss Ttt Uuu Vvv Www Xxx Yyy Zzz)
    local ARRAY_OPT=(OptA OptB OptC) # -> short:oa, ob, oc  long:opta, optb, optc
    # FooBar -> -fb --foobar
    local OPT_S
    local OPT_L
    while [[ $LOOPEXIT == 'no' ]];do
        ((count++))
        COUNT_FAIL=0
        for opt in "${ARRAY_OPT[@]}";do
            OPT_L=$(echo -n "${opt}"|sed -e "y/$(echo -n {A..Z}|tr -d ' ')/$(echo -n {a..z}|tr -d ' ')/")
            OPT_S=$(echo -n "${opt}"|sed -e 's/[a-z]//g' -e "y/$(echo -n {A..Z}|tr -d ' ')/$(echo -n {a..z}|tr -d ' ')/")
            
            if [[ ${1} =~ ^(-(${OPT_S}|-${OPT_L}=).+|-(${OPT_S}|-${OPT_L}))$ ]];then
                if [[ ${1} =~ ^-${OPT_S}.+$ ]];then
                    echo "${count}:${OPT_L}:${1#-${OPT_S}}"
                elif [[ ${1} =~ ^--${OPT_L}=.+$ ]];then
                    echo "${count}:${OPT_L}:${1#--${OPT_L}=}"
                elif [[ ${1} =~ ^-(${OPT_S}|-${OPT_L})$ ]];then
                    echo "${count}:${OPT_L}:${2}"
                    shift
                fi
            else
                ((COUNT_FAIL++))
            fi
        done
        if ! [[ $COUNT_FAIL < ${#ARRAY_OPT[@]} ]];then
            echo "FINISH:${1}"
            LOOPEXIT='yes'
        fi
    shift
    done
}

function ughhhtestughhhhhh(){
    local ugh ughh ughhh ughhhh
    # ugh=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    ugh=(oa ob oc)
    ug=(opta optb optc)
    ughh+='opt_check'
    for _ in $(seq "${1:-10}");do
        ughhh=${ugh[$((RANDOM%3))]}
        ughhhh=${ug[$((RANDOM%3))]}
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

# ughhhtestughhhhhh "$1" #num
time ughhhtestughhhhhh 100 #num
