!> This project is under development, and this documentation page is for internal development at this point.

TODO: Explain how the genotype data in a Poseidon package should be structured beyond the minimal information in the standard definition. This should also include an explanation how this data can be produced from BAM or FASTQ files.

# The genotype data in a Poseidon package

## File formats

Genotype data in `.janno` files can be stored in either of two (multi)file formats: PLINK (binary) and EIGENSTRAT.

|   | PLINK (binary) | EIGENSTRAT |
|---|---|---|
| genotype file | [`.bed` (binary biallelic genotype table)](https://www.cog-genomics.org/plink/1.9/formats#bed) | [`.geno` (genotype file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67)
| SNP file  | [`.bim` (extended MAP file)](https://www.cog-genomics.org/plink/1.9/formats#bim) | [`.snp` (snp file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |
| individual file  | [`.fam` (sample information)](https://www.cog-genomics.org/plink/1.9/formats#fam) | [`.ind` (indiv file)](https://github.com/DReichLab/EIG/blob/fb4fb59065055d3622e0f97f0149588eae630a3e/CONVERTF/README#L67) |

The PLINK file format is a well specified, storage efficient data type compatible with many bioinformatic software tools, which made it an obvious choice for Poseidon. The EIGENSTRAT format is also common within archaeogenetics, compatible with many of the important tools developed by the Reich Lab, e.g. the ones in the [EIGENSOFT](https://github.com/DReichLab/EIG) package and finally human-reable. In the future even more formats might be supported.

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

