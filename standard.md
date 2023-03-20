# Package Definition

A Poseidon package is defined as a directory with specific files:

* a `POSEIDON.yml` file, which gives important meta-information for the package, like author, version and file paths
* Genotype data in PLINK or EIGENSTRAT format
* An optional (but strongly recommended) so-called `.janno` file, which lists meta-data for each individual in a tab-separated table
* an optional bibliography file formatted as [BibTeX](http://www.bibtex.org/)
* an optional README file
* an optional CHANGELOG file
* an optional sequencingSourceFile, which lists links to raw data in archives such as the [ENA](https://www.ebi.ac.uk/ena/browser/home).

The precise definitions of each of these files is detailed in our [schema-repository](https://github.com/poseidon-framework/poseidon2-schema).

<a class="github-button" href="https://github.com/poseidon-framework/poseidon2-schema/issues" data-icon="octicon-issue-opened" data-show-count="true" aria-label="Issue poseidon-framework/poseidon2-schema on GitHub">Report an issue</a>
<a class="github-button" href="https://github.com/poseidon-framework/poseidon2-schema" data-icon="octicon-star" data-show-count="true" aria-label="Star poseidon-framework/poseidon2-schema on GitHub">Star this project</a>

Here is an example of the files in a typical package:

```
Switzerland_LNBA_Roswita/POSEIDON.yml
Switzerland_LNBA_Roswita/Switzerland_LNBA.plink.bed
Switzerland_LNBA_Roswita/Switzerland_LNBA.plink.bim
Switzerland_LNBA_Roswita/Switzerland_LNBA.plink.fam
Switzerland_LNBA_Roswita/Switzerland_LNBA.janno
Switzerland_LNBA_Roswita/Switzerland_LNBA.bib
Switzerland_LNBA_Roswita/README.txt
Switzerland_LNBA_Roswita/CHANGELOG.txt
Switzerland_LNBA_Roswita/sourcedata.tsv
```

And here a fitting `POSEIDON.yml` file. It lists relative file paths and metainformation in a standardized, machine-readable format.

```
poseidonVersion: 2.5.0
title: Switzerland_LNBA_Roswita
description: LNBA Switzerland genetic data not yet published
contributor:
  - name: Josiah Carberry
    email: carberry@brown.edu
    orcid: 0000-0002-1825-0097
  - name: Paul Panther
    email: paul.panther@example.edu
packageVersion: 1.1.2
lastModified: 2021-04-28
genotypeData:
  format: PLINK	
  genoFile: Switzerland_LNBA_Roswita.bed
  snpFile: Switzerland_LNBA_Roswita.bim
  indFile: Switzerland_LNBA_Roswita.fam
  snpSet: 1240K
jannoFile: Switzerland_LNBA_Roswita.janno
sequencingSourceFile: sourcedata.tsv
bibFile: sources.bib
readmeFile: README.txt
changelogFile: CHANGELOG.txt
```

When a package is modified in any way (e.g. updates of the context information in the `.janno` file), then the `packageVersion` field should be incremented and the `lastModified` field updated to the current date.

For the key elements in a package, see the pages for [genotype data](genotype_data) and the [.janno file](janno_details).


