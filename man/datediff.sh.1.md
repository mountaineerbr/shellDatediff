% DATEDIFF.SH(1) v0.25.2 | General Commands Manual
% Jamil Soni N
% December 2024


# NAME

|    **datediff.sh** - Calculate time ranges / intervals between dates


## SYNOPSIS

|    **datediff.sh** \[**-Rrttuvvv**] \[`-`_NUM_] \[`-f`_\"FMT\"_] _DATE1_ _DATE2_ \[_UNIT_]
|    **datediff.sh** **-FF** \[**-vv**] \[\[_DAY_IN_WEEK_] \[_DAY_IN_MONTH_]] \[_START_DATE_]
|    **datediff.sh** **-eel** \[**-v**] _YEAR_..
|    **datediff.sh** **-m** \[**-v**] _DATE_..
|    **datediff.sh** **-h**


## DESCRIPTION

Calculate time interval (elapsed) between _DATE1_ and _DATE2_ in various
time units. The `C-code date` programme is optionally run to process dates.

Extra functions include checking if _YEAR_ is leap, generating Easter,
Carnaval, and Corpus Christi dates on
a given _YEAR_ and the phase of the moon at _DATE_.


### Main Function

In the main function, `GNU date` accepts mostly free format human
readable date strings. If using `FreeBSD date`, input _DATE_ strings
must be **ISO-8601** (_YYYY-MM-DDThh:mm:ss_), unless **option -f** _FMT_ is
set to a new input time format. If `C-code date` programme is not available
then input must be formatted as **ISO-8601** or **UNIX time**.

If _DATE_ is not set, defaults to _now_. If only one _DATE_ is set, the first
one is assumed to be _now_ or _1970_.

To flag _DATE_ as UNIX time, prepend an "at" sign "_\@_" to it or
set **option -r**.

Stdin input supports one _DATE_ string per line (max two lines) or two ISO-8601
_DATES_ separated by space in a single line. Input is processed in a best effort basis.


### Main Output

Output "RANGES" section displays intervals in different units of time
(years, or months, or weeks, or days, or hours, or minutes, or seconds alone).
It also displays a compound time range with all
the above units into consideration to each other.

Single _UNIT_ time periods can be displayed in table format with
**option -t** and their scale set with command line 
**option -NUM** where _NUM_ is an integer.
The least significant digit of the result is subject to rounding.

When the last positional parameter _UNIT_ is exactly one of
_Y_, _MO_, _W_, _D_, _H_, _M_, or _S_,
only a single _UNIT_ time interval is printed to stdout.

Output "DATES" section prints two dates in **ISO-8601 format** or, if
**option -R** is set, in the **RFC-5322 format**.

**Option -u** sets or prints dates in Coordinated Universal Time (UTC)
in the main function. This affects how the `C-code date` programme process dates.

In the main function, set **options -v** to print only the single-unit results
and **-vv** to print only the compound time range result.

In other function, set **options -v** to decrease verbose.


### Extra Functions

**Option -e** prints Easter dates for given _YEARS_ (for Western Churches)
and **option -ee** additionally prints Carnaval and Corpus Christi dates.

**Option -l** checks if a _YEAR_ is leap. Set **option -v**
to decrease verbosity.
The ISO-8601 system assumes proleptic Gregorian calendar, year
zero and no leap seconds.

**Option -m** prints lunar phase at _DATE_ as _YYYY[-MM[-DD]]_, auto
expansion takes place on partial _DATE input_ (UTC time).
Code snippet adapted from _NetHack_.

**Option -F** prints the date of next Friday the 13th. The _START_DATE_ must
be formatted as _YYYY[-MM[-DD]]_. Optionally, set _day in the week_, such as
_Sunday_, and _day-number-in-month_ as the first and second positional parameters.
Set **option -FF** to print the following ten matches.


### Timezone Offsets

DATE offsets as per ISO-8601 are supported throughout this script. When
environment _\$TZ_ is a positive or negative decimal number, such
as _UTC+3_, it is read as offset. Variable _\$TZ_ with timezone name
or ID (e.g. America/Sao_Paulo) is supported by `C-code date` warping only.

This script uses `Bash` / `Ksh` arithmetics to perform most time range
calculations, and relies on `bc` for large-number integers and float arithmetics.
The programme `dc` is executed in the Easter function as a mysterious function
taken from _Dershowitz and Reingold_'s paper.


### Debug and Test


**Options -d** and **-dd** execute result checks against `C-code datediff`
and `C-code date` programmes in the main function. Requires `datediff.debug.sh`.

**Option -d** sets _TZ=UTC_, unsets verbose switches and run checks against
`C-code datediff` and `C-code date`. Set once to dump debug information
only when results differ and set the flag twice to code exit only.

**Option -D** disables C-code date warping and **option -DD** disables
`Bash`/`Ksh` `printf %()T` warping, too. This will have the script run
and process dates with only the shell built-in code instead of trying
to execute `C-code date` for date processing and format conversion.


<br/>
The project source is hosted at:

	<https://gitlab.com/fenixdragao/shelldatediff>
	<https://github.com/mountaineerbr/shellDatediff>


## REFINEMENT RULES

Some time intervals can be calculated in more than one way depending
on the logic used in the compound time range display. We
decided to mimic _Hroptatyr_'s `datediff` refinement rules as often
as possible.

Script error rate of the core code is estimated to be lower than
one percent after extensive testing with selected and corner-case
sample dates and times. Check the script source code and
repository for details.


## ENVIRONMENT

**CFACTOR**

:    Correction factor used in the lunar phase function.
     
     Defaults=\"_-1892_\"


**DATE_CMD**

:    Path to `C-code date` programme.

     Forks of **GNU**, **BSD**, **AST**,
     and **Busybox** **date** are supported.


**TZ**

:    Offset time.

     POSIX time zone definition by the $TZ variable takes a different form from ISO-8601 standards, so that ISO UTC-03 is equivalent to setting $TZ=UTC+03.

     Only the **C-code date** programme can parse timezone names and IDS.


## WARRANTY

Licensed under the **GNU General Public License 3** or better. This
software is distributed without support or bug corrections. Many
thanks for all whose advice improved this script from c.u.shell.

`Bash2.05b+`, `Ksh93` or `Zsh` is required. `Bc` or `Ksh93` is required
for single-unit calculations. `FreeBSD12+` or `GNU` `date` is
optionally required.


## SEE ALSO

- `Datediff` from `dateutils`, by _Hroptatyr_
 <www.fresse.org/dateutils/>
- `PDD` from _Jarun_
 <github.com/jarun/pdd>
- `AST date` elapsed time `option -E`
 <github.com/att/ast>
- `Units` from GNU.
 <https://www.gnu.org/software/units/>
- Do calendrical savants use calculation to answer date questions?
 A functional magnetic resonance imaging study, _Cowan and Frith_, 2009.
 <https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2677581/#!po=21.1864>
- Calendrical calculation, _Dershowitz and Reingold_, 1990
 <http://www.cs.tau.ac.il/~nachum/papers/c/home/jsn/www/lab-shelldatediff/man/datediff.sh.1.mdc-paper.pdf>
 <https://books.google.com.br/books?id=DPbx0-qgXu0C>
- How many days are in a year? _Manning_, 1997.
 <https://pumas.nasa.gov/files/04_21_97_1.pdf>
- Iana Time zone database
 <https://www.iana.org/time-zones>
- Fun with Date Arithmetic (see replies)
 <https://linuxcommando.blogspot.com/2009/11/fun-with-date-arithmetic.html>

| Tip: Division is but subtractions and multiplication but additions.
| --Lost reference


## EXAMPLES

**Leap year check**

|    datediff.sh **-l** 2000
|    datediff.sh **-l** {1980..2000}
|    echo 2000 | datediff.sh **-l**


**Moon phases for January 1996**

|    datediff.sh **-m** 1996-01

**Print following Friday, 13th**

|    datediff.sh **-F**

**Print following Sunday, 12th after 1999**

|    datediff.sh **-F** sun 12 1999

**Single unit time periods**

|    datediff.sh 2022-03-01T00:00:00 2022-03-01T10:10:10 _m_
|    datediff.sh \'10 years ago\'  _mo_
|    datediff.sh 1970-01-01  2000-02-02  _y_

**Time ranges/intervals**

|    datediff.sh 2020-01-03T14:30:10 2020-12-24T00:00:00
|    datediff.sh 0921-04-12 1999-01-31
|    echo 1970-01-01 2000-02-02 | datediff.sh 
|    _TZ=UTC+3_ datediff.sh  2020-01-03T14:30:10-06  2021-12-30T21:00:10-03:20

**GNU date warping**

|    datediff.sh \'next monday\'
|    datediff.sh 2019/6/28  1Aug
|    datediff.sh \'5min 34seconds\'
|    datediff.sh 1aug1990-9month now
|    datediff.sh \-- -2week-3day
|    datediff.sh \-- \"today + 1day\" *\@*1952292365
|    datediff.sh **-2** \-- \'1hour ago 30min ago\'
|    datediff.sh  today00:00  \'12 May 2020 14:50:50\'
|    datediff.sh \'2020-01-01 - 6months\' 2020-01-01
|    datediff.sh \'05 jan 2005' \'now - 43years -13 days\'
|    datediff.sh **-u** 2023-01-14T11:20:00Z \'2023-01-14T11:20:00Z + 5 hours\'
|    datediff.sh *\@*1561243015 *\@*1592865415

**BSD date warping**

|    datediff.sh **-f**\'%m/%d/%Y\' 6/28/2019  9/04/1970 
|    datediff.sh **-r** 1561243015 1592865415
|    datediff.sh  200002280910.33  0003290010.00
|    datediff.sh \-- \'-v +2d\' \'-v -3w\'


## OPTIONS


**Extra Functions**

**-e**  \[_YEAR_..]

:    Print Easter dates (Western Church).

**-ee**  \[_YEAR_..]

:    Print Carnaval, Easter and Corpus Christi dates.


**-FF**  \[\[_DAY_IN_WEEK_] \[_DAY_IN_MONTH_]] \[_START_DATE_]

:    Print following Friday the 13th date.

**-h**

:    Print this help page.

**-l**  \[_YEAR_..]

:    Check if YEAR is leap year.

**-m**  \[_YYYY[-MM[-DD]]_]

:    Print lunar phase at DATE (ISO UTC time).


**Main Function**

**-[**_0-9_**]**

:    Set scale for single unit interval results.

**-DD**, **-dd**

:    Debug options, check the Debug Section above.


**-f**  \[_FMT_]

:    Input time string format (only with `BSD date`).

**-R**

:    Print human time in RFC-5322 format (verbose).


**-r**, **-\@**

:    Input DATES are UNIX timestamps.


**-t**, **-tt**

:    Table display of single unit intervals (such as `-ttv`).

**-u**

:    Set or print in UTC times instead of local times. This affects
     how `C-code date` process input dates.


**-v**, **-vv**, **-vvv**

:    Change how output is displayed, verbose levels.



<!-- Verbose level, change print layout of functions. -->


<!-- Generate the man page:
    pandoc --standalone --to man ~/bin/ddate/datediff.sh.1.md -o ./datediff.sh.1
-->
