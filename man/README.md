---
author:
- Jamil Soni N
date: June 2025
title: DATEDIFF.SH(1) v0.27 \| General Commands Manual
---

# NAME

   **datediff.sh** - Calculate time ranges / intervals between dates

# SYNOPSIS

   **datediff.sh** \[-Rrttuvvv\] \[-*NUM*\] \[-f *"FMT"*\] *DATE1*
*DATE2* \[*UNIT*\]  
   **datediff.sh** **-FF** \[-vv\] \[\[*DAY_IN_WEEK*\]
\[*DAY_IN_MONTH*\]\] \[*START_DATE*\]  
   **datediff.sh** \[**-ee**\|**-l**\] \[-v\] *YEAR*..  
   **datediff.sh** **-m** \[-v\] *DATE*..

# DESCRIPTION

Calculate time interval (elapsed time) between *DATE1* and *DATE2* in
various time units.

For robust parsing of diverse date formats beyond ISO-8601 and UNIX
times, `datediff.sh` can leverage an external `C-code date` utility
(e.g., `GNU date`, `BSD date`).

Special functions include checking for leap years, generating dates for
Easter, Carnaval, and Corpus Christi, and calculating the phase of the
moon for a specified date.

# OPTIONS

## Date and Time Calculations

**-\[***0-9***\]**, **-\[***NUM***\]**  
Scale factor (decimal plates) for single time-unit float results.

Parameter *NUM* must be an integer.

**-f** \[*FMT*\]  
Input time format specification (`BSD date`).

**-R**  
Print output dates in RFC-5322 format.

**-r**, **-@**  
Input DATES are UNIX timestamps.

**-t**, **-tt**  
Table display layout selection of single-unit intervals.

**-u**  
Set input and output dates to UTC instead of local times.

This affects how `C-code date` processes input dates.

**-v**, **-vv**, **-vvv**  
Select / filter output result groups (main function).

Verbosity levels.

## Special Date Functions

**-e** \[*YEAR*..\]  
Easter dates (Western Church).

**-ee** \[*YEAR*..\]  
Carnaval, Easter and Corpus Christi dates (table in TSV format).

**-F**, **-FF** \[\[*DAY_IN_WEEK*\] \[*DAY_IN_MONTH*\]\] \[*START_DATE*\]  
Following Friday the 13th date.

Set twice to print the following 10 matches.

**-h**  
Print the script help page.

**-l** \[*YEAR*..\]  
Check for leap years.

**-m** \[*YYYY\[-MM\[-DD\]\]*\]  
Print lunar phase for DATE.

# DATE AND TIME CALCULATIONS

`GNU date` accepts mostly free format human readable date strings. If
using `FreeBSD date`, input *DATE* strings must be **ISO-8601**
(“*YYYY-MM-DDThh:mm:ss*”) or other supported time formats, unless
**option -f** *FMT* is set to a new input time format. If `C-code date`
programme is not available, then input must be formatted as **ISO-8601**
or **UNIX time**.

If *DATE* is not set, defaults to *now*. If only one *DATE* is set, the
first one is assumed to be *now* (or *1970* as last fallback).

To flag *DATE* as UNIX time, prepend an “at” sign “*@*” to it or set
**option -r**.

Stdin input is expected to have one *DATE* string per line (max two
lines) or two ISO-8601 *DATES* separated by space in a single line.
Input is processed in a best-effort basis.

# DATE AND TIME OUTPUT

Output “RANGES” section displays intervals in different units of time
(years, or months, or weeks, or days, or hours, or minutes, or seconds
alone). It also displays a compound time range, considering all units
relative to each other.

Single *UNIT* time periods can be displayed in table format with
**option -t**. The decimal scale factor can be set with command line
**option -NUM** where *NUM* is an integer. The least significant digit
of the result is subject to rounding.

When the last positional parameter *UNIT* is exactly one of *Y*, *MO*,
*W*, *D*, *H*, *M*, or *S*, only a single *UNIT* time interval is
printed to stdout.

Output “DATES” section prints input dates in **ISO-8601 format** or, if
**option -R** is set, **RFC-5322 format**.

**Option -u** sets or prints dates in Coordinated Universal Time (UTC).
This affects how the `C-code date` programme processes dates, too.

Set **option -v** to print only the single-unit results and **-vv** to
print only the compound time range result.

<!--
In other function, set **options -v** to decrease verbosity. -->

# SPECIAL DATE FUNCTIONS

**Option -e** prints Easter dates for given *YEARS* (Western Church) and
**option -ee** additionally prints Carnaval and Corpus Christi dates.

**Option -l** checks if *YEAR* is leap. Set **option -v** to decrease
verbosity. The ISO-8601 system assumes proleptic Gregorian calendar,
year zero, and no leap seconds.

**Option -m** prints lunar phase for *UTC* *DATE*
(“*YYYY\[-MM\[-DD\]\]*”). Auto expansion takes place on partial *DATE
input*. Code snippet adapted from *NetHack*.

**Option -F** prints the date of next Friday the 13th. The *START_DATE*
must be formatted as “*YYYY\[-MM\[-DD\]\]*”. Optionally, set
*day-in-week*, such as *Sunday*, and *day-in-month* as the first and
second positional parameters, respectively. Set **options -FF** to print
the following ten matches.

# TIMEZONE OFFSETS

Dates formatted in **ISO-8601** and **POSIX offset** declaration in
environment variable \$TZ are features supported throughout this script.

Environment \$TZ is read as **POSIX offset** when it holds a positive or
negative decimal number, such as “*+03*” (or even “*UTC+03*”). **POSIX**
time zone definition by the \$TZ variable takes a different form from
**ISO-8601** standards, so that “*ISO* *UTC-03*” is equivalent to
setting “*\$TZ=UTC+03*”.

Importantly, \$TZ **POSIX offsets** are often the inverse of
**ISO-8601** *UTC* *values* seen in timestamps, so that:

      "$TZ=+03" corresponds to an offset of "ISO UTC-03" (West of UTC)

      "$TZ=-03" corresponds to an offset of "ISO UTC+03" (East of UTC)

Timezone names and IDS (e.g. “*America/Sao_Paulo*”) may be parsed by one
`C-code date` programme when it is leveraged to process user input.

# ENVIRONMENT

**DATE_CMD**  
Path for the `C-code date` binary.

**GNU**, **BSD**, **AST**, and **Busybox** **date** are supported.

**TZ**  
**POSIX** time zone offset. Numeric offset must be in the format
“*\[+\|-\]HH\[:MM\]*”, or sometimes “*UTC\[+\|-\]HH\[:MM\]*”.

<!--  Better mentioned in Diagnostics
**CFACTOR**
&#10;:    Correction factor used in the lunar phase function.
&#10;     Default=\"_-1892_\"
-->

# REFINEMENT RULES

**Compound time range** calculations depend on refining logic to
assemble the final results when dealing with end-of-month and
start-of-month date combinations, and different month lengths.

The script’s compound time range calculations largely follow Hroptatyr’s
`C-code datediff` refinement rules.

Script error rate of the main code is estimated to be lower than one
percent after extensive testing with selected and corner-case sample
dates and times.

Check source code and project repository for details and documentation.

# DIAGNOSTICS

**Option -d** executes result checks against `C-code datediff` and
`C-code date` programmes in the main function. This sets UTC time and
runs checks against `C-code datediff` and `C-code date`.

Set **options -dd** to code exit immediately. Debug data is dumped only
when checks fail.

**Option -D** disables external `C-code date` for date input parsing.

**Option -DD** disables all external date parsing mechanisms, including
`C-code date` and shell time-related builtins.

Lunar phase function incorporates an internal empirical constant.
Environment variable **\$CFACTOR** offers an override to this value.
Default is "-1892".

# DEPENDENCIES

This script uses shell arithmetics to perform most time range
calculations and relies on `bc` for large-number integers and float
arithmetics.

The Desk Calculator `dc` is executed in the Easter function as a
mysterious function taken from *Dershowitz and Reingold*’s paper.

- `Bash2.05b+`, `Ksh93` or `Zsh` is required.
- Basic Calculator `bc` or shell `Ksh93`/`Zsh` is required for
  single-unit time calculations.
- `FreeBSD12+ date` or `GNU date` is optionally required to parse input
  date in various formats.
- For debugging, *Hroptatyr*’s `C-code datediff` and `datediff.debug.sh`
  are needed.

# EXAMPLES

**Leap year check**

   datediff.sh **-l** {1990..2000}  
   echo 2000 \| datediff.sh **-l**

**Moon phases for January or full year**

   datediff.sh **-m** 1996-01  
   datediff.sh **-m** 1996

**Print following Friday, 13th**

   datediff.sh **-F**

**Print following Sunday, 12th after 1999**

   datediff.sh **-F** sun 12 1999

**Single-unit time periods**

   datediff.sh '10 years ago' *mo* \#\[mo\]nths  
   datediff.sh 1970-01-01 2000-02-02 *y* \#\[y\]ears

**Time ranges/intervals**

   datediff.sh 0921-04-12 1999-01-31  
   echo 1970-01-01 2000-02-02 \| datediff.sh  
   **TZ=UTC+03** datediff.sh 2020-01-03T14:30:10-06
2021-12-30T21:00:10-03

**GNU date warping**

   datediff.sh 2019/6/28 1Aug  
   datediff.sh 'next monday'  
   datediff.sh '5min 34seconds'  
   datediff.sh '2020-01-01 - 6months' '2020-01-01'  
   datediff.sh '05 jan 2005' 'now - 43years -13 days'  
   datediff.sh **-2** -- '1hour ago 30min ago'  
   datediff.sh **-u** '2023-01-14T11:20:00Z' '2023-01-14T11:20:00Z + 5
hours'  
   datediff.sh -- '-2week-3day' 'now'  
   datediff.sh -- 'today + 1day' *@*1952292365  
   datediff.sh *@*1561243015 *@*1592865415

**BSD date warping**

   datediff.sh **-f**'%m/%d/%Y' '6/28/2019' '9/04/1970'  
   datediff.sh **-r** 1561243015 1592865415  
   datediff.sh 200002280910.33 0003290010.00  
   datediff.sh -- '-v +2d' '-v -3w'

# WARRANTY

Licensed under the **GNU General Public License 3** or better. This
software is distributed without support or bug corrections.

Many thanks for all advice from c.u.shell!

# PROJECT SOURCE

    <https://gitlab.com/fenixdragao/shelldatediff>

    <https://github.com/mountaineerbr/shellDatediff>

# SEE ALSO

- `Datediff` from `dateutils`, by *Hroptatyr*
  \<www.fresse.org/dateutils/\>.

- `PDD` from *Jarun* <https://github.com/jarun/pdd>.

- `AST date` elapsed time `option -E` <https://github.com/att/ast>.

- `Units` from GNU. <https://www.gnu.org/software/units/>.

- “*Do calendrical savants use calculation to answer date questions?*” A
  functional magnetic resonance imaging study, *Cowan and Frith*, 2009
  <https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2677581/#!po=21.1864>.

- Calendrical calculation, *Dershowitz and Reingold*, 1990
  <http://www.cs.tau.ac.il/~nachum/papers/cc-paper.pdf>
  <https://books.google.com.br/books?id=DPbx0-qgXu0C>.

- How many days are in a year? *Manning*, 1997
  <https://pumas.nasa.gov/files/04_21_97_1.pdf>.

- Iana Time zone database <https://www.iana.org/time-zones>.

- Fun with Date Arithmetic (see replies)
  <https://linuxcommando.blogspot.com/2009/11/fun-with-date-arithmetic.html>.

<!--
- "_Division is but subtractions and multiplication but additions_" \--Lost reference
-->
<!-- Generate the man page:
    pandoc --standalone --to man ./datediff.sh.1.md -o ./datediff.sh.1
-->
