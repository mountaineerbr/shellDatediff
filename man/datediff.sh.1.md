% DATEDIFF.SH(1) v0.27 | General Commands Manual
% Jamil Soni N
% June 2025


# NAME

|    **datediff.sh** - Calculate time ranges / intervals between dates


# SYNOPSIS

|    **datediff.sh** \[-Rrttuvvv] \[-_NUM_] \[-f _\"FMT\"_] _DATE1_ _DATE2_ \[_UNIT_]
|    **datediff.sh** **-FF** \[-vv] \[\[_DAY_IN_WEEK_] \[_DAY_IN_MONTH_]] \[_START_DATE_]
|    **datediff.sh** \[**-ee**|**-l**] \[-v] _YEAR_..
|    **datediff.sh** **-m** \[-v] _DATE_..


# DESCRIPTION

Calculate time interval (elapsed time) between _DATE1_ and _DATE2_ in various
time units.

For robust parsing of diverse date formats beyond ISO-8601 and UNIX times,
`datediff.sh` can leverage an external `C-code date` utility
(e.g., `GNU date`, `BSD date`).

Special functions include checking for leap years, generating
dates for Easter, Carnaval, and Corpus Christi,
and calculating the phase of the moon for a specified date.


# OPTIONS

## Date and Time Calculations

**-[**_0-9_**]**, **-[**_NUM_**]**

:    Scale factor (decimal plates) for single time-unit float results.

     Parameter _NUM_ must be an integer.


**-f**  \[_FMT_]

:    Input time format specification (`BSD date`).

**-R**

:    Print output dates in RFC-5322 format.


**-r**, **-\@**

:    Input DATES are UNIX timestamps.


**-t**, **-tt**

:    Table display layout selection of single-unit intervals.

**-u**

:    Set input and output dates to UTC instead of local times.

     This affects how `C-code date` processes input dates.


**-v**, **-vv**, **-vvv**

:    Select / filter output result groups (main function).

     Verbosity levels.


## Special Date Functions

**-e**  \[_YEAR_..]

:    Easter dates (Western Church).

**-ee**  \[_YEAR_..]

:    Carnaval, Easter and Corpus Christi dates (table in TSV format).


**-F**, **-FF**  \[\[_DAY_IN_WEEK_] \[_DAY_IN_MONTH_]] \[_START_DATE_]

:    Following Friday the 13th date.

     Set twice to print the following 10 matches.


**-h**

:    Print the script help page.

**-l**  \[_YEAR_..]

:    Check for leap years.

**-m**  \[_YYYY[-MM[-DD]]_]

:    Print lunar phase for DATE.


# DATE AND TIME CALCULATIONS

`GNU date` accepts mostly free format human readable date strings.
If using `FreeBSD date`, input _DATE_ strings must be **ISO-8601**
("_YYYY-MM-DDThh:mm:ss_") or other supported time formats, unless
**option -f** _FMT_ is set to a new input time format.
If `C-code date` programme is not available,
then input must be formatted as **ISO-8601** or **UNIX time**.

If _DATE_ is not set, defaults to _now_. If only one _DATE_ is set, the first
one is assumed to be _now_ (or _1970_ as last fallback).

To flag _DATE_ as UNIX time, prepend an "at" sign "_\@_" to it or
set **option -r**.

Stdin input is expected to have one _DATE_ string per line (max two lines)
or two ISO-8601 _DATES_ separated by space in a single line.
Input is processed in a best-effort basis.


# DATE AND TIME OUTPUT

Output "RANGES" section displays intervals in different units of time
(years, or months, or weeks, or days, or hours, or minutes, or seconds alone).
It also displays a compound time range, considering all
units relative to each other.

Single _UNIT_ time periods can be displayed in table format with
**option -t**. The decimal scale factor can be set with command line 
**option -NUM** where _NUM_ is an integer.
The least significant digit of the result is subject to rounding.

When the last positional parameter _UNIT_ is exactly one of
_Y_, _MO_, _W_, _D_, _H_, _M_, or _S_,
only a single _UNIT_ time interval is printed to stdout.

Output "DATES" section prints input dates in **ISO-8601 format** or, if
**option -R** is set, **RFC-5322 format**.

**Option -u** sets or prints dates in Coordinated Universal Time (UTC).
This affects how the `C-code date` programme processes dates, too.

Set **option -v** to print only the single-unit results
and **-vv** to print only the compound time range result.

<!--
In other function, set **options -v** to decrease verbosity. -->


# SPECIAL DATE FUNCTIONS

**Option -e** prints Easter dates for given _YEARS_ (Western Church)
and **option -ee** additionally prints Carnaval and Corpus Christi dates.

**Option -l** checks if _YEAR_ is leap. Set **option -v**
to decrease verbosity.
The ISO-8601 system assumes proleptic Gregorian calendar, year
zero, and no leap seconds.

**Option -m** prints lunar phase for _UTC_ _DATE_ ("_YYYY[-MM[-DD]]_").
Auto expansion takes place on partial _DATE input_.
Code snippet adapted from _NetHack_.

**Option -F** prints the date of next Friday the 13th. The _START_DATE_ must
be formatted as "_YYYY[-MM[-DD]]_". Optionally, set _day-in-week_, such as
_Sunday_, and _day-in-month_ as the first and second positional parameters,
respectively.
Set **options -FF** to print the following ten matches.


# TIMEZONE OFFSETS

Dates formatted in **ISO-8601** and **POSIX offset** declaration
in environment variable \$TZ are features supported throughout this script.

Environment \$TZ is read as **POSIX offset** when it holds a positive or
negative decimal number, such as "_+03_" (or even "_UTC+03_").
**POSIX** time zone definition by the \$TZ variable takes a different
form from **ISO-8601** standards, so that
"_ISO_ _UTC-03_" is equivalent to setting "_\$TZ=UTC+03_".

Importantly, \$TZ **POSIX offsets** are often the inverse of
**ISO-8601** _UTC_ _values_ seen in timestamps, so that:

	  "$TZ=+03" corresponds to an offset of "ISO UTC-03" (West of UTC)

	  "$TZ=-03" corresponds to an offset of "ISO UTC+03" (East of UTC)


Timezone names and IDS (e.g. "_America/Sao_Paulo_") may be parsed by
one `C-code date` programme when it is leveraged to process user input.


# ENVIRONMENT

**DATE_CMD**

:    Path for the `C-code date` binary.

     **GNU**, **BSD**, **AST**, and **Busybox** **date** are supported.


**TZ**

:    **POSIX** time zone offset. Numeric offset must be in the
     format "_[+|-]HH[:MM]_", or sometimes "_UTC[+|-]HH[:MM]_".


<!--  Better mentioned in Diagnostics
**CFACTOR**

:    Correction factor used in the lunar phase function.

     Default=\"_-1892_\"
-->


# REFINEMENT RULES

**Compound time range** calculations depend on refining logic to assemble
the final results when dealing with end-of-month and start-of-month date
combinations, and different month lengths.

The script's compound time range calculations largely follow Hroptatyr's
`C-code datediff` refinement rules.

Script error rate of the main code is estimated to be lower than
one percent after extensive testing with selected and corner-case
sample dates and times.

Check source code and project repository for details and documentation.


# DIAGNOSTICS

**Option -d** executes result checks against `C-code datediff`
and `C-code date` programmes in the main function.  This sets UTC time and
runs checks against `C-code datediff` and `C-code date`.

Set **options -dd** to code exit immediately. Debug data is dumped
only when checks fail.

**Option -D** disables external `C-code date` for date input parsing.

**Option -DD** disables all external date parsing mechanisms, including
`C-code date` and shell time-related builtins.

Lunar phase function incorporates an internal empirical constant.
Environment variable **$CFACTOR** offers an override to this value.
Default is \"-1892\".


# DEPENDENCIES

This script uses shell arithmetics to perform most time range calculations
and relies on `bc` for large-number integers and float arithmetics.

The Desk Calculator `dc` is executed in the Easter function as a mysterious
function taken from _Dershowitz and Reingold_'s paper.

- `Bash2.05b+`, `Ksh93` or `Zsh` is required.
- Basic Calculator `bc` or shell `Ksh93`/`Zsh` is required for single-unit time calculations.
- `FreeBSD12+ date` or `GNU date` is optionally required to parse input date in various formats.
- For debugging, _Hroptatyr_'s `C-code datediff` and `datediff.debug.sh` are needed.


# EXAMPLES

**Leap year check**

|    datediff.sh **-l** {1990..2000}
|    echo 2000 | datediff.sh **-l**


**Moon phases for January or full year**

|    datediff.sh **-m** 1996-01
|    datediff.sh **-m** 1996

**Print following Friday, 13th**

|    datediff.sh **-F**

**Print following Sunday, 12th after 1999**

|    datediff.sh **-F** sun 12 1999

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


# WARRANTY

Licensed under the **GNU General Public License 3** or better. This
software is distributed without support or bug corrections.

Many thanks for all advice from c.u.shell!


# PROJECT SOURCE

	<https://gitlab.com/fenixdragao/shelldatediff>

	<https://github.com/mountaineerbr/shellDatediff>


# SEE ALSO

- `Datediff` from `dateutils`, by _Hroptatyr_
 <www.fresse.org/dateutils/>.

- `PDD` from _Jarun_
 <https://github.com/jarun/pdd>.

- `AST date` elapsed time `option -E`
 <https://github.com/att/ast>.

- `Units` from GNU.
 <https://www.gnu.org/software/units/>.

- "_Do calendrical savants use calculation to answer date questions?_"
 A functional magnetic resonance imaging study, _Cowan and Frith_, 2009
 <https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2677581/#!po=21.1864>.

- Calendrical calculation, _Dershowitz and Reingold_, 1990
 <http://www.cs.tau.ac.il/~nachum/papers/cc-paper.pdf>
 <https://books.google.com.br/books?id=DPbx0-qgXu0C>.

- How many days are in a year? _Manning_, 1997
 <https://pumas.nasa.gov/files/04_21_97_1.pdf>.

- Iana Time zone database
 <https://www.iana.org/time-zones>.

- Fun with Date Arithmetic (see replies)
 <https://linuxcommando.blogspot.com/2009/11/fun-with-date-arithmetic.html>.

<!--
- "_Division is but subtractions and multiplication but additions_" \--Lost reference
-->


<!-- Generate the man page:
    pandoc --standalone --to man ./datediff.sh.1.md -o ./datediff.sh.1
-->
