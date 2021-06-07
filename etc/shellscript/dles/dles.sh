#!/bin/bash
isScript='yes'
function dles(){
	local SCRIPTNAME='Data List Editor Script'
	local SCRIPTNAMESHORT="$(echo "${SCRIPTNAME}"|sed -e 's/[a-z\ ]//g' -e "y/$(echo -n {A..Z}|tr -d ' ')/$(echo -n {a..z}|tr -d ' ')/")"
	local SCRIPTVERSION='1.0'

	local OUTPUT_MODE='none' # none, verbose, silence

	local PRE_FILE FILE='' # filein 
	local PRE_MODE MODE='none' # modein
	local ARRAY_MODE


	function dles:debug:verbose(){
		[[ $OUTPUT_MODE == 'verbose' ]] && echo "[${1}]:${*:2}"
	}

	function dles:debug:default(){
		[[ $OUTPUT_MODE == 'silence' ]] || echo "[${1}]:${*:2}"
	}

	function dles:set(){
		:
	}

	function dles:del(){
		:
	}

	function dles:get(){
		:
	}

	function dles:check:file(){
		if [[ -f ${PRE_FILE} && ${PRE_FILE} =~ ^.+\.dlf$ ]];then
			FILE="${PRE_FILE}"
		else
			if ! [[ -f ${PRE_FILE} ]];then
				dles:debug:default dles:check:file "'${PRE_FILE}' is not exist."
			fi
			if ! [[ ${PRE_FILE} =~ ^.+\.dlf$ ]];then
				dles:debug:default dles:check:file "'${PRE_FILE}' is not .dlf file."
			fi
		fi
	}
	
	function dles:check:mode(){
		for _ in ${ARRAY_MODE[@]};do
		done
	}

	function dles:info(){
		local LOOPEXIT_1='no'
		local count=0

		while [[ $LOOPEXIT_1 == 'no' ]];do
			((count++))
			case $1 in
				('info')
					cat <<-EOF
					# name    : ${SCRIPTNAME}
					# version : ${SCRIPTVERSION}$([[ $isScript == 'yes' ]] && echo -e "\n# tips    : This script can use as function\n#         : source ${0}")
					EOF
					;;
				(*)
					dles:debug:verbose 'dles:info' 'loopstop'
					dles:debug:verbose 'dles:info' 'loopcount' "$count"
					LOOPEXIT_1='yes'
					;;
			esac
			shift
		done
	}

	function dles:main(){
		local LOOPEXIT_1='no' # yes, no
		local LOOPEXIT_2='no' # yes, no
		local ARRAY_OPT=(file mode index element)

		# trap
		if [[ $# == 0 ]];then
			dles:info >&2
			return 1
		fi

		# first argcheck [[output], [file]]
		while [[ $LOOPEXIT_1 == 'no' ]];do
			if   [[ ${1} =~ ^'-'('v'|'-verbose')$ ]];then
				OUTPUT_MODE='verbose'
				dles:debug:verbose dles:main:arg1 OUTPUT_MODE=verbose
				shift
			elif [[ ${1} =~ ^'-'('s'|'-silence')$ ]];then
				dles:debug:verbose dles:main:arg1 OUTPUT_MODE=silence
				OUTPUT_MODE='silence'
				shift
			elif [[ ${1} =~ ^'-'('h'|'-help')$ ]];then
				dles:info info
				return 0
			else
				LOOPEXIT_1='yes'
			fi
		done

		# second argcheck [<mode>, [file], [mode], [element], [index]]
		while [[ ${LOOPEXIT_2} == 'no' ]];do
			COUNT_FAIL=0
			for opt in "${ARRAY_OPT[@]}";do
				if [[ ${1} =~ ^(-(${opt:0:1}|-${opt}=).+|-(${opt:0:1}|-${opt}))$ ]];then
					if [[ ${1} =~ ^-${opt:0:1}.+$ ]];then
						echo "${opt}:${1#-${opt:0:1}}"
						case $opt in
							('file') PRE_FILE=${1#-${opt:0:1}};;
							('mode') PRE_MODE=${1#-${opt:0:1}};;
						esac
						shift
					elif [[ ${1} =~ ^--${opt}=.+$ ]];then
						echo "${opt}:${1#--${opt}=}"
						case $opt in
							('file') PRE_FILE=${1#--${opt}=};;
							('mode') PRE_MODE=${1#--${opt}=};;
						esac
						shift
					elif [[ ${1} =~ ^-(${opt:0:1}|-${opt})$ ]];then
						echo "${opt}:${2}"
						if [[ -z ${2} ]];then #avoid infinity loop
							dles:debug:verbose dale:main:arg2 "avoid infinity loop"
							LOOPEXIT_2='yes'
						fi
						case ${opt} in
							('file') PRE_FILE=${2};;
							('mode') PRE_MODE=${2};;
						esac
						shift 2
					fi
				else
					((COUNT_FAIL++))
				fi
			done
			if ! [[ ${COUNT_FAIL} < ${#ARRAY_OPT[@]} ]];then
				dles:debug:verbose dles:main:arg2 "FINISH:${1}"
				LOOPEXIT_2='yes'
			else
				if [[ -n ${FILE} && ${MODE} != 'none' ]];then
					case ${mode} in
						('write') ;;
						('delete') ;;
					esac
				else
					# pre_v -> check && pre_v -> v || '' -> pre_v
					dles:check:file
					dles:check:mode
				fi
			fi
		done
	}
	dles:main "$@"
}
dles "$@"