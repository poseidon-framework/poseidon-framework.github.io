!> This project is under development, and this documentation page is for internal development at this point.

# The genotype data in a Poseidon package

## File formats

Genotype data in `.janno` files can be stored in either of two (multi)file formats: PLINK (binary) and EIGENSTRAT.

|   | PLINK (binary) | EIGENSTRAT |
|---|---|---|
| genotype file | [`.bed` (binary biallelic genotype table)](https://www.cog-genomics.org/plink/1.9/formats#bed) | [`.geno` (genotype file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67)
| SNP file  | [`.bim` (extended MAP file)](https://www.cog-genomics.org/plink/1.9/formats#bim) | [`.snp` (snp file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |
| individual file  | [`.fam` (sample information)](https://www.cog-genomics.org/plink/1.9/formats#fam) | [`.ind` (indiv file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |

The PLINK file format is a well specified, storage efficient data type compatible with many bioinformatic software tools, which made it an obvious choice for Poseidon. The EIGENSTRAT format is also common within archaeogenetics, compatible with many of the important tools developed by the Reich Lab, e.g. the ones in the [EIGENSOFT](https://github.com/DReichLab/EIG) package and finally human-readable. In the future even more formats might be supported.

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
  genoFile: X.bed
  snpFile: X.bim
  indFile: X.fam
```
</td>
<td>

```
genotypeData:
  format: EIGENSTRAT
  genoFile: X.geno
  snpFile: X.snp
  indFile: X.indiv
```
</td>
</tr>
</table>

## Naming of SNPs, individuals and groups

### SNP IDs

All SNPs listed in the SNP file must adhere to the Reference SNP cluster ID naming scheme ("RS number/id") as provided and maintained by the [dbSNP database](https://www.ncbi.nlm.nih.gov/snp/). Other SNP naming schemes are not explicitly forbidden or prevented in POSEIDON, but we encourage you to rely on this established standard to keep merging data from different sources as simple as possible.

### Individual IDs

The individual IDs in the individual file of a Poseidon package must be identical to the respective IDs in the `.janno` file. This ID together with identical ordering is what allows seamless linkage of genotype and context data.

To our knowledge there is unfortunately no established authority for systematically naming human individuals for which (ancient) DNA analysis was performed. Nevertheless Poseidon requires the individual IDs within a set of Poseidon packages to be unique. Contrary to the usually decentralised philosophy of the framework we would very much like to establish unique identifiers for individuals. Unambiguous IDs would be a tremendous advantage for all fields working with ancient genomic data, including archaeology, which often collects substantially more context information about prehistoric human individuals.

### Group IDs

...

## Generating Poseidon-compatible genotype data from raw sequencing data

BAM ... FASTQ ... [pileupCaller](https://github.com/stschiff/sequenceTools)

