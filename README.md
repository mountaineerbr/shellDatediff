# shellDatediff
Calculate time differences with Ksh, Bash and Zsh built-ins.

![Showing off datediff.sh script](https://gitlab.com/mountaineerbr/etc/-/raw/main/gfx/datediff_intro.gif)

The project contains a small shell library to calculate elapsed time
between two dates in various time units and some extra functions.

Results are delivered in different units taking into account all time
units (*compound time range*), or as a fractional single time unit.

The script warps `GNU`/`BSD` `C-code date` programme to process input
date strings in various formats (main function), otherwise
input must be *ISO-8601* or *UNIX* times.

Extensively tested, see [testing scripts](tests/), [notes](tests/d-test.sh#L78-L186), and [man page](man/README.md).


## ✨ Features

- Date input as *ISO-8601*, or *UNIX times*. Optionally, warps `C-code date`.
- Date offset aware, heeds environment `$TZ`
- Check whether year is leap
- Check moon / lunar phases
- Check Easter, Carnaval, and Corpus Christi dates
- Check for next Friday the 13th


## Usage Examples

### Time elapsed from *January 15th, 2008* to *now*

```
% datediff.sh -u 2008-01-15
DATES-
2008-01-15T00:00:00+00:00       1200355200
2024-09-11T16:15:34+00:00       1726071334
RANGES
16Y 07M 03W 06D  16h 15m 34s
16.7 years | 376.6 months | 869.2 weeks | 6084.7 days | 146032.3 hours | 8761935.6 mins | 525716134 secs
```

Note that `option -u` sets dates as UTC time. The second date is empty and defaults to *now*.

`Option -u` primarily influences the behavior of the underlying `C-code date` program and the shell's `printf` time builtins.

For direct execution without wrapping the `C-code date` programme, use either the `-D` or `-DD` option.

Note that in these cases, input dates *must* be in ISO-8601 format or UNIX timestamps, and timezone offsets are significant.


### Check when next *Friday the 13th* is

```
% datediff.sh -F Fri 13
Fri, 13 Oct 2023 is  245 days away
```

Obs: set -FF to get the next 10 dates.


### Check whether year 2023 *is leap*

```
% datediff.sh -l 2023
not leap year -- 2023
```

Obs: exit code 1 if year is not leap.


### Generate the *lunar phase calendar* for *February, 20023*

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


### Generate dates for 2023 *Carnaval*, *Easter* (western church) and *Corpus Christi* dates

```
% datediff.sh -ee 2023
  Carnaval          Easter      CorpusChristi
2023-02-21      2023-04-09      2023-06-08
```

Obs: set multiple years to get a nice `TSV`-formatted output.


## Requirements

- `Ksh93`, `Bash`, or `Zsh`
- `GNU`/`BSD`/`AST`/`Busybox` `date` (optional)
- `Bc` (optional)


## Help

Please, check script help page with `datediff.sh -h`.


## Project Source

- GitLab <https://gitlab.com/fenixdragao/shelldatediff>
- GitHub <https://github.com/mountaineerbr/shellDatediff>


## See Also

- C-code `dateutils/datediff`, *Hroptatyr*, <http://www.fresse.org/dateutils/>.
- Python `PDD`, *Jarun*,	<https://github.com/jarun/pdd>.
- *AST* `date`, see elapsed time option -E, <https://github.com/att/ast>.
- *GNU* `units`, <https://www.gnu.org/software/units/>.
- \`\`Calendrical calculation'', *Dershowitz* and *Reingold*, 1990,	<http://www.cs.tau.ac.il/~nachum/papers/cc-paper.pdf>.



<!--

	Please, consider sending me a nickle!
		=) 	bc1qlxm5dfjl58whg6tvtszg5pfna9mn2cr2nulnjr

        -->
