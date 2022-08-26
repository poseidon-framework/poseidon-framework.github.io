# Contributing to our central repositories

The Poseidon framework has a strongly decentralized philosophy and relies very much on a community of users willing to prepare and improve the data in the repositories. If you want to prepare a Poseidon dataset for one of the repositories or fix mistakes in the data, you should follow the procedures outlined here. To ensure a professional and welcoming atmosphere please respect our [Contributor Code of Conduct](conduct.md) in all interactions with the Poseidon team and other users on GitHub and beyond.

We assume you have some basic knowledge about using a command line software like `trident`, and how to handle Git and GitHub. If not, then you can become knowledgable quickly about the latter, for example [here](https://lab.github.com/githubtraining/introduction-to-github).

## Preparing a new Poseidon package for the public repository

If you would like to provide a new package, we would welcome you preparing it as far as you can and then commiting it as a pull request to the [GitHub repository](https://github.com/poseidon-framework/published_data) for our public data archive.

### Preparing the package

1. Acquire the respective genotype data in binary PLINK file format. You will have to prepare this e.g. from the [BAM](https://en.wikipedia.org/wiki/SAM_(file_format)) or [FASTQ](https://en.wikipedia.org/wiki/FASTQ_format) files usually shared by the authors of aDNA papers. For some minimal documentation please look [here](genotype_data).
2. [Install trident](https://poseidon-framework.github.io/#/trident?id=installation-quickstart) and run [`trident init`](trident?id=init-command) with the genotype data. This should give you the skeleton of a Poseidon package, which you can populate with more meta and context information.
3. Fill out the newly created [`POSEIDON.yml`](standard?id=the-poseidonyml-file-mandatory) file.
4. Fill out the newly created `.janno` file. More information about the many columns and how to fill them can be found in the extensive documentation [here](janno_details). You do not necessarily have to fill out all columns - incomplete submissions are fine, as they can be completed later.
5. Fill out the `.bib` file with the relevant sources. Some more information on how to do this can be found [here](janno_details?id=context-information).
6. Add/update the file checksums in the `POSEIDON.yml` file with [`trident update`](trident?id=update-command)
7. Check if your new Poseidon package passes the validation with [`trident validate`](trident?id=validate-command). This is mandatory.

Now your local package should be complete and can be submitted.

### Submitting a package to the public repository

The public repository has some additional requirements for your package. The following list contains some of these less obvious qualities you should check before submitting:

- [ ] The package does not exist already in the repository (maybe under another name).
- [ ] The package title in the `POSEIDON.yml` either conforms to the title predefined [here](https://github.com/poseidon-framework/published_data/issues/14) or follows the general title structure suggested here: `<Year>_<Last name of first author>_<Region, time period or special feature of the paper>`, e.g. `2021_Zegarac_SoutheasternEurope`, `2021_SeguinOrlando_BellBeaker` or `2021_Kivisild_MedievalEstonia`.
- [ ] The package lives in a directory with this name.
- [ ] The package version in the `POSEIDON.yml` file is `1.0.0`
- [ ] There is no CHANGELOG file (this would be meaningless for a first submission).
- [ ] The `POSEIDON.yml` file contains checksums for the fields `genoFile`, `snpFile`, `indFile`, `jannoFile` and `bibFile`.
- [ ] The `Publication` column in the `.janno` file is filled and the respective .bib file has complete entries for the listed mentioned keys.
- [ ] Empty columns are removed from the `.janno` file.
- [ ] Every file you submit is correctly referenced in the `POSEIDON.yml` file and there are no supplementary files in your submission.
- [ ] All text files are UTF-8 encoded and have Unix/Unix-like line endings (`LF`, not `CR+LF` or `CR`)

The procedure for the actual submission is then as follows:

<!-- Not reworked yet! I think there must be a git clone setting to ignore LFS files, but still allow to commit them.

1. Fork and clone the [GitHub repository](https://github.com/poseidon-framework/published_data).
2. Copy your new package into your local clone, commit and push. Make sure not to commit any private files or any large genotype data files. Our `.gitignore` settings should usually prevent this automatically.
3. Submit a pull request to merge your updates with our repository. We will inspect your submission and contact you on GitHub about necessary changes - and finally how you can send us the prepared genotype data.

-->

## Modifying the context data of a package in one of the public repositories

If you identify a mistake in any package metadata, be it context data (`.janno`-files), package-meta-data (`POSEIDON.yml`) or bibliographic information (`.bib` files), we welcome contributions to correct or extend that data. This goes most easily through our GitHub repository, which you can fork, commit changes and ask for Pull requests. You can also use the [issue tracker](https://github.com/poseidon-framework/published_data/issues) on GitHub (for which you can find some help [here](https://lab.github.com/githubtraining/introduction-to-github)). 

<!-- Not reworked yet! See below for more details on this.

This is rather simple, because no large files have to be moved.

1. Fork and clone the Github repository that contains the package you want to improve.
2. Modify the files you want to change. Remember to also update the md5 checksums in the POSEIDON.yml file after you are done. This can be triggered with [`trident update`](trident?id=update-command).
3. Commit and push your changes.
4. Submit a pull request to merge your updates with our repository. We will contact you about this submission as soon as possible.

-->