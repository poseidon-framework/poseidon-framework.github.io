# The .janno file

This documentation includes some more background about some of the columns in the `.janno` file beyond the general remarks in the [standard](standard) definition and the overview table [here](https://github.com/poseidon-framework/poseidon2-schema/blob/master/janno_columns.tsv). This should make it more easy to compile the necessary information for both published and unpublished data.

- [Identifiers](#identifiers)
- [Spatial position (`Country`, `Location`, `Site`, `Latitude`, `Longitude`)](#spatial-position)
- [Temporal position (`Date_C14_Labnr`, `Date_C14_Uncal_BP`, `Date_C14_Uncal_BP_Err`, `Date_BC_AD_Median`, `Date_BC_AD_Start`, `Date_BC_AD_Stop`, `Date_Type`)](#temporal-position)
- [Genetic summary data](#genetic-summary-data)
    - [Individual properties (`Genetic_Sex`, `MT_Haplogroup`, `Y_Haplogroup`)](#individual-properties)
    - [Library properties (`Source_Tissue`, `No_of_Libraries`, `Data_Type`, `UDG`, `Library_Built`, `Genotype_Ploidy`)](#library-properties)
    - [Data yield (`Endogenous`, `Nr_autosomal_SNPs`, `Coverage_1240K`)](#data-yield)
    - [Data quality (`Damage`, `Xcontam`, `Xcontam_stderr`, `mtContam`, `mtContam_stderr`)](#data-quality)
- [Context information (`Primary_Contact`, `Publication_Status`, `Note`, `Keywords`)](#context-information)

# Identifiers

The `Individual_ID` column has to represent each sample with a world-wide unique identifier string equal to the identifier used in the respective accompanying publication. There is no central authority to issue these identifiers, so it remains in the hand of the authors to avoid duplication. The `Individual_ID`s are also employed in the [genetic data files](genotype_data?id=individual-ids) and therefore have to adhere to certain constraints. If there are multiple samples from one individual, then they have to be clearly distinguished with relevant suffixes added to the `Individual_ID`.

The `Collection_ID` column stores an additional, secondary identifier as it is often provided by collaboration partners (archaeologists, museums, collections) that provide specimen for archaeogenetic research. These identifiers might have a very heterogenous structure and may not be unique across different projects or institutions. The `Collection_ID` column is therefore a free form text field.

The `Group_Name` column contains one or multiple group or population names for each individual, separated by `;`. The first entry must be identical to the one used in the [genotype data](genotype_data?id=group-ids) for the respective sample. Assigning group and population names is a hard problem in archeogenetics, so that's why the `.janno` file allows for more than one identifier.

# Spatial position

The `.janno` file contains five columns to describe the spatial origin of an individual sample:  `Country`, `Location`, `Site` and finally `Latitude` and `Longitude`. 

The `Country` column should contain a present-day political country name following the `English short name` in [ISO 3166](https://www.iso.org/iso-3166-country-codes.html). 

The `Location` column allows for free form text entry and can contain further, unspecified location information. This might be the name of an administrative or geographic region, or an arbitrary unit of reference like a mountain, lake or city close to the point of discory of the respective sample.

The `Site` column should contain a site name, ideally in the latin alphabet and ideally the name that is commonly used in publications.

The `Latitude` and `Longitude` column should contain geographic coordinates (WGS84) in decimal degrees (DD) with a precision of not more than five places after the decimal point. This yields a precision of about [1.1132m at the equator](https://en.wikipedia.org/wiki/Decimal_degrees) which is sufficient to describe the position of an archaeological site. Coordinates in other formats like for example Degrees Minutes Seconds (DMS) or in completely different coordinate reference systems should be transformed. There exist many Open Source software solutions to do that, most based on the [PROJ library](https://proj.org/index.html) e.g. the [The World Coordinate Converter](https://twcc.fr/en/#).

# Temporal position

The temporal position of a sample is encoded with seven different columns in the `.janno` file: 
`Date_C14_Labnr`, `Date_C14_Uncal_BP`, `Date_C14_Uncal_BP_Err`, `Date_BC_AD_Median`, `Date_BC_AD_Start`, `Date_BC_AD_Stop`, `Date_Type`

The `Date_Type` column handles the general distinction between the most common forms of dating: `C14`, `contextual` and `modern`. The entry `modern` is reserved for present day reference samples, so not ancient DNA. If the sample is directly (or very reliably indirectly) radiocarbon dated and the columns `Date_C14_Labnr`, `Date_C14_Uncal_BP` and `Date_C14_Uncal_BP_Err` can be filled, then `C14` applies. `contextual` covers everything else, including age attribution based on the archaeologically determined stratigraphy or typological information. The `contextual` value should also be chosen if the sample is only dated very indirectly (e.g. radiocarbon dates from other, unrelated features of the respective site) or dated with other physical or chemical dating methods (e.g. dendrochronology or optically stimulated luminescence).

If a sample is radiocarbon dated (`Date_Type = C14`), then the three columns `Date_C14_Labnr`, `Date_C14_Uncal_BP` and `Date_C14_Uncal_BP_Err` can be filled. Each of these can hold multiple values separated by `;` to allow for multiple radiocarbon dates for each aDNA sample. With multiple values the number and order of values in the columns should of course be equal.

Each radiocarbon date has a unique identifier: the Lab number. It consists of a [Lab code](http://www.radiocarbon.org/Info/labcodes.html) issued by the journal [Radiocarbon](https://www.cambridge.org/core/journals/radiocarbon) for each laboratory and a serial number. This lab code makes the date well identifiable and should be reported in `Date_C14_Labnr` with the Lab code separated from the number with a minus symbol.

The uncalibrated radiocarbon measurement can be described by a Gaussian distribution with mean and standard deviation. So the column `Date_C14_Uncal_BP` holds the mean of that distribution in years before present (BP) as usually reported by radiocarbon laboratories. The age is always a positive integer value starting from a zero that corresponds to 1950 AD. The column `Date_C14_Uncal_BP_Err` holds the respective standard deviation for each date in years. This should be the 1-sigma distance, so that the probability that the actual uncalibrated age of the measured sample is within the `Date_C14_Uncal_BP`±`Date_C14_Uncal_BP_Err` range is about 68%.

The columns `Date_BC_AD_Median`, `Date_BC_AD_Start`, `Date_BC_AD_Stop` store a simplified summary of the age information. Ages are reported in years BC and AD, so in relation to the zero point of the Gregorian calender. BC dates are represented with negative, AD with positive integer values. 

- If radiocarbon dates are available (`Date_Type = C14`): `Date_BC_AD_Median` should report the median age after calibration. With multiple dates this can be determined either with sum calibration or more complex (e.g. bayesian) age modelling. `Date_BC_AD_Start` and `Date_BC_AD_Stop` should report the starting/ending age of a 95% probability window around the age median. poseidonR offers a simple function to calibrate radiocarbon dates and compile the necessary input for `Date_BC_AD_Median`, `Date_BC_AD_Start`, `Date_BC_AD_Stop`: [`poseidonR::quickcalibrate()`](https://github.com/poseidon-framework/poseidonR#general-helper-functions)
- If only contextual (e.g. from archaeological typology) age information is available (`Date_Type = contextual`): `Date_BC_AD_Start` and `Date_BC_AD_Stop` should simply report the approximate starting and end date determined by the respective source of scientific authority. `Date_BC_AD_Median` should be calculated as the mean of `Date_BC_AD_Start` and `Date_BC_AD_Stop` rounded to an integer value.
- If the sample is a modern reference sample (`Date_Type = modern`): `Date_BC_AD_Median`, `Date_BC_AD_Start`, `Date_BC_AD_Stop` should all be set to the value 2000.

# Genetic summary data

## Individual properties

The `Genetic_Sex` column should encode the biological sex as determined from the DNA read distribution on the X and Y chromosome. It only allows for the entries `F` (female), `M` (male) and `U` (unknown), just as the genotype data formats by Plink and the Eigensoft software package. Edge cases (e.g. XXY, XYY, X0, ...) can not be expressed with this format and should be reported as `U` with an additional comment in the free text `Note` field. Genetic sex determination for ancient DNA can be performed for example with [Sex.DetERRmine](https://github.com/TCLamnidis/Sex.DetERRmine).

The `MT_Haplogroup` column is meant to store the human mitochondrial DNA haplogroup for the respective individual in a simple string. The entry can be arbitrarily precise. A software tool to determine the MT haplogroup is for example [Haplogrep](https://haplogrep.i-med.ac.at).

The `Y_Haplogroup` column holds the respective human Y-chromosome DNA haplogroup in a simple string. Arbitrary precision applies here as well.

## Library properties

In case of multiple libraries: merge.

`Source_Tissue`

`No_of_Libraries`

`Data_Type`

`UDG`

`Library_Built`

`Genotype_Ploidy`

## Data yield

`Endogenous`

The `Nr_autosomal_SNPs` column should report the number of SNPs on the 1240K SNP array covered at least once in any of the libraries from this sample. The 1240K SNP array was specifically designed for ancient human population genetics research and includes "nearly all SNPs on the Affymetrix Human Origins and Illumina 610-Quad arrays, 49,711 SNPs on chromosome X and 32,681 on chromosome Y, and 47,384 SNPs with evidence of functional importance" -- [Mathieson et al. 2015](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4918750/). This can be calculated for example with ...

The `Coverage_1240K` column should report the mean SNP *coverage* on the 1240K SNP array for the merged libraries of this sample. To calculate the coverage it's necessary to determine which 1240K SNPs are covered how many times by the mapped reads. Individual SNPs might be covered multiple times, whereas others may not be covered at all by the highly deteriorated ancient DNA. The coverage for each SNP is therefore a number between 0 and n and the mean coverage for a complete sample can be calculated as a mean of the SNP-wise coverage distribution for all its libraries combined. The coverage can be determined with ...

## Data quality

`Damage`

`Xcontam`

`Xcontam_stderr`

`mtContam`

`mtContam_stderr`

# Context information

The `Primary_Contact` column is a free form text field that stores the name of the main or the corresponding author of the respective paper for published data.

The `Publication_Status` column holds either the value `unpublished` for (yet) unpublished samples or -- for published data -- a citation-key of the form `AuthorJournalYear` without any spaces or special characters. This key has to be identical to the [BibTeX](http://www.bibtex.org/) citation-key identifying the respective entry in the `LITERATURE.bib` file of the package. BibTeX is a file format to store bibliographic information, where each entry (article, book, website, ...) is defined by a series of parameters (authors, year of publication, journal, ...). Here's an example `LITERATURE.bib` file with two entries:

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

@article{FeldmanScienceAdvances2019,
    doi = {10.1126/sciadv.aax0061},
    url = {https://doi.org/10.1126%2Fsciadv.aax0061},
    year = 2019,
    month = {jul},
    publisher = {American Association for the Advancement of Science ({AAAS})},
    volume = {5},
    number = {7},
    pages = {eaax0061},
    author = {Michal Feldman and Daniel M. Master and Raffaela A. Bianco and Marta Burri and Philipp W. Stockhammer and Alissa Mittnik and Adam J. Aja and Choongwon Jeong and Johannes Krause},
    title = {Ancient {DNA} sheds light on the genetic origins of early Iron Age Philistines},
    journal = {Science Advances}
}
```

The string `CassidyPNAS2015` is the citation-key of the first entry. When creating a new Poseidon package the `LITERATURE.bib` file should be filled together with the `Publication_Status` column. One of the most simple ways to obtain the BibTeX entries may be to request them with the doi from https://doi2bib.org/. Some times it may be necessary to adjust the outcome manually, though. The citation-key for example has to be replaced by the one used in the `Publication_Status` column.

The `Note` column is a free form text field that can contain small amounts of additional information that is not yet expressed in a more systematic form in the the other `.janno` file columns.

The `Keywords` column was introduced to allow for tagging individuals with arbitrary keywords. This should simplify sorting and filtering in personal Poseidon package repositories. Each keyword is a string and multiple keywords can be separated with `;`.

