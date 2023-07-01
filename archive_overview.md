# Public Poseidon Archives

We, so the [Department of Archaeogenetics](https://www.eva.mpg.de/archaeogenetics/index.html) at the Max Planck Institute for Evolutionary Anthropology and many colleagues around the world, maintain public repositories that serves as a central hub for most data we use, produce and publish.

At the moment there are three archives, which are described below:

- [The Poseidon Community Archive (PCA)](#the-poseidon-community-archive-pca)
- [The Poseidon Minotaur Archive (PMA)](#the-poseidon-minotaur-archive-pma)
- [The Poseidon AADR Archive (PAA)](#the-poseidon-aadr-archive-paa)

We opted to maintain these archives with [Git](https://git-scm.com) on [GitHub](https://github.com/poseidon-framework) to ensure clean version management on the file level. The context data in a Poseidon package is text data that can be stored and maintained easily with line-wise version control. Unfortunately that does not hold true for the large genotype data files. They are not suitable to be handled in Git directly. Instead we rely on GitHub's [large file storage system](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github), which comes with a number of technical hurdles and drawbacks both for developers and users of the Poseidon archives.

We therefore generally do _not_ recommend to use the GitHub repositories for end-user-level access to the data. While we're planning a more interactive web interface, at this point you can explore and download it through

- a simple [archive viewer webpage](http://www.poseidon-adna.org/community-archive/) (currently only for the PCA)
- our [Web-API](web_api)
- the [`fetch`](trident#fetch-command) and [`list --remote`](trident#list-command) commands of the trident command line software

We do recommend that you work through GitHub, though, if you want to report an issue or suggest changes to the data (as described [here](archive_submission_guide.md)).

## The Poseidon Community Archive (PCA)

The Poseidon Community Archive ([on GitHub: <i class="fab fa-github" aria-hidden="true"></i>](https://github.com/poseidon-framework/community-archive)) is the oldest and arguably the most important public archive. It stores publication-wise packages, so one package for the genotype data released with one paper.

**The PCA focusses on author submissions**, so Poseidon packages prepared by the authors of the packaged publication, containing exactly the genotype data used for the analysis in the paper. This ensures a high degree of computational reproducibility. Author submissions are also ideal for the context data in the .janno file, because the respective domain-experts are generally most knowledgable on the spatiotemporal origin of their samples.

For historical reasons the PCA does not only contain author submissions, though. To kickstart the public archive development in 2020, we prepopulated it with data from the AADR and directly incorportated publications without explicit author involvement. This legacy data will remain in the PCA to maintain established workflows. Authors and other community members are always welcome to step up, take ownership and improve the quality of these datasets, in case the current state is not satisfactory.

## The Poseidon Minotaur Archive (PMA)

<!-- ToDo: Fix links! -->

The Poseidon Minotaur Archive ([on GitHub: <i class="fab fa-github" aria-hidden="true"></i>](https://github.com/poseidon-framework/minotaur-archive)) mirrors the PCA in that it features publication-wise packages, sometimes even the very same as the PCA. To distinguish them clearly, package titles and sample-wise Poseidon_IDs in the PMA carry the suffix `_MNT` (for "MiNoTaur").

**Packages in the PMA include consistently reprocessed genotype data**, run through the [Minotaur workflow](...). Consitent bioinformatic processing across publications is an important quality for meta-analysis. So while the context information in the .janno file between PCA and PMA is identical to some degree, the PMA packages fulfill an important property for data reuse beyond paper-wise reproducibility.

## The Poseidon AADR Archive (PAA)

The Poseidon AADR Archive ([on GitHub: <i class="fab fa-github" aria-hidden="true"></i>](https://github.com/poseidon-framework/aadr-archive)) is the conceptionally most simple archive. It features **"poseidonized" versions of releases of the [Allen Ancient DNA Resource (AADR)](https://reich.hms.harvard.edu/allen-ancient-dna-resource-aadr-downloadable-genotypes-present-day-and-ancient-dna-data)**. The code and decisions for the cleaning and packaging process are documented [here](https://github.com/poseidon-framework/aadr2poseidon). Due to file size limitations of GitHub's LFS system each AADR dataset is split into smaller sub-packages by data type and geographic origin.
