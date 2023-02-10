#!/usr/bin/env ksh
#check datediff.sh debug log
#pipe debug log from datediff,sh to this script!

pl() { 	echo $line "    [$n]" ;}

sed -e 's/sh=// ;s/dd=//' -e 1,3d -e 's/^.*|\s*//' |
while read Y M W D H MIN S  y m w d h min s
do 	((++n))
	line="sh=$Y $M $W  $D $H $MIN $S  dd=$y $m $w  $d $h $min $s"
	{ [[ ! $s ]] || [[ ! $S ]] ;} && echo bad line $n -- $lineX >&2

	#TESTS
	#here, we can check both shell and C-code datediff results (compound range).
	#easy to compare fields: UPPERCASE are for shell datediff
	#and lowercase are for C-code datediff.

	#((w>4)) && pl                          ##ddiff weeks>4##
	#((W==4)) && ((D<4)) && ((w<=4)) && pl  ##sh weeks==4, days<4 and ddiff weeks<=4##
	#((M+1==m)) && pl                       ##sh months is more refined than ddiff at the months/weeks interface##
	#((m+1==M)) && pl

	#((w>4)) || { ((W==4)) && ((D<4)) && ((w<=4)) ;} || pl

done

