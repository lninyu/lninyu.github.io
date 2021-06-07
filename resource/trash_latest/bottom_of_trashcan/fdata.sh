#!/bin/zsh
function f:data(){
	local FLAG_VERBOSE=0
	local EXIT_STATUS=0
	local NAME_FILE
	local ARG_0="${0}"
	local TEMP TEMP1
	local elem 
	function innerFuncPrint(){
		case ${1} in
			("1") [[ ${FLAG_VERBOSE} == 1 ]] && echo "[${ARG_0}]: ${2}";;
			("1f") echo "[${ARG_0}]: ${2}";;
			("2") echo "[${ARG_0}]: ${2}" >&2 ; EXIT_STATUS=1;;
		esac 
	}
	function innerFuncUsage(){
		local in='   '
		echo "usage: ${ARG_0} [--] [-v|--verbose] <[new:]*.datl> <command> <args...>"
		echo "command:"
		echo "${in}h  help   : ${ARG_0} help"
		echo "${in}l  list   : ${ARG_0} <*.datl> list   [-a | --all] [-c | --count]"
		echo "${in}ch check  : ${ARG_0} <*.datl> check  [-s | --silent] <name>"
		echo "${in}cr create : ${ARG_0} <*.datl> create <element>"
		echo "${in}w  write  : ${ARG_0} <*.datl> write  <element> <data>"
		echo "${in}r  rename : ${ARG_0} <*.datl> rename <element> <name>"
		echo "${in}g  get    : ${ARG_0} <*.datl> get    <element>"
		echo "${in}c  clear  : ${ARG_0} <*.datl> clear  <element>"
		echo "${in}rm remove : ${ARG_0} <*.datl> remove <element>"
	}
	function innerFuncCreate(){
		if [[ $# == 1 ]];then
			if grep -q "${elem}:" ${NAME_FILE};then
				innerFuncPrint 2 "element:{1} is exist."
			else
				echo ${elem}: >> ${NAME_FILE}
				innerFuncPrint 1 "element:{1} created."
			fi
		else
			innerFuncPrint 2 "wrong argment($#)"
		fi
	}
	function innerFuncWrite(){
		if [[ $# == 2 ]];then
			if grep -q "${elem}:" ${NAME_FILE};then
				TEMP=$(sed "s/$(grep "${elem}:" ${NAME_FILE})/${elem}:$(echo -n ${2}|xxd -p|tr -d "\n")/" ${NAME_FILE})
				echo -n ${TEMP}> ${NAME_FILE}
				innerFuncPrint 1 "writing completed"
			else
				innerFuncPrint 2 "element:{1} is not exist."
			fi
		else
			innerFuncPrint 2 "wrong argment($#)"
		fi
	}
	function innerFuncRename(){
		if [[ $# == 2 ]];then
			if grep -q "${elem}:" ${NAME_FILE};then
				if grep -q "$(echo -n ${2}|xxd -p|tr -d "\n"):" ${NAME_FILE};then
					innerFuncPrint 2 "element:{2} exists."
				else
					TEMP=$(sed "s/$(grep "${elem}:" ${NAME_FILE})/$(echo -n ${2}|xxd -p|tr -d "\n"):$(grep "${elem}:" ${NAME_FILE}|sed -e 's/^.*://')/" ${NAME_FILE})
					echo -n ${TEMP}> ${NAME_FILE}
					innerFuncPrint 1 "renamed \'${1}\' -> \'${2}\'"
				fi
			else
				innerFuncPrint 2 "element:{1} is not exist."
			fi
		else
			innerFuncPrint 2 "wrong argment($#)"
		fi
	}
	function innerFuncGet(){
		if grep -q "${elem}:" ${NAME_FILE};then
			grep "${elem}:" ${NAME_FILE}|sed -e "s/${elem}://"|xxd -p -r
		else
			innerFuncPrint 2 "element:{1} is not exist."
		fi
	}
	function innerFuncClear(){
		if [[ $# == 1 ]];then
			if grep -q "${elem}:" ${NAME_FILE};then
				TEMP=$(sed "s/$(grep "${elem}:" ${NAME_FILE})/${elem}:/" ${NAME_FILE})
				echo -n ${TEMP}> ${NAME_FILE}
				innerFuncPrint 1 "element:{1} cleared"
			else
				innerFuncPrint 2 "element:{1} is not exist."
			fi
		else
			innerFuncPrint 2 "wrong argment($#)"
		fi
	}
	function innerFuncRemove(){
		if [[ $# == 1 ]];then
			if grep -q "${elem}:" ${NAME_FILE};then
				if grep -q "${elem}: " ${NAME_FILE};then
					TEMP=$(sed "s/$(grep "${elem}:" ${NAME_FILE})//" ${NAME_FILE})
					echo -n ${TEMP}> ${NAME_FILE}
					innerFuncPrint 1 "element:{1} cleared"
				else
					innerFuncPrint 2 "element:{1} in not empty."
				fi
			else
				innerFuncPrint 2 "element:{1} is not exist."
			fi
		else
			innerFuncPrint 2 "wrong argment($#)"
		fi
	}
	function innerFuncList(){
		local flag_ALL
		local flag_COUNT
		local element_d
		local data_d

		if [[ ${1} == '-ac' || ${1} == '-ca' ]];then
			flag_ALL=1
			innerFuncPrint 1 "list_all:on"
			flag_COUNT=1
			innerFuncPrint 1 "list_count:on"
			shift
		else
			for loop in {1..2};do
				case ${1} in
					("-a"|"--all")
						flag_ALL=1
						innerFuncPrint 1 "list_all:on"
						shift
						;;
					("-c"|"--count")
						flag_COUNT=1
						innerFuncPrint 1 "list_count:on"
						shift
						;;
				esac
			done
		fi
		
		element_d=($(sed -e 's/:.*$//g' ${NAME_FILE}))
		if [[ ${flag_ALL} == 1 ]];then
			data_d=($(sed -e 's/^.*:$/null/g' -e 's/^.*://g' ${NAME_FILE}))
			for loop in $(seq ${#element_d[@]});do
				echo "$(echo -n ${element_d[loop]} | xxd -p -r):$(echo -n ${data_d[loop]} | xxd -p -r)"
			done
		else
			sed -e "s/:.*$//g" ${NAME_FILE} | xargs -P2 -I{} sh -c 'echo $(echo -n {}|xxd -p -r)'
		fi
		[[ ${flag_COUNT} == 1 ]] && echo "${#element_d[@]} elements."
	}
	function innerFuncCheck(){
		local flag_SILENT

		if [[ ${1} == '-s' || ${1} == '--silent' ]];then
			flag_SILENT=1
			shift
		fi

		if grep -q "${elem}:" ${NAME_FILE};then
			[[ ${flag_SILENT} == 1 ]] || innerFuncPrint 1f "element:{1} is exist."
		else
			[[ ${flag_SILENT} == 1 ]] || innerFuncPrint 2 "element:{1} is not exist."
			EXIT_STATUS=1
		fi
	}
	if [[ $# == 0 ]];then
		innerFuncUsage >&2
	elif [[ $# > 0 ]];then
		if [[ ${1} == '-v' || ${1} == '--verbose' ]];then
			FLAG_VERBOSE=1
			[[ ${FLAG_VERBOSE} == 1 ]] && innerFuncPrint 1 "verbose:on"
			shift
		elif [[ ${1} == '--' ]];then
			shift
		fi

		if [[ ${1} =~ ^new:.+\.datl$ ]];then
			TEMP1=${1:4}
			:>${TEMP1}
		else
			TEMP1=${1}
		fi
		
		if [[ -f ${TEMP1} ]];then
			if [[ ${TEMP1} =~ ^.+\.datl$ ]];then
				NAME_FILE="${TEMP1}"
				shift
				echo >> ${NAME_FILE}
				elem="$(echo -n ${2:-"empty_element_default_name[${RANDOM}]"}|xxd -p|tr -d "\n")"
				case ${1} in
					("l"|"list")
						shift
						innerFuncList $@
						;;
					("ch"|"check")
						shift
						innerFuncCheck $@
						;;
					("cr"|"create")
						shift
						innerFuncCreate $@
						;;
					("w"|"write")
						shift
						innerFuncWrite $@
						;;
					("r"|"rename")
						shift
						innerFuncRename $@
						;;
					("g"|"get")
						shift
						innerFuncGet $@
						;;
					("c"|"clear")
						shift
						innerFuncClear $@
						;;
					("rm"|"remove")
						shift
						innerFuncRemove $@
						;;
					(*) innerFuncPrint 2 "'${1}' command is not exist.  see '${0} help'.";;
				esac
				TEMP=$(sed -e '/^$/d' ${NAME_FILE})
				echo -n ${TEMP} | tr " " "\n" > ${NAME_FILE}
			else
				innerFuncPrint 2 "*.datl only."
			fi
		elif [[ ${1} == 'h' || ${1} == 'help' ]];then
			innerFuncUsage >&1
		else
			innerFuncPrint 2 "file:${TEMP1} is not exist."
		fi
	fi
	unset -f innerFunc{Print,Usage,List,Check,Create,Write,Rename,Get,Clear,Remove}
	return ${EXIT_STATUS}
}

f:data $@
echo "can use as function : source ${0}"
