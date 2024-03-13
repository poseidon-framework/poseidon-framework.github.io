# The Minotaur workflow

The Minotaur workflow (henceforth "Minotaur") offers a way to convert archived sequencing data into poseidon packages, that are in turn made available in the [Poseidon Minotaur Archive (PMA)](https://github.com/poseidon-framework/minotaur-archive).

For the processing of data through Minotaur, a package recipe is required. These recipes are made available in a [dedicated GitHub repository](https://github.com/poseidon-framework/minotaur-recipes/tree/main), and include all the files necessary for processing of a package through minotaur.

The recipe for any package can be found in `packages/<PACKAGE_NAME>` within the repository.
At the core of each recipe is a [Sequencing Source File](https://www.poseidon-adna.org/#/ssf_details) named after the intended package name (`<PACKAGE_NAME>.ssf`). A valid SSF file for Minotaur MUST include the columns `poseidon_IDs`, `udg`, `library_built`, `instrument_model`, `instrument_platform`, `fastq_ftp`.

**delphis-bot**, the Poseidon Framework's helper bot account, then uses the information within the SSF file, as well as some files pulled form a package template, to create all other parts of a recipe, requiring a modicum of human validation/editing. For more information on creating a package recipe for Minotaur, see [Contributing a package recipe](#contributing-a-package-recipe).

A complete minotaur recipe therefore includes the following files:

  - A valid Sequencing Source File (`<PACKAGE_NAME>.ssf`) that MUST include the columns `poseidon_IDs`, `udg`, `library_built`, `instrument_model`, `instrument_platform`, `fastq_ftp`
  - A nf-core/eager configuration file for the package (`<PACKAGE_NAME>.conf`)
  - A generalised nf-core/eager input tab-separated-value table (`<PACKAGE_NAME>.tsv`), with all the relevant information for the processing of the data, but with dummy paths in the R1/R2 entries (`<PATH_TO_DATA>/*`)
  - A tsv_patch bash script (`<PACKAGE_NAME>.tsv_patch.sh`), for localising the nf-core/eager input table to the cluster that will run the processing.
  - A `script_versions.txt`, that keeps track of the versions of different scripts and templates used during the processing of the package.

## Requesting a package recipe

If you want to request a package be added to the PMA, and a recipe for it does not already exist in [minotaur-recipes](https://github.com/poseidon-framework/minotaur-recipes/tree/main), you can request the recipe be added by opening an [issue](https://github.com/poseidon-framework/minotaur-recipes/issues), and using the `Please add: [PACKAGE_NAME]` template. The template has tasks marked with `TODO` that you will need to follow, namely checking that a recipe does not already exist and has not already been requested, as well as providing the doi and project accession number of the publication.

Each recipe MUST have a corresponding issue, as these are used to make it clear who will work on the recipe, as well as track the progress of the processing in a transparent way.

We really appreciate it when users contribute the recipe for packages they are requesting. If you are plan to work on adding the recipe yourself, please leave a comment on the issue to let others know. For a step by step guide on how to contribute a package recipe, see [Contributing a package recipe](#contributing-a-package-recipe) below.

## Updating a package recipe

It is possible to request changes to an existing recipe. To do so, you MUST open an [issue](https://github.com/poseidon-framework/minotaur-recipes/issues) using the `Please update: [PACKAGE_NAME]` template. The template has tasks marked with `TODO` that you will need to follow, namely, specify the package that needs updating, ensure that no open issue or PR that already addresses these changes already exists, and outline what needs changing in the recipe.
Optionally, you can also provide information on the specific changes you would suggest to the recipe, as well as information on how you realised that something about the recipe needed updating.

## What is the processing status of the package I requested?

The issue created for each recipe addition or update also serves as a tracker of the progress the Minotaur has made in processing the data. Here's a quick legend to understand what your issue says about the data processing and upcoming PMA package:

  - When a new issue is opened, it gets the `new package` or `package update` label.
  - Once the requested changes to the recipe are addressed, the relevant PR(s) are linked to the issue.
  - When the PR is merged, the new recipe is used to begin processing. Once download and processing of the data on our servers begins, an additional `in processing` label is added to the issue.
  - Once processing is completed, a PR withthe resulting poseidon package is opened in the [PMA](https://github.com/poseidon-framework/minotaur-archive) which will mention the opened issue.
  - Once the PR on the [PMA](https://github.com/poseidon-framework/minotaur-archive) is merged, the issue in the minotaur-recipes repository gets closed, to indicate that the changes are now mirrored in the PMA.

## Contributing a package recipe

### 1. Fork the minotaur-recipes repository, and clone the fork

To contribute a package recipe, you will need to fork the [minotaur-recipes](https://github.com/poseidon-framework/minotaur-recipes/tree/main) repository, and clone it somewhere on your local machine, so you can add files to it. 
You can follow the steps on [this guide](https://docs.github.com/en/get-started/quickstart/fork-a-repo), but make sure you use the SSH key option when cloning the repository locally.

### 2. Create a folder for the recipe

You will now need to create the directory for the package recipe you want to provide. The name of the directory should match the name of the package, and follow the poseidon package naming scheme that includes the year of the publication, the last name of the first author, as well as an identifier for the package all separated by underscores (e.g. `2018_Lamnidis_Fennoscandia`).

```bash
## Run this within your local clone of the minotaur-recipes repository
mkdir packages/<PACKAGE_NAME> ## Where <PACKAGE_NAME> is replaced by the name of the package recipe you are adding.
```

### 3. Create the SSF

Now that you have the directory for the package recipe, and the name of the resulting package, you will need to create the Sequencing Source File (SSF) for the package. We offer a convenient script for this, which creates an SSF file including all columns required by Minotaur from an ENA project accession number. You can run the script like this:

```bash
## requires python >= 3.8
scripts/create_ssf_from_ena_project.py -o packages/<PACKAGE_NAME>/<PACKAGE_NAME>.ssf <ENA_PROJECT_ACCESSION>
```

Where `<ENA_PROJECT_ACCESSION>` is the accession number of the ENA project you want to create the SSF for, and `<PACKAGE_NAME>` is the name of the package recipe you are adding.
This will create the file `<PACKAGE_NAME>.ssf` in the directory you created in the previous step.

### 4. Fill-in the SSF

While most fields of the SSF file have been filled-in automatically with information from the ENA, the `udg`, `library_built`, and `poseidon_IDs` columns need to be specified manually.

  - The `udg` column MUST be filled with the UDG treatment of the samples (`plus`, `half` or `minus`)
  - The `library_built` column MUST be filled with the strandedness of each library (`ds` or `ss`)
  - The `poseidon_IDs` column MUST be filled with the Poseidon IDs that this set of data should be associated with. If one set of reads should be associated with multiple Poseidon IDs, these should be separated by a semi-colon (e.g. `GUP001;GUP001_SG`)
  - The optional `notes` field, where you SHOULD record any notes you might have about the data, or the decisions you made if any (e.g. `Data in the FastQ is actually a mix of UDG-half and non-UDG libraries. Setting to udg to "none".`)

In most cases, the `poseidon_Ids` field will be a single Poseidon ID, but associating multiple Poseidon IDs to a single set of reads might be useful in some cases. For example, if the contamination estimate of one library of individual `ABC001` was reported as borderline in the publication, users might want to have two versions of an individual in the resulting poseidon package: one using all available data, and one where that library is excluded. In this scenario, all data from that individual should have `poseidon_Ids` set to `ABC001;ABC001_all_libraries`, except for the library that should be excluded from the `ABC001` poseidon Id, which would only get the ID `ABC001_all_libraries` in that column.

When you are done filling in the SSF, you can commit the changes to the repository, and push them to your fork on GitHub.

```bash
## Run this within your local clone of the minotaur-recipes repository
git add packages/<PACKAGE_NAME>
git commit -m "Added SSF for <PACKAGE_NAME>"
git push
```

Once again, replacing `<PACKAGE_NAME>` with the name of the package recipe you are adding. If you refresh your branch on GitHub you should now see the SSF file you created.

### 5. Open a Pull Request(PR) to the minotaur-recipes repository

Go to the [*Pull Requests* tab of the minotaur-recipes repository](https://github.com/poseidon-framework/minotaur-recipes/pulls) on GitHub, and click on the *New Pull Request* button.

Set your own fork of the repository as the *head repository* (you may have to click on *compare across forks*), and the minotaur-recipes main branch as the *base repository* of the Pull Request, and click on *Create Pull Request*.

Your PR text will then be filled with the template for adding a package recipe. You will now need to do the following:

  - In the `Closes #XXX` line of the template, change the `XXX` with the issue number of the issue that requested the recipe (if any).
  - Apply the `new package` label to the PR.
  - Comment `@delphis-bot create recipe` to the PR. This will trigger **delphis-bot** to create the rest of the files required for the recipe, and add them to the PR.
    - This step should be repeated after every change to the SSF file.

Once all additional files have been added to the PR by **delphis-bot**, you will need to verify that each required file is there, and that the contents of each file are correct. You can do this by clicking on the *Files changed* tab of the PR, and reviewing the changes made by **delphis-bot**. If all the files are there, it is time to request a review from the Poseidon Framework team, by clicking on the *Reviewers* tab of the PR, and requesting a review from `poseidon-framework/poseidon-core-team`.

Once the Poseidon Framework team has reviewed the PR, and all the files are correct, the PR will be merged, and the recipe will be added to the minotaur-recipes repository. Once processing of the data is finished, the resulting poseidon package will be added to the PMA. Your review of the resulting package may be requested by the Poseidon Framework team, to ensure that the package is correct.

Thank you for contributing a package recipe to the Poseidon Framework!
