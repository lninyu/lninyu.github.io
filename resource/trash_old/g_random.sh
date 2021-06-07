#!/bin/bash
ln_arg=`echo ${1}|tr -d "-"`
ln_cg="\033[32m%s\033[m"
ln_cr="\033[31m%s\033[m"
ln_n(){
    echo ""
}
ln_ee(){
    printf "${ln_cr}\n" "${1}"
}
ln_ge(){
    for ln_l1 in `seq ${ln_con}`;do
        echo -n "$((${RANDOM}%${ln_num}))"
    done
ln_n
}
ln_ua(){
    printf "\033[36musage : g_random <length>\n        g_random [option] <length>\noption: -h --help : show help\n        -[1-16]   : n-ary (default 10)\033[m\n"
}
    case ${1} in
        [0-9]*)
            ln_num=10
            ln_con=${1}
            printf "${ln_cg}" `ln_ge`
            [[ -n "${2}" ]] && ln_ee "	warn:unnecessary argument" || ln_n
            ;;
        "-h"|"--help")
            for ln_l0 in "tr" "printf" "seq" "bc";do
                type ${ln_l0} > /dev/null 2>&1 && printf "hello ${ln_l0}!  " || printf "who is ${ln_l0}?  "
            done
            ln_n
            ln_ua
            ;;
        -1)
            ln_num=1
            [[ -n "${2}" ]] && {
                ln_con=${2}
                printf "${ln_cg}\n" `ln_ge`
                } || ln_ee "error:second argument is empty"
            ;;
        -${ln_arg})
            [[ ${ln_arg} -le 16 ]] && {
                ln_num=${ln_arg}
                [[ -n "${2}" ]] && {
                    ln_con=$((${2}*2))
                    ln_s0=`ln_ge`
                    ln_s1=`echo "obase=${ln_arg};ibase=10;${ln_s0}"|bc|tr -d '\'|tr -d '\n'`
                    printf "${ln_cg}\n" ${ln_s1:0:$((${ln_con}/2))};
                } || ln_ee "error:illegal arguments"
            } || ln_ee "error:${ln_arg}<17"
        ;;
        *)
            ln_ee "error:illegal argument"
            ln_ua
            ;;
        esac
        unset ln_ge ln_ua ln_arg ln_cr ln_cg ln_l0 ln_l1 ln_con ln_num ln_s0 ln_s1;
#うわあああああ

# 20210607164632
# この世の終わりみたいなスクリプトを書かないでくれ過去の私よ
# シェルチェックが26も問題があるっていってるよ...
# +indent +space +line