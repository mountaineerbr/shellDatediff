# shellDatediff
Calculate time differences with shell builtins.


![Showing off datediff.sh script](https://gitlab.com/mountaineerbr/etc/-/raw/main/gfx/datediff_intro.gif)

Shell utility for calculating time intervals between dates. Works with Ksh, Bash and Zsh.

The project contains a small shell library to calculate **elapsed time between dates** as **compound time ranges** and as **single-unit fractions** - all while handling timezone offsets.

The script works with ISO-8601 and UNIX timestamps directly. It can optionally leverage `C-code date` to process diverse date formats as input.

Beyond time intervals, it offers a few helpful calendar functions for day-to-day use.


## ✨ Features

- Date input as *ISO-8601*, or *UNIX time*
- Optionally warps `C-code date` to parse various date formats
- Timezone offset aware, heeds environment `$TZ`
- Check whether year is leap
- Calculate moon / lunar phases
- Calculate Easter, Carnaval, and Corpus Christi dates
- Check for next Friday the 13th (or any day-of-week/month combination)
- _Stdin_ _input_ (pipe) support


## Usage Examples

### Time elapsed between two dates

```
% datediff.sh -u  2008-01-15  2024-09-11

DATES
2008-01-15T00:00:00+00:00       1200355200
2024-09-11T00:00:00+00:00       1726012800
RANGES
16Y 07M 03W 06D  00h 00m 00s
16.7 years | 199.9 months | 869.1 weeks | 6084.0 days | 146016.0 hours | 8760960.0 mins | 525657600 secs
```

`Option -u` sets dates as UTC time and it also influences how the underlying `C-code date` programme processes dates.

Setting the last argument of the command line to exactly `y`, `mo`, `w`, `d`, `m`, or `s` will print only the [specified time frame result](#-single-time-unit-result).

Alternatively, set `options -vvv` to filter the main output layout for specific fields.

For example, print the **compound time range** _only_:


```
% datediff.sh -vv  2025-03-30T12:33:58  2031-04-17T04:34:10

6Y 00M 02W 03D  16h 00m 12s
```

Mind that input dates must be ISO-8601 or UNIX time.
When available, `C-code date` is leveraged to parse
user input in various date formats.

<!-- 
To avoid wrapping the `C-code date` programme to process dates,
set `options -DD`. -->


### Result layout

The main function is very verbose by default and
prints two sections with processed dates (**DATES**) and time range results (**RANGES**).

The user can filter out which fields are going to be calculated and printed.

Set the verbose `option -v` up to three times to select different layouts in
the main function. Setting `-v` in other functions decrease verbose.


Set **option -v** once to print all single unit results _only_:

```
% datediff.sh -v  2008-01-15
17.4 years | 209.3 months | 910.3 weeks | 6371.8 days | 152923.3 hours | 9175400.5 mins | 550524032 secs
```

**Note:** if only one date is specified,
the first date is assumed to be **now**.
. <!-- (or **1970** as last fallback). -->


<!--
Compound time range _only_:

```
% datediff.sh -vv 2008-01-15

16Y 10M 00W 03D  21h 25m 28s
```
-->


Compound time range (`AST date` style):

```
% datediff.sh -vvv  2008-01-15

16Y10M00W03D21h25m34s
```


### Single time unit result

The user can optionally set the last positional parameter as exactly
`y`, `mo`, `w`, `d`, `m` or `s` to print only the specific single-unit result:


```
% datediff.sh  2008-01-15  2025-06-25  mo

209.3 months
```


### Decimal plates

The number of decimal plates shown in float results can be set with `option -[num]`,
where _num_ is an integer. For three decimal plates, the incantation should start as
`datediff.sh -3`.

Results are subject to rounding for improved precision!


### Table view

There is also a table layout with single-unit results. This is activated with
`option -t`.

To **print results in the table layout**, set `options -tt`
at the command line incantation:


```
% datediff.sh -3 -t -u  2008-01-15  2024-12-14
Years          16.913
Months        202.968
Weeks         882.571
Days         6178.000
Hours      148272.000
Mins      8896320.000
Secs    533779200
```


### Check when **next Friday the 13th** is:

```
% datediff.sh -F  Fri 13

Fri, 13 Oct 2023 is  245 days away
```

Optionally set a *start date*.  <!-- following date -->


Check any combination of **day-in-week** and **day-in-month**:

```
% datediff.sh -F  Mon 1  2025-06-25

Mon, 01 Sep 2025 is   68 days away
```

Set `options -FF` to get the next 10 dates.


### Check whether a **year is leap**

```
% datediff.sh -l 2023

not leap year -- 2023
```

The _exit code is 1_ if a year _is not_ leap.

Set `option -v` to decrease verbose. 


### Generate **lunar phase calendar**

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

For multiple-month calendar:

```
% datediff.sh -m 2024-{02..12}
```


### Calculate dates of **Carnaval**, **Easter** and **Corpus Christi**

```
% datediff.sh -ee  2023

  Carnaval          Easter      CorpusChristi
2023-02-21      2023-04-09      2023-06-08
```

Set multiple years to generate a table of dates:
<!-- a nice `TSV`-formatted table -->

```
% datediff.sh -ee  20{23..30}
  Carnaval          Easter      CorpusChristi
2023-02-21      2023-04-09      2023-06-08
2024-02-13      2024-03-31      2024-05-30
2025-03-04      2025-04-20      2025-06-19
2026-02-17      2026-04-05      2026-06-04
2027-02-09      2027-03-28      2027-05-27
2028-02-29      2028-04-16      2028-06-15
2029-02-13      2029-04-01      2029-05-31
2030-03-05      2030-04-21      2030-06-20
```

The dates are for the Western Church.


## More Examples

Check further [examples at the man page](man#examples).


## Dependencies

- `Ksh93`, `Bash`, or `Zsh`
- `GNU`/`BSD`/`AST`/`Busybox` `date` (optional)
- Basic Calculator `bc` and Desk Calculator `dc` (optional)


### Debugging dependencies

- `datedff.debug.sh` script
- Hroptatyr's `C-code datediff`


## Help

Please, check script help page with `datediff.sh -h`
or the [online man page](man/README.md).


## Project Source

- GitLab <https://gitlab.com/fenixdragao/shelldatediff>
- GitHub <https://github.com/mountaineerbr/shellDatediff>

Extensively tested, see [testing scripts](tests/), [notes](tests/d-test.sh#L78-L186), and [man page](man/README.md).


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
