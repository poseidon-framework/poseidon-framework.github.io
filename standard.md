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

Poseidon is a solution for archaeogenetic genotype data organisation. This standard defines the core components of the Poseidon package.

A .pdf version of the latest instance of this document can be downloaded [here](https://github.com/poseidon-framework/poseidon-schema/blob/master/poseidon_package_specification.pdf).

Further details on [genotype data](https://poseidon-framework.github.io/#/genotype_data), the [.janno file](https://poseidon-framework.github.io/#/janno_details) and the [.ssf file](https://poseidon-framework.github.io/#/ssf_details) are documented on the Poseidon website.

The website also features a changelog documenting the changes across different schema versions [here](https://poseidon-framework.github.io/#/changelog).

The key words *MUST*, *MUST NOT*, *REQUIRED*, *SHALL*, *SHALL NOT*, *SHOULD*, *SHOULD NOT*, *RECOMMENDED*, *MAY*, and *OPTIONAL* in this document are to be interpreted as described in [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

### The Poseidon package structure

A Poseidon package stores genotype data with context information for DNA samples from (ancient) (human) individuals. Packages are defined by the POSEIDON.yml file, which holds relative paths to all other files in a package.

A package therefore MUST contain:

- A `POSEIDON.yml` file to formally define the package
- Genotype data in PLINK or EIGENSTRAT format

It SHOULD additionally contain:

- A `.janno` file to store context information on spatiotemporal origin or sample quality
- A `.bib` file for literature references

It MAY also contain:

- A `README.md` file for arbitrary, additional context information
- A `CHANGELOG.md` file to document changes to the package
- A `.ssf` file with information on the underlying raw sequencing data

Here is an example of a package `Switzerland_LNBA_Roswita` in one directory:

```
Switzerland_LNBA_Roswita/POSEIDON.yml
Switzerland_LNBA_Roswita/Switzerland_LNBA.bed
Switzerland_LNBA_Roswita/Switzerland_LNBA.bim
Switzerland_LNBA_Roswita/Switzerland_LNBA.fam
Switzerland_LNBA_Roswita/Switzerland_LNBA.janno
Switzerland_LNBA_Roswita/Switzerland_LNBA.ssf
Switzerland_LNBA_Roswita/Switzerland_LNBA.bib
Switzerland_LNBA_Roswita/README.md
Switzerland_LNBA_Roswita/CHANGELOG.md
```

All text files in the package MUST be UTF-8 encoded.

### The `POSEIDON.yml` file

The `POSEIDON.yml` file defines Poseidon packages by listing metainformation and relative paths in a standardised, machine-readable format.

- It MUST be a valid [YAML file](https://yaml.org).
- Its mandatory and optional fields are documented in the [POSEIDON_yml_fields.tsv file](https://github.com/poseidon-framework/poseidon-schema/blob/master/POSEIDON_yml_fields.tsv).

Here is an example for a `POSEIDON.yml` file:

```
poseidonVersion: 2.7.1
title: Switzerland_LNBA_Roswita
description: LNBA Switzerland genetic data not yet published
contributor:
  - name: Roswita Malone
    email: roswita.malone@example.org
    orcid: 1234-1234-1234-1234
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

When a package is modified in any way (including updates of the context information in the `.janno` file), then the `packageVersion` field SHOULD be incremented and the `lastModified` field updated to the current date.

#### Package versioning

The `packageVersion` field is a mandatory entry of the `POSEIDON.yml` file. It denotes the version of the individual package, using a three-component versioning system derived from [semantic versioning](https://semver.org).

Each version number is comprised of three numbers, separated by a `.`. For example: `0.1.0`, `1.0.0` or `2.1.3`. The first number gives the `Major`, the second the `Minor` and the third the `Patch` component of the version number. For a Poseidon package these components SHOULD be incremented when the following changes occur:

- **`Major`** (e.g. `1.4.2` -> `2.0.0`)
  - When samples are added to a package.
  - When samples are removed from a package.
  - When the genotype data (i.e. the contents of the `.bed`/`.bim`/`.fam` or `.geno`/`.snp`/`.ind` files) for any number of samples is changed.

- **`Minor`** (e.g. `1.4.2` -> `1.5.0`)
  - When larger pieces of meta- or context information are added or modified in any package file, except the genotype data. For example:
    - An entire `.janno`, `.bib` or `.ssf` file is added or replaced.
    - Entire columns in the `.janno` or `.ssf` file are added or replaced.
    - Primary publications for samples in the `.janno` and `.bib` file are added or replaced.

- **`Patch`** (e.g. `1.4.2` -> `1.4.3`)
  - When smaller pieces of meta- or context information are added or modified in any package file, except the genotype data. For example:
    - Individual entries in the `.janno` or `.ssf` file are added or replaced.
    - Secondary publications for samples in the `.janno` and `.bib` file are added or replaced.
    - BibTeX entries in the `.bib` file are modified.
    - The package `description` changes in the `POSEIDON.yml` file.
    - The `CHANGELOG.md` file is modified with additional information on previous entries.

When the `packageVersion` is changed, then the `lastModified` date MUST be updated and an entry to the `CHANGELOG.md` file SHOULD be added summarising the changes made.

Packages SHOULD start at `packageVersion` `0.1.0`.

### Genotype data

Genotype data in Poseidon packages is stored either in (binary) PLINK or EIGENSTRAT format.

|   | PLINK (binary) | EIGENSTRAT |
|---|---|---|
| genotype file | [`.bed` (binary biallelic genotype table)](https://www.cog-genomics.org/plink/1.9/formats#bed) | [`.geno` (genotype file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67)
| SNP file  | [`.bim` (extended MAP file)](https://www.cog-genomics.org/plink/1.9/formats#bim) | [`.snp` (snp file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |
| individual file  | [`.fam` (sample information)](https://www.cog-genomics.org/plink/1.9/formats#fam) | [`.ind` (indiv file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |

In addition to these files (and optionally their checksums), the POSEIDON.yml file SHOULD also provide a `snpSet` entry which determines the shape of the genotype file.

###  The `.janno` file

The `.janno` file is a tab-separated text file with a header line. It holds context information (variables/columns) for each sample (objects/rows) in a package.

- A set of strictly defined core variables (defined by column name) and their possible content are documented here: [janno_columns.tsv](https://github.com/poseidon-framework/poseidon-schema/blob/master/janno_columns.tsv)
- A `.janno` file MAY have all of these core variables, or only a subset of them.
- Only three columns MUST be present to make the file valid: **Poseidon_ID**, **Group_Name** and **Genetic_Sex**
- Arbitrary columns not defined here MAY be added as long as their column names do not clash with the defined ones.
- The column order is irrelevant.
- If information is unknown or a variable does not apply for a certain sample, then the respective cell(s) MAY be filled with `n/a` or simply an empty string.
- The order of the samples (rows) in the `.janno` file MUST be equal to the order in the genetic data files (`.ind`, `.fam`) in the package.
- The values in the columns **Poseidon_ID**, **Group_Name** and **Genetic_Sex** MUST be equal to the terms used in the genetic data files (`.ind`, `.fam`).
- Multiple predefined columns of the `.janno` file are list columns that can hold multiple values (either strings or numerics) separated by `;`.
- The decimal separator for all floating point numbers MUST be `.`.

### The `.bib` file

A [BibTeX](http://www.bibtex.org/) file with all references listed in the `.janno` file. The entry keys MUST fit the ones used in the `.janno` file.

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

To connect a sample in the package to this particular literature reference, the .janno file column `Publication` would have to be filled with `CassidyPNAS2015`.

### The `README.md` file

A simple [markdown](https://daringfireball.net/projects/markdown) file with informal, arbitrarily structured information accompanying the package.

Example:

```
This package contains a rather interesting set of samples relevant for the peopling of the Territory of Christmas Island in the Indian Ocean. We consider this especially relevant, because ...
```

### The `CHANGELOG.md` file

A markdown file to document changes in the history of a package.

Example:

```
- V 1.1.1: Fixed a spelling mistake in one site name: "Hosenacker" -> "Rosenacker"
- V 1.1.0: Added mtDNA contamination estimation to the .janno file
- V 1.0.0: Added spatial coordinates and age information to the .janno file and finalized a first stable version of the package
- V 0.2.0: Added previously restricted sample L1337
- V 0.1.0: Creation of the package
```

The structure with `- V X.X.X:` at the beginning of each line is not mandatory, but SHOULD be followed for reasons of interoperability.

### The `.ssf` file

The `.ssf` file is another tab-separated text file with a header line. It stores sequencing source data, so metainformation about the raw sequencing data behind the genotypes in a Poseidon package. The primary entities in this table are sequencing entities, typically corresponding to DNA libraries or even multiple runs/lanes of the same library.

- The predefined columns are specified here: [ssf_columns.tsv](https://github.com/poseidon-framework/poseidon-schema/blob/master/ssf_columns.tsv)
- All columns of this schema are optional, so a `.ssf` MAY have all of these core variables, only a subset of them, or even none. It SHOULD have a `poseidon_IDs` column, though, to link the sequencing entities to the Poseidon package.
- The link to the individuals listed in the `.janno`-file (and therefore to the entire Poseidon package) is made through a many-to-many foreign-key relationship between the .janno column `Poseidon_ID` and the .ssf column `poseidon_IDs`. That means each entry in the .janno file can be linked to many rows in the .ssf file and vice versa.
- As in the `.janno` file arbitrary columns not defined here MAY be added to the `.ssf` file as long as their column names do not clash with the defined ones.
- The order of columns and rows is irrelevant.
- If information is unknown or a variable does not apply, then the respective cell(s) MAY be filled with `n/a` or simply an empty string.
- Multiple predefined columns of the `.ssf` file are list columns that can hold multiple values (either strings or numerics) separated by `;`.
- The decimal separator for all floating point numbers MUST be `.`.


#### **v2.7.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.7.0/README.md ':include')

#### **v2.6.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.6.0/README.md ':include')

#### **v2.5.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.5.0/README.md ':include')

#### **v2.4.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.4.0/README.md ':include')

<!-- tabs:end -->
