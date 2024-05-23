# Getting started

This is a short tutorial that runs you through some basic functionality of the poseidon framework and tooling.

Please also see the slides [A short introduction to the Poseidon framework](https://nevrome.github.io/uni.tuebingen.poseidon.intro.2h.2024/) by Clemens Schmid, which showcases many key aspects of the framework, as well as our [preprint on biorxiv](https://www.biorxiv.org/content/10.1101/2024.04.12.589180).

## Preparation
You will need to install our two command-line tools `trident` and `xerxes`. They are available as pre-compiled binaries for MacOS and Linux, and in case of trident also for Windows: 
* `trident`: https://github.com/poseidon-framework/poseidon-hs/releases/latest
* `xerxes`: https://github.com/poseidon-framework/poseidon-analysis-hs/releases/latest

You can also install both tools from bioconda: [trident](https://anaconda.org/bioconda/poseidon-trident), [xerxes](https://anaconda.org/bioconda/poseidon-xerxes)

For the following, we assume you have the executables for your operating system somewhere on your path.

## Getting some remote data

Let's check which packages are available remotely:

```bash
trident list --remote --packages
```

You will see a long list of packages. Let's check which packages has French individuals

```bash
trident list --remote --groups --raw | grep 'French'
```

Among the packages listed you should find `2012_PattersonGenetics`. 
Let's download that one, and let's also add three further packages. We will download them into a new directory named `~/poseidon_repo` right in your home folder:

?> Tipp: You can also use `trident list` to view entities in your own local repository. You can list packages, groups or individuals. Check out `trident list --help` or the [documentation](trident.md)

```bash
mkdir -p ~/poseidon_repo
trident fetch -f '*2012_PattersonGenetics*,*Reference_Genomes*,*Archaic_Humans*' -d ~/poseidon_repo
```

We can now check out some summary of the packages:

```bash
trident summarise -d ~/poseidon_repo
```

which gives us a short summary of the package contents:
```
.-------------------------.--------------------------------------------------------------.
|         Summary         |                            Value                             |
:=========================:==============================================================:
| Nr Individuals          | 1052                                                         |
| Individuals             | Altai_published.DG, Altai_snpAD.DG, Ancestor.REF, Chimp.REF… |
| Nr Groups               | 122                                                          |
| Groups                  | Yoruba: 70, Han: 43, Druze: 39, Palestinian: 38, Ignore_Yor… |
| Nr Publications         | 10                                                           |
| Publications            | PattersonGenetics2012, Pruefer2017, PrueferNature2013, Meye… |
| Nr Countries            | 27                                                           |
| Countries               | Pakistan: 187, China: 179, Israel: 133, Nigeria: 108, Russi… |
| Mean age BC/AD          | -45479 ± 5108                                                |
| Dating type             | modern: 1040, contextual: 12                                 |
| Sex distribution        | M: 683, F: 356, U: 13                                        |
| MT haplogroups          | n/a: 1052                                                    |
| Y haplogroups           | n/a: 1050, A0-T: 1, BT: 1                                    |
| % endogenous human DNA  | no values                                                    |
| Nr of SNPs              | 597207 ± 51237                                               |
| Coverage on target SNPs | 17.09 ± 19.87                                                |
| Library type            | ds: 1045, ss: 7                                              |
| UDG treatment           | n/a: 1043, minus: 7, half: 2                                 |
'-------------------------'--------------------------------------------------------------'
```


## Simple analyses

Let's analyse the newly downloaded data using some F-statistics. Let's show that people with West-Eurasian ancestry are significantly more closely related to Neanderthals than people with West-African ancestry are:

```bash
xerxes fstats -d ~/poseidon_repo --stat 'F4(<Chimp.REF>,<Altai_published.DG>,Yoruba,French)' \
  --stat 'F4(<Chimp.REF>,<Altai_published.DG>,Sardinian,French)'
```

Here is the result:
```
.-------------------------------------------------------.-----------.-----------.--------------------.
|                       Statistic                       | Estimate  |  StdErr   |      Z score       |
:=======================================================:===========:===========:====================:
| F4(<Chimp.REF>,<Altai_published.DG>,Yoruba,French)    | 1.5829e-3 | 1.9813e-4 | 7.989467197071763  |
| F4(<Chimp.REF>,<Altai_published.DG>,Sardinian,French) | 7.6101e-5 | 6.9205e-5 | 1.0996459760097628 |
'-------------------------------------------------------'-----------'-----------'--------------------'
```

You can see that the Z-Score for French being more closely related to the Altai Neanderthal than Yoruba are (an ethnic group from Nigeria) is much larger than 3, suggesting high significance, while the Z-score for either Sardinians or French being more closely related to the Altai Neanderthal is not-significant.

?> Tipp: There are many other statistics that you can compute, such as F2, F3 or FST. Check out `xerxes fstats --help` or the [documentation](xerxes.md)

## Creating your own packages

We now assume that you have genotype data available from your own set of ancient or modern samples. We can simulate this situation by downloading an existing package:

```bash
mkdir -p ~/tmp
trident fetch -f '*2014_SkoglundScience*' -d ~/tmp
```

We now forget about the fact that this is already a Poseidon package and just use its genotype data to create a new package:

```bash
trident init \
  -p ~/tmp/2014_SkoglundScience/2014_SkoglundScience.bed \
  -o ~/tmp/MyNewPackage
```

## Inspecting packages

We can also check out the completeness of metadata files in packages (their "Janno"-File):

```bash
trident survey -d ~/tmp/MyNewPackage
```

which yields:
```
.--------------.---------------------------------------------------------.
|   Package    |                         Survey                          |
:==============:=========================================================:
| MyNewPackage | GB|███..|.....|.....|.....|.....|.....|.....|.....|.... |
'--------------'---------------------------------------------------------'
```

Here, every dot is a meta-data column which has missing data, so almost all metadata is missing. No surprise since we've just created the package from scratch. For comparison, here is the result from the 3 packages we had downloaded before:

```bash
trident survey -d ~/poseidon_repo
```

which gives

```
.------------------------.---------------------------------------------------------.
|        Package         |                         Survey                          |
:========================:=========================================================:
| 2012_PattersonGenetics | GB|███..|...██|░.███|.....|.....|.█.██|..█..|.....|.██. |
| Archaic_Humans         | GB|███..|...██|█.▓▓█|...▓▓|▓..░▓|░█▓██|..██.|.....|▓██. |
| Reference_Genomes      | GB|███..|...█.|....█|.....|.....|.█.██|..█..|.....|.██. |
'------------------------'---------------------------------------------------------'
```

with a lot more fields filled.

?> To learn about the metadata fields available, check out the [documentation](janno_details.md).

?> To learn more about `trident init`, `trident summarise` and `trident survey`, check out the respective help docs (`tridnet init --help` etc) or the [documentation](trident.md).


## Forging a new packages

Now that we have our own (fake) package and packages with existing data, we can forge them together to create one large package.

A particularly useful feature is the ability to pull out specific groups, packages and individuals. To make a selection, let's first list the packages we have now:

```bash
trident list --packages -d ~/poseidon_repo
```

which gives 
```
.------------------------.----------------.
|         Title          | Nr Individuals |
:========================:================:
| 2012_PattersonGenetics | 1036           |
| Archaic_Humans         | 12             |
| Reference_Genomes      | 4              |
'------------------------'----------------'
```

OK, which groups do we have?
```bash
trident list --groups -d ~/poseidon_repo
```

actually a lot, here is a truncated output:
```
.--------------------------------------.------------------------.----------------.
|                Group                 |        Packages        | Nr Individuals |
:======================================:========================:================:
| Adygei                               | 2012_PattersonGenetics | 16             |
| Altai_Neanderthal.DG                 | Archaic_Humans         | 1              |
| Altai_Neanderthal_published.DG       | Archaic_Humans         | 1              |
| Ancestor.REF                         | Reference_Genomes      | 1              |
| Balochi                              | 2012_PattersonGenetics | 20             |
| BantuKenya                           | 2012_PattersonGenetics | 6              |
| BantuSA                              | 2012_PattersonGenetics | 5              |
| BantuSA_Ovambo                       | 2012_PattersonGenetics | 1              |
| Basque                               | 2012_PattersonGenetics | 20             |
| BedouinA                             | 2012_PattersonGenetics | 25             |
...
```

and individuals likewise:

```bash
trident list --individuals -d ~/poseidon_repo
```

```
.------------------------.-----------------------------------.--------------------------------------.
|        Package         |            Individual             |                Group                 |
:========================:===================================:======================================:
| 2012_PattersonGenetics | HGDP00001                         | Brahui                               |
| 2012_PattersonGenetics | HGDP00003                         | Brahui                               |
| 2012_PattersonGenetics | HGDP00005                         | Brahui                               |
| 2012_PattersonGenetics | HGDP00007                         | Brahui                               |
| 2012_PattersonGenetics | HGDP00011                         | Brahui                               |
| 2012_PattersonGenetics | HGDP00013                         | Ignore_Brahui                        |
| 2012_PattersonGenetics | HGDP00015                         | Brahui                               |
...
```

OK, we can now make arbitraty selections of packages, groups and individuals, for which there is a mini-language described in `trident forge --help`. 

For example, here is a command that forges a new package consisting of

* all individuals that in Patterson package, excluding the Brahui group, but including individual HGDP00001
* all individuals from the Archaic_Humans package, except for individual Denisova11.SG
* the Chimp and the Human reference genome
* my entire newly created package from above

```bash
trident forge -d ~/poseidon_repo -d ~/tmp/MyNewPackage \
  -o ~/tmp/MyForgedPackage -n MyForgedPackage \
  -f '*2012_PattersonGenetics*,-Brahui,<HGDP00001>,*Archaic_Humans*,-<Denisova11.SG>,<Chimp.REF>,<Href.REF>,*MyNewPackage*'
```

?> Note that there is a shortcut of you just like to forge everything, which is `-f ''`, since an empty forge string implicitly forges all packages that it finds under the given base paths `-d ... -d ...`.

?> Note that you can also give a forge-file if you have a more complex set up. Check out `trident forge --help` and the [documentation](trident.md) to learn more.

We now have our forged package in `~/tmp/MyForgedPackage` with merged genotype data and all metadata, which can be used for further analysis with external tools.

?> `trident forge` is quite powerful and allows output of different genotype formats and also lets you select specific SNP sets. Check out `trident forge --help` and the [documentation](trident.md) to learn more.

