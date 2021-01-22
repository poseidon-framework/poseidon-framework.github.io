!> This project is under development, and this documentation page is for internal development at this point.

# The Poseidon Framework documentation page

## What is Poseidon?

Poseidon is a framework to provide a standardized way to store and share archaeogenetic genotype datasets with context information in a decentralized way. It is built on three pillars:

1. A package standard for genotype and context data:
	- The Poseidon [Standard](standard)
	- The [.janno file](janno_details)
2. Software tools to work with Poseidon packages:
	- The [trident](trident) CLI software
	- The [poseidonR](poseidonR) R package
3. Public repositories of published data
	- The Poseidon [Repositories](repos) (not online yet)

Poseidon is an initiative of the [Department of Archaeogenetics](https://www.eva.mpg.de/archaeogenetics/index.html) at the Max Planck Institute for Evolutionary Anthropology in Leipzig.

## And why?

Archaeogenetics has become a fast accelerating field, with new data coming out faster than people can co-analyze. Together with samples currently being processed in the world's largest laboratories, we're now approaching genome-wide data for 10,000 ancient individuals. In addition, emergent fields such as ancient metagenomics and paleo-proteomics are adding complexity to a scene that already hosts data from long-established non-genetic technologies like radiocarbon dating and stable isotope analyses.

The way data is currently shared and published via academic papers, at least from genetic analyses, is mainly via releasing raw sequencing data into public repositories such as the [ENA](https://www.ebi.ac.uk/ena), while providing partial metadata on samples via poorly formatted Excel tables in the Supplement. This creates (at least) the following problems:

1. Intermediate data such as genotypes or metagenomic profiles are often not released at all, making it hard for others to reproduce analyses. 
2. The connection between individuals, contextual information, and genetic data becomes hard to maintain, bridging between very different repositories and sources (Excel vs. personal homepages vs. public repositories)
4. Meta-analyses spanning datasets require enormous amounts of work on data collection and curation (the Reich team has done an [admirable job](https://reich.hms.harvard.edu/downloadable-genotypes-present-day-and-ancient-dna-data-compiled-published-papers) on that front, but it's hard to maintain this in such a centralized way within one lab.
5. Studies that combine data from different technologies (isotopes, C14 dating, genetics) have no clear way to release such complex relationships in a concise way.
6. Incrementally produced data, for example by adding new data to  previously published individuals, cannot be easily connected to the same individuals.

All in all, data in the field certainly doesn't -- even remotely -- satisfy the [FAIR principles](https://en.wikipedia.org/wiki/FAIR_data) of open data: Findability, Accessibility, Interoperability, Reproducibility.

