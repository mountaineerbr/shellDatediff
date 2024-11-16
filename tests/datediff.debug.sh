# datediff.debug.sh v0.25
# Function for `mountaineer's `chatgpt.sh''

# Option -d sets TZ=UTC, unsets verbose switches and run checks
# against \`C-code datediff' and \`C-code date'. Set once to dump
# only when results differ and set twice to code exit only.

#Copy the function body to where debugf() is in `chatgpt.sh' (fast).
#Otherwise this function must be under your `$PATH' to be sourced.

#Execute result checks against `datediff' and `date'.
#GNU date preferably. Input must be well-formatted ISO8601.
#We defaults to UTC while `date' may set random offsets.
function debugf
{
		unset unix2t unix1t buf d_cmd ranget utc2t utc1t rfc2t rfc1t ddout y_dd mo_dd w_dd d_dd h_dd m_dd s_dd dd brk ret
		d_cmd="$DATE_CMD" DATE_CMD="${DATE_CMD_DEBUG:-date}"

		[[ $d_cmd = [Ff][Aa][Ll][Ss][Ee] ]] && [[ -z $TZ ]] && TZ=UTC+0
		if ((TZs)) || [[ $TZ = *:*:*:* ]] || [[ $tzA = *:*:*:* ]] || [[ $tzB = *:*:*:* ]]
		then 	echo "warning: \`datediff' and \`date' may not take offsets with seconds" >&2
			((ret+=230))
		fi
		if [[ $2 != *[Tt:]*[+-]$GLOBTZ ]] || [[ $1 != *[Tt:]*[+-]$GLOBTZ ]]
		then 	echo "warning: input dates are missing offset/tz bits!" >&2
		fi
		if [[ -z $1 || -z $2 ]]
		then 	if [[ $d_cmd = [Ff][Aa][Ll][Ss][Ee] ]] || ((OPTDD))
			then 	set -- "${1:-$EPOCH}" "${2:-$EPOCH}"
			else 	set -- "${1:-$(datefun -Isec)}" "${2:-$(datefun -Isec)}"
			fi
		fi

		unix2t=$(datefun "$2" +%s) unix1t=$(datefun "$1" +%s)
		if ((unix1t>unix2t))  #sort dates
		then 	set -- "$2" "$1" ;buf=$unix1t unix1t=$unix2t unix2t=$buf
		fi
		((ranget=unix2t-unix1t))
		
		utc2t=$(datefun -Isec "$2") utc1t=$(datefun -Isec "$1")
		((OPTRR)) && rfc2t=$(datefun -R "$2") rfc1t=$(datefun -R "$1")

		#compound range check against `datediff', offset range between -14h and +14h!
		ddout=$(datediff -f'%Y %m %w %d  %H %M %S' "${1:-$utc1t}" "${2:-$utc2t}") || ((ret+=250))
		read y_dd mo_dd w_dd d_dd  h_dd m_dd s_dd <<<"$ddout"
		dd=(${y_dd#-} $mo_dd $w_dd $d_dd  $h_dd $m_dd $s_dd)

		{ 	{ 	{ [[ ${date2_iso8601:0:25}    = ${utc2t:0:25} ]] &&
				  [[ ${date1_iso8601:0:25}    = ${utc1t:0:25} ]] #iso
				} ||
				{ [[ ${date2_iso8601_pr:0:25} = ${rfc2t:0:25} ]] &&
				  [[ ${date1_iso8601_pr:0:25} = ${rfc1t:0:25} ]] #rfc
				}
			} &&

			((unix2==unix2t)) && ((unix1==unix1t)) &&
		 	((range==(unix2t-unix1t) )) &&
			
			[[ ${sh[*]} = "${dd[*]:-${sh[*]}}" ]]
		} || { 	#brk='\n'
			echo -ne "\033[2K" >&2
			echo ${brk+-e} \
"${TZ},${1},${2} | $brk"\
"${date1_iso8601:0:25} ${utc1t:0:25} | $brk"\
"${date2_iso8601:0:25} ${utc2t:0:25} | $brk"\
"${date1_iso8601_pr:0:25} ${rfc1t:0:25} | $brk"\
"${date2_iso8601_pr:0:25} ${rfc2t:0:25} | $brk"\
"${unix1} ${unix1t} | $brk"\
"${unix2} ${unix2t} | $brk"\
"${range} ${ranget} | $brk"\
"sh=${sh[*]} dd=${dd[*]}"
			((ret+=1))
		}
		DATE_CMD="$d_cmd"

		#((DEBUG>1)) && return ${ret:-0}  #!#
		((DEBUG>1)) && exit ${ret:-0}  #!#
		return ${ret:-0}
}

