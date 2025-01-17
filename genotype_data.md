# Genotype data details

## File formats

Genotype data in Poseidon packages can be stored in either of two (multi)file formats: PLINK (binary) and EIGENSTRAT.

|   | PLINK (binary) | EIGENSTRAT |
|---|---|---|
| genotype file | [`.bed` (binary biallelic genotype table)](https://www.cog-genomics.org/plink/1.9/formats#bed) or `.bed.gz` | [`.geno` (genotype file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) or `.geno.gz`
| SNP file  | [`.bim` (extended MAP file)](https://www.cog-genomics.org/plink/1.9/formats#bim) or `.bim.gz` | [`.snp` (snp file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) or `.snp.gz` |
| individual file  | [`.fam` (sample information)](https://www.cog-genomics.org/plink/1.9/formats#fam) | [`.ind` (indiv file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |

The PLINK file format is a well specified, storage efficient data type compatible with many bioinformatic software tools, which made it an obvious choice for Poseidon. The EIGENSTRAT format is also common within archaeogenetics, compatible with many of the important tools developed by the Reich Lab, e.g. the ones in the [EIGENSOFT](https://github.com/DReichLab/EIG) and [ADMIXTOOLS](https://github.com/DReichLab/AdmixTools). In the future even more formats might be supported (see e.g. [here](https://reich.hms.harvard.edu/software/InputFileFormats)).

The large genotype data files to store SNP definitions and values can be stored in gzipped files (`*.gz`).

The `genotypeData` field in the `POSEIDON.yml` file documents in which format the data for a package is stored and the relative paths to the respective files.

<table>
<tr>
<th>PLINK (binary)</th>
<th>EIGENSTRAT</th>
</tr>
<tr>
<td>

```
genotypeData:
  format: PLINK
  genoFile: X.bed | X.bed.gz
  snpFile: X.bim | X.bim.gz
  indFile: X.fam
  snpSet: 1240K
```
</td>
<td>

```
genotypeData:
  format: EIGENSTRAT
  genoFile: X.geno | X.geno.gz
  snpFile: X.snp | X.snp.gz
  indFile: X.ind
  snpSet: 1240K
```
</td>
</tr>
</table>

## Typical setup and SNP panels

Poseidon is not limited to a specific panel of single nucleotide polymorphism (SNPs) that should be available for each sample. All known SNPs for an individual derived from one or multiple libraries can be merged and stored in the genotype data accompanying a Poseidon package. The `snpSet` subfield in the `POSEIDON.yml` file documents the shape of the genotype file in the respective package, with the possible entries `HumanOrigins`, `1240K`, and `Other`.

As of today (25.01.2021) most ancient genomic data is pulled down to the Affymetrix Human Origins SNP array ([Patterson et al. 2012](https://dx.doi.org/10.1534%2Fgenetics.112.145037)) or the 1240k SNP array ([Mathieson et al. 2015](https://dx.doi.org/10.1038%2Fnature16152)). These are the panels we are relying on for our public Poseidon [repositories](repos) because of their ubiquitous use in public datasets such as the [Allen Ancient DNA Resource](https://reich.hms.harvard.edu/allen-ancient-dna-resource-aadr-downloadable-genotypes-present-day-and-ancient-dna-data) and their design for population genetic research questions. The 1240k SNP array includes "nearly all SNPs on the Affymetrix Human Origins and Illumina 610-Quad arrays, 49,711 SNPs on chromosome X and 32,681 on chromosome Y, and 47,384 SNPs with evidence of functional importance" -- [Mathieson et al. 2015](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4918750/).

## Naming of SNPs, individuals and groups

### SNP IDs

All SNPs listed in the SNP file must adhere to the Reference SNP cluster ID naming scheme ("RS number/id") as provided and maintained by the [dbSNP database](https://www.ncbi.nlm.nih.gov/snp/). Other SNP naming schemes are not explicitly forbidden or prevented in POSEIDON, but we encourage users to rely on this established standard to keep merging data from different sources as simple as possible.

### Individual IDs

The individual IDs in the individual file of a Poseidon package must be identical to the respective IDs in the `.janno` file (column `Individual_ID`). This ID together with identical ordering is what allows seamless linkage of genotype and context data.

Poseidon requires the individual IDs within a set of Poseidon packages to be unique, at least for many useful operations within our toolset. Contrary to the usually decentralised philosophy of the framework we would very much like to establish unique identifiers for individuals. Unambiguous IDs would be a tremendous advantage for all fields working with ancient genomic data, including archaeology, which often collects substantially more context information about prehistoric human individuals.

### Group IDs

Just as the individual IDs, the group/family/population IDs across the individual file and the `.janno` file (column `Group_Name`) must be identical. We are aware that group identification and meaningful classification is a major discussion point in the humanities and a core subject of archaeology research. That's why the `Group_Name` variable in the `.janno` file is a list column that can hold many different names. Only the first entry has to be identical to the one in the genotype data individual file, which can only hold one value.
