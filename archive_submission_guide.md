# Contributing to our public archives

The Poseidon framework has a strongly decentralized philosophy and relies very much on a community of users willing to prepare and improve the data in the public data repositories. If you want to prepare a Poseidon dataset for one of the repositories or fix mistakes in the data, you should follow the procedures outlined below. To ensure a professional and welcoming atmosphere please respect our [Contributor Code of Conduct](conduct.md) in all interactions with the Poseidon team and other users on GitHub and beyond. If you have questions about the processes, you can post them as an issue on GitHub or contact us directly.

We assume you have some basic knowledge about using a command line software like [`trident`](trident), and how to handle Git and GitHub. If not, then you can become knowledgable quickly about the latter, for example [here](https://lab.github.com/githubtraining/introduction-to-github).

## Preparing a new package for the public repository

If you would like to provide a new package, you should prepare it as far as you can and then commit it as a pull request to the repository.

### Preparing the package

1. Acquire the respective genotype data in binary PLINK file format. You will have to derive this e.g. from the [BAM](https://en.wikipedia.org/wiki/SAM_(file_format)) or [FASTQ](https://en.wikipedia.org/wiki/FASTQ_format) files usually shared by the authors of aDNA papers. For some minimal documentation please look [here](genotype_data).
2. [Install trident](https://poseidon-framework.github.io/#/trident?id=installation-quickstart) and run [`trident init`](trident?id=init-command) on the genotype data. This should give you the skeleton of a Poseidon package, which you can then populate with more meta- and context information.
3. Fill out the newly created [`POSEIDON.yml`](standard?id=the-poseidonyml-file-mandatory) file.
4. Fill out the newly created `.janno` file. More information about the many columns and how to fill them can be found in the extensive documentation [here](janno_details). You do not necessarily have to fill out all columns - incomplete submissions are fine, as they can be completed later.
5. Fill out the `.bib` file with the relevant source publications. Some more information on how to do this can be found [here](janno_details?id=context-information).
6. Add/update the file checksums in the `POSEIDON.yml` file with [`trident update`](trident?id=update-command).
7. Check if your new Poseidon package passes the validation with [`trident validate`](trident?id=validate-command). This is mandatory.

The public repository has some additional requirements for your package beyond what you would need to simply use the package locally for your own analysis. The following list contains some of these less obvious qualities you should check before submitting:

- The package does not exist already in the repository (maybe under another name).
- The package title in the `POSEIDON.yml` conforms to the general title structure suggested here: `<Year>_<Last name of first author>_<Region, time period or special feature of the paper>`, e.g. `2021_Zegarac_SoutheasternEurope`, `2021_SeguinOrlando_BellBeaker` or `2021_Kivisild_MedievalEstonia`.
- The package lives in a directory also with this name.
- The package version in the `POSEIDON.yml` file is `1.0.0`
- There is no CHANGELOG file (this would be meaningless for a first submission).
- The `POSEIDON.yml` file contains checksums for the fields `genoFile`, `snpFile`, `indFile`, `jannoFile` and `bibFile`.
- The `Publication` column in the `.janno` file is filled and the respective .bib file has complete entries for the listed mentioned keys.
- Empty columns are removed from the `.janno` file.
- The order of columns in the `.janno` file adheres to the [standard order](https://github.com/poseidon-framework/poseidon-schema/blob/master/janno_columns.tsv).
- Every file you submit is correctly referenced in the `POSEIDON.yml` file and there are no additional, supplementary files in your submission that are not listed in the `.yml` file.
- All text files are UTF-8 encoded and have Unix/Unix-like line endings (`LF`, not `CR+LF` or `CR`)

### Submitting the package

The procedure for the actual submission is then as follows:

1. Fork and and then clone the GitHub repository for the archive you want to modify. To safe our [Git LFS](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-git-large-file-storage) bandwidth, **we would like to ask you to clone in a way that does not download the large data files from GitHub** (they should be downloaded from our webserver with [`trident fetch`](trident?id=fetch-command)). At the same time you need to be able to add new LFS files. A proper setup for this includes [downloading and installing Git LFS](https://git-lfs.github.com/) and then setting it up for your user with `git lfs install`. You can then clone with the `GIT_LFS_SKIP_SMUDGE` environment variable, which prevents downloading the LFS files despite Git LFS being enabled:

```
GIT_LFS_SKIP_SMUDGE=1
git clone git@github.com:<your GitHub user name>/<archive name>.git
```

As a consequence the large files will not be downloaded, but only stub files, representing the real files on the LFS server. This clone is only for submission purposes after all -- you can not work with the genotype data in it. `2021_Wang_EastAsia/2021_Wang_EastAsia.bed` for example will look like this:

```
version https://git-lfs.github.com/spec/v1
oid sha256:766e7c9f79c1659dfb924c901420f01e8720557a0ec37f2a694f6a29cdc0a55e
size 177553875
```

2. Copy your new package into your local clone with a directory name equal to the package name. The directory should include the genotype data. Git and GitHub will detect automatically that it should treat them as LFS files. Then commit the changes and push.
3. Submit a pull request from your fork to merge your updates into our repository. We will inspect your submission and contact you on GitHub about necessary changes. When everything is alright and according to our standards, we can merge and add your package. It will then be available from the webserver a couple of days later.

## Modifying an existing package in the public repository

If you identify a mistake in any package, be it in the context data (`.janno`-files), package-meta-data (`POSEIDON.yml`), bibliographic information (`.bib` files) or genotype data, we welcome both issues to point them out and contributions to correct them directly.

1. Fork and clone the Github repository that contains the package you want to improve. Unlike for the package submission (see above), it is recommended to make a full clone of the repository with Git LFS (see above, so to clone without `GIT_LFS_SKIP_SMUDGE=1` here). Expert users are asked, though, to reduce their bandwidth requirements as much as possible. Changes in non-genotype data files are well possible with an incomplete clone.
2. Modify the files you want to change. Remember to also (i) update the md5 checksums in the POSEIDON.yml file, (ii) increment the package version number and (iii) add an informative entry to the changelog file after you are done. This can be done automatically with [`trident update`](trident?id=update-command). Please use its command line arguments to get well documented changes (see the following examples).

	- Example 1: You added a radiocarbon date for a sample in the .janno file
	```
	trident update \
	  --versionCompontent "Patch" \
	  --newContributors "[Firstname Lastname](email@address.com)" \
	  --logText "Added radiocarbon date AAA-1234 for sample I99362"
	```

	- Example 2: You added a missing sample to a package and thus had to edit the genotype data and the .janno file
	```
	trident update \
	  --versionComponent "Minor" \
	  --newContributors "[Firstname Lastname](email@address.com)" \
	  --logText "Added sample I99363"
	```

	- Example 3: You removed a sample from a package
	```
	trident update \
	  --versionComponent "Major" \
	  --newContributors "[Firstname Lastname](email@address.com)" \
	  --logText "Removed sample I99363. The authors removed this sample because ..."
	```

3. Check if the modified package passes the validation with [`trident validate`](trident?id=validate-command). This is mandatory.
4. Commit and push your changes.
5. Submit a pull request to merge your updates with our repository. Please do not wait too long (max. 2 weeks) between creation of the fork and submitting the pull request to prevent merge conflicts.
