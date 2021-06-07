#!/bin/bash
# name: dale, data list editor
# date: 20210606074747(JP)
#
# $0 $1 $2 $...
# $@ -> $1 $2 $...
# $* -> "$1 $2 $..."

function dale(){
	local mode_out='none' # none, verbose, silence
	local mode_edit='none' # none, write, delete, get, list, rename, reformat
	local format_default='xxd' # xxd, base64
	local file='' # *.dlf only
	local file_type='' # plain, binary
	local file_format='none' #xxd, base64

	function dale:debug(){
		local loop
		case $1 in
			('v'|'variable') 
				for loop in mode_out mode_edit format_default file file_type file_format
				do
					dale:debug log "$(eval echo -n $loop:\$$loop)"
				done
				;;
			('l'|'log')
				[[ "${mode_out}" == 'verbose' ]] && echo "dale:debug:log:[${*:2}]" | sed -e 's/:]$/:<null>]/g'
				;;
		esac
	}

	function dale:argcheck:0(){
		local argcheck0loop='yes'
		while [[ ${argcheck0loop} != 'no' ]];do
			case ${1} in
				('-v'|'--verbose')
					mode_out='verbose'
					;;
				('-s'|'--silence')
					mode_out='silence'
					;;
				('-h'|'--help')
					dale:usage default
					dale:debug log "dale:argcheck:0:loopstop"
					argcheck0loop='no'
					;;
				(*) 
					dale:debug log "dale:argcheck:0:loopstop"
					argcheck0loop='no'
					;;
			esac
			shift
		done
	}

	function dale:argcheck:1(){
		local argcheck1loop='yes'
		while [[ ${argcheck1loop} != 'no' ]];do
			#if new
			if [[ =~ ]]
			#case old
			case ${1} in #write, delete, get, list, rename, reformat, data
				('-w'|'--write')
					mode_edit='write'
					;;
				('-d'|'--delete')
					mode_edit='delete'
					;;
				('-g'|'--get')
					mode_edit='get'
					;;
				('-l'|'--list')
					mode_edit='list'
					;;
				('--rename')
					mode_edit='rename'
					;;
				('--reformat')
					mode_edit='reformat'
					;;
				('--data')
					mode_edit='data'
					;;
				(*) 
					dale:debug log "dale:argcheck:1:loopstop"
					argcheck1loop='no'
					;;
			esac
			shift
		done
	}

	function dale:main(){
		dale:argcheck:0 "$@"
		dale:debug variable
	}
	dale:main "$@"
	unset dale:{argcheck:{0,1},main} 2>/dev/null
}
dale "$@"
