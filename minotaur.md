# The Minotaur workflow

The Minotaur workflow (henceforth "Minotaur") offers a way to convert archived sequencing data into poseidon packages, that are in turn made available in the Poseidon Minotaur Archive.

For the processing of data through Minotaur, a package recipe is required. These recipes are made available in a [dedicated GitHub repository](https://github.com/poseidon-framework/minotaur-recipes/tree/main), and include the following files:
- A valid Sequencing Source File (`<package_name>.ssf`) that MUST include the columns `poseidon_IDs`, `udg`, `library_built`, `instrument_model`, `instrument_platform`, `fastq_ftp`
- A nf-core/eager configuration file for the package (`<package_name>.conf`)
- A generalised nf-core/eager input tab-separated-value table (`<package_name>.tsv`), with all the relevant information for the processing of the data, but with dummy paths in the R1/R2 entries (`<PATH_TO_DATA>/*`)
- A tsv_patch bash script (`<package_name>.tsv_patch.sh`), for localising the nf-core/eager input table to the cluster that will run the processing.
- A `script_versions.txt`, that keeps track of the versions of different scripts and templates used during the processing of the package.

Most of these files can be created automatically by **delphis-bot**, the Poseidon Framework's helper bot account. For more information on creating a package recipe for Minotaur, see [Contributing a package recipe](#contributing-a-package-recipe)

## Requesting a package recipe

## Contributing a package recipe
