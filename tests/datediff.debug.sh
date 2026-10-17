# datediff.debug.sh
# oct/2026   mountaineerbr
# run checks against `c-code datediff' and `c-code date'
# this function must be under `$PATH' or `$PWD' to be sourced

#Execute result checks against c-code `datediff' and `date'.
#GNU date preferably. Input must be well-formatted ISO8601.
#The function expects UTC while `date' may set random offsets.
#RFC checks may require "export LC_TIME=C TZ=UTC" before invocation.

# POSIX syntax required here so ksh93 uses dynamic scope
# to inspect local variables in the caller's frame.
debugf()
{
		unset unix2t unix1t buf date_cmd ranget utc2t utc1t rfc2t rfc1t ddout y_dd mo_dd w_dd d_dd h_dd m_dd s_dd dd brk  #ret

		date_cmd="$DATE_CMD" DATE_CMD="${DATE_CMD_DEBUG:-date}"
		#warning: variables for `datefun()' may have already been set at this point
		
		if ((TZs)) || [[ $TZ = *:*:*:* ]] ||
			[[ $tzA = *:*:*:* ]] || [[ $tzB = *:*:*:* ]]
		then
			echo "warning: \`datediff' and \`date' may not take offsets with seconds" >&2
			((ret+=230))
		fi

		if [[ $2 != *[Tt:]*[+-]$GLOBTZ ]] ||
			[[ $1 != *[Tt:]*[+-]$GLOBTZ ]]
		then
			echo "warning: input dates are missing offset/tz bits!" >&2
		fi
		if [[ -z $1 || -z $2 ]]
		then 	if [[ $date_cmd = [Ff][Aa][Ll][Ss][Ee] ]] || ((OPTDD>1))
			then 	set -- "${1:-$EPOCH}" "${2:-$EPOCH}"
			else 	set -- "${1:-$(datefun "+${TIME_ISO8601_FMT}")}" "${2:-$(datefun "+${TIME_ISO8601_FMT}")}"
				##set -- "$(colonisef "${1}")" "$(colonisef "${2}")"
			fi
		fi

		unix2t=$(datefun "$2" +%s) || ((ret+=1))
		unix1t=$(datefun "$1" +%s) || ((ret+=1))
		if ((unix1t>unix2t))  #sort dates
		then 	set -- "$2" "$1" ;buf=$unix1t unix1t=$unix2t unix2t=$buf
		fi
		((ranget=unix2t-unix1t))

		utc2t=$(datefun "$2" "+${TIME_ISO8601_FMT}") utc1t=$(datefun "$1" "+${TIME_ISO8601_FMT}")
		## note: "%z" does not colonise tz offsets
		##utc2t=$(colonisef "$utc2t") utc1t=$(colonisef "$utc1t")

		((OPTRR)) && rfc2t=$(datefun "$2" "+${TIME_RFC5322_FMT}") rfc1t=$(datefun "$1" "+${TIME_RFC5322_FMT}")
		#compound range check against `datediff', offset range between -14h and +14h!

		ddout=$(datediff -f'%Y %m %w %d  %H %M %S' "${1:-$utc1t}" "${2:-$utc2t}") || ((ret+=200))
		read y_dd mo_dd w_dd d_dd  h_dd m_dd s_dd <<<"$ddout"
		dd=(${y_dd#-} $mo_dd $w_dd $d_dd  $h_dd $m_dd $s_dd)
		#sh[] array inherited from mainf()

		{ 	{
				{
				  { ((${#date2_iso8601}==0)) ||
				    [[ ${date2_iso8601%%[+-]0000} = "${utc2t%%[+-]0000}" ]]
				  } &&
				  { ((${#date1_iso8601}==0)) ||
				    [[ ${date1_iso8601%%[+-]0000} = "${utc1t%%[+-]0000}" ]]
				  }  #iso
				} &&
				{ ((!OPTRR)) || {
				    { ((${#date2_iso8601_pr}==0)) ||
				      [[ ${date2_iso8601_pr%%[+-]0000} = "${rfc2t%%[+-]0000}" ]]
				    } &&
				    { ((${#date1_iso8601_pr}==0)) ||
				      [[ ${date1_iso8601_pr%%[+-]0000} = "${rfc1t%%[+-]0000}" ]]
				    }  #rfc
				  }
				}
			} &&

			((unix2==unix2t)) && ((unix1==unix1t)) &&
		 	((range==(unix2t-unix1t) )) &&

			[[ ${sh[*]} = "${dd[*]:-${sh[*]}}" ]]
		} || { 	#brk='\n'
			echo -ne "\033[2K" >&2
			echo ${brk+-e} \
"${TZ-local},${1},${2} | $brk"\
"${date1_iso8601:-x} ${utc1t:-x} | $brk"\
"${date2_iso8601:-x} ${utc2t:-x} | $brk"\
"${date1_iso8601_pr:-x} ${rfc1t:-x} | $brk"\
"${date2_iso8601_pr:-x} ${rfc2t:-x} | $brk"\
"${unix1:-x} ${unix1t:-x} | $brk"\
"${unix2:-x} ${unix2t:-x} | $brk"\
"${range:-x} ${ranget:-x} | $brk"\
"sh=${sh[*]:-err} dd=${dd[*]:-err}"
			((ret+=1))
		}
		DATE_CMD="$date_cmd"

		#((DATE_DEBUG>1)) && return ${ret:-0}  #!# mainf()
		((DATE_DEBUG>1)) && exit ${ret:-0}  #!# debugf()
		return ${ret:-0}
}

