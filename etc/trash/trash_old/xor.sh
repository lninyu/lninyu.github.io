#!/bin/bash
main() {

_usage() { echo "usage" ; }

_c() {
  for loop in str key ; do
    case `eval echo '$'${loop}` in
      *[a-zA-Z2-9]* )
        echo "${loop} isnt bin" #d
        str=
        key=
        ;;
      [0-1]* )
        echo "${loop} is bin" #d
        
        ;;
    esac
  done
  echo "obase=2;$((2#${str} ^ 2#${key}))"|bc
}

case ${1} in 
  [0-1]* ) _c ; str="${1}" ; key="${2}" ;;
  "-e" | "--encode" ) _c ; str="${2}" ; key="${3}" ;;
  "-h" | "--help" ) _usage ;;
esac

}

main "01001010" "01010010"

length() { echo "$((`eval echo "${#1}"` * 8))" ; }
length hogefugapiyohogeraqrarapqapapapapapraparaparaprapa

# 20210607165437
# +shbang