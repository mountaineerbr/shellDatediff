% DATEDIFF.SH(1) v0.31.1 | General Commands Manual
% Jamil Soni N
% November 2026


# NAME

|    **datediff.sh** - Calculate time ranges / intervals between dates


# SYNOPSIS

|    **datediff.sh** \[-RRrttuvvv] \[-_NUM_] \[-f _\"FMT\"_] _DATE1_ _DATE2_ \[_UNIT_]
|    **datediff.sh** **-FF** \[-v] \[\[_DAY_IN_WEEK_] \[_DAY_IN_MONTH_]] \[_START_DATE_]
|    **datediff.sh** **-ee** \[-v] _YEAR_ ...
|    **datediff.sh** **-l**  \[-v] _YEAR_ ...
|    **datediff.sh** **-m**  \[-v] _DATE_ ...


# DESCRIPTION

Calculate the time interval (elapsed time) between _DATE1_ and _DATE2_
in various time units.

Special functions generate dates for
Easter, Carnaval, and Corpus Christi,
check for leap years, and
generate moon phase calendars.

Input is expected as an ISO-8601 date or UNIX time. However,
the script can leverage an external `C-code` `date` utility to
parse a wider range of date formats.


# OPTIONS

## Date and Time Calculations

**-[**_0-9_**]**, **-NUM**

:    Scale factor for single-unit float results (decimal plates).

     Parameter _NUM_ must be an integer.

<!-- Results are subject to rounding. -->


**-f**  _FORMAT_

:    Input date format specification (`BSD`, `Toybox` `date`).


**-r**, **-\@**

:    Input _DATES_ are UNIX timestamps.


**-t**, **-tt**

:    Table display of single-unit time intervals.


**-u**

:    Operate in UTC instead of local time.

     This also affects how `C-code date` processes input dates.


**-v**

:    Print single-unit ranges alone (e.g. "_1 day, 24 hours, 1440 mins.._").


**-vv**, **-vvv**

:    Print the compound range alone (e.g. "_6Y 11M 01W 06D_").

     Set **-vvv** to remove spaces (e.g. "_6Y11M01W06D_"), AST style.


## Special Date Functions

**-e**  \[_YEAR_ ...]

:    Easter dates (Western Church).


**-ee**  \[_YEAR_ ...]

:    Carnaval, Easter and Corpus Christi dates (TSV table).


**-F**, **-FF**  \[\[_DAY_IN_WEEK_] \[_DAY_IN_MONTH_]] \[_START_DATE_]

:    Next Friday the 13th or other date combinations.

     Set twice to print the following ten matches.


**-l**  \[_YEAR_ ...]

:    Check for leap years.

     Set **option -v** to decrease verbosity.


**-m**  \[_YYYY[-MM[-DD]]_]

:    Print moon phase for UTC _DATE_.

     Partial _DATE_ input is expanded automatically.


## Miscellaneous


**-h**

:    Print the script help page.


**-k**

:   Suppress bold formatting (text highlighting) in output.


**-R**, **-RR**

:    Output dates in RFC 5322 format. Repeat the option to use names
     from the current time locale where supported. 

**-v**

:    Decrease or change verbosity mode.


# DATE AND TIME CALCULATIONS

If _DATE_ is not given, it defaults to _now_. If only one _DATE_ is set,
the first date is assumed to be _now_ (or _1970_ as a last fallback).

To flag _DATE_ as UNIX time, prepend an "at" sign ("_\@_") to it or
set **option -r**.

`GNU date` accepts most free-form human-readable date strings.
With `FreeBSD` and `BusyBox` `date`, the input format may be set
with **option -f** _FORMAT_, such as **-f \"%Y-%m-%d %H:%M:%S\"**.

Support for timezones and the `%z` and `%Z` input conversion specifiers 
varies between `date` implementations.

When no `C-code date` programme is available, input must be given
as **ISO-8601 date** or **UNIX time**.

Standard input may contain either one _DATE_ string per line
(up to two lines), or two ISO-8601 _DATES_ separated by a space
on a single line. Input is processed on a best-effort basis.


# DATE AND TIME OUTPUT

The "RANGES" output section displays intervals in different
units of time (years, or months, or weeks..).
It also displays a compound time range, with all
units considered relative to each other.

_Single-unit_ time periods can be displayed in
table format with **option -t**.
Set the decimal scale factor with command-line
**option -NUM**, where _NUM_ is an integer.

The least significant digit of the result is subject to rounding.

When the last positional parameter _UNIT_ is exactly one of
_Y_, _MO_, _W_, _D_, _H_, _M_, or _S_,
the corresponding _single-unit_ time interval is printed to stdout.

The "DATES" output section prints input dates as **UNIX times** and
**ISO-8601 dates**, or as **RFC 5322 dates** if **option -R** is set.

If specified more than once, as in **-RR**, output weekday and
month abbreviations from the current time locale, where supported. 

**Option -u** sets the environment variable "\$TZ=UTC" and operates
internally in Coordinated Universal Time (UTC).
Note that this affects how the `C-code date` programme processes dates.

**Option -v** prints single-unit ranges alone (e.g. "_1 day, 24 hours, 1440 mins_").
**Option -vv** prints the compound range alone (e.g. "_6Y 11M 01W 06D_"),
and setting **-vvv** further removes spaces (e.g. "_6Y11M01W06D_"), AST style.


# SPECIAL DATE FUNCTIONS

**Option -e** prints Easter dates for given _YEARS_ (Western Church)
and **option -ee** additionally prints Carnaval and Corpus Christi dates.

**Option -l** checks whether _YEAR_ is a leap year.
Set **option -v** to decrease verbosity and exit with a status code.

Calculations use the proleptic Gregorian calendar, include year zero,
and do not account for leap seconds.

**Option -m** prints lunar phase for _UTC_ _DATE_ ("_YYYY[-MM[-DD]]_").
Partial _input_ _DATES_ are expanded automatically.
Code snippet adapted from _NetHack_.

**Option -F** prints the next Friday the 13th.
_START_DATE_ must use the format "_YYYY[-MM[-DD]]_".
Optionally, set _day-in-week_ and _day-in-month_;
e.g. "_Sun_ _01_ \[_START_DATE_]".

Set **options -FF** to print the following ten matches.


# TIMEZONE OFFSETS

Environment variable **\$TZ** is read as **POSIX offset**.
Fixed offsets do not consider daylight-saving changes.

Set **\$TZ** using the **POSIX** form "_UTC[+|-]HH[:MM]_",
such as "_UTC+03_".

Importantly, **POSIX** \$TZ offsets use the opposite sign to
**ISO-8601** UTC offsets:

- "_$TZ=UTC+03_" corresponds to "_ISO UTC-03_" (West of UTC)
- "_$TZ=UTC-03_" corresponds to "_ISO UTC+03_" (East of UTC)

Timezone names and IDs (e.g. "_America/Sao_Paulo_") may be parsed by
`C-code date` when it is leveraged to process user input.

The \$TZ variable affects the timezone offset display of output dates.


# REFINEMENT RULES

**Compound time range** calculations follow refinement rules intended
to minimise excessive granularity in the resulting units.

As of release v0.31 (Oct 2026), shell arithmetics have been fully verified
against the `C-code` `date` and `datediff` references.
No remaining divergences were found in arithmetics or refinement rules.

Most differences or errors in older releases involved month boundaries,
end-of-month and start-of-month date combinations,
such as days **29, 30, or 31** versus days **1, 2, or 3**,
unusual timezone offsets, and discrete bugs in refinement calculations.

The script's logic strives to follow _Hroptatyr's_ `C-code` `datediff`
refinement rules for compound ranges.

For the full testing log, check `d-test.sh` at the project repository.


# ENVIRONMENT

**DATE_CMD**

:    Path for the `C-code` `date` command.

     `GNU`, `BSD`, `AST`, `BusyBox` and `Toybox` `date` are supported.


**LC_TIME**

:    Locale for weekday and month names in **RFC 5322-style** output
     with **options -RR**, where supported. Nonempty **LC_ALL** takes
     precedence; **LANG** spplies the default.


**TZ**

:    `POSIX` timezone offset. The offset must be in the
     format "_UTC[+|-]HH[:MM]_".


# EXAMPLES

**Leap year check**

|    datediff.sh **-l** 1900 2000 2100
|    datediff.sh **-l** {2080..2100}

The second incantation relies on brace expansion in the invoking shell.

**Moon phases for January or full year**

|    datediff.sh **-m** 2030-01
|    datediff.sh **-m** 2030

**Print the next Friday the 13th**

|    datediff.sh **-F**

**Print the first Sunday falling on the 12th on or after 2030-01-01**

|    datediff.sh **-F** sun 12 2030

**Single-unit time periods**

|    datediff.sh \'10 years ago\'  _mo_    #[mo]nths
|    datediff.sh 1970-01-01  2000-02-02  _y_    #[y]ears

**Time ranges/intervals**

|    datediff.sh 0921-04-12 1999-01-31
|    echo 1970-01-01 2000-02-02 | datediff.sh 
|    **TZ=UTC+03** datediff.sh  2020-01-03T14:30:10-06  2021-12-30T21:00:10-03

**GNU date warping**

|    datediff.sh 2019/6/28  1Aug
|    datediff.sh \'next monday\'
|    datediff.sh \'5min 34seconds\'
|    datediff.sh \'2020-01-01 - 6months\'  \'2020-01-01\'
|    datediff.sh \'05 jan 2005\'  \'now - 43years -13 days\'
|    datediff.sh **-2**  \--  \'1hour ago 30min ago\'
|    datediff.sh **-u**  \'2023-01-14T11:20:00Z\'  \'2023-01-14T11:20:00Z + 5 hours\'
|    datediff.sh \-- \'-2week-3day\' \'now\'
|    datediff.sh \-- \'today + 1day\'  *\@*1952292365
|    datediff.sh *\@*1561243015  *\@*1592865415

**BSD date warping**

|    datediff.sh **-f**\'%m/%d/%Y\'  \'6/28/2019\'  \'9/04/1970\'
|    datediff.sh **-r** 1561243015  1592865415
|    datediff.sh 200002280910.33  0003290010.00
|    datediff.sh \-- \'-v +2d\' \'-v -3w\'


# DEPENDENCIES

This script uses shell arithmetics for most time range calculations
and relies on `bc` for large integers and floating-point arithmetics.

- `Bash 2.05b+`, `Ksh93` or `Zsh 5+` is required.
- `bc` Basic Calculator or `Ksh93`/`Zsh` shell is required for single-unit time calculations.
- `FreeBSD` `date` or `GNU` `date` is optionally required to parse input dates in various formats.


# DEBUGGING DEPENDENCIES

- Sourceable helper script `datediff.debug.sh`.
- `C-code` implementation of `date`.
- `C-code` implementation of `datediff`.


# DIAGNOSTICS

**Option -D** disables external `C-code date` for input date parsing.

Setting **options -DD** further disables time-related builtins of the shell.

**Option -d** executes result checks against `C-code` `datediff`
and `C-code` `date` programmes in the main function (UTC time mode).

Set **options -dd** to exit immediately with a status number.
Debug data is dumped only when checks fail.


# WARRANTY

Licensed under the **GNU General Public License version 3** or better.
This software is distributed without support or bug corrections.


# PROJECT SOURCE

- GitLab <https://gitlab.com/fenixdragao/shelldatediff>.

- GitHub <https://github.com/mountaineerbr/shellDatediff>.


 Many thanks for all advice from _c.u.shell_!


# SEE ALSO

- `Datediff` from `dateutils`, by _Hroptatyr_
 <https://www.fresse.org/dateutils/>.

- `PDD` from _Jarun_
 <https://github.com/jarun/pdd>.

- `AST date` elapsed time `option -E`
 <https://github.com/att/ast>.

- `Units` from GNU.
 <https://www.gnu.org/software/units/>.

- "_Do calendrical savants use calculation to answer date questions?_"
 A functional magnetic resonance imaging study, _Cowan and Frith_, 2009
 <https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2677581/>.

- Calendrical calculation, _Dershowitz and Reingold_, 1990
 <http://www.cs.tau.ac.il/~nachum/papers/cc-paper.pdf>
 <https://books.google.com.br/books?id=DPbx0-qgXu0C>.

- How many days are in a year? _Manning_, 1997
 <https://pumas.nasa.gov/files/04_21_97_1.pdf>.

- IANA Time Zone Database
 <https://www.iana.org/time-zones>.

- Fun with Date Arithmetic (see replies)
 <https://linuxcommando.blogspot.com/2009/11/fun-with-date-arithmetic.html>.

<!--
- "_Division is but subtractions and multiplication but additions_" \--Lost reference
-->


<!-- Generate the man page:
    pandoc --standalone --to man ./datediff.sh.1.md -o ./datediff.sh.1
-->
