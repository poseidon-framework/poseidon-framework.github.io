<!-- Subheaders will be ignored here https://docsify.js.org/#/more-pages?id=ignoring-subheaders -->

# The Poseidon package <!-- {docsify-ignore-all} -->

The core idea of Poseidon is to organize genotype data together with relevant meta- and context data in a structured yet flexible, human- and machine-readable format.

This format is the **Poseidon package**, defined in a versioned specification, openly available [here](https://github.com/poseidon-framework/poseidon-schema) and in `.pdf` format [here](https://github.com/poseidon-framework/poseidon-schema/blob/master/poseidon_package_specification.pdf). This page mirrors the tables and text in the schema repository.

1. The pre-defined fields and columns in the `POSEIDON.yml`, `.janno` and `.ssf` file for the latest schema version:

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

#### **v3.0.0**

Poseidon is a solution for archaeogenetic genotype data organisation. It is geared towards human data, but is to a large extent species-agnostic and can be used to track archaeogenetic data also of non-human species.

This standard defines a data structure: the **Poseidon package**. A Poseidon package stores genotype data with meta- and context information.

A .pdf version of the latest instance of this document can be downloaded [here](https://github.com/poseidon-framework/poseidon-schema/blob/master/poseidon_package_specification.pdf).

Further details on [genotype data](https://poseidon-framework.github.io/#/genotype_data), the [.janno file](https://poseidon-framework.github.io/#/janno_details) and the [.ssf file](https://poseidon-framework.github.io/#/ssf_details) are documented on the Poseidon website.

A changelog documents the changes across different schema versions [here](https://github.com/poseidon-framework/poseidon-schema/blob/master/changelog.md).

The key words *MUST*, *MUST NOT*, *REQUIRED*, *SHALL*, *SHALL NOT*, *SHOULD*, *SHOULD NOT*, *RECOMMENDED*, *MAY*, and *OPTIONAL* in this document are to be interpreted as described in [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

### Primary entities of a Poseidon package

The main operational entities in a Poseidon package are discrete sets of genotype data attributed to a single human or non-human individual, scientifically generated for archaeogenetic research questions. Within a Poseidon package each of these sets gets attributed a unique identifier: the `Poseidon_ID`.

Generally, archaeogenetics operates on depositional contexts, e.g. graves, with one or multiple (ancient) human or non-human individuals. Usually, it is possible to attribute the (skeletal) remains within these contexts to individuals based on archaeological evidence and physical-anthropological analysis. Each individual can get sampled one or multiple times, either by directly probing their preserved tissue, or by sampling any reagent that contains their DNA (through whatever pathway or taphonomic process). From one such sample one or multiple extracts can be derived, which can be transformed into one or multiple libraries, which may or may not be subjected to a DNA capture protocol and then sequenced one or multiple times. The raw sequencing data can undergo various different forms of computational processing and eventually genotyping to produce the data relevant for most derived analyses and thus stored in a Poseidon package.

While the wetlab-processes yield a relatively predictable tree of separate physical and digital products for any given sample, the computational data-processing breaks the conceptual tree-ness by allowing for arbitrary conflation of sequencing data obtained through potentially separate means: Data from different libraries, for example, may be merged if they are from the same individual, even if they are not from the same sample.

`Poseidon_ID`s therefore represent one consciously selected end-point in the complex data preparation graph laid out above. Typically this end-point corresponds to an optimal result for a given individual, research question and publication.

For the sake of convenience and despite the lack of conceptual clarity, below we sometimes use the term *sample* to denote `Poseidon_ID` entities. Data aggregation on the level of physical samples is often sensible, and the term is conventionally used for analysis endpoints in the community of practice.

### The Poseidon package structure

A Poseidon package is defined by the POSEIDON.yml file, which holds relative paths to all other files in the package.

A package therefore MUST contain:

- A `POSEIDON.yml` file to formally define the package
- Genotype data in PLINK, EIGENSTRAT or VCF format

It SHOULD additionally contain:

- A `.janno` file to store context information on spatiotemporal origin or sample quality
- A `.bib` file for literature references

It MAY also contain:

- A `README.md` file for arbitrary, additional context information
- A `CHANGELOG.md` file to document changes to the package
- A `.ssf` file with information on the underlying raw sequencing data

Here is an example of a package `Switzerland_LNBA_Roswita` in one directory:

```default
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

### Text encoding

All text files in the package MUST be UTF-8 encoded. They SHOULD use Unix-style line endings, so a single Line Feed (LF, `\n`) character, NOT a Carriage Return and Line Feed (CRLF) pair (`\r\n`) as in MS DOS and Windows.

`Poseidon_ID`s and `Group_Name`s, so the primary sample and group identifiers across `.janno`, `.ssf`, and genotype data files, SHOULD contain only characters of a subset of the 7-bit ASCII code set. Specifically the alphanumeric characters `A-Z`, `a-z`, `0-9`, and the symbols `_` (underscore), `-` (hyphen-minus), and `.` (period, dot or full stop).

### The `POSEIDON.yml` file

The `POSEIDON.yml` file defines Poseidon packages by listing metainformation and relative paths in a standardised, machine-readable format.

- It MUST be a valid [YAML file](https://yaml.org).
- Its mandatory and optional fields are documented in the [POSEIDON_yml_fields.tsv file](https://github.com/poseidon-framework/poseidon-schema/blob/master/POSEIDON_yml_fields.tsv).

Here is an example for a `POSEIDON.yml` file:

```yml
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
license:
  name: CC BY 4.0
  url: https://creativecommons.org/licenses/by/4.0/
  file: license.md
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

### Data licensing and the license.md file

Data licences are a common way to grant the public permission to use a dataset under copyright law.

Poseidon packages MAY specify a license, and if so, SHOULD use [Creative Commons licences](https://creativecommons.org/share-your-work/cclicenses).

Licences are documented in the `POSEIDON.yml` file in the `license` section, either with just the `name`, or with a license `file`, or with both the `name` and a `file`. `name` SHOULD include a short string with name and version of the license, e.g. `CC BY 4.0`. The `file`, typically named `license.md`, MAY include the full text of a license, or a short notifier further contextualizing the entry in the `name` field. For example:

```default
The Poseidon package Switzerland_LNBA_Roswita © 2021 by Roswita Malone is licensed under Creative Commons Attribution 4.0 International. To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
```

### Genotype data

Genotype data in Poseidon packages is stored either in (binary) PLINK, EIGENSTRAT or Variant Call Format (VCF).

|   | PLINK (binary) | EIGENSTRAT | VCF |
|---|---|---|---|
| genotype file | [`.bed` (binary biallelic genotype table) or `.bed.gz`](https://www.cog-genomics.org/plink/1.9/formats#bed) | [`.geno` (genotype file) or `.geno.gz`](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) | [`.vcf` or `.vcf.gz`](https://samtools.github.io/hts-specs/VCFv4.2.pdf) |
| SNP file  | [`.bim` (extended MAP file) or `.bim.gz`](https://www.cog-genomics.org/plink/1.9/formats#bim) | [`.snp` (snp file) or `.snp.gz`](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |  |
| individual file  | [`.fam` (sample information)](https://www.cog-genomics.org/plink/1.9/formats#fam) | [`.ind` (indiv file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |  |

Both PLINK and EIGENSTRAT formats require three files to be specified. In PLINK, the genotype file is binary (with 2 bits per genotype), while in Eigenstrat, the genotype file is text-based (with 8 bits per genotype). The SNP and individual files are text-based for both formats (see links behind the file endings in the table above). The EIGENSTRAT format specifically is common within archaeogenetics, compatible with many important tools, e.g. [EIGENSOFT](https://github.com/DReichLab/EIG) and [ADMIXTOOLS](https://github.com/DReichLab/AdmixTools). Finally, the VCF format is the most formally specified format, with properly versioned specifications being released regularly. VCF is well established in the wider genetics community and the de-facto standard to store variants in the field of medical genetics.

VCF files, as well as genotype and SNP files in PLINK and EIGENSTRAT can be stored in gzipped form, signifified by an additional file ending (`*.gz`).

To make VCF files fully convertible to PLINK and EIGENSTRAT, they MUST be biallelic and contain only genotypes coded as `0/0`, `0/1`, `1/1`, `./.`. Furthermore, they CAN encode group names and genetic sex for all samples through special header fields `##group_names=name1,name2,...` and `##genetic_sex=F,U,M,...`, respectively. If these fields are not present, then group names are assumed to be "unknown" and genetic sex "U" (unknown) for all samples.

###  The `.janno` file

The `.janno` file is a tab-separated text file with a header line. It holds context information (variables/columns) for each sample (objects/rows) in a package.

- A set of strictly defined core variables (defined by column name) and their possible content are documented here: [janno_columns.tsv](https://github.com/poseidon-framework/poseidon-schema/blob/master/janno_columns.tsv)
- A `.janno` file MAY have all of these core variables, or only a subset of them.
- Only three columns MUST be present to make the file valid: **Poseidon_ID**, **Group_Name** and **Genetic_Sex**.
- Arbitrary columns not defined here MAY be added as long as their column names do not clash with the defined ones.
- Arbitrary, additional free-text information directly related to a column **<Column_Name>** from the set of specified core variables in [janno_columns.tsv](https://github.com/poseidon-framework/poseidon-schema/blob/master/janno_columns.tsv) SHOULD be added in a column whose name has the form **<Column_Name>_Note**. Example: `Contamination_Note`.
- The column order is not fixed, but MAY follow the order in [janno_columns.tsv](https://github.com/poseidon-framework/poseidon-schema/blob/master/janno_columns.tsv). **<Column_Name>_Note** columns SHOULD be placed directly after the respective column they are refering to.
- If information is unknown or a variable does not apply for a certain sample, then the respective cell(s) MAY be filled with `n/a` or simply an empty string.
- The order of the samples (rows) in the `.janno` file MUST be equal to the order in the genetic data files (`.ind`, `.fam`) in the package.
- The values in the columns **Poseidon_ID**, **Group_Name** and **Genetic_Sex** MUST be equal to the terms used in the genetic data files (`.ind`, `.fam`).
- Multiple predefined columns of the `.janno` file are list columns that can hold multiple values (either strings or numerics) separated by `;`.
- The decimal separator for all floating point numbers MUST be `.`.

### The `.bib` file

A [BibTeX](http://www.bibtex.org/) file with all references listed in the `.janno` file. The entry keys MUST fit the ones used in the `.janno` file.

Example:

```default
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

```default
This package contains a rather interesting set of samples relevant for the peopling of the Territory of Christmas Island in the Indian Ocean. We consider this especially relevant, because ...
```

### The `CHANGELOG.md` file

A markdown file to document changes in the history of a package.

Example:

```default
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

### Details

#### The `Capture_Type` .janno column

The following protocols are specified:

- `Shotgun`: Sequencing without any enrichment (whole genome sequencing, screening etc.).
- `1240K`: Target enrichment with hybridization capture optimised for sequences covering the 1240k SNP array, see [@Fu2015](https://doi.org/10.1038/nature14558), [@Haak2015](https://doi.org/10.1038/nature14317), [@Mathieson2015](https://doi.org/10.1038/nature16152).
- `ArborComplete`, `ArborPrimePlus`, `ArborAncestralPlus`: Target enrichment with hybridization capture as provided by Arbor Biosciences in three different kits branded [myBaits Expert Human Affinities](https://arborbiosci.com/genomics/targeted-sequencing/mybaits/mybaits-expert/mybaits-expert-human-affinities).
- `TwistAncientDNA`: Target enrichment with hybridization capture as provided by Twist Bioscience [@Rohland2022](https://doi.org/10.1101/gr.276728.122).
- `WISC2013`: Whole genome capture as described by [@Carpenter2013](10.1016/j.ajhg.2013.10.002).
- `OtherCapture`: Target enrichment with hybridization capture for any other set of sequences.

#### **v2.7.1**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.7.1/README.md ':include')

#### **v2.7.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.7.0/README.md ':include')

#### **v2.6.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.6.0/README.md ':include')

#### **v2.5.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.5.0/README.md ':include')

#### **v2.4.0**

[filename](https://raw.githubusercontent.com/poseidon-framework/poseidon-schema/v2.4.0/README.md ':include')

<!-- tabs:end -->
