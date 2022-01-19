# Xerxes CLI software

## Fstats command

Xerxes allows you to analyse genotype data across poseidon packages, including your own, as explained above by "hooking" in your own package via a `--baseDir` (or `-d`) parameter. This has the advantage that you can compute arbitrary F-Statistics across groups and individuals distributed in many packages, without the need to explicitly merge the data. Xerxes also takes care of merging PLINK and EIGENSTRAT data on the fly. It also takes care of different genotype base sets, like Human-Origins vs. 1240K. It also flips alleles automatically across genotype files, and throws an error if the alleles in different packages are incongruent with each other. Xerxes is also smart enough to select only the packages relevant for the statistics that you need, and then streams through only those genotype data.

Here is an example command for computing several F-Statistics:

```
xerxes fstats -d ... -d ... \
  --stat "F4(<Chimp.REF>, <Altai_published.DG>, Yoruba, French)" \
  --stat "F4(<Chimp.REF>, <Altai_snpAD.DG>, Spanish, French)" \
  --stat "F4(Mbuti,Nganasan,Saami.DG,Finnish)" \
  --stat "F3(French,Spanish,Mbuti)" \
  --stat "F2(French,Spanish)" \
  --stat "PWM(French,Spanish)"
```

This showcases a couple of points:
* You can compute F2, F3 and F4 statistics, as well as Pairwise-Mismatch-Rates between groups. Note that in F3 statistics, the third population has the outgroup-role (or the target-admixture role depending on how you use it).
* Use the `--stat` option to enter a single statistic. Use it multiple times to compute several statistics in one go
* Use opening and closing brackets to list the groups, separated by comma followed by zero or more spaces.
* Enclose a statistic with double-quotes, to not have bash interpret the brackets wrongly.
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
computing chunk range (1,752566) - (1,12635412), size 5000, values [5.911444428637878e-3,-1.8095540770823502e-3,-1.125257367242664e-2,0.14513440659936425,3.019591456774886e-3,-1.2895210945181934]
computing chunk range (1,12637058) - (1,23477511), size 5000, values [9.680787233954864e-3,8.875422512874053e-4,-1.5542492018047156e-2,0.1510010864324222,3.423485242616963e-3,-1.3555910200669081]
computing chunk range (1,23485934) - (1,36980804), size 5000, values [2.3725885721274857e-3,-2.9289533859294493e-5,-9.839436474279163e-3,0.17268760649484693,2.883453062983087e-3,-1.4139911740647404]
computing chunk range (1,36983827) - (1,49518537), size 5000, values [1.0732414227978656e-2,1.82935508093639e-3,-1.265178671079672e-2,0.1465399856299282,4.448175472444382e-3,-1.408587647156686]
computing chunk range (1,49519125) - (1,61041875), size 5000, values [1.7715712201896328e-3,-5.296485015140395e-4,-1.0758548403470404e-2,0.13780069899614356,3.101218183674832e-3,-1.380892007845735]
```

This shows you the progress of the command. Each logging row here denotes a block of genotype data, for which each statistic is computed, as listed in the end of each line.

The final output of the `fstats` command looks like this:

```
.----------------------------------------------------.-----------------------.-----------------------.---------------------.
|                     Statistic                      |       Estimate        |        StdErr         |       Z score       |
:====================================================:=======================:=======================:=====================:
| F4(<Chimp.REF>,<Altai_published.DG>,Yoruba,French) | 3.158944901394701e-3  | 3.9396628452534067e-4 | 8.018312798519467   |
| F4(<Chimp.REF>,<Altai_snpAD.DG>,Spanish,French)    | 6.224416129499041e-5  | 6.593273670495018e-5  | 0.9440554784421251  |
| F4(Mbuti,Nganasan,Saami.DG,Finnish)                | -8.203181515666918e-3 | 5.722102735664199e-4  | -14.335956368869223 |
| F3(French,Spanish,Mbuti)                           | 0.13473315812634057   | 1.366496126392123e-3  | 98.5975412034781    |
| F2(French,Spanish)                                 | 3.16793648777051e-3   | 3.4084098466298525e-5 | 92.94470531185924   |
| PWM(French,Spanish)                                | -1.19837777631975     | 8.820206514282228e-3  | -135.86731494089872 |
'----------------------------------------------------'-----------------------'-----------------------'---------------------'
```
which lists each statistic, the genome-wide estimate, its standard error and its Z-score.