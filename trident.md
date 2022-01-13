# trident CLI software 

`trident` is a command line software tool to work with Poseidon packages and handle various data management tasks. It is written in Haskell and openly available on Github.

<a class="github-button" href="https://github.com/poseidon-framework/poseidon-hs/issues" data-icon="octicon-issue-opened" data-show-count="true" aria-label="Issue poseidon-framework/poseidon-hs on GitHub">Report an issue</a>
<a class="github-button" href="https://github.com/poseidon-framework/poseidon-hs" data-icon="octicon-star" data-show-count="true" aria-label="Star poseidon-framework/poseidon-hs on GitHub">Star this project</a>

## Installation

To download the latest stable release version of `trident` click here:

- [📥 Linux](https://github.com/poseidon-framework/poseidon-hs/releases/latest/download/trident-Linux) 
- [📥 macOS](https://github.com/poseidon-framework/poseidon-hs/releases/latest/download/trident-macOS) 
- [📥 Windows](https://github.com/poseidon-framework/poseidon-hs/releases/latest/download/trident-Windows.exe). 

So in Linux you can run the following commands to get started:

```bash
# download the current stable release binary
wget https://github.com/poseidon-framework/poseidon-hs/releases/latest/download/trident-Linux
# make it executable
chmod +x trident-Linux
# run it
./trident-Linux -h
```

The code for trident is available on [Github](https://github.com/poseidon-framework/poseidon-hs). There you will also find [older release versions](https://github.com/poseidon-framework/poseidon-hs/releases) and [instructions to build trident from source](https://github.com/poseidon-framework/poseidon-hs#for-haskell-developers).

## Guide for trident

### Poseidon package repositories
Trident generally requires Poseidon datasets to work with. Most trident subcommands therefore have a central parameter, called `--baseDir` or simply `-d` to specify one or more base directories to look for Poseidon packages. For example, if all Poseidon packages live inside a repository at `/path/to/poseidon/packages` you would simply say `trident <subcommand> -d /path/to/poseidon/dirs/` and `trident` would automatically search all subdirectories inside of the repository for valid poseidon packages (as identified by valid `POSEIDON.yml` files).

You can arrange a poseidon repository in a hierarchical way. For example:

```
/path/to/poseidon/packages
    /modern
        /2019_poseidon_package1
        /2019_poseidon_package2
    /ancient
        /...
        /...
    /Reference_Genomes
        /...
        /...
    /Archaic_Humans
        /...
        /...
```

You can use this structure to select only the level of packages you're interested in, and you can make use of the fact that `-d` can be given multiple times.

Let's use the `list` command to list all packages in the `modern` and `Reference_Genomes`:

```
trident list -d /path/to/poseidon/packages/modern \
  -d /path/to/poseidon/packages/ReferenceGenomes --packages
```

### Analysing your own dataset outside of the main repository

Being able to specify one or multiple repositories is often not enough, as you may have your own data to co-analyse with the main repository. This is easy to do, as you simply need to provide your own genotype data as yet another poseidon package to be added to your `trident list` command. For example, let's say you have genotype data in `EIGENSTRAT` format (`trident` supports `EIGENSTRAT` and `PLINK` as formats.):

```
~/my_project/my_project.geno
~/my_project/my_project.snp
~/my_project/my_project.ind
```

then you can make that to a skeleton Poseidon package with the [`init`](#init-command) command. You can also do it manually by simply adding a `POSEIDON.yml` file, with for example the following content:

```
poseidonVersion: 2.4.0
title: My_awesome_project
description: Unpublished genetic data from my awesome project
contributor:
  - name: Stephan Schiffels
    email: schiffels@institute.org
packageVersion: 0.1.0
lastModified: 2020-10-07
genotypeData:
  format: EIGENSTRAT
  genoFile: my_project.geno
  snpFile: my_project.snp
  indFile: my_project.ind
jannoFile: my_project.janno
bibFile: sources.bib
```

Two remarks: 1) all file paths are considered _relative_ to the directory in which `POSEIDON.yml` resides. Here I assume that you put this file into the same directory as the three genotype files. 2) Besides the genotype data files there are two (technically optional) files referenced by this example `POSEIDON.yml` file: `sources.bib` and `my_project.janno`. Of course you can add them manually - `init` automatically creates empty dummy versions.

Once you have set up your own "Poseidon" package (which is really only a skeleton so far), you can add it to your `trident` analysis, by simply adding your project directory to the command using `-d`:

```
trident list -d /path/to/poseidon/packages/modern \
  -d /path/to/poseidon/packages/ReferenceGenomes
  -d ~/my_project --packages
```

### Package creation and manipulation commands

#### Init command
`init` creates a new, valid poseidon package from genotype data files. It adds a valid `POSEIDON.yml` file, a dummy .janno file for context information and an empty .bib file for literature references.

The command

```
trident init \
  --inFormat EIGENSTRAT/PLINK \
  --genoFile path/to/geno_file \
  --snpFile path/to/snp_file \
  --indFile path/to/ind_file \
  --snpSet 1240K|HumanOrigins|Other \
  -o path/to/new_package_name
```

requires the format (`--inFormat`) of your input data (either `EIGENSTRAT` or `PLINK`), the paths to the respective files in `--genoFile`, `--snpFile`, and `--indFile`, and the "shape" of these files (`--snpSet`), so if they cover the `1240K`, the `HumanOrigins` or an `Other` SNP set.

|          | EIGENSTRAT | PLINK |
|----------|------------|-------|
| genoFile | .geno      | .bed  |
| snpFile  | .snp       | .bim  |
| indFile  | .ind       | .fam  |

The output package of `init` is created as a new directory `-o`, which should not already exist, and gets the package `title` corresponding to the basename of `-o`. You can also set the title explicitly with `-n`. The `--minimal` flag causes `init` to create a minimal package with a very basic `POSEIDON.yml` and no `.bib` and `.janno` files.

#### Fetch command
`fetch` allows to download poseidon packages from a remote poseidon server.

It works with 

```
trident fetch -d ... -d ... \
  -f "*package_title_1*,*package_title_2*,*package_title_3*" \
  --fetchFile path/to/forgeFile
```

and the packages you want to download must be listed either in a simple string with comma-separated values (`-f`/`--fetchString`) or in a text file (`--fetchFile`). Each package title has to be wrapped in asterisks: *package_title* (more about that in the documentation of `forge` below). `--downloadAll` causes fetch to ignore `-f` and download all packages from the server. The downloaded packages are added in the first (!) `-d` directory, but downloads are only performed if the respective packages are not already present in an up-to-date version in any of the `-d` dirs.

`fetch` also has the optional arguments `--remote https:://..."` do name an alternative poseidon server. The default points to the [DAG server](https://poseidon-framework.github.io/#/repos). 

To overwrite outdated package versions with `fetch`, the `-u`/`--upgrade` flag has to be set. Note that many file systems do not offer a way to recover overwritten files. So be careful with this switch.

#### Forge command
`forge` creates new poseidon packages by extracting and merging packages, populations and individuals from your poseidon repositories.

`forge` can be used with

```
trident forge -d ... -d ... \
  -f "*package_name*, group_id, <individual_id>" \
  --forgeFile path/to/forgeFile \
  -o path/to/new_package_name
```

where the entities (packages, groups/populations, individuals/samples) you want in the output package can be denoted either as as simple string with comma-separated values (`-f`/`--forgeString`) or in a text file (`--forgeFile`). Entities have to be marked in a certain way: 

- Each package is surrounded by `*`, so if you want all individuals of `2019_Jeong_InnerEurasia` in the output package you would add `*2019_Jeong_InnerEurasia*` to the list.
- Groups/populations are not specially marked. So to get all individuals of the group `Swiss_Roman_period`, you would simply add `Swiss_Roman_period`.
- Individuals/samples are surrounded by `<` and `>`, so `ALA026` becomes `<ALA026>`.

Do not forget to wrap the forgeString in quotes. 

You can either use `-f` or `--forgeFile` or even combine them. In the file each line is treated as a separate forgeString, empty lines are ignored and `#` starts comments. So this is a valid forgeFile:

```
# Packages
*package1*, *package2*

# Groups and individuals from other packages beyond package1 and package2
group1, <individual1>, group2, <individual2>, <individual3>

# group2 has two outlier individuals that should be ignored
-<bad_individual1> # This one has very low coverage
-<bad_individual2> # This one is from a different time period
```

By prepending `-` to the bad individuals, we can exclude them from the new package. `forge` always collects all entities (packages, groups, individuals) it should include, and only then substracts the ones it should exclude. Duplicated entries in the forgeString/File are treated as one entry. If only a negative selection, so only entities for exclusion, are listed, then `forge` will assume you want to merge all individuals in the packages found in the baseDirs (except the ones explicitly excluded, of course). An empty forgeString will therefore merge all available individuals.

Just as for `init` the output package of `forge` is created as a new directory `-o`. The title can also be explicitly defined with `-n`. `--minimal` allows for the creation of a minimal output package without `.bib` and `.janno`. This might be especially useful for data analysis pipelines, where only the genotype data is required.

`forge` has a an optional flag `--intersect`, that defines, if the genotype data from different packages should be merged with an **union** or an **intersect** operation. The default (if this option is not set) is to output the union of all SNPs, with genotypes defined as missing in samples from packages which do not have a SNP that is present in another package. With this option set, on the other hand, the forged dataset will typically have fewer SNPs, but less missingness.

`--intersect` also influences the automatic determination of the `snpSet` field in the POSEIDON.yml file for the resulting package. If the `snpSet`s of all input packages are identical, then the resulting package will just inherit this configuration. Otherwise `forge` applies the following pairwise merging logic:

| Input snpSet A | Input snpSet B | `--intersect` | Ouput snpSet |
|----------------|----------------|---------------|--------------|
| Other          | *              | *             | Other        |
| 1240K          | HumanOrigins   | True          | HumanOrigins |
| 1240K          | HumanOrigins   | False         | 1240K        |

`--selectSnps` allows to provide `forge` with a SNP file in EIGENSTRAT (`.snp`) or PLINK (`.bim`) format to create a package with a specific selection. When this option is set, the output package will have exactly the SNPs listed in this file. Any SNP not listed in the file will be excluded. If `--intersect` is also set, only the SNPs overlapping between the SNP file and the forged packages are output.

Merging genotype data across different data sources and file formats is tricky. `forge` is more verbose about potential issues, if the `-w`/`--warnings` flag is set.

#### Genoconvert command
`genoconvert` converts the genotype data in a Poseidon package to a different file format. The respective entries in the POSEIDON.yml file are changed accordingly. 

With the default setting

```
trident genoconvert -d ... -d ... --outFormat EIGENSTRAT/PLINK
```

all packages in `-d` will be converted to the desired `--outFormat` (either `EIGENSTRAT` or `PLINK`), if the data is not already in this format. 

The "old" data is not deleted, but kept around. That means conversion will result in a package with both PLINK and EIGENSTRAT data, but only one is linked in the POSEIDON.yml file, and that is what will be used by trident. To delete the old data in the conversion you can add the `--removeOld` flag.

Remember that the POSEIDON.yml file can also be edited by hand if you want to replace the genotype data in a package.

#### Update command
`update` automatically updates POSEIDON.yml files of one or multiple packages if the packages were changed.

It can be called with a lot of optional arguments

```
trident update -d ... -d ... \
  --poseidonVersion "X.X.X" \
  --versionComponent Major/Minor/Patch \
  --noChecksumUpdate
  --ignoreGeno
  --newContributors "[Firstname Lastname](Email address);..."
  --logText "short description of the update"
  --force
```

By default `update` will not edit a package's POSEIDON.yml file, even when arguments like `--versionComponent`, `--newContributors` or `--logText` are explicitly set. This default exists to run the function on a large set of packages where only few of them were edited and need an active update. A package will only be modified by `update` if either

- any of the files with checksums (e.g. the genotype data) in it were modified,
- the `--poseidonVersion` argument differs from the `poseidonVersion` in the package's POSEIDON.yml file
- or the `--force` flag was set in `update`.

If any of these applies to a package in the search directory (`--baseDir`/`-d`), it will be updated. This includes the following steps:

- If `--poseidonVersion` is different from the `poseidonVersion` field in the package, then that will be updated.
- The `packageVersion` will be incremented. If `--versionComponent` is not set, then it falls back to `Patch`, so a change in the last position of the three digit version number. `Minor` increments the middle, and `Major` the first position (see [semantic versioning](https://semver.org)).
- The `lastModified` field will be updated to the current day (based on your computer's system time).
- The contributors in `--newContributors` will be added to the `contributor` field if they're not there already.
- If any checksums changed, then they will be updated. If certain checksums are not set yet, then they will be added. The checksum update can be skipped with `--noChecksumUpdate` or partially skipped for the genotype data with `--ignoreGeno`.
- The CHANGELOG.md file will be updated with a new row for the new version and the text in `--logText` (default: "not specified"), which will be appended as the first line of the file. If no CHANGELOG.md file exists, then it will be created and referenced in the POSEIDON.yml file.

:heavy_exclamation_mark: As `update` reads and rewrites POSEIDON.yml files, it may change their inner order, layout or even content (e.g. if they have fields which are not in the [Poseidon package definition](https://github.com/poseidon-framework/poseidon2-schema)). Create a backup of the POSEIDON.yml file before running `update` if you are uncertain.

### Inspection commands

#### List command
`list` lists packages, groups and individuals of the datasets you use, or of the packages available on the server.

To list packages from your local repositories, as seen above you can run

```
trident list -d ... -d ... --packages
```

This will yield a table like this

```
.-----------------------------------------.------------.----------------.
|                  Title                  |    Date    | Nr Individuals |
:=========================================:============:================:
| 2015_1000Genomes_1240K_haploid_pulldown | 2020-08-10 | 2535           |
| 2016_Mallick_SGDP1240K_diploid_pulldown | 2020-08-10 | 280            |
| 2018_BostonDatashare_modern_published   | 2020-08-10 | 2772           |
| ...                                     | ...        |                |
'-----------------------------------------'------------'----------------'
```
so a nicely formatted table of all packages, their last update and the number of individuals in it.

To view packages on the remote server, instead of using directories to specify the locations of repositories on your system, you can use `--remote` to show packages on the remote server. For example

```
trident list --packages --remote
```

will result in a view of all published packages in our public online repository.

You can also list groups, as defined in the third column of EIGENSTRAT `.ind` files (or the first column of a PLINK `.fam` file), and individuals:

```
trident list -d ... -d ... --groups
trident list -d ... -d ... --individuals
```

The `--individuals` flag also provides a way to immediately access information from the `.janno` files on the command line. This works with the `-j`/`--jannoColumn` option. For example adding `--jannoColum Country --jannoColumn Date_C14_Uncal_BP` to the commands above will add the `Country` and the `Date_C14_Uncal_BP` columns to the respective output tables.

Note that if you want a less fancy table, for example because you want to load this into Excel, or pipe into another command that cannot deal with the neat table layout, you can use the `--raw` option to output that table as a simple tab-delimited stream.

#### Summarise command
`summarise` prints some general summary statistics for a given poseidon dataset taken from the .janno files.

You can run it with

```
trident summarise -d ... -d ...
```

which will show you context information like -- among others -- the number of individuals in the dataset, their sex distribution, the mean age of the samples (for ancient data) or the mean coverage on the 1240K SNP array in a table. `summarise` depends on complete .janno files and will silently ignore missing information for some statistics.

You can use the `--raw` option to output the summary table in a simple, tab-delimited layout.

#### Survey command
`survey` tries to indicate package completeness (mostly focused on `.janno` files) for poseidon datasets.

Running

```
trident survey -d ... -d ...
```

will yield a table with one row for each package. See `trident survey -h` for a legend which cell of this table means what.

Again you can use the `--raw` option to output the survey table in a tab-delimited format.

#### Validate command
`validate` checks poseidon datasets for structural correctness. 

You can run it with

```
trident validate -d ... -d ...
```

and it will either report a success (`Validation passed ✓`) or failure with specific error messages to simplify fixing the issues. 

`validate` tries to ensure that each package in the dataset adheres to the [schema definition](https://github.com/poseidon-framework/poseidon2-schema). Here is a list of what is checked:

- Presence of the necessary files
- Full structural correctness of .bib and .janno file
- Superficial correctness of genotype data files. A full check would be too computationally expensive
- Correspondence of BibTeX keys in .bib and .janno
- Correspondence of individual and group IDs in .janno and genotype data files

In fact much of this validation already runs as part of the general package reading pipeline invoked for many trident subcommands (e.g. `forge`). `validate` is meant to be more thorough, though, and will explicitly fail if even a single package is broken.

### Analysis commands

#### Fstats command

Trident allows you to analyse genotype data across poseidon packages, including your own, as explained above by "hooking" in your own package via a `--baseDir` (or `-d`) parameter. This has the advantage that you can compute arbitrary F-Statistics across groups and individuals distributed in many packages, without the need to explicitly merge the data. Trident also takes care of merging PLINK and EIGENSTRAT data on the fly. It also takes care of different genotype base sets, like Human-Origins vs. 1240K. It also flips alleles automatically across genotype files, and throws an error if the alleles in different packages are incongruent with each other. Trident is also smart enough to select only the packages relevant for the statistics that you need, and then streams through only those genotype data.

Here is an example command for computing several F-Statistics:

```
trident fstats -d ... -d ... \
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

## Getting help

You can use `trident --help` and `trident <subcommand> --help` to get information about each parameter, including some which we haven't covered in this guide.

We also provide some more information for developers in the [README on Github](https://github.com/poseidon-framework/poseidon-hs).

