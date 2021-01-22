!> This project is under development, and this documentation page is for internal development at this point.

# Poseidon Repositories

## Our public repositories

A Poseidon repository is nothing more but a collection of Poseidon packages. That means you can easily set up your own repository for your own needs and purposes. You could even share this repository and the packages within it online to make them available to a wider community. Sharing and maintaining public data is one of main goals of our initiative.

We, so the [Department of Archaeogenetics](https://www.eva.mpg.de/archaeogenetics/index.html) at the Max Planck Institute for Evolutionary Anthropology and many affiliated colleagues around the world, maintain two main public repositories that serve as a central hub for most data we use, produce and publish:

!> These are not public yet.

- [data_ancient](https://github.com/poseidon-framework/data_ancient): Ancient samples
- [data_modern](https://github.com/poseidon-framework/data_modern): Modern reference samples

We opted to monitor our repositories with [Git](https://git-scm.com) to ensure clean version management on the file level. The context data in a Poseidon package is text data that can be stored and maintained easily with line-wise version control. Unfortuntaly that does not hold true for the large genotype data files. They are not suitable to be handled in Git, and even less in code sharing platforms like Github. Our solution to this issue is to keep the genotype data separate from the context data. To maintain referential integrity across context data and genotype data files, we introduced (optional) md5 checksums and package version numbers in the `POSEIDON.yml` file.

So you can download/fork/clone the package context data from Github, but where can you get the respective genotype data? 

## The DAG-Poseidon Webserver

... Website ... API ...

## Contributing to our central repository

The Poseidon framework has a strongly decentralized philosophy and relies very much on a community of users willing to prepare and improve the data in the repositories. We are glad that you are considering this step and we will try to make this as smooth and convenient as possible. To ensure a professional and welcoming atmosphere we would first of all like to ask you to respect our [Contributor Code of Conduct](conduct.md) in all interactions with the Poseidon team and other users on Github and beyond.

If you want to prepare a Poseidon dataset for one of the repositories or fix mistakes in the data, you should follow the procedures outlined here.

### Preparing a new Poseidon package for one of the public repositories

- ...
- ...

### Modifying the context data (individual or group names, .janno, .bib) of a package in one of the public repositories

- ...
- ...

### Modifying the genotype data of a package in one of the public repositories

- ...
- ...

