# Changelog

Here we document changes in the Poseidon standard, so that packages can be manually updated from one version to the next. The documentation on the website should always be relevant only for the latest release.

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

### 2.0.0 -> 2.0.1 [potentially breaking]

- UTF-8 encoding became mandatory for all files in a Poseidon package
- Made many implicit details about the fields in the POSEIDON.yml and the .janno file more explicit

