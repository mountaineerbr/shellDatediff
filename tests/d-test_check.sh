#!/usr/bin/env ksh
# d-test_check.sh  jun/26  by mountaineerbr
# filter datediff.debug.sh log
# pipe debug log from datediff.sh to this script!

function pl { 	printf '%s\n' "$line    [$n]    $dates${1:+    $1}" ;}


sed -e 's/sh=// ;s/dd=//' -e 1,3d -e 's/\s*|\s*.*|\s*/ /' |
while read  dates  Y M W D H MIN S  y m w d h min s
do
	((++n))
	line="sh=$Y $M $W  $D $H $MIN $S  dd=$y $m $w  $d $h $min $s"
	{ [[ ! -n "$s" ]] || [[ ! -n "$S" ]] ;} && echo "bad line $n -- ${dates:-err}" >&2

	#TEST EXAMPLES
	#Compare shell and c-code datediff results.
	#UPPERCASE vars are for shell datediff.sh,
	#and lowercase are for c-code datediff.

	#((w>4)) && { pl; continue; }  # c-code ddiff weeks>4
	#((W==4)) && ((D<4)) && ((w<=4)) && { pl; continue ;}  # shell weeks==4, days<4 and ddiff weeks<=4
	#((w>4)) || { ((W==4)) && ((D<4)) && ((w<=4)) ;} || { pl; continue ;}  # c-code ddiff related

	#((M+1==m)) && ((W>=4)) && { pl; continue; }  # shell is more granular
	#((M==m+1)) && ((w>=4)) && { pl; continue; }  # c-code more refined

	((S==s && MIN==min && H==h)) || pl  # same seconds, minutes, and hours

done
echo $'\n' >&2
echo "N=${n:-err}"

