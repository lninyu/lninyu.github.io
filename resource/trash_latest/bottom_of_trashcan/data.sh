#!/bin/zsh
#lastexecutedate:18
function f:datalist(){
	local functionName currentFunctionName mode format='def' statusExit subCommand fopt loop interact_e
	functionName="${0}"
	function funcLogger(){
		local msg="[${functionName:2}${currentFunctionName}] ${@:1:$# -1}" 2>/dev/null
		local colorR='\e[31m'
		local colorG='\e[32m'
		local unColor='\e[0m'
		case ${@:$#:1} in
			('f1') echo "${colorG}${msg}${unColor}";;
			('f2') echo "${colorR}${msg}${unColor}">&2;;
			('s1') [[ ${mode} == 's' ]] || echo "${colorG}${msg}${unColor}";;
			('s2') [[ ${mode} == 's' ]] || echo "${colorR}${msg}${unColor}">&2;;
			('v1') [[ ${mode} == 'v' ]] && echo "${colorG}${msg}${unColor}";;
			('v2') [[ ${mode} == 'v' ]] && echo "${colorR}${msg}${unColor}">&2;;
			(*) [[ ${mode} == 's' ]] || echo "${colorR}[${functionName:2}:${currentFunctionName:2}:${0:4}] wrong args.${unColor}">&2;;
		esac
	}
	function funcConvert(){
		[[ $# != 2 ]] && return 1
		case ${1} in
			('encode')
				[[ ${format} == 'hex' ]] && echo -n "${2}"|xxd -p
				[[ ${format} == 'b64' ]] && echo -n "${2}"|base64
				[[ ${format} == 'old' ]] && echo -n "${2}"|xxd -p|rev|xxd -p -r|base64
				[[ ${format} == 'def' ]] && echo -n "${2}"|xxd -p|rev|xxd -p -r|base64|sed -e 'y!wBoCQ42edfjD71YFHzqZrAKnkv96EpX+bShWsiJt08x3VcRgUlaPOGNmMI5u/LTy!JLqV9silwGTyK6Zbf-mA0xCW8FSYt/DrcugQ2pzHU3NdvEkMo4aBPIh5RO17Xjen!' -e 's/==/¥/g'
				;;
			('decode')
				[[ ${format} == 'hex' ]] && echo -n "${2}"|xxd -p -r
				[[ ${format} == 'b64' ]] && echo -n "${2}"|base64 -d
				[[ ${format} == 'old' ]] && echo -n "${2}"|base64 -d|xxd -p|rev|xxd -p -r
				[[ ${format} == 'def' ]] && echo -n "${2}"|sed -e 's/¥/==/g' -e 'y!JLqV9silwGTyK6Zbf-mA0xCW8FSYt/DrcugQ2pzHU3NdvEkMo4aBPIh5RO17Xjen!wBoCQ42edfjD71YFHzqZrAKnkv96EpX+bShWsiJt08x3VcRgUlaPOGNmMI5u/LTy!'|base64 -d|xxd -p|rev|xxd -p -r
				;;
		esac
	}
	function funcFileCheck(){
		if [[ ${1} =~ ^.+\.datl$ ]];then
				if [[ -f ${1} ]];then
					if [[ $(xxd -p ${1}) == '' ]];then
						echo "#format[${format}]" > ${1}
					fi
					case $(cat ${1}|sed -n 1p) in
						('#format[hex]') format='hex';;
						('#format[b64]') format='b64';;
						('#format[old]') format='old';;
						('#format[def]') format='def';;
						(*) echo 'unknown format' ;return 1;;
					esac
					return 0
				else
					funcLogger "file<${1}> is not exist." v2
					funcLogger "file<${1}> generated." v1
					echo "#format[${format}]" > ${1}
					return 1
				fi
			else
				funcLogger "file<${1}> is not *.datl." v2
				return 2
			fi
		
	}
	function funcHelp(){
		currentFunctionName=":${0:4}"
		case $1 in
			('l')
				echo 'usage: list [-ac] <*.datl>'
				echo 'option:'
				echo '   -c --count   : count elements.'
				echo '   -a --all     : show content of element.'
				;;
			('w')
				echo 'usage: write <*.datl> <element> [data]'
				;;
			('n')
				echo 'usage: rename <*.datl> <before> <after>'
				;;
			('g')
				echo 'usage: get [-n|-q] <*.datl> <element>'
				echo 'option:'
				echo '   -n --name    : show element name.'
				echo '   -q --quite   : no output. return 0/1.'
				;;
			('d')
				echo 'usage: delete <*.datl> <element>'
				;;
			('f')
				echo 'usage: reformat <*.datl> <old_format> <new_format>'
				;;
			('i')
				echo 'usage: interact <*.datl>'
				;;
			('h')
				echo "usage: ${functionName} [option] <command> <*.datl> <args...>"
				echo 'option:'
				echo '   -v --verbose : '
				echo '   -s --silence : '
				echo '   --initformat : data format.'
				echo '                : initformat= hex, b64, old, def'
				echo 'command:'
				echo '   h  help      : show this help.'
				echo '   l  list      : show elements list.'
				echo '   w  write     : write to element.'
				echo '   r  rename    : rename element.'
				echo '   g  get       : get element.'
				echo '   d  delete    : delete element.'
				echo '   f  reformat  : reformatting datl.'
				echo '   i  interact  : '
				;;
			('hi')
				echo ' h  help        : show this help.'
				echo ' e  exit        : exit from interactive mode.'
				echo ' l  list        : show elements list.'
				echo ' w  write       : write to element.'
				echo ' r  rename      : rename element.'
				echo ' g  get         : get element.'
				echo ' d  delete      : delete element.'
				echo ' f  reformat    : reformatting datl.'
				;;
			(*) funcLogger "?$1" v2;;
		esac
	}
	function funcList(){
		currentFunctionName=":${0:4}"
		[[ $# == 0 ]] && { funcHelp l >&2;return 1;}
		for loop in $(seq 2);do
			case ${1} in
				('-ac'|'-ca') fopt='ac';shift;break;;
				('-a'|'--all') fopt+='a';shift;;
				('-c'|'--count') fopt+='c';shift;;
				(-*) funcLogger "unknown option: ${1}" v2;;
			esac
		done ; [[ $# != 1 ]] && return 1
		if funcFileCheck ${1};then
			local element_d=($(sed -e 's/:.*$//g' -e 's/^\#format\[...\]$//g' -e '/^$/d' ${1}))
			local data_d=($(sed -e 's/^.*:$/null/g' -e 's/^.*://g' -e 's/^\#format\[...\]$//g' -e '/^$/d' ${1}))
			
			
			if [[ ${fopt} =~ ^.*a.*$ ]];then
				for loop in $(seq ${#element_d[@]});do
					echo "$(funcConvert decode ${element_d[loop]}):$(funcConvert decode ${data_d[loop]})"
				done
			else
				for loop in $(seq ${#element_d[@]});do
					echo "$(funcConvert decode ${element_d[loop]})"
				done
			fi
			[[ ${fopt} =~ ^.*c.*$ ]] && funcLogger "${#element_d[@]} elements." s1
		else 
			return 1
		fi
	}
	function funcWrite(){
		currentFunctionName=":${0:4}"
		[[ $# < 2 ]] && { funcHelp w >&2;return 1;}
		if funcFileCheck ${1};then
			local estr2="$(funcConvert encode "${2}")"
			if ! grep -q "${estr2}:" ${1} 2>/dev/null;then
				echo "\n${estr2}:$(funcConvert encode "${@:3}")" >> ${1}
			else
				data=$(sed -e "s/^${estr2}:.*$/${estr2}:$(funcConvert encode "$(echo -n ${@:3})")/" ${1})
				echo -n ${data} > ${1}
				funcLogger "element<${2}> is exist." v2
				funcLogger "element<${2}> has been overwritten." v2
			fi
		else
			return 1
		fi
	}
	function funcRename(){
		currentFunctionName=":${0:4}"
		[[ $# != 3 ]] && { funcHelp n >&2;return 1;}
		if funcFileCheck ${1};then
			local estr2="$(funcConvert encode "${2}")"
			local estr3="$(funcConvert encode "${3}")"
			if grep -q "${estr2}:" ${1};then
				if ! grep -q "${estr3}:" ${1};then
					funcWrite ${1} "${3}" "$(funcGet ${1} "${2}")"
					funcLogger "element<${2}> has been written.." v1
					funcDelete ${1} "${2}"
					funcLogger "element<${2}> has been deleted." v1
				else
					funcLogger "element<${3}> is exist." v2
					return 1
				fi
			else
				funcLogger "element<${2}> is not exist." v2
				return 1
			fi
		else 
			return 1
		fi
	}
	function funcGet(){
		currentFunctionName=":${0:4}"
		[[ $# == 0 ]] && { funcHelp g >&2;return 1;}
		local exitstat=0 encodedstr=''
		case ${1} in
			('-n'|'--name') fopt='n';shift;;
			('-q'|'--quite') fopt='q';shift;;
			(-*) funcLogger "unknown option: ${1}" v2;;
		esac ; [[ $# != 2 ]] && return 1
		if funcFileCheck ${1};then
			estr2="$(funcConvert encode "${2}")"
			if grep -q "${estr2}:" ${1};then
				case ${fopt} in
					('n') 
						echo "$(funcConvert decode $(grep "${estr2}:" ${1}|sed -e 's/:.*$//g')):$(funcConvert decode $(grep "${estr2}:" ${1}|sed -e 's/^.*://g'))"
						;;
					('q') :;;
					(*)
						echo $(funcConvert decode "$(grep "${estr2}:" ${1}|sed -e 's/^.*://g')")
						;;
				esac
				return 0
			else
				funcLogger "element<${2}> is not exist." v2
				return 1
			fi
		else 
			return 1
		fi
	}
	function funcDelete(){
		currentFunctionName=":${0:4}"
		[[ $# != 2 ]] && { funcHelp d >&2;return 1;}
		if funcFileCheck ${1};then
			local estr2="$(funcConvert encode "${2}")"
			if grep -q "${estr2}:" ${1};then
				data=$(sed -e "s/^${estr2}:.*$//" -e '/^$/d' ${1})
				echo -n ${data} > ${1}
				funcLogger "element<${2}> deleted." v1
			else
				funcLogger "element<${2}> is not exist." v2
			fi
		else
			return 1
		fi
	}
	function funcReformat(){
		currentFunctionName=":${0:4}"
		[[ $# != 3 ]] && { funcHelp f >&2;return 1;}
		local temp0=${format} temp1 temp2="temp$(date +%S%M%S%H%S%m).datl"
		if funcFileCheck ${1};then
			if ! [[ ${2} =~ (hex|b64|old|def) && ${3} =~ (hex|b64|old|def) ]];then
				return 1
			fi
			echo $(<${1})|tr ' ' '\n'>${temp2}
			echo "#format[${3}]">${1}
			for loop in $(funcList ${temp2});do
				format="${2}"
				temp1="$(funcGet ${temp2} "${loop}")"
				format="${3}"
				echo $(funcConvert encode "${loop}"):$(funcConvert encode "${temp1}") >> ${1}
			done
			rm ${temp2}
			format=${temp0}
		else
			return 1
		fi
	}
	function funcInteract(){
		currentFunctionName=":${0:4}"
		[[ $# != 1 ]] && { funcHelp i >&2;return 1;}
		if funcFileCheck ${1};then
			local args
			echo "':f' -> '${1}'"
			while :;do
				echo -n "[${1}> ";read interact_e
				args=($(echo -n "${interact_e}"|sed -e "s/:f/${1}/"))
				case ${args:0:1} in
					('e'|'exit'|'quit') break;;
					('h'|'help') funcHelp hi;;
					('l'|'list') funcList ${args:1};;
					('w'|'write') funcWrite ${args:1};;
					('r'|'rename') funcRename ${args:1};;
					('g'|'get') funcGet ${args:1};;
					('d'|'delete') funcDelete ${args:1};;
					('f'|'reformat') funcReformat ${args:1};;
					(*) :;;
				esac
			done
		else
			return 1
		fi
	}
	function funcMain(){
		currentFunctionName=":${0:4}"
		[[ $# == 0 ]] && { funcHelp h>&2; funcHelp hi>&2;return 1;}
		case ${1} in
			('-s'|'--silence') mode='s';shift;;
			('-v'|'--verbose') mode='v';funcLogger "initial argument:[$@]" v1;funcLogger "verbose:on" v1;shift;;
		esac ; [[ $# == 0 ]] && return 1
		
		case ${1} in
			('-fhex'|'--initformat=hex') format='hex';shift;;
			('-fb64'|'--initformat=b64') format='b64';shift;;
			('-fold'|'--initformat=old') format='old';shift;;
			('-fdef'|'--initformat=def') format='def';shift;;
		esac ; [[ $# == 0 ]] && return 1
		funcLogger "initformat:${format}" v1
		if [[ ${1} =~ -.* ]];then
			funcLogger "too many option." v2
			return 1
		fi
		subCommand="${1}";shift
		case ${subCommand} in
			('h'|'help') funcHelp h;funcHelp hi;;
			('l'|'list') funcList $@;;
			('w'|'write') funcWrite $@;;
			('r'|'rename') funcRename $@;;
			('g'|'get') funcGet $@;;
			('d'|'delete') funcDelete $@;;
			('f'|'reformat') funcReformat $@;;
			('i'|'interact') funcInteract $@;;
			(*) funcLogger "${subCommand} command is not exist." v2;;
		esac
	}
	funcMain $@ ; statusExit=$?
	unset -f func{Logger,Convert,FileCheck,Help,List,Write,Rename,Get,Delete,Reformat,Main}
	return ${statusExit}
}
f:datalist $@ 
if [[ $(cat ./${0} | grep -m1 "#lastexecutedate:") != "#lastexecutedate:$(date +%M)" ]];then
	ofile=$(cat ./${0} | sed -e "s/^#lastexecutedate:.*$/#lastexecutedate:$(date +%M)/")
	echo -nE "$ofile">${0}
	echo "can use as function : source ${0}"
fi
