#!/usr/bin/env bash
#datediff.sh unix_toiso() test

. ~/bin/datediff.sh 1>/dev/null 2>&1
set --
export TZ

u_start=$(date -u -d 1969-01-01 +%s)    #2170-03-01
u_end=$(date -u -d 1970-12-31 +%s)      #1768-01-01  RANDOM%
echo time = $u_start,$u_end = $((${u_start#-}+${u_end#-}))

for ((u=u_start;u<u_end;++u))
do
	((++n))
	((TZ_neg = n%2?+1:-1 ))
	((TZh = (RANDOM%24), TZm = (RANDOM%60) ))
	[[ $TZ_neg != -* ]] && TZ_neg=+$TZ_neg
	((${#TZh}==1)) && TZh=0$TZh
	((${#TZm}==1)) && TZm=0$TZm
	TZ=UTC${TZ_neg%1}$TZh:$TZm

	a=$(unix_toiso "$u" \
		"$neg_tz" "$tzh" "$tzm" "$tzs" \
		"$TZ_neg" "$TZh" "$TZm" "$TZs"
	)
	a="${a/-00:00:00/+00:00:00}"
	
	c=$(unix_toiso -R "$u" \
		"$neg_tz" "$tzh" "$tzm" "$tzs" \
		"$TZ_neg" "$TZh" "$TZm" "$TZs"
	)
	c="${c/-00:00:00/+00:00:00}"
	
	((uu=u+( ( (tzh*60*60)+(tzm*60)+tzs)*neg_tz)-( ( (TZh*60*60)+(TZm*60)+TZs)*TZ_neg) ))
	aa=${DAY_OF_WEEK[( ( (uu+(uu<0?1:0))/(24*60*60))%7 +(uu<0?6:7))%7]}
	aa=${aa:0:3}
	b=$(date -Isec -d "@$u")
	bbc=$(date -R   -d "@$u") bbc="${bbc:0:29}:${bbc:29:2}"
	bb=${bbc:0:3}


	[[ ${a%???} = "$b" && $aa = "$bb" && ${c%???} = "$bbc" ]] || {
		echo  "$aa ${a%???} | $bb $b | $c $bbc | unix=$u $uu TZ=$TZ" | tee ~/log.err.txt
		((++ne))
	}
	((n%3001)) || echo "$aa ${a%???} | $bb $b | $c $bbc | unix=$u,$uu TZ=$TZ [${ne:-0}/$n] ($(($n/$SECONDS)))" | tee ~/log.txt
done

print
print

#usage: unix_toiso [-R] UNIX [+1|-1] [tzXh] [$tzXm] [tzXs] [+1|-1] [TZh] [$TZm] [TZs]
