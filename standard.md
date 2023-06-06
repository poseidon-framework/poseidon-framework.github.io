<!-- Subheaders will be ignored here https://docsify.js.org/#/more-pages?id=ignoring-subheaders -->

# The Poseidon package <!-- {docsify-ignore-all} -->

The core idea of Poseidon is to organize genotype data together with relevant meta- and context data in a structured yet flexible, human- and machine-readable format. This format is the Poseidon package, defined in a versioned specification, openly available here: https://github.com/poseidon-framework/poseidon-schema. This page mirrors the tables and text in this schema repository.

1. The pre-defined fields and columns in the `POSEIDON.yml`, `.janno` and `.ssf` file for the latest schema version **v2.7.1**:

<script>
  Vue.createApp({
    data () {
     return {
        ymlDefFileRows: null,
        jannoDefFileRows: null,
        ssfDefFileRows: null,
      }
    },
    async mounted () {
      const ymlResponse = await fetch(
        "https://raw.githubusercontent.com/poseidon-framework/poseidon2-schema/master/POSEIDON_yml_fields.tsv"
      );
      const ymlTSVData = await ymlResponse.text();
      this.ymlDefFileRows = this.parseTSV(ymlTSVData);
      const jannoResponse = await fetch(
        "https://raw.githubusercontent.com/poseidon-framework/poseidon2-schema/master/janno_columns.tsv"
      );
      const jannoTSVData = await jannoResponse.text();
      this.jannoDefFileRows = this.parseTSV(jannoTSVData);
      const ssfResponse = await fetch(
        "https://raw.githubusercontent.com/poseidon-framework/poseidon2-schema/master/ssf_columns.tsv"
      );
      const ssfTSVData = await ssfResponse.text();
      this.ssfDefFileRows = this.parseTSV(ssfTSVData);
    },
    methods: {
      parseTSV(csvData) {
        const lines = csvData.split("\n");
        const headers = lines[0].split("\t");
        const rows = [];
        for (let i = 1; i < lines.length; i++) {
          const values = lines[i].split("\t");
          if (values.length !== headers.length) continue;
          const row = {};
          for (let j = 0; j < headers.length; j++) {
            row[headers[j]] = values[j];
          }
          rows.push(row);
        }
        return rows;
      }
    }
  }).mount('#defFileViewer');
</script>

<div id="defFileViewer">

<!-- tabs:start -->

#### **POSEIDON.yml variables**

<details>
  <summary><u>Overview table of the fields in the POSEIDON.yml file.</u></summary>
  <div v-if="ymlDefFileRows">
    <p>{{ymlDefFileRows.length}} fields</p>
    <table>
      <thead>
        <tr>
          <th>Field</th>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
      <tr v-for="ymlDefFileRow in ymlDefFileRows">
        <td>
          <div style="max-width: 15ch;word-wrap:break-word;">
            {{ymlDefFileRow.field}}<sup v-if="ymlDefFileRow.mandatory == 'TRUE'">*</sup>
          </div>
        </td>
        <td>
          <div>
            {{ymlDefFileRow.description}}
          </div>
          <div v-if="ymlDefFileRow.parent">
            <u>subfield of:</u> {{ymlDefFileRow.parent}}
          </div>
          <div v-if="ymlDefFileRow.type">
            <u>type:</u> {{ymlDefFileRow.type}}
          </div>
          <div v-if="ymlDefFileRow.format">
            <u>format:</u> {{ymlDefFileRow.format}}
          </div>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
  <div v-else><i>...fetching data from GitHub</i></div>
</details>

See the machine-readable table with precise data type definitions here: [POSEIDON_yml_fields.tsv](https://github.com/poseidon-framework/poseidon-schema/blob/master/POSEIDON_yml_fields.tsv)

#### **.janno variables**

<details>
  <summary><u>Overview table of the columns in the .janno file.</u></summary>
  <div v-if="jannoDefFileRows">
    <p>{{jannoDefFileRows.length}} variables</p>
    <table>
      <thead>
        <tr>
          <th>Variable</th>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
      <tr v-for="jannoDefFileRow in jannoDefFileRows">
        <td>
          <div style="max-width: 15ch;word-wrap:break-word;">
            {{jannoDefFileRow.janno_column_name}}<sup v-if="jannoDefFileRow.mandatory == 'TRUE'">*</sup>
          </div>
        </td>
        <td>
          <div>
            {{jannoDefFileRow.description}}
          </div>
          <div v-if="jannoDefFileRow.multi == 'TRUE'">
            <u>list column</u>
          </div>
          <div v-if="jannoDefFileRow.data_type">
            <u>type:</u> {{jannoDefFileRow.data_type}}
          </div>
          <div v-if="jannoDefFileRow.choice == 'TRUE'">
            <u>allowed values:</u> {{jannoDefFileRow.choice_options}}
          </div>
          <div v-if="jannoDefFileRow.range == 'TRUE'">
            <u>allowed range:</u> {{jannoDefFileRow.range_lower}} - {{jannoDefFileRow.range_upper}}
          </div>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
  <div v-else><i>...fetching data from GitHub</i></div>
</details>

See the machine-readable table with precise data type definitions here: [janno_columns.tsv](https://github.com/poseidon-framework/poseidon-schema/blob/master/janno_columns.tsv)

#### **.ssf variables**

<details>
  <summary><u>Overview table of the columns in the .ssf file.</u></summary>
  <div v-if="ssfDefFileRows">
    <p>{{ssfDefFileRows.length}} variables</p>
    <table>
      <thead>
        <tr>
          <th>Variable</th>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
      <tr v-for="ssfDefFileRow in ssfDefFileRows">
        <td>
          <div style="max-width: 15ch;word-wrap:break-word;">
            {{ssfDefFileRow.sequencingSourceFile_column_name}}<sup v-if="ssfDefFileRow.mandatory == 'TRUE'">*</sup>
          </div>
        </td>
        <td>
          <div>
            {{ssfDefFileRow.description}}
          </div>
          <div v-if="ssfDefFileRow.multi == 'TRUE'">
            <u>list column</u>
          </div>
          <div v-if="ssfDefFileRow.data_type">
            <u>type:</u> {{ssfDefFileRow.data_type}}
          </div>
          <div v-if="ssfDefFileRow.choice == 'TRUE'">
            <u>allowed values:</u> {{ssfDefFileRow.choice_options}}
          </div>
          <div v-if="ssfDefFileRow.range == 'TRUE'">
            <u>allowed range:</u> {{ssfDefFileRow.range_lower}} - {{ssfDefFileRow.range_upper}}
          </div>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
  <div v-else><i>...fetching data from GitHub</i></div>
</details>

See the machine-readable table with precise data type definitions here: [ssf_columns.tsv](https://github.com/poseidon-framework/poseidon-schema/blob/master/ssf_columns.tsv)

<!-- tabs:end -->

</div>

2. The current and older version of the formal definition of the package format, mirrored from the [poseidon-schema repository](https://github.com/poseidon-framework/poseidon-schema):

<!-- tabs:start -->

#### **v2.7.1**

# The Poseidon Standard

Poseidon is a solution for genotype data organisation established within the Department of Archaeogenetics at the Max Planck Institute for the Science of Human History (MPI-SHH) in Jena.

Detailed documentation for Poseidon can be found at [https://poseidon-framework.github.io](https://poseidon-framework.github.io)

A changelog is available [here](https://poseidon-framework.github.io/#/changelog).

## The Poseidon package structure

All ancient and modern data in Poseidon are distributed into so-called packages, which are directories containing a dedicated set of files. Packages correspond to published sets of genomes, or in case of unpublished projects, ongoing (and growing) sets of samples currently analysed. All text files in the package are UTF-8 encoded.

Every package should have the following files: 

- A `POSEIDON.yml` file to formally define the package
- Genotype data in eigenstrat or plink format
- A `.janno` file to store context information
- A `.bib` file for literature references

It can also contain the following files:

- A `README.md` file for arbitrary context information
- A `CHANGELOG.md` file to document changes to the package
- A `.ssf` file with information on the underlying raw sequencing data

Example:

```
Switzerland_LNBA_Roswita/POSEIDON.yml
Switzerland_LNBA_Roswita/Switzerland_LNBA.plink.bed
Switzerland_LNBA_Roswita/Switzerland_LNBA.plink.bim
Switzerland_LNBA_Roswita/Switzerland_LNBA.plink.fam
Switzerland_LNBA_Roswita/Switzerland_LNBA.janno
Switzerland_LNBA_Roswita/Switzerland_LNBA.ssf
Switzerland_LNBA_Roswita/Switzerland_LNBA.bib
Switzerland_LNBA_Roswita/README.md
Switzerland_LNBA_Roswita/CHANGELOG.md
```

## The `POSEIDON.yml` file

The `POSEIDON.yml` file lists relative file paths and metainformation in a standardized, machine-readable format.

- It must be a valid [YAML file](https://yaml.org/).
- Its fields of the `POSEIDON.yml` file are documented in the [POSEIDON_yml_fields.tsv file](https://github.com/poseidon-framework/poseidon-schema/blob/master/POSEIDON_yml_fields.tsv) in this repository.

Example:

```
poseidonVersion: 2.5.0
title: Switzerland_LNBA_Roswita
description: LNBA Switzerland genetic data not yet published
contributor:
  - name: Roswita Malone
    email: roswita.malone@example.org
  - name: Paul Panther
    email: paul.panther@example.edu
packageVersion: 1.1.2
lastModified: 2021-01-28
genotypeData: 
  format: PLINK 
  genoFile: Switzerland_LNBA_Roswita.bed
  genoFileChkSum: 95b093eefacc1d6499afcfe89b15d56c
  snpFile: Switzerland_LNBA_Roswita.bim
  snpFileChkSum: 6771d7c873219039ba3d5bdd96031ce3
  indFile: Switzerland_LNBA_Roswita.fam
  indFileChkSum: f77dc756666dbfef3bb35191ae15a167
  snpSet: 1240K
jannoFile : Switzerland_LNBA_Roswita.janno
jannoFileChkSum: 555d7733135ebcabd032d581381c5d6f
sequencingSourceFile: Switzerland_LNBA_Roswita.ssf
sequencingSourceFileChkSum: 19db1906240ee2f076e1a9659567dca4
bibFile: Switzerland_LNBA_Roswita.bib
bibFileChkSum: 70cd3d5801cee8a93fc2eb40a99c63fa
readmeFile: README.md
changelogFile: CHANGELOG.md
```

When a package is modified in any way (e.g. updates of the context information in the `.janno` file), then the `packageVersion` field should be incremented and the `lastModified` field updated to the current date.

## Genotype data

Genotype data in Poseidon packages is stored either in PLINK (binary) or EIGENSTRAT format.

|   | PLINK (binary) | EIGENSTRAT |
|---|---|---|
| genotype file | [`.bed` (binary biallelic genotype table)](https://www.cog-genomics.org/plink/1.9/formats#bed) | [`.geno` (genotype file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67)
| SNP file  | [`.bim` (extended MAP file)](https://www.cog-genomics.org/plink/1.9/formats#bim) | [`.snp` (snp file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |
| individual file  | [`.fam` (sample information)](https://www.cog-genomics.org/plink/1.9/formats#fam) | [`.ind` (indiv file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |

In addition to these files and their checksums, you also should provide a `snpSet` entry which determines the shape of the genotype file. Currently, only `1240K`, `HumanOrigins` or `Other` are allowed. While technically not a mandatory field, for backwards compatibility, we encourage users to set this field, and in fact our software also encourages this through required user input.

##  The `.janno` file

The `.janno` file is a tab-separated text file with a header line. It holds context information (variables/columns) for each sample (objects/rows) in a package.

- A set of strictly defined core variables (defined by column name) and their possible content are documented here: [janno_columns.tsv](https://github.com/poseidon-framework/poseidon-schema/blob/master/janno_columns.tsv)
- A `.janno` file can have all of these core variables, or only a subset of them. 
- Only three columns are mandatory to make the file valid: **Poseidon_ID**, **Group_Name** and **Genetic_Sex**
- Arbitrary columns not defined here can be added as long as their column names do not clash with the defined ones.
- The column order is irrelevant.
- If information is unknown or a variable does not apply for a certain sample, then the respective cell(s) can be filled with the NULL value `n/a` or simply an empty string.
- The order of the samples (rows) in the `.janno` file must be equal to the order in the genetic data files (`.ind`, `.fam`).
- The values in the columns **Poseidon_ID**, **Group_Name** and **Genetic_Sex** must be equal to the terms used in the genetic data files (`.ind`, `.fam`).
- Multiple pre-defined columns of the `.janno` file are list columns that hold multiple values (either strings or numerics) separated by `;`.
- The decimal separator for all floating point numbers is `.`.

For a more extensive documenation of the columns and their interaction see [https://poseidon-framework.github.io/#/janno_details](https://poseidon-framework.github.io/#/janno_details).

## The `.bib` file

[BibTeX](http://www.bibtex.org/) file with all references listed in the `.janno` file. The bibtex keys must fit to ones used in the `.janno` file.

Example:

```
@article{CassidyPNAS2015,
    doi = {10.1073/pnas.1518445113},
    url = {https://doi.org/10.1073%2Fpnas.1518445113},
    year = 2015,
    month = {dec},
    publisher = {Proceedings of the National Academy of Sciences},
    volume = {113},
    number = {2},
    pages = {368--373},
    author = {Lara M. Cassidy and Rui Martiniano and Eileen M. Murphy and Matthew D. Teasdale and James Mallory and Barrie Hartwell and Daniel G. Bradley},
    title = {Neolithic and Bronze Age migration to Ireland and establishment of the insular Atlantic genome},
    journal = {Proceedings of the National Academy of Sciences}
}
```

## The `README.md` file

Informal information accompanying the package.

Example:

```
This package contains a rather interesting set of samples relevant for the peopling of the Territory of Christmas Island in the Indian Ocean. We consider this especially relevant, because ...
```

## The `CHANGELOG.md` file

Documentation of important changes in the history of a package.

Example:

```
- V 1.2.0: Fixed a spelling mistake in the site name "Hosenacker"->"Rosenacker"
- V 1.1.1: Added mtDNA contamination estimation to .janno file
- V 1.1.0: The authors of @Gassenhauer_2021 made some previously restricted samples for their publication available later and we added them
- V 1.0.0: Creation of the package
```

## The `.ssf` file

The `.ssf` file stores sequencing source data, so metainformation about the raw sequencing data behind the genotypes in a Poseidon package. The primary entities in this table are sequencing entities, typically corresponding to DNA libraries or even multiple runs/lanes of the same library.

It is a tab-separated table, much like the `.janno` file, but following a different schema, specified in the file `ssf_columns.tsv`. All columns of this schema are optional.

The link to the individuals listed in the `.janno`-file (and therefore to the entire Poseidon package) is made through a many-to-many foreign-key relationship between the .janno column `Poseidon_ID` and the .ssf column `poseidon_IDs`. That means each entry in the .janno file can be linked to many rows in the .ssf file and vice versa.

#### **v2.7.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.7.0/README.md ':include')

#### **v2.6.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.6.0/README.md ':include')

#### **v2.5.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.5.0/README.md ':include')

#### **v2.4.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.4.0/README.md ':include')

<!-- tabs:end -->
