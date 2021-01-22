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

If you want to prepare a Poseidon dataset for one of the repositories or fix mistakes in the data, you should follow the procedures outlined here.

!> Just thought experiments so far.

### Preparing a new Poseidon package for one of the public repositories

1. Acquire the respective genotype data in EIGENSTRAT file format. For security reasons we can not accept submissions in the binary PLINK format.
2. [Install trident](https://poseidon-framework.github.io/#/trident?id=installation-quickstart) and run [`trident init`](trident?id=init-command) with the genotype data.
3. Fill out the newly created [`POSEIDON.yml`](standard?id=the-poseidonyml-file-mandatory) file.
4. Fill out the newly created [`.janno`](standard?id=the-xjanno-file-mandatory) file. More information about the many columns and how to fill them can be found in the extensive documentation [here](janno_details). You do not necessarily have to fill out all columns - we may consider incomplete submissions, as they can be completed later.
5. Fill out the [`.bib`](standard?id=the-literaturebib-file-optional) file with the relevant sources. Some more information on how to do this can be found [here](janno_details?id=context-information).
6. ...

### Modifying the context data (individual or group names, .janno, .bib) of a package in one of the public repositories

- ...
- ...

### Modifying the genotype data of a package in one of the public repositories

- ...
- ...

