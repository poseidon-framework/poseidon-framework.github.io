# Changelog

Here we document changes in the Poseidon standard, so that packages can be manually updated from one version to the next. The documentation on the website only considers the latest version.

### 2.6.0 -> 2.7.0 [not breaking]

- Added the Sequencing Source File (`.ssf`) to the Poseidon package definition.
- Added the column `Country_ISO` to the .janno file definition.
- Added the list column `Library_Names` to the .janno file definition.
- Replaced the option `other` by `mixed` in the `Library_Built` .janno column. Although this is technically a breaking change, we will not treat 2.7.0 as breaking. We assume this only affects few packages.

### 2.5.0 -> 2.6.0 [not breaking]

- Made the *contributor* field in the POSEIDON.yml file optional. We strongly recommend to keep this information in published packages, but for private packages or in computational pipelines it can be omitted now.
- Added the optional subfield *orcid* to the contributor field of the POSEIDON.yml file. A unique identifier for authors as provided by the [ORCID](https://info.orcid.org/what-is-orcid) is very valuable.
- Added new possibly entries for the *Capture_Type* field in the .janno file: `ArborComplete`, `ArborPrimePlus`, `ArborAncestralPlus`, `TwistAncientDNA`

### 2.4.0 -> 2.5.0 [breaking]

Only adds changes to the .janno file -- these are pretty significant, though. Please check [the documentation](janno_details.md) for details on how to use the new columns. 

**The function `upgrade_janno()` in [poseidonR](poseidonR) automates the transformation from the old to the new `.janno` file format.**

- Renamed multiple columns
  - *Individual_ID* -> *Poseidon_ID*
  - *No_of_Libraries* -> *Nr_Libraries*
  - *Data_Type* -> *Capture_Type*
  - *Nr_autosomal_SNPs* -> *Nr_SNPs*
  - *Publication_Status* -> *Publication*
  - *Coverage_1240K* -> *Coverage_on_Target_SNPs* (this change also implies a small semantic change in the meaning of this column)
- Added a new column to specify details about the absolute dating information
  - *Date_Note*
- Added a new set of columns to represent biological relationships among samples/individuals
  - *Alternative_IDs*
  - *Relation_To*
  - *Relation_Type*
  - *Relation_Degree*
  - *Relation_Note*
- Replaced the previous, pretty limited solution to document contamination estimates with a more flexible set of columns. That means the following columns were removed: *X_Contam*, *X_Contam_Stderr*, *MT_Contam*, *MT_Contam_Stderr*. Instead we added the following columns:
  - *Contamination*
  - *Contamination_Err*
  - *Contamination_Meas*
  - *Contamination_Note*
- Changed the column order to increase human readability

### 2.3.1 -> 2.4.0 [not breaking]

- Made the *snpSet* field introduced in 2.3.0 non-mandatory

### 2.3.0 -> 2.3.1 [breaking]

- Renamed *1240k* to *1240K* in all fields and column names

### 2.2.0 -> 2.3.0 [breaking]

- Defined the new, optional columns *Genetic_Source_Accession_IDs* and *Data_Preparation_Pipeline_URL* for the .janno file
- Added a mandatory field *snpSet* to the POSEIDON.yml file. It was later made optional in 2.4.0

### 2.1.0 -> 2.2.0 [not breaking]

- Relaxed the .janno file definition significantly: Instead of requiring a long list of variables, the standard now allows to omit any column except the mandatory *Individual_ID*, *Group_Name* and *Genetic_Sex*. The column order becomes irrelevant and arbitrary, additional variables can be added, as long as their column names do not clash with the set of pre-defined ones.
- The NULL value in .janno files can now be not just `n/a`, but alternatively also an empty string "".

### 2.0.1 -> 2.1.0 [not breaking]

- Added multiple optional fields to the POSEIDON.yml file. These include checksum fields for the genotype data as well as the .janno and .bib file. Also fields for paths to a README and a CHANGELOG file.
- Simplified and improved the standard definition document

### 2.0.0 -> 2.0.1 [breaking]

- UTF-8 encoding became mandatory for all files in a Poseidon package
- Made many implicit details about the fields in the POSEIDON.yml and the .janno file more explicit

