# shellDatediff
Calculate time differences with Ksh, Bash and Zsh

Small shell library to calculate elapsed time between two dates in
various time units.

It uses shell built-ins to deliver results in different units of
time separately or taking account of each other. It may warp `date`
package to process input date strings, otherwise input must be
ISO-8601 or UNIX times.

Extensively tested, see [testing scripts](tests/) and [notes](tests/d-test.sh#L78-L186).


## Features

- Accepts standard ISO-8601 dates and UNIX times
- Aware of date string offset, heeds environment $TZ
- Warps `date` package to process input date strings more easily (specially `GNU date`)
- Retrieve day in the week for a given date
- Check if year is leap
- Check moon phases
- Calculate Easter, Carnaval and Corpus Christi dates
- Check for next Friday 13th (or any combination of weekday + month day)


## Usage Examples

```
% datediff.sh 2008-01-15
DATES-
2008-01-15T00:00:00-02:00       1200362400
2023-02-10T02:35:50-03:00       1676007350
RANGES
15Y 00M 03W 05D  03h 35m 50s
15.1 years | 345.8 months | 786.4 weeks | 5505.1 days | 132123.6 hours | 7927415.8 mins | 475644950 secs
```

```
% datediff.sh -F Fri 13
Fri, 13 Oct 2023 is  245 days away
```

```
% datediff.sh -l 2023
not leap year -- 2023
```

```
% datediff.sh -m 2023-02
2023-02-01  First Quarter
2023-02-02  Waxing Gibbous
2023-02-06  Full Moon
2023-02-09  Waning Gibbous
2023-02-13  Last Quarter
2023-02-17  Waning Crescent
2023-02-20  New Moon
2023-02-24  Waxing Crescent
2023-02-28  First Quarter
```

```
% datediff.sh -ee 2023
  Carnaval          Easter      CorpusChristi
2023-02-21      2023-04-09      2023-06-08
```


## Requirements

- Ksh93, Bash or Zsh
- GNU/BSD/AST/busybox date (optional)
- Bc (optional)


## See Also

- C-code \`dateutils/datediff', Hroptatyr, <http://www.fresse.org/dateutils/>.
- Python \`PDD', Jarun,	<https://github.com/jarun/pdd>.
- AST \`date', see elapsed time option -E, <https://github.com/att/ast>.
- GNU \`Units', <https://www.gnu.org/software/units/>.
- \`\`Calendrical calculation'', Dershowitz and Reingold, 1990,	<http://www.cs.tau.ac.il/~nachum/papers/cc-paper.pdf>.

