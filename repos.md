!> This project is under development, and this documentation page is for internal development at this point.

# Poseidon Repositories

A Poseidon repository is nothing more but a collection of Poseidon packages. That means you can easily set up your own repository for your own needs and purposes. You could even share this repository and the packages within it online to make them available to a wider community. Sharing and maintaining public data is one of main goals of our initiative.

## Our public repositories

We, so the [Department of Archaeogenetics](https://www.eva.mpg.de/archaeogenetics/index.html) at the Max Planck Institute for Evolutionary Anthropology and many affiliated colleagues around the world, maintain two main public repositories that serve as a central hub for most data we use, produce and publish:

!> These are not public yet.

- [data_ancient](https://github.com/poseidon-framework/data_ancient): Ancient samples
- [data_modern](https://github.com/poseidon-framework/data_modern): Modern reference samples

We opted to monitor our repositories with [Git](https://git-scm.com) to ensure clean version management on the file level. The context data in a Poseidon package is text data that can be stored and maintained easily with line-wise version control. Unfortuntaly that does not hold true for the large genotype data files. They are not suitable to be handled in Git, and even less in code sharing platforms like Github. Our solution to this issue is to keep the genotype data separate from the context data. To maintain referential integrity across context data and genotype data files, we introduced (optional) md5 checksums and package version numbers in the `POSEIDON.yml` file.

So you can download/fork/clone the package context data from Github, but where can you get the respective genotype data? 

## The DAG-Poseidon Webserver

!> Not running yet.

... Website ... API ...

## Contributing to our central repositories

The Poseidon framework has a strongly decentralized philosophy and relies very much on a community of users willing to prepare and improve the data in the repositories. We are glad that you are considering this step and we will try to make this as smooth and convenient as possible. To ensure a professional and welcoming atmosphere we would first of all like to ask you to respect our [Contributor Code of Conduct](conduct.md) in all interactions with the Poseidon team and other users on Github and beyond.

If you want to prepare a Poseidon dataset for one of the repositories or fix mistakes in the data, you should follow the procedures outlined here. We assume you have some basic knowledge about using a command line software like `trident`, and how to handle Git and Github. If not, then you can become knowledgable quickly at least about the latter, for example [here](https://lab.github.com/githubtraining/introduction-to-github).

!> Just thought experiments so far.

### Preparing a new Poseidon package for one of the public repositories

Before you start keep in mind to separate modern reference samples from ancient data. They should go to different packages.

1. Acquire the respective genotype data in EIGENSTRAT file format. For security reasons we can not accept submissions in the binary PLINK format. More information on how to prepare this data e.g. from the [BAM](https://en.wikipedia.org/wiki/SAM_(file_format)) or [FASTQ](https://en.wikipedia.org/wiki/FASTQ_format) files often shared by the authors of aDNA papers, see the documentation [here](genotype_data).
2. [Install trident](https://poseidon-framework.github.io/#/trident?id=installation-quickstart) and run [`trident init`](trident?id=init-command) with the genotype data.
3. Fill out the newly created [`POSEIDON.yml`](standard?id=the-poseidonyml-file-mandatory) file.
4. Fill out the newly created [`.janno`](standard?id=the-xjanno-file-mandatory) file. More information about the many columns and how to fill them can be found in the extensive documentation [here](janno_details). You do not necessarily have to fill out all columns - we may consider incomplete submissions, as they can be completed later.
5. Fill out the [`.bib`](standard?id=the-literaturebib-file-optional) file with the relevant sources. Some more information on how to do this can be found [here](janno_details?id=context-information).
6. Check if your new Poseidon package passes the validation with `trident validate`. This is mandatory.

Now your local package is complete and can be submitted to our repository.

7. Fork and clone the Github repository where you would like to submit the package. ([data_ancient](https://github.com/poseidon-framework/data_ancient) or [data_modern](https://github.com/poseidon-framework/data_modern))
8. Copy your new package into your local clone, commit and push. Make sure not to commit any private files or any large genotype data files. Our `.gitignore` settings should usually prevent this automatically.
9. Submit a pull request to merge your updates with our repository. We will inspect your submission and contact you on Github about necessary changes - and finally how you can send us the prepared genotype data.

### Modifying the context data of a package in one of the public repositories (individual or group names in .fam, context information in .janno or .bib) 

This is rather simple, because no large files have to be moved.

1. Fork and clone the Github repository that contains the package you want to improve.
2. Modify the files you want to change. Remember to also update the md5 checksums in the POSEIDON.yml file after you are done. This can be triggered with `trident update`.
3. Commit and push your changes.
4. Submit a pull request to merge your updates with our repository. We will contact you about this submission as soon as possible.

### Modifying the genotype data of a package in one of the public repositories

Please open an issue in the relevant Github repository that contains the package you want to improve. Explain which changes you want to apply. We will contact you there and discuss if and how you can send us the improved genotype data.


