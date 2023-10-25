# The Minotaur workflow

The Minotaur workflow (henceforth "Minotaur") offers a way to convert archived sequencing data into poseidon packages, that are in turn made available in the Poseidon Minotaur Archive (PMA).

For the processing of data through Minotaur, a package recipe is required. These recipes are made available in a [dedicated GitHub repository](https://github.com/poseidon-framework/minotaur-recipes/tree/main), and include the following files:
- A valid Sequencing Source File (`<package_name>.ssf`) that MUST include the columns `poseidon_IDs`, `udg`, `library_built`, `instrument_model`, `instrument_platform`, `fastq_ftp`
- A nf-core/eager configuration file for the package (`<package_name>.conf`)
- A generalised nf-core/eager input tab-separated-value table (`<package_name>.tsv`), with all the relevant information for the processing of the data, but with dummy paths in the R1/R2 entries (`<PATH_TO_DATA>/*`)
- A tsv_patch bash script (`<package_name>.tsv_patch.sh`), for localising the nf-core/eager input table to the cluster that will run the processing.
- A `script_versions.txt`, that keeps track of the versions of different scripts and templates used during the processing of the package.

Most of these files can be created automatically by **delphis-bot**, the Poseidon Framework's helper bot account. For more information on creating a package recipe for Minotaur, see [Contributing a package recipe](#contributing-a-package-recipe)

## Requesting a package recipe

If you want to request a package be added to the PMA, and a recipe for it does not already exist in [minotaur-recipes](https://github.com/poseidon-framework/minotaur-recipes/tree/main), you can request the recipe be added by opening an [issue](https://github.com/poseidon-framework/minotaur-recipes/issues), and using the `Please add: [PACKAGE_NAME]` template. The template has tasks marked with `TODO` that you will need to follow, namely checking that a recipe does not already exist and has not already been requested, as well as providing the doi and project accession number of the publication.

We really appreciate it when users contribute the recipe for packages they are requesting. If you are plan to work on adding the recipe yourself, please also assign yourself to the issue by clicking on *assign yourself*, under "Assignees" on the right-sidebar of the issue. This helps the community collaborate effectively and avoid duplicating work. For a step by step guide on how to contribute a package recipe, see [Contributing a package recipe](#contributing-a-package-recipe) below.

## Contributing a package recipe
