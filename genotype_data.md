# Genotype data details

## File formats

Genotype data in Poseidon packages can be stored in one of three (multi)file formats: PLINK (binary), EIGENSTRAT, and VCF.

|   | PLINK (binary) | EIGENSTRAT | VCF |
|---|---|---|---|
| genotype file | [`.bed` (binary biallelic genotype table) or `.bed.gz`](https://www.cog-genomics.org/plink/1.9/formats#bed) | [`.geno` (genotype file) or `.geno.gz`](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) | [`.vcf` or `.vcf.gz`](https://samtools.github.io/hts-specs/VCFv4.2.pdf) |
| SNP file  | [`.bim` (extended MAP file) or `.bim.gz`](https://www.cog-genomics.org/plink/1.9/formats#bim) | [`.snp` (snp file) or `.snp.gz`](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |  |
| individual file  | [`.fam` (sample information)](https://www.cog-genomics.org/plink/1.9/formats#fam) | [`.ind` (indiv file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |  |

The PLINK file format is a well specified, storage efficient data type compatible with many bioinformatic software tools, which made it an obvious choice for Poseidon. The EIGENSTRAT format is also common within archaeogenetics, compatible with many of the important tools developed by the Reich Lab, e.g. the ones in the [EIGENSOFT](https://github.com/DReichLab/EIG) and [ADMIXTOOLS](https://github.com/DReichLab/AdmixTools) sets. Since Poseidon v3.0.0 the [Variant Call Format](https://samtools.github.io/hts-specs/VCFv4.2.pdf) (VCF) is also supported. In the future even more formats might be added (see e.g. [here](https://reich.hms.harvard.edu/software/InputFileFormats)).

To make VCF files fully convertible to PLINK and EIGENSTRAT, they MUST be biallelic and contain only genotypes coded as `0/0`, `0/1`, `1/1`, `./.`. Furthermore, they CAN encode group names and genetic sex for all samples through special header fields `##group_names=name1,name2,...` and `##genetic_sex=F,U,M,...`, respectively. If these fields are not present, then group names are assumed to be "unknown" and genetic sex "U" (unknown) for all samples.

For all of these formats the large genotype data files to store SNP definitions and values can be stored in gzipped form (`*.gz`).

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

<table>
<tr>
<th>VCF</th>
</tr>
<tr>
<td>

```
genotypeData:
  format: VCF
  genoFile: X.vcf
  snpSet: 1240K
```
</td>
</tr>
</table>

## Typical setup and SNP panels

Poseidon is not limited to a specific panel of single nucleotide polymorphism (SNPs) that should be available for each sample. All known SNPs for an individual derived from one or multiple libraries can be merged and stored in the genotype data accompanying a Poseidon package. The `snpSet` subfield in the `POSEIDON.yml` file documents the shape of the genotype file in the respective package, with the possible entries `HumanOrigins`, `1240K`, and `Other`.

As of today (25.01.2021) most ancient genomic data is pulled down to the Affymetrix Human Origins SNP array ([Patterson et al. 2012](https://dx.doi.org/10.1534%2Fgenetics.112.145037)) or the 1240k SNP array ([Mathieson et al. 2015](https://dx.doi.org/10.1038%2Fnature16152)). These are the panels we are relying on for our public Poseidon [repositories](repos) because of their ubiquitous use in public datasets such as the [Allen Ancient DNA Resource](https://reich.hms.harvard.edu/allen-ancient-dna-resource-aadr-downloadable-genotypes-present-day-and-ancient-dna-data) and their design for population genetic research questions. The 1240k SNP array includes "nearly all SNPs on the Affymetrix Human Origins and Illumina 610-Quad arrays, 49,711 SNPs on chromosome X and 32,681 on chromosome Y, and 47,384 SNPs with evidence of functional importance" -- [Mathieson et al. 2015](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4918750/).

## Naming of SNPs, samples and groups

### SNP IDs

All SNPs listed in the SNP file must adhere to the Reference SNP cluster ID naming scheme ("RS number/id") as provided and maintained by the [dbSNP database](https://www.ncbi.nlm.nih.gov/snp/). Other SNP naming schemes are not explicitly forbidden or prevented in POSEIDON, but we encourage users to rely on this established standard to keep merging data from different sources as simple as possible.

### Poseidon IDs

The sample IDs in the individual file of a Poseidon package must be identical to the respective IDs in the `.janno` file (column `Poseidon_ID`). This ID together with identical ordering is what allows seamless linkage of genotype and context data.

Poseidon requires the `Poseidon_ID`s IDs within a set of Poseidon packages to be unique, at least for many useful operations within our toolset. Contrary to the usually decentralised philosophy of the framework we would very much like to establish unique identifiers for samples and individuals. Unambiguous IDs would be a tremendous advantage for all fields working with ancient genomic data, including archaeology, which often collects substantially more context information about prehistoric human individuals.

### Group IDs

Just as the individual IDs, the group/family/population IDs across the individual file and the `.janno` file (column `Group_Name`) must be identical. We are aware that group identification and meaningful classification is a major discussion point in the humanities and a core subject of archaeology research. That's why the `Group_Name` variable in the `.janno` file is a list column that can hold many different names. Only the first entry has to be identical to the one in the genotype data individual file, which can only hold one value.
