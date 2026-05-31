#!/usr/bin/env ksh
# moon-check.sh  jun/2026  mountaineerbr
# phase_of_the_moon test for datediff.sh
# requires usno lunar phase data

AST=/opt/ast/arch/linux.i386-64/bin
JOBMAX=4
OPTK=1

#convert from day-since-1970 to iso date
#day number since 1970: unix/86400
function dd { 	date -I -u -d @$((${1} * 24*60*60)); }


#mkdir -p ~/tmp/moon-phase/data-usno ~/tmp/moon-phase/debug
cd ~/tmp/moon-phase || exit
pwd >&2

IFS=$'\n'
array=( $(<usno-unix.txt) ) || exit
IFS=$' \t\n'
echo "usno array: ${#array[@]} items" >&2


#. ~/bin/datediff.sh >&2 || exit;


#tsv header
echo "cfactor"$'\t'"errors_total"$'\t'"errors_sum"$'\t'"errors_negative"$'\t'"errors_positive"$'\t'"e_neg_max"$'\t'"e_pos_max"$'\t'"mismatches"

set --  $(seq 2000 2099)

for c in $(seq -- -4000 64 -2029) $(seq -- -2030 2030)  $(seq -- 2031 64 4000)
do
	out=$(

	CFACTOR=$c ~/bin/datediff.sh -m ${@} |
	grep -i -e 'New Moon' -e 'First Quarter' -e 'Full Moon' -e 'Last Quarter' |
	while read d p;
	do
		printf '%s\n' "$(( $( TZ=UTC date -u -d "$d"T00:00:00+00 +"%s" ) / 86400 )) ${p:-err}"
	done | uniq -f 1
	)

	out_n=$(wc -l <<<$out)  #usno-unix.txt 2000-2100: 4953 lines
	((out_n > ${#array[@]}-10 && out_n < ${#array[@]}+10 )) ||
		! echo "WARNING: list: items=$n cfactor=$c" >&2

	#printf '%s\n' "$out" >debug/debug-$c.txt || exit

	n= m= e= e_neg_most= e_pos_most= phase_old=
	e_neg= e_pos= e_sum= e_total= mismatch=
	while read day phase
	do
		[[ -n $day ]] || { echo skip empty line >&2; continue ;}
		((m++))

		((n)) ||  #find the first new moon "2000-1-6 18:14 New Moon"
		{ [[ $phase = *'New Moon'* ]] || continue ;}

		read tgt ph <<< ${array[n]}
		((n++))

		if [[ $phase = $ph ]]
		then
			if (( day == tgt ))
			then
				:
			else
				((++e_total))
				(( e = day - tgt ))

				if (( e < 0 ))
				then
					(( e_neg += e ))
					(( e_sum -= e ))
					(( e_neg_most < e )) || (( e_neg_most = e))

				else
					(( e_pos += e ))
					(( e_sum += e ))
					(( e_pos_most > e )) || (( e_pos_most = e))
				fi
			fi
		else
			((--n));
			echo "PHASE UNSYNC: target='${tgt:-err},$(dd $tgt),${ph:-err}' check='${day:-err},$(dd $day),${phase:-err}' cfactor=${c:-err}" >&2
			((++mismatch))
			phase_old=
		fi

		#check datediff.sh list for consistency
		[[ -z ${phase_old} ]] ||
		case "${phase:-err}" in
		*'New Moon'*)
			[[ $phase_old = *'Last Quarter'* ]]
			;;
		*'First Quarter'*)
			[[ $phase_old = *'New Moon'* ]]
			;;
		*'Full Moon'*)
			[[ $phase_old = *'First Quarter'* ]]
			;;
		*'Last Quarter'*)
			[[ $phase_old = *'Full Moon'* ]]
			;;
		''|err|*)
			! echo "undefined error" >&2
			;;
		esac || echo "BAD SEQUENCE: '${phase_old:-err}' -> '${phase:-err}' on date=${day:-err},$(dd $day) cfactor=${c:-err}" >&2
		phase_old=${phase:-$phase_old}

	done <<< $out

	echo "${c:-err}"$'\t'"${e_total:-0}"$'\t'"${e_sum:-0}"$'\t'"${e_neg:-0}"$'\t'"${e_pos:-0}"$'\t'"${e_neg_most:-0}"$'\t'"${e_pos_most:-0}"$'\t'"${mismatch:-0}"
done
#wait


# NOTES

# The resulting USNO Navy data set needs careful manual curation before use!

# #Phase of the Moon (US Navy API, v4.0.0)
# #usage: moonphase [YYYY-MM-DD] [NUMBER_OF_PHASES]
# moonphase()
# {
# 	local url date nump
# 	date=$(date -u -Idate ${1:+-d"$1"}) || date=$1
# 	nump=${2:-10}  #number of phases < 100
# 	url="https://aa.usno.navy.mil/api/moon/phases/date?date=${date:0:10}&nump=${nump:0:2}"
#
#	curl "$url" | jq -r '.phasedata[]|"\(.year)-\(.month)-\(.day)\t\(.time)\t\(.phase)"'
# }
# #https://aa.usno.navy.mil/data/MoonPhases
# #https://aa.usno.navy.mil/data/api#phase

# #Fetch moon phase data from 2000 to 2100
# for ((y=2000;y<2100;y++))
# do
# 	for ((m=1;m<=12;m++))
# 	do
# 		((${#m}<2)) && mm=0$m || mm=$m
# 		t="./$y-$mm.txt"
# 		[[ -s "$t" ]] && continue 1
#
# 		moonphase "$y-$mm-01" 10 | tee "$t" || rm -fv "$t"
#
# 		[[ -s $t ]] || rm -fv "$t"
#
# 		sleep 1
# 	done
# done

# USNO Navy data sample
# % moonphase 2020-01-01
# 2020-1-3	04:45	First Quarter
# 2020-1-10	19:21	Full Moon
# 2020-1-17	12:58	Last Quarter
# 2020-1-24	21:42	New Moon
# 2020-2-2	01:42	First Quarter

# Catenate data and keep only the first entry on overlay:
# cat ./data-usno/*txt | { awk '!visited[$0]++' ;} | tee ./usno.txt

# Convert dates to day-since-1970 format:
# while read d t p; do printf '%s\n' "$(( $(TZ=UTC date -u -d "$d"T00:00:00+00 +"%s") / 86400 )) $p"; done < usno.txt  > usno-unix.txt

