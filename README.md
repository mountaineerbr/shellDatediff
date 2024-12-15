# shellDatediff
Calculate time differences with Ksh, Bash and Zsh built-ins.

![Showing off datediff.sh script](https://gitlab.com/mountaineerbr/etc/-/raw/main/gfx/datediff_intro.gif)

The project contains a small shell library to calculate elapsed time
between two dates in various time units and some extra functions for
day-to-day use.

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
- Get input from _stdin_


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

When only one date is specified, the first date is assumed to be *now* or *1970*.

Note that `option -u` sets dates as UTC time and it influences how the underlying `C-code date` programme works.

To test the shell built-in code for the ISO-8601 and UNIX times tamp processing and conversion
without wrapping the `C-code date` programme, set `options -DD`.

Setting the last argument of the command line to exactly `y`, `mo`, `w`, `d`, `m`, or `s` will print only the specified time frame result.

Alternatively, set `options -vvv` to filter the main output layout for specific fields.

For example, print the **compound time range** _only_:


```
% datediff.sh -vv tomorrow+6years+400hours+12seconds

6Y 00M 02W 03D  16h 00m 12s
```


### Result layout

The main function is very verbose by defaults and
prints two sections with processed dates (**DATES**) and time range results (**RANGES**).

The user can filter out which fields are going to be calculated and printed.

Set the verbose `option -v` up to three times to select different layouts in
the main function. Setting `-v` in other functions decrease verbose.


All single unit results _only_:

```
% datediff.sh -v 2008-01-15

16.8 years | 378.8 months | 879.0 weeks | 6152.9 days | 147669.4 hours | 8860165.2 mins | 531609914 secs
```

<!--
Compound time range _only_:

```
% datediff.sh -vv 2008-01-15

16Y 10M 00W 03D  21h 25m 28s
```
-->


Compound time range (`AST date` style):

```
% datediff.sh -vvv 2008-01-15

16Y10M00W03D21h25m34s
```


### Single time unit result

The user can optionally set the last positional parameter as exactly
`y`, `mo`, `w`, `d`, `m` or `s` to print only the specific single-unit result:


```
% datediff.sh 2008-01-15  mo

378.8 months
```


### Decimal plates

The number of decimal plates shown in float results can be set with `options -[num]`,
where _num_ is an integer. For three decimal plates, the incantation should start as
`datediff.sh -3`.

Results are subject to rounding for improved precision!


### Table view

There is also a table layout with single-unit results. This is activated with
`option -t`.

To **print results in the table layout only**, the user
must set both `options -ttv` at the command line incantation:


```
% datediff.sh -3 -tv 2008-01-15

Years	       16.915
Months	      379.704
Weeks	      882.690
Days	     6178.831
Hours	   148291.953
Mins	  8897517.150
Secs	533851029
```


### Check when next *Friday the 13th* is

```
% datediff.sh -F Fri 13

Fri, 13 Oct 2023 is  245 days away
```

Set `options -FF` to get the next 10 dates.


### Check whether year 2023 *is leap*

```
% datediff.sh -l 2023

not leap year -- 2023
```

The exit code is *1* if a year _is_ _not_ leap.

Set `option -v` to decrease verbose. 


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

Also try `datediff.sh -m 2024-{02..12}` for multiple months!


### Generate dates for *Carnaval*, *Easter* and *Corpus Christi* dates

```
% datediff.sh -ee 2023

  Carnaval          Easter      CorpusChristi
2023-02-21      2023-04-09      2023-06-08
```

Set multiple years to get a nice `TSV`-formatted output.

The dates are for the Western Church.


## Requirements

- `Ksh93`, `Bash`, or `Zsh`
- `GNU`/`BSD`/`AST`/`Busybox` `date` (optional)
- `Bc` and `Dc` (optional)


## Help

Please, check script help page with `datediff.sh -h`
or the [online man page](man/README.md).


## Project Source

- GitLab <https://gitlab.com/fenixdragao/shelldatediff>
- GitHub <https://github.com/mountaineerbr/shellDatediff>


## See Also

- C-code `dateutils/datediff`, *Hroptatyr*, <http://www.fresse.org/dateutils/>.
- Python `PDD`, *Jarun*,	<https://github.com/jarun/pdd>.
- *AST* `date`, see elapsed time _option_ _-E_, <https://github.com/att/ast>.
- *GNU* `units`, <https://www.gnu.org/software/units/>.
- \`\`Calendrical calculation'', *Dershowitz* and *Reingold*, 1990,	<http://www.cs.tau.ac.il/~nachum/papers/cc-paper.pdf>.



<!--

	Please, consider sending me a nickle!
		=) 	bc1qlxm5dfjl58whg6tvtszg5pfna9mn2cr2nulnjr

        -->
