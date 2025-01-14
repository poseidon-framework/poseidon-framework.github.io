# Contributing to our public archives

The Poseidon framework has a strongly decentralized philosophy and relies very much on a community of users willing to prepare and improve the data in the public data repositories. If you want to prepare a Poseidon dataset for one of the repositories or fix mistakes in the data, you should follow the procedures outlined below. To ensure a professional and welcoming atmosphere please respect our [Contributor Code of Conduct](conduct.md) in all interactions with the Poseidon team and other users on GitHub and beyond. If you have questions about the processes, you can post them as an issue on GitHub or contact us directly.

We assume you have some basic knowledge about using a command line software like [`trident`](trident), and how to handle Git and GitHub. If not, then you can become knowledgable quickly about the latter, for example [here](https://githubtraining.github.io/training-manual).

!> This documentation only covers submissions to the [Poseidon Community Archive](archive_overview). Look [here](minotaur) for the submission process to the [Poseidon Minotaur Archive](archive_overview).

## Archive curation roles

To manage package submissions and modifications in our archives, we define the following roles, which are synonymous to the respective roles within github:

1. Assignees: A package is submitted by a single author, with a github account. This user is tagged as "Assignee" in the github interface. The same holds for the modification of an existing package: Here, the "assignee" is the user who authors a Pull Request to change a given package. Assignees are specific per package. **An assignee is responsible for bringing the package into shape, and responding to review requests.**

2. Reviewers: A Pull request for a new or modified package is reviewed by one or more users, who are assigned by the respective _editor_. Reviewers will often be recruited from the Poseidon Core Team, but can also encompass other relevant users, for example if they have special knowledge on the package, or otherwise expertise. Guidelines for reviewers and assignees overlap, and are summarised below. **Reviewers are asked to ensure that all checklist items are covered.** Reviewers are asked to make a decision either by the "Request changes" status, or the "Approve" status in their review. It is then up to editors to ensure revisions to be complete.

3. Editors: Editors are not assigned per package, but per repository. **Editors are responsible for assigning reviewers and eventually merging Pull Requests into their respective archives, and maintaining those archives.** Currently, editors for the [Community Archive](#the-poseidon-community-archive-pca) are users [@Aygal](https://github.com/AyGhal) and [@nevrome](https://github.com/nevrome). Editor for the [Minotaur Archive](#the-poseidon-minotaur-archive-pma) is user [@TCLamnidis](https://github.com/TCLamnidis).


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

[](https://raw.githubusercontent.com/poseidon-framework/community-archive/master/.github/PULL_REQUEST_TEMPLATE/add_package_template.md ':include')

### Submitting the package

The procedure for the actual submission is then as follows (a shorter, slightly more hands-on tutorial is available [here](https://mpi-eva-archaeogenetics.github.io/comp_human_adna_book/poseidon.html#contributing-to-the-community-archive)):

**1. Fork and then clone the GitHub repository for the archive you want to modify.**

You need to be logged into github with your user account. You can then navigate to our github repository: [https://github.com/poseidon-framework/community-archive(https://github.com/poseidon-framework/community-archive) and hit the "Fork" button near the top of the page.

You will then have a copy of the entire repository under your own user name: `https://github.com/<yourGithubUserName>/community-archive`.

For the following to work, you need to have setup your github account in a way that allows you to communicate with github via the command line. For this, you need to configure an SSH public-key, so github really knows it's you. Find out more about it here: [https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

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

You should now copy your package including the full genotype data into the cloned repository as a new package directory. The directory should include the genotype data. Git (with Git LFS enabled) and GitHub will detect automatically that it should treat them as LFS files. Then commit the changes and push:

```
git add <pathToNewPackageDirectory>
git commit -m "added new package named <packageName>"
git push
```

If you accidentally pushed the large files as normal files, for example if your LFS setup was incomplete, you can fix this with `git lfs migrate import --no-rewrite path/to/file.bed` (see [here](https://github.com/git-lfs/git-lfs/blob/main/docs/man/git-lfs-migrate.adoc#import-without-rewriting-history)).

**3. Submit a pull request from your fork to merge your updates into our repository.**

Having successfully pushed your branch to your fork on github, you need to now tell github to propose your branch as a submission to our master repository. This is done through [github Pull Requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests).

When you navigate now to the community archive github page at [https://github.com/poseidon-framework/community-archive](https://github.com/poseidon-framework/community-archive), you will probably already see a yellow banner on top, with a button to initiate a Pull request. Alternatively, you can directly navigate to our [Pull Request page](https://github.com/poseidon-framework/community-archive/pulls) and hit `New Pull Request`. Fill in your fork as the source, and our master branch as the target, and follow instructions on the emerging Pull Request, and ultimately hit `Open Pull Request`.

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

[](https://raw.githubusercontent.com/poseidon-framework/community-archive/master/.github/PULL_REQUEST_TEMPLATE/modify_package_template.md ':include')

