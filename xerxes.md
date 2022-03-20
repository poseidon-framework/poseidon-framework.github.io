# Xerxes CLI software

* Documentation for version 0.1.0.0

## Fstats command

Xerxes allows you to analyse genotype data across poseidon packages, including your own, as explained above by "hooking" in your own package via a `--baseDir` (or `-d`) parameter. This has the advantage that you can compute arbitrary F-Statistics across groups and individuals distributed in many packages, without the need to explicitly merge the data. Xerxes also takes care of merging PLINK and EIGENSTRAT data on the fly. It also takes care of different genotype base sets, like Human-Origins vs. 1240K. It also flips alleles automatically across genotype files, and throws an error if the alleles in different packages are incongruent with each other. Xerxes is also smart enough to select only the packages relevant for the statistics that you need, and then streams through only those genotype data.

Here is an example command for computing several F-Statistics:

```
xerxes fstats -d ... -d ... \
  --stat "F4(<Chimp.REF>, <Altai_published.DG>, Yoruba, French)" \
  --stat "F4(<Chimp.REF>, <Altai_snpAD.DG>, Spanish, French)" \
  --stat "F4(Mbuti,Nganasan,Saami.DG,Finnish)" \
  --stat "F3(French,Spanish,Mbuti)" \
  --stat "F3(Sardinian, <MA1.SG>, French)" \
  --stat "F2(French,Spanish)" \
  --stat "PWM(French,Spanish)" \
  --stat "FST(French,Spanish)" \
  -f outputfile.txt
```

This showcases a couple of points:
* You can compute F2, F3 and F4 statistics, as well as Pairwise-Mismatch-Rates (PWM) and FST between groups.
* Use the `--stat` option to enter a single statistic. Use it multiple times to compute several statistics in one go
* Use opening and closing brackets to list the groups, separated by comma followed by zero or more spaces.
* Enclose a statistic with double-quotes in order to not have bash interpret the brackets wrongly.
* A normal name is interpreted as the name of a group, while a name enclosed by angular brackets, like "<Chimp.REF>" refers to an _individual_. This can be useful if you want to analyse some individuals in a group separately.

You can also load these statistics from a file. Say you have a file named `fstats.txt` with the following content:

```
F4(<Chimp.REF>, <Altai_published.DG>, Yoruba, French)
F4(<Chimp.REF>, <Altai_snpAD.DG>, Spanish, French)
F4(Mbuti,Nganasan,Saami.DG,Finnish)
```

you can then load these statistics using the option `--statFile fstats.txt`. You can also combine statistics read from
a file and statistics read from the command line.

While running the command, you will see a lot of log messages of the form:

```
computing chunk range (1,752566) - (1,12635412), size 5000
computing chunk range (1,12637058) - (1,23477511), size 5000
computing chunk range (1,23485934) - (1,36980804), size 5000
computing chunk range (1,36983827) - (1,49518537), size 5000
computing chunk range (1,49519125) - (1,61041875), size 5000
```

This shows you the progress of the command. Each logging row here denotes a block of genotype data, for which each statistic is computed, as listed in the end of each line.

The final output of the `fstats` command looks like this:

```
.----------------------------------------------------.------------------------.-----------------------.---------------------.
|                     Statistic                      |        Estimate        |        StdErr         |       Z score       |
:====================================================:========================:=======================:=====================:
| F4(<Chimp.REF>,<Altai_published.DG>,Yoruba,French) | 1.5818676232155493e-3  | 1.982581647865739e-4  | 7.9788271263301525  |
| F4(<Chimp.REF>,<Altai_snpAD.DG>,Spanish,French)    | 2.7141327349031186e-5  | 3.466226718060918e-5  | 0.7830222762870696  |
| F4(Mbuti,Nganasan,Saami.DG,Finnish)                | -4.043746953619087e-3  | 2.762626586426705e-4  | -14.637327293839723 |
| F3(French,Spanish,Mbuti)                           | 0.2559919477898731     | 2.4689280173971206e-3 | 103.68546429302296  |
| F3(Sardinian,<MA1.SG>,French)                      | -7.4289157055813515e-3 | 5.014922444930713e-4  | -14.813620324459457 |
| F2(French,Spanish)                                 | 2.0095370727631068e-4  | 1.2247621687567062e-5 | 16.407569763548867  |
| PWM(French,Spanish)                                | 0.2344403145673155     | 7.47206478154086e-4   | 313.75573074055995  |
| FST(French,Spanish)                                | 9.505255375107935e-4   | 4.0975688373199805e-5 | 23.197304920263054  |
'----------------------------------------------------'------------------------'-----------------------'---------------------'

```
which lists each statistic, the genome-wide estimate, its standard error and its Z-score. An even more detailed table is output if you specify an output file using option `--tableOutFile` or `-f`, which then also gives the entity names in tab-separated columns, which is useful for further processing.

All options for the `fstats` subcommand can be listed using `xerxes fstats --help`:

```
Usage: xerxes fstats (-d|--baseDir DIR) [-j|--jackknife ARG] 
                     [-e|--excludeChroms ARG] [--stat ARG] [--statFile ARG] 
                     [-f|--tableOutFile ARG]
  Compute f-statistics on groups and invidiuals within and across Poseidon
  packages

Available options:
  -h,--help                Show this help text
  -d,--baseDir DIR         a base directory to search for Poseidon Packages
                           (could be a Poseidon repository)
  -j,--jackknife ARG       Jackknife setting. If given an integer number, this
                           defines the block size in SNPs. Set to "CHR" if you
                           want jackknife blocks defined as entire chromosomes.
                           The default is at 5000 SNPs
  -e,--excludeChroms ARG   List of chromosome names to exclude chromosomes,
                           given as comma-separated list. Defaults to X, Y, MT,
                           chrX, chrY, chrMT, 23,24,90
  --stat ARG               Specify a summary statistic to be computed. Can be
                           given multiple times. Possible options are: F4(a, b,
                           c, d), F3(a, b, c), F2(a, b), PWM(a, b), FST(a, b),
                           Het(a) and some more special options described at
                           https://poseidon-framework.github.io/#/xerxes?id=fstats-command.
                           Valid entities used in the statistics are group names
                           as specified in the *.fam, *.ind or *.janno failes,
                           individual names using the syntax "<Ind_name>", so
                           enclosing them in angular brackets, and entire
                           packages like "*Package1*" using the Poseidon package
                           title. You can mix entity types, like in
                           "F4(<Ind1>,Group2,*Pac*,<Ind4>)". Group or individual
                           names are separated by commas, and a comma can be
                           followed by any number of spaces.
  --statFile ARG           Specify a file with F-Statistics specified similarly
                           as specified for option --stat. One line per
                           statistics, and no new-line at the end
  --maxSnps ARG            Stop after a maximum nr of snps has been processed.
                           Useful for short test runs
  -f,--tableOutFile ARG    a file to which results are written as tab-separated
                           file
```

### Allowed statistics

The following statistics are allowed in the `--stat` and the `--statFile` options. In all of the following, symbols `a`, `b`, `c` or `d` stand for arbitrary entities allowed in Poseidon, so groups (such as `French`), individuals (such as `<MA1.SG>`) or packages (such as `*2012_PattersonGenetics*`).

* `F2vanilla(a, b)`: F2-Statistics - Vanilla version. Computed using `F2vanilla(a, b) = (a-b)^2` across the genome.
* `F2(a, b)`: F2-Statistics (bias-corrected version). Computed as `F2(a, b) = F2vanilla(a, b) - hA/sA - hB/sB`, where where `sA` is the number of non-missing alleles in entity A, and `hA = nA * nA' / sA * (sA - 1)` is an estimator of half the heterozygosity (see `Het(a)`), and likewise for `sB` and `nB` etc.
* `F3vanilla(a,b,c)`: F3-Statistics - Vanilla version, recommended if used as Outgroup-F3 statistics or with group c being pseudo-haploid: Are computed as `F3(a, b, c) = (c-a)(c-b)` across all SNPs.
* `F3(a,b,c)`: F3-Statistics - normalised and bias-corrected version, recommended for Admixture-F3 tests. Are computed by i) first substracting per SNP from the vanilla-F3 statistic a bias-correction term hC/sC, as above for F2, and ii) then normalising the genome-wide estimate by a genome-wide estimate of the heterozygosity of entity C (`Het(c)`), in order to make results comparable between different groups C (see Patterson et al., Genetics, 2012)
* `F4(a,b,c,d)`: F4 statistics. Are computed by averageing the quantity (a-b)(c-d) across all SNPs. No bias correction is necessary for this statistic.
* `Het(a)`: An estimate of the heterozygosity across all SNPs, computed as `2*hA`, with `hA` defined as above in `F2`
* `FST(a, b)`: An estimate of FST across the genome, following the formular from Appendix A in Patterson et al. 2012, which is a ratio of two terms, with numerator being `F2(a, b)` including bias correction, and the denominator being `F2(a, b) + hA + hB` including bias correction and `hA` and `hB` defined as above.
* `PWM(a, b)`: The pairwise mismatch rate between entities a and b, computed from allele frequencies as `a (1 - b) + (1 - a) b`.


## RAS (in development)

The RAS command computes pairwise RAS statistics between a collection of "left" entities, and a collection of "right" entities. Every Entity is either a group name or an individual, with the similar syntax as in F-statistics above, so `French` is a group, and `<IND001>` is an individual.

The input of left-pops and right-pops uses a YAML file via `--popConfigFile`. Here is an example:
```
groupDefs:
  group1: a,b,!c,!<d>
  group2: e,f,!<g>
popLefts:
- <I13721>
- <I14000>
- <I13722>
- <Iceman.SG>
popRights:
- Mbuti
- Mixe
- Spanish
outgroup: <Chimp.REF>
```

In this case, two groups are defined on the fly: `group1` comprises groups `a` and `b`, but excludes group `c` and individual `d`. Note that inclusions and exclusions are executed in order. `group2` comprises of group `e` and group `f`, but excludes individual `<g>`.

As in [RAScalculator](https://github.com/TCLamnidis/RAStools), the allele frequency ascertainment is done across right populations only. 

The are a couple of optons, as specified in the CLI help (`xerxes ras --help`):

```
Usage: xerxes ras (-d|--baseDir DIR) [-j|--jackknife ARG] 
                  [-e|--excludeChroms ARG] --popConfigFile ARG 
                  [-k|--maxAlleleCount ARG] [-m|--maxMissingness ARG]
                  (-f|--tableOutFile ARG)
  Compute RAS statistics on groups and individuals within and across Poseidon
  packages

Available options:
  -h,--help                Show this help text
  -d,--baseDir DIR         a base directory to search for Poseidon Packages
                           (could be a Poseidon repository)
  -j,--jackknife ARG       Jackknife setting. If given an integer number, this
                           defines the block size in SNPs. Set to "CHR" if you
                           want jackknife blocks defined as entire chromosomes.
                           The default is at 5000 SNPs
  -e,--excludeChroms ARG   List of chromosome names to exclude chromosomes,
                           given as comma-separated list. Defaults to X, Y, MT,
                           chrX, chrY, chrMT, 23,24,90
  --popConfigFile ARG      a file containing the population configuration
  -k,--maxAlleleCount ARG  define a maximal allele-count cutoff for the RAS
                           statistics. (default: 10)
  -m,--maxMissingness ARG  define a maximal missingness for the right
                           populations in the RAS statistics. (default: 0.1)
  -f,--tableOutFile ARG    the file to which results are written as
                           tab-separated file
```

The output gives both cumulative (up to allele-count k) and and per-allele-frequency RAS (for allele count k) for every pair of left and rights. The standard out contains a pretty-printed table, and in adition, a tab-separated file is written to the file specified using option `-f`. 