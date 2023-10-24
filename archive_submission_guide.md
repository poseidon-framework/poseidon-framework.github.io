# Contributing to our public archives

The Poseidon framework has a strongly decentralized philosophy and relies very much on a community of users willing to prepare and improve the data in the public data repositories. If you want to prepare a Poseidon dataset for one of the repositories or fix mistakes in the data, you should follow the procedures outlined below. To ensure a professional and welcoming atmosphere please respect our [Contributor Code of Conduct](conduct.md) in all interactions with the Poseidon team and other users on GitHub and beyond. If you have questions about the processes, you can post them as an issue on GitHub or contact us directly.

We assume you have some basic knowledge about using a command line software like [`trident`](trident), and how to handle Git and GitHub. If not, then you can become knowledgable quickly about the latter, for example [here](https://githubtraining.github.io/training-manual).

!> At the moment this documentation only covers submissions to the [Poseidon Community Archive](archive_overview). We will soon consolidate and document the contribution process for the Poseidon Minotaur Archive.

## Preparing a new package for the community archive

If you would like to provide a new package, you should prepare it as far as you can and then commit it as a pull request to the repository.

### Preparing the package

**1. Acquire the respective genotype data in binary PLINK file format.**

If you are submitting data you have published yourself, you most likely already have it PLINK or EIGENSTRAT format and can directly wrap it in a Poseidon package. Please look [here](genotype_data) for some additional documentation on how a Poseidon package stores genotype data. As the community archive primarily focusses on author submissions we assume this to be the normal case, but if you prepare a package from data you have not published, you will have to derive the genotype data yourself from the raw sequencing data - the [BAM](https://en.wikipedia.org/wiki/SAM_(file_format)) or [FASTQ](https://en.wikipedia.org/wiki/FASTQ_format) files shared by the authors. In this case the minotaur archive and its automatic data generation might be more suitable.

**2. [Install trident](https://poseidon-framework.github.io/#/trident?id=installation-quickstart) and run [`trident init`](trident?id=init-command) on the genotype data.**

This should give you the skeleton of a Poseidon package, which you can then populate with more meta- and context information.

**3. Fill out the newly created [`POSEIDON.yml`](standard?id=the-poseidonyml-file-mandatory) file.**

**4. Fill out the newly created `.janno` file.**

More information about the many columns and how to fill them can be found in the extensive documentation [here](janno_details). You do not necessarily have to fill out all columns - incomplete submissions are fine, as they can be completed later.

**5. Fill out the `.bib` file with the relevant source publications.**

Some more information on how to do this can be found [here](janno_details?id=context-information).

**6. Add/update the file checksums in the `POSEIDON.yml` file.**

Either manually, or with [`trident rectify`](trident?id=rectify-command).

**7. Check if your new Poseidon package passes the validation**

This is mandatory. Please also run [`trident validate`](trident?id=validate-command) with the `--fullGeno` flag (so `trident validate -d path/to/your/package --fullGeno`) once.

***

The community archive has some additional requirements for your package beyond what you would need to simply use the package locally for your own analysis. So the following submission **checklist** includes some of these less obvious qualities you should consider before submitting the package online, on top of what is technically necessary:

- [ ] The package does not exist already in the community archive, also not with a different name.
- [ ] The package title in the `POSEIDON.yml` conforms to the general title structure suggested here: `<Year>_<Last name of first author>_<Region, time period or special feature of the paper>`, e.g. `2021_Zegarac_SoutheasternEurope`, `2021_SeguinOrlando_BellBeaker` or `2021_Kivisild_MedievalEstonia`.
- [ ] The package is stored in a directory that is named like the package title.


- [ ] The package is complete and features the following elements:
  - [ ] Genotype data in binary PLINK format (not EIGENSTRAT format).
  - [ ] A `POSEIDON.yml` file with not just the file-referencing fields, but also the following meta-information fields present and filled: `poseidonVersion`, `title`, `description`, `contributor`, `packageVersion`, `lastModified` (see [here](https://github.com/poseidon-framework/poseidon-schema/blob/master/POSEIDON_yml_fields.tsv) for their definition)
  - [ ] A reasonably filled `.janno` file (for a list of available fields look [here](https://github.com/poseidon-framework/poseidon-schema/blob/master/janno_columns.tsv) and [here](https://www.poseidon-adna.org/#/janno_details) for more detailed documentation about them).
  - [ ] A `.bib` file with the necessary literature references for each sample in the `.janno` file.
- [ ] Every file in the submission is correctly referenced in the `POSEIDON.yml` file and there are no additional, supplementary files in the submission that are not documented there.
- [ ] Genotype data, `.janno` and `.bib` file are all named after the package title and only differ in the file extension.
- [ ] All text files are UTF-8 encoded and have Unix/Unix-like line endings (`LF`, not `CR+LF` or `CR`).
- [ ] The package version in the `POSEIDON.yml` file is `1.0.0`.
- [ ] The `poseidonVersion` of the package in the `POSEIDON.yml` file is set to the latest version of the Poseidon schema.
- [ ] The `POSEIDON.yml` file contains the corresponding checksums for the fields `genoFile`, `snpFile`, `indFile`, `jannoFile` and `bibFile`.
- [ ] There is either no `CHANGELOG` file or one with a single entry for version `1.0.0`.


- [ ] The `Publication` column in the `.janno` file is filled and the respective `.bib` file has complete entries for the listed mentioned keys.
- [ ] The `.janno` file does not include any empty columns or columns only filled with `n/a`.
- [ ] The order of columns in the `.janno` file adheres to the standard order as defined in the Poseidon schema [here](https://github.com/poseidon-framework/poseidon-schema/blob/master/janno_columns.tsv).


- [ ] The package passes a validation with `trident validate --fullGeno`.

### Submitting the package

The procedure for the actual submission is then as follows (a shorter, slightly more hands-on tutorial is available [here](https://mpi-eva-archaeogenetics.github.io/comp_human_adna_book/poseidon.html#contributing-to-the-community-archive)):

**1. Fork and and then clone the GitHub repository for the archive you want to modify.**

To safe our [Git LFS](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-git-large-file-storage) bandwidth, **we would like to ask you to clone in a way that does not download the large data files from GitHub** (they should be downloaded from our webserver with [`trident fetch`](trident?id=fetch-command)). At the same time you need to be able to add new LFS files. A proper setup for this includes the following steps

- downloading and [installing Git LFS](https://git-lfs.github.com/),
- setting it up for your user with `git lfs install`
- cloning the repo with the `GIT_LFS_SKIP_SMUDGE` environment variable, which prevents downloading the LFS files despite Git LFS being enabled:

```
GIT_LFS_SKIP_SMUDGE=1 git clone git@github.com:<yourGitHubUserName>/community-archive.git
```

As a consequence the large files will not be downloaded, but only stub files, representing the real files on the LFS server. This clone is only for submission purposes after all -- you can not work with the genotype data in it. `2021_Wang_EastAsia/2021_Wang_EastAsia.bed` for example will look like this:

```
version https://git-lfs.github.com/spec/v1
oid sha256:766e7c9f79c1659dfb924c901420f01e8720557a0ec37f2a694f6a29cdc0a55e
size 177553875
```

**2. Copy your new package into your local clone.**

The directory should include the genotype data. Git (with Git LFS enabled) and GitHub will detect automatically that it should treat them as LFS files. Then commit the changes and push.

If you accidentally pushed the large files as normal files, for example if your LFS setup was incomplete, you can fix this with `git lfs migrate import --no-rewrite path/to/file.bed` (see [here](https://github.com/git-lfs/git-lfs/blob/main/docs/man/git-lfs-migrate.adoc#import-without-rewriting-history)).

**3. Submit a pull request from your fork to merge your updates into our repository.**

We will inspect your submission and contact you on GitHub about necessary changes. When everything is alright and according to our standards, we can merge and add your package. It will then be available from the Web API a couple of days later.

## Modifying existing packages in the community archive

If you identify a mistake in any package, be it in the context data (`.janno` files), package-meta-data (`POSEIDON.yml`), bibliographic information (`.bib` files) or genotype data, we welcome both issues to point them out and contributions to correct them directly.

**1. Fork and clone the GitHub repository that contains the package you want to improve.**

Unlike for the package submission (see above), it is recommended to make a full clone of the repository with Git LFS (see above, so to clone without `GIT_LFS_SKIP_SMUDGE=1` here). Expert users are asked, though, to reduce their bandwidth requirements as much as possible. Changes in non-genotype data files are well possible with an incomplete clone.

**2. Modify the files you want to change.**

Remember to also i. update the md5 checksums in the POSEIDON.yml file, ii. increment the package version number and iii. add an informative entry to the changelog file after you are done. This can be done automatically with [`trident rectify`](trident?id=rectify-command).

Please use its command line arguments to get well documented changes according to the following examples:

- Example 1: You added a radiocarbon date for a sample in the .janno file
	```
	trident rectify \
	  --packageVersion "Patch" \
	  --logText "Added radiocarbon date AAA-1234 for sample I99362" \
	  --checksumJanno \
	  --newContributors "[Firstname Lastname](email@address.com)"
	```

- Example 2: You added a missing sample to a package and thus had to edit the genotype data and the .janno file
	```
	trident rectify \
	  --packageVersion "Minor" \
	  --logText "Added sample I99363" \
	  --checksumAll \
	  --newContributors "[Firstname Lastname](email@address.com)"
	```

- Example 3: You removed a sample from a package
	```
	trident rectify \
	  --packageVersion "Major" \
	  --logText "Removed sample I99363, because ..." \
	  --checksumAll \
	  --newContributors "[Firstname Lastname](email@address.com)"
	```

Make sure to check if the modified package passes the validation with [`trident validate`](trident?id=validate-command).**
This is mandatory.

Finally commit and push your changes.

**3. Submit a pull request to merge your updates with our repository.**

Please do not wait too long (max. 2 weeks) between creation of the fork and submitting the pull request to prevent merge conflicts.

***

Please note the following submission **checklist** for modified packages:

- [ ] The changes maintain the structural integrity of the affected packages.
- [ ] The checksums of the modified files in the respective `POSEIDON.yml` files were adjusted properly.
- [ ] Every file in the submission is correctly referenced in the relevant `POSEIDON.yml` files and there are no additional, supplementary files in the submission that are not documented there.
- [ ] All text files are still UTF-8 encoded and have Unix/Unix-like line endings (`LF`, not `CR+LF` or `CR`).


- [ ] The `packageVersion` numbers of the affected packages were increased in their `POSEIDON.yml` files.
- [ ] The changes were documented in the respective `CHANGELOG` files. If no `CHANGELOG` files existed previously it was added here.
- [ ] The `lastModified` fields of the affected `POSEIDON.yml` files were updated.
- [ ] The `contributor` fields were updated with `name`, `email` and `orcid` of the relevant, new contributors.


- [ ] All affected packages pass a validation with `trident validate --fullGeno`.
