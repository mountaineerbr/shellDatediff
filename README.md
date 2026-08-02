# shellDatediff
Calculate time differences with shell builtins.


![Showing off datediff.sh script](https://gitlab.com/mountaineerbr/etc/-/raw/main/gfx/datediff_intro.gif)

Shell utility for calculating time intervals between dates. Works with Ksh, Bash, and Zsh.

The project contains a small shell library to calculate **elapsed time between dates** as **compound time ranges** and as **single-unit fractions**.

The script works with ISO-8601 and UNIX timestamps directly. It can optionally leverage `C-code date` to process diverse date formats as input.

Beyond time intervals, it offers a few helpful calendar functions for day-to-day use.


## Index

<details>
  <summary>★ Click to expand! ★</summary>

- 1. [Features](#-features)
- 2. [Installation](#installation)
  - 2.1 [Arch linux users](#arch-linux)
- 3. [Time Elapsed Between Two Dates](#time-elapsed-between-dates)
  - 3.1 [Fun with history](#fun-with-history)
- 4. [Compound Time Range](#compound-time-range)
- 5. [Single-Unit Time Ranges](#single-unit-time-ranges)
  - 5.1 [Single-unit result](#single-unit-result)
  - 5.2 [Table view](#table-view)
  - 5.3 [Decimal plates](#decimal-plates)
- 6. [Next Friday the 13th](#next-friday-the-13th)
  - 6.1 [Other weekday day-of-month pairs](#other-weekday-day-of-month-pairs)
- 7. [Lunar Calendars](#lunar-calendars)
- 8. [Carnaval, Easter and Corpus Christi](#carnaval-easter-and-corpus-christi)
- 9. [Leap Year Check](#leap-year-check)
- 10. [More Examples](#more-examples)
- 11. [Help](#help)
- 12. [Dependencies](#dependencies)
- 13. [Debugging Dependencies](#debugging-dependencies)
- 14. [Project Source](#project-source)
- 15. [See Also](#see-also)
- 16. [Logo Art](#see-also)

</details>


## ✨ Features

- [Time lapse overview](#time-elapsed-between-dates)
- [Moon phase calendars](#lunar-calendars)
- [Easter, Carnaval, and Corpus Christi dates](#carnaval-easter-and-corpus-christi)
- [Next Friday the 13th](#next-friday-the-13th)
- [Check whether year is leap](#leap-year-check)
- [Extra input time formats with `C-code date`](#fun-with-history)


## Installation

Place [datediff.sh](datediff.sh) in your `$PATH` and make it executable.

```
chmod +x /path/to/datediff.sh
```

### Arch Linux

Arch Linux users can install the [PKGBUILD from the AUR](https://aur.archlinux.org/packages/datediff.sh) with an AUR helper:

```
yay -S datediff.sh
```

The script is compatible with `ksh`, `bash`, and `zsh`; the shebang may be changed as needed.


## Time Elapsed Between Dates

The main function is verbose by default and prints two sections with
processed dates (**DATES**) and time range results (**RANGES**).

If only one date is specified, the first date is assumed to be **now**.

<!-- (or **1970** as last fallback). -->


```
% datediff.sh -u  2008-01-15  2024-09-11

DATES
2008-01-15T00:00:00+00:00       1200355200
2024-09-11T00:00:00+00:00       1726012800
RANGES
16Y 07M 03W 06D  00h 00m 00s
16.7 years | 199.9 months | 869.1 weeks | 6084.0 days | 146016.0 hours | 8760960.0 mins | 525657600 secs
```

Setting `option -u` performs all date calculations in UTC.
It also influences how the underlying `C-code date` programme processes dates.


### Fun with history

Calculate the age of the Apollo 11 mission at the moment of landing:

```
% datediff.sh -u2  "1969-07-20T20:17:40Z"  "now"
```

Mind that input dates must be ISO-8601 or UNIX time.
When available, `C-code date` is used to parse
user input in various date formats.


## Compound Time Range

The **compound range** takes into consideration each time unit in relation
to the others for a human-readable result.

Use `options` `-vv` and `-vvv` to print **the compound range** _alone_.


```
% datediff.sh -vv  2025-03-30T12:33:58  2031-04-17T04:34:10

6Y 00M 02W 03D  16h 00m 12s
```

Using `AST date` style layout:

```
% datediff.sh -vvv  2008-01-15

17Y05M01W03D01h00m00s
```

## Single-Unit Time Ranges

There are various ways to get information between two dates
on a specific time unit.

Set `option -v` once to print all single-unit results _alone_:

```
% datediff.sh -v  2008-01-15

17.4 years | 209.3 months | 910.3 weeks | 6371.8 days | 152923.3 hours | 9175400.5 mins | 550524032 secs
```

**Note:**  Example command run on 2025-06-25.

<!-- if only one date is specified,
the first date is assumed to be **now**. -->


### Single-unit result

A single float time result may be calculated when the user
gives the last positional parameter as exactly
`y`, `mo`, `w`, `d`, `m` or `s` to print only the specific single-unit result:


```
% datediff.sh  2008-01-15  2025-06-25  mo

209.3 months
```


### Table view

**Print results in table layout** with `options` `-t` and `-tt`
(single-unit intervals):


```
% datediff.sh -3 -t -u  2008-01-15  2025-06-25

Years          17.440
Months        209.323
Weeks         910.143
Days         6371.000
Hours      152904.000
Mins      9174240.000
Secs    550454400
```


### Decimal plates

The number of decimal plates shown in float results can be set with `option -[NUM]`,
where _NUM_ is an integer. For three decimal plates, the incantation should start as
`datediff.sh -3`.

Results are subject to rounding for improved precision!


## Next Friday the 13th

Using the _current date_ by default, run on _2025-06-25_:

```
% datediff.sh -F  Fri 13

Fri, 13 Feb 2026 is  233 days away
```


### Other weekday day-of-month pairs

Check any combination of **day-in-week** and **day-in-month**:

Optionally specify a *start date* for the search.

```
% datediff.sh -F  Mon 1  2030-01-01

Mon, 01 Apr 2030 is   90 days away
```

Set `options -FF` to print the following 10 date matches as a list!

<!--
% datediff.sh -FF Mon 1 2030

Mon, 01 Apr 2030 is   90 days away
Mon, 01 Jul 2030 is  181 days away
Mon, 01 Sep 2031 is  608 days away
Mon, 01 Dec 2031 is  699 days away
Mon, 01 Mar 2032 is  790 days away
Mon, 01 Nov 2032 is 1035 days away
Mon, 01 Aug 2033 is 1308 days away
Mon, 01 May 2034 is 1581 days away
Mon, 01 Jan 2035 is 1826 days away
Mon, 01 Oct 2035 is 2099 days away
-->


## Lunar Calendars

Setting `option -m` without an argument shows the moon phase for the current date.

For the monthly calendar:

```
% datediff.sh -m  2030-01

2030-01-01  Waning Crescent
2030-01-03  New Moon
2030-01-07  Waxing Crescent
2030-01-10  First Quarter
2030-01-14  Waxing Gibbous
2030-01-18  Full Moon
2030-01-21  Waning Gibbous
2030-01-25  Last Quarter
2030-01-29  Waning Crescent
```

For multiple-month calendar:

```
% datediff.sh -m  2030-{01..12}
```

Or simply:

```
% datediff.sh -m  2030
```

Port of the NetHack `phase_of_the_moon()` code;
as an approximation, its results may differ slightly from actual moon phases.


## Carnaval, Easter and Corpus Christi

```
% datediff.sh -ee  2030

  Carnaval          Easter      CorpusChristi
2030-03-05      2030-04-21      2030-06-20

```

Set multiple years to calculate a table of dates:

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

<!-- a nice `TSV`-formatted table -->

The dates are for the _Western_ _Church_.


## Leap Year Check

```
% datediff.sh -l  2032

leap year -- 2032
```

The _exit code is 1_ if a year _is not_ leap.

Set `option -v` to decrease verbosity.


## More Examples

Check further [examples at the man page](man#examples).


## Help

Please, check script help page with `datediff.sh -h`
or the [online man page](man/README.md).


## Dependencies

- `Ksh93`, `Bash`, or `Zsh`
- `GNU`/`BSD`/`AST`/`Busybox` `date` (optional)
- Basic Calculator `bc` (optional)


## Debugging Dependencies

- Sourceable [`datediff.debug.sh` script](tests)
- `C-code date` implementation
- Hroptatyr's `C-code datediff`


## Project Source

- GitLab <https://gitlab.com/fenixdragao/shelldatediff>
- GitHub <https://github.com/mountaineerbr/shellDatediff>

Extensively tested, see [testing scripts](tests/),
[notes](tests/d-test.sh#L78-L186), and [man page](man/README.md).


## See Also

- C-code `dateutils/datediff`, *Hroptatyr*, <http://www.fresse.org/dateutils/>.
- C-code `datediff`, *William C. Hammel*, <https://graham.main.nc.us/~bhammel/graham/CPROGS/datediff.html>.
- Python `PDD`, *Jarun*, <https://github.com/jarun/pdd>.
- *AST* `date`, see elapsed time _option_ _-E_, <https://github.com/att/ast>.
- *GNU* `units`, <https://www.gnu.org/software/units/>.
- \`\`Calendrical calculation'', *Dershowitz* and *Reingold*, 1990,	<http://www.cs.tau.ac.il/~nachum/papers/cc-paper.pdf>.


<!--

	Please, consider sending me a nickel!
		=) 	bc1qlxm5dfjl58whg6tvtszg5pfna9mn2cr2nulnjr

        -->

---

<br />
<a id="logo-art" href="https://gitlab.com/fenixdragao/shelldatediff"><p align="center">
  <img width="128" height="128" alt="Datediff.sh script dark theme logo"
  src="https://gitlab.com/mountaineerbr/etc/-/raw/main/gfx/datediff_logo/out-8/datediff_dark-8-128.png">
  &nbsp;&nbsp;&nbsp;
  <img width="128" height="128" alt="Datediff.sh script light theme logo"
  src="https://gitlab.com/mountaineerbr/etc/-/raw/main/gfx/datediff_logo/out-8/datediff_light-8-128.png">
</p></a>


<!-- User theme aware --> <!--
<a id="logo-art" href="https://gitlab.com/fenixdragao/shelldatediff"><p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://gitlab.com/mountaineerbr/etc/-/raw/main/gfx/datediff_logo/out-8/datediff_dark-8-128.png">
    <img width="128" height="128" alt="Datediff.sh script logo" src="https://gitlab.com/mountaineerbr/etc/-/raw/main/gfx/datediff_logo/out-8/datediff_light-8-128.png">
  </picture>
</p></a>
-->

