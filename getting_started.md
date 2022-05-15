# Getting started

This is a short tutorial that runs you through some basic functionality of the poseidon framework and tooling.

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

## Simple analyses

Let's analyse the newly downloaded data using some F-statistics. Let's show that people with West-Eurasian ancestry are significantly more closely related to Neanderthals than people with West-African ancestry are:

```bash
xerxes fstats -d ~/poseidon_repo --stat 'F4(<Chimp.REF>,<Altai_published.DG>,Yoruba,French)' \
  --stat 'F4(<Chimp.REF>,<Altai_published.DG>,Sardinian,French)'
```

Here is the result:
```
.-------------------------------------------------------.-----------------------.-----------------------.--------------------.
|                       Statistic                       |       Estimate        |        StdErr         |      Z score       |
:=======================================================:=======================:=======================:====================:
| F4(<Chimp.REF>,<Altai_published.DG>,Yoruba,French)    | 1.5829336247989434e-3 | 1.9812755791513955e-4 | 7.989467197071763  |
| F4(<Chimp.REF>,<Altai_published.DG>,Sardinian,French) | 7.610136296417463e-5  | 6.920533028304284e-5  | 1.0996459760097628 |
'-------------------------------------------------------'-----------------------'-----------------------'--------------------'
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
trident init --genoFile ~/tmp/2014_SkoglundScience/2014_SkoglundScience.bed \
  --snpFile ~/tmp/2014_SkoglundScience/2014_SkoglundScience.bim \
  --indFile ~/tmp/2014_SkoglundScience/2014_SkoglundScience.fam \
  --inFormat PLINK --snpSet Other \
  -o ~/tmp/MyNewPackage \
  -n MyNewPackage
```

## Inspecting packages

OK, we can now check out the new package:

```bash
trident summarise -d ~/tmp/MyNewPackage
```

which gives us a short summary of the package contents:
```
.-------------------------.--------------------------------------------------------------.
|         Summary         |                            Value                             |
:=========================:==============================================================:
| Nr Individuals          | 11                                                           |
| Individuals             | Ajvide52.SG, Ajvide53.SG, Ajvide58.SG, Ajvide59.SG, Ajvide7… |
| Nr Groups               | 5                                                            |
| Groups                  | Sweden_PWC_NHG.SG: 5, Sweden_TRB_MN.SG: 3, Sweden_HG.SG: 1,… |
| Nr Publications         | 1                                                            |
| Publications            | no values                                                    |
| Nr Countries            | 1                                                            |
| Countries               | n/a: 11                                                      |
| Mean age BC/AD          | no values                                                    |
| Dating type             | n/a: 11                                                      |
| Sex distribution        | M: 7, F: 4                                                   |
| MT haplogroups          | n/a: 11                                                      |
| Y haplogroups           | n/a: 11                                                      |
| % endogenous human DNA  | no values                                                    |
| Nr of SNPs              | no values                                                    |
| Coverage on target SNPs | no values                                                    |
| Library type            | n/a: 11                                                      |
| UDG treatment           | n/a: 11                                                      |
'-------------------------'--------------------------------------------------------------'
```

We can also check out the completeness of its metadata file (it's "Janno"-File):

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

Now that we have our own (fake) package and packages with existing data, we can forge them together to create one large package:

```bash
trident forge -d ~/poseidon_repo -d ~/tmp/MyNewPackage \
  -o ~/tmp/MyForgedPackage -n MyForgedPackage -f '*2012_PattersonGenetics*,*Archaic_Humans*,*MyNewPackage*,*Reference_Genomes*'
```

?> Note that the option `-f ''` would have worked just as well in this case, since an empty forge string implicitly forges all packages that it finds under the given base paths `-d ... -d ...`.

We now have our forged package in `~/tmp/MyForgedPackage` with merged genotype data and all metadata, which can be used for further analysis with external tools.

?> `trident forge` is quite powerful and allows output of different genotype formats and also lets you select specific SNP sets. Check out `trident forge --help` and the [documentation](trident.md) to learn more.

