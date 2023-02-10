#!/usr/bin/env ksh
echo $KSH_VERSION $BASH_VERSION ;date -R
echo 'USAGE: d-test.sh "[path/datediff.sh]" "[month..]" "[day..]"' >&2
export DEBUG=2
export TZ

src="$HOME/bin/datediff.sh"
[[ -e $1 ]] && { 	src="$1" ;set -- "${@:2}" ;}
echo "SOURCE: $src" >&2
. "$src" -D >&2  #flag -D disables package `date' warping


function signf { 	((RANDOM%2)) && echo + || echo - ;}

for y in  1988  1989  #also test with: 1940 1941
do 	for m in ${1:-1 2 3  6  11 12}
	do 	((${#m}==2)) || m=0$m
		echo "MONTH=$m"
		for d in ${2:-1 2 3   27 28 29 30 31}
		do 	((${#d}==2)) || d=0$d
			for h in 0 1  12  23
			do 	((${#h}==2)) || h=0$h
				for min in 0 1  59
				do 	((${#min}==2)) || min=0$min
					for s in 0 1  59
					do 	((${#s}==2)) || s=0$s
	(( d <= $(month_maxday $m $y) )) || continue
	
	((tzh=RANDOM%15)); ((tzm=RANDOM%60)); ((${#tzh}==2)) || tzh=0$tzh; ((${#tzm}==2)) || tzm=0$tzm
	D1="$y-$m-${d}T$h:$min:$s$(signf)${tzh:-00}:${tzm:-00}"
	#dates must have time zone, even if set to +00:00

		for Y in 1989 1988  #also test with: 1941 1940
		do 	for M in 1 2 3  5  10 12
			do 	((${#M}==2)) || M=0$M
				for D in 1 2 3 4  27 28 29 30 31
				do 	((${#D}==2)) || D=0$D
					for H in 0 1    23
					do 	((${#H}==2)) || H=0$H
						for MIN in 0 1  58
						do 	((${#MIN}==2)) || MIN=0$MIN
							for S in 0 1  58
							do 	((${#S}==2)) || S=0$S
			(( D <= $(month_maxday $M $Y) )) || continue

			((tzh=RANDOM%15)); ((tzm=RANDOM%60)); ((${#tzh}==2)) || tzh=0$tzh; ((${#tzm}==2)) || tzm=0$tzm
			D2="$Y-$M-${D}T$H:$MIN:$S$(signf)${tzh:-00}:${tzm:-00}"

			#$TZ OFFSET/TIME-ZONE TEST
			((TZ_neg = n%2?+1:-1 ))
			((TZh = RANDOM%15 )); ((TZm = RANDOM%60 ))
			[[ $TZ_neg != -* ]] && TZ_neg=+$TZ_neg
			((${#TZh}==1)) && TZh=0$TZh
			((${#TZm}==1)) && TZm=0$TZm
			TZ=UTC${TZ_neg%1}$TZh:$TZm

			{
				p=$(mainf "$D1" "$D2") || { 	echo >&2 ;echo "$p" ;}
			} &
			printf '\033[2K%s | %s\t(%d) [%d] {%d}\r' "$D1" "$D2" $((++n)) $SECONDS $((n/(SECONDS+1))) >&2
							done
						done
					done
				done
			done
		done
					done
				done 
			done
		done
	done
	wait
	echo "n=$n ($y)"
done
wait
echo "N=$n"

#NOTES
#Year 1988==4405104; Year 1989==4304988; total==8.710.092
#2*6*8*4*3*3 * 9*3*3*3*2*6 == 10077696

#Note input dates must have time zone, even if set to +00:00, to avoid
#debug checkign errors as `date' programme has got undefined behaviour
#interpreting dates without timezone settings!

#LOG
##v0.16.6
#Compound range testing:
#.35171, about 35% of errors detected in testing are `datediff' only errs (9720/27644).
#.1554,  about 16% of errors is from wrong shell arithmetics compensation for start-and-end-of-month days. 
#.10577, about 11% of error testing results are due to shell arithmetics outputting negative days.
#.04720, at least 5% of other times we are probably right, too, as well as `datediff' (different ways of counting).
#
##v0.16.7    (addon2)
#.4570, about 45% of errors detected in testing are `datediff' only errs (12636/27644) (compound range).
#Result differences remain the same, we detect false-positive errors thanks to addon2 code.
#It fixes most negative day ranges but takes apart a full month in these cases, which makes result more refined than `datediff' and equally correct.
#
##v0.16.8    (addon2+addon3)
#Addon3 prevents breaking a full month from count and delivers correct results, specially when dayA is `31'. 
#Result differences remain the same, we detect false-positive errors thanks to addon3 code. We cannot really see bad range results any more but we note that we count differently than `datediff' in some cases.
#
#Testing was performed on 4,405,104 pairs of dates for 1988 vs. 1989 (compound range):
#.00311, `datediff' error rate is at least 3% of total dates tested.
#.006275, a 0,62% of error rate of total dates tested was produced.
#Errors are understood as results that differ from `datediff' and may be false-positive errors (just different counting refinements).
#.45709, `datediff' errs account for about 45% (12636/27644) of one testing error type (eights and nines as resulting weeks) while our results seems correct in those cases.
#.03885 `datediff' accounts for almost 4% more errs of another type (start-and-end-of-month dates), while our results seem correct in those cases.
#.4959, thus almost 50% of testing errors are only `datediff'.
#Remaining date results match although with different refinements (our results are little more refined than `datediff').

#OLDER LOG FROM SCRIPT SOURCE
# Hroptatyr's `man datediff' says ``refinement rules'' cover over 99% cases.
# Calculated C-code `datediff' error rate is at least 0.26% of total tested dates (compound range).
# Results differ from C-code `datediff' in the ~0.6% of all tested dates in script v0.21 (compound range).
# All differences occur with ``end-of-month vs. start-of-month'' dates, such as days `29, 30 or 31' of one date against days `1, 2 or 3' of the other date.
# Different results from C-code `datediff' in compound range are not necessarily errors in all cases and may be considered correct albeit with different refinements. This seems to be the case for most, if not all, other differences obtained in testing results.
# A bug was fixed in v0.20 in which UNIX time generationw was affected. No errors were found in range (seconds) calculation since. 
# Note `datediff' offset ranges between -14h and +14h.
# Offset-aware date results passed checking against `datediff' as of v0.21.
#Ksh exec time is ~2x faster than Bash (main function).
#
#NOTES
##Time zone / Offset support
#dbplunkett: <https://stackoverflow.com/questions/38641982/converting-date-between-timezones-swift>
#-00:00 and +24:00 are valid and should equal to +00:00; however -0 is denormal;
#support up to `seconds' for time zone adjustment; POSIX time does not
#account for leap seconds; POSIX time zone definition by the $TZ variable
#takes a different form from ISO8601 standards; environment $TZ applies to both dates;
#it is easier to support OFFSET instead of TIME ZONE; should not support
#STD (standard) or DST (daylight saving time) in timezones, only offsets;
# America/Sao_Paulo is a TIMEZONE ID, not NAME; `Pacific Standard Time' is a tz name.
#<https://stackoverflow.com/questions/3010035/converting-a-utc-time-to-a-local-time-zone-in-java>
#<https://www.iana.org/time-zones>, <https://www.w3.org/TR/NOTE-datetime>
#<https://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html>
##A year zero does not exist in the Anno Domini (AD) calendar year system
#commonly used to number years in the Gregorian calendar (nor in its
#predecessor, the Julian calendar); in this system, the year 1 BC is
#followed directly by year AD 1. However, there is a year zero in both
#the astronomical year numbering system (where it coincides with the
#Julian year 1 BC), and the ISO 8601:2004 system, the interchange standard
#for all calendar numbering systems (where year zero coincides with the
#Gregorian year 1 BC). In Proleptic Gregorian calendar, year 0000 is leap.
#<https://docs.julialang.org/en/v1/stdlib/Dates/>
#Serge3leo - https://stackoverflow.com/questions/26861118/rounding-numbers-with-bc-in-bash
#MetroEast - https://askubuntu.com/questions/179898/how-to-round-decimals-using-bc-in-bash
#``Rounding is more accurate than chopping/truncation''.
#https://wiki.math.ntnu.no/_media/ma2501/2016v/lecture1-intro.pdf
##Negative zeros have some subtle properties that will not be evident in
#most programs. A zero exponent with a nonzero mantissa is a "denormal."
#A denormal is a number whose magnitude is too small to be represented
#with an integer bit of 1 and can have as few as one significant bit.
#https://www.lahey.com/float.htm
##4.3. Unknown Local Offset Convention
##   If the time in UTC is known, but the offset to local time is unknown,
##   this can be represented with an offset of "-00:00".  This differs
##   semantically from an offset of "Z" or "+00:00", which imply that UTC
##   is the preferred reference point for the specified time.  RFC2822
##   [IMAIL-UPDATE] describes a similar convention for email.


#LIMITS
#	Testing on ARM reveals that shell arithmetics can only count up
#	to 2,147,483,647 seconds (~68 years) for the FP results of single
#	units of time interval. That number is one decrement below
#	(2^32 / 2) = (4294967296 / 2) = 2147483648  because there is no
#	bits left for a double point after that (there is still a bit left
#	for the sign). That is why Bc is prefered instead of shell FP
#	arithmetics. On desktop architecture, shell FP maths may work
#	with a broader range.
#
#	The compound time interval, and the UNIX time generation facility
#	of the script, though, should work for much larger lengths of time.
#	Those functions work with shell integer arithmetics which have
#	got a limit of 19 digits. It should work with time intervals up
#	to about 9,223,372,036,854,775,807 seconds, which is about
#	292 billions years!
#
#	Please check limitations of \`date' programme of your system!
#
#	The moon phase function (adapted and improved from HackLib) is
#	a quantized version (only 8 phases) of formula and is only an
#	approximation of reality.
#
#	\`\`The definition of Easter as \`the first Sunday after the first
#	full moon occurring on or after the vernal equinox' seems precise,
#	but accurate determination of the full moon and the vernal equinox
#	is quite complex in reality, and simpler approximations are used
#	in practice'' -- Dershowitz and Reingold.


