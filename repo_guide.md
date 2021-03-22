# The Public Poseidon Repository

We, so the [Department of Archaeogenetics](https://www.eva.mpg.de/archaeogenetics/index.html) at the Max Planck Institute for Evolutionary Anthropology and many affiliated colleagues around the world, maintain two main public repositories that serve as a central hub for most data we use, produce and publish.

While we're planning a more interactive web interface to explore the available data, at this point you can reach it i) through [this](public_repo.md) very simple table, ii) through our [Web-API](see below), or iii) through [`trident`](trident.md) command line software. 

## Our git repositories

We opted to follow a hybrid system to keep track of our central repository. First, we have all packages - without their genotype data - available as package directories on github. Second, we provide packages to be used for end-users on our package-server.

!> This is not public yet.
Here is our central github repository for our publicly available packages: https://github.com/poseidon-framework/data_published.

We opted to monitor our repositories with [Git](https://git-scm.com) to ensure clean version management on the file level. The context data in a Poseidon package is text data that can be stored and maintained easily with line-wise version control. Unfortuntaly that does not hold true for the large genotype data files. They are not suitable to be handled in Git, and even less in code sharing platforms like Github. Our solution to this issue is to keep the genotype data separate from the context data. To maintain referential integrity across context data and genotype data files, we introduced (optional) md5 checksums and package version numbers in the `POSEIDON.yml` file.

We generally do _not_ recommend to use the github repositories for end-user-level access to our package data. We do recommend that you work through github, though, if you would like to submit an issue or suggest changes to the meta-data. 

## The DAG-Poseidon Webserver

We have a webserver running, which currently has two possible APIs implemented:

1. Under [https://c107-224.cloud.gwdg.de/packages](https://c107-224.cloud.gwdg.de/packages), one receives a JSON-list of packages available at the server. Each JSON entry has a title, a description, a last-modified date and a package version.
2. Under [https://c107-224.cloud.gwdg.de/package_table](https://c107-224.cloud.gwdg.de/package_table), one receives a HTML table of packages with download links, available at the server.
3. Under [https://c107-224.cloud.gwdg.de/zip_file/\<package_name\>](https://c107-224.cloud.gwdg.de/zip_file/<package_name>), a zip-file for the given package can be downloaded, which contains the package content.

The webserver is powered by an HTTP server program called `poseidon-http-server`, whose source-code can be reviewed at the [same repository](https://github.com/poseidon-framework/poseidon-hs) as `trident` is sourced. For those interested to run their own instance of this webserver, for example under `localhost`, the server comes with a short command line help. It gets installed via `stack install`, similarly to `trident`. The program first scans the given directories for Poseidon packages, then creates zip-files for them, and then starts a HTTP server listening - by default - to port 3000, and providing the two APIs listed above.

## Contributing to our central repositories

The Poseidon framework has a strongly decentralized philosophy and relies very much on a community of users willing to prepare and improve the data in the repositories. To ensure a professional and welcoming atmosphere we would first of all like to ask you to respect our [Contributor Code of Conduct](conduct.md) in all interactions with the Poseidon team and other users on Github and beyond.

There are two basic ways you can contribute to Poseidon:

1) If you identify a mistake in any package metadata, be it context data (`.janno`-files), package-meta-data (`POSEIDON.yml`) or bibliographic information (`.bib` files), we welcome contributions to correct or extend that data. This goes most easily through our github-package, which you can fork, commit changes and ask for Pull requests. You can also use the issue tracker on github (for which you can find some help [here](https://lab.github.com/githubtraining/introduction-to-github)). See below for more details on this.

2) If you have new genetic data to share with us, we would like to process that data ourselves, to ensure maximum compatibility with the existing database and to minimise batch effects. So if you want us to add an entirely new package with genetic data, please share with us the raw data, such as BAM or fastq-files, so that we can generate the data and include it into a new Poseidon package.

If you want to prepare a Poseidon dataset for one of the repositories or fix mistakes in the data, you should follow the procedures outlined here. We assume you have some basic knowledge about using a command line software like `trident`, and how to handle Git and Github. If not, then you can become knowledgable quickly at least about the latter, for example [here](https://lab.github.com/githubtraining/introduction-to-github).


### Modifying the context data of a package in one of the public repositories (individual or group names in .fam, context information in .janno or .bib) 

1. Fork and clone the Github repository that contains the package you want to improve.
2. Modify the files you want to change. Remember to also update the md5 checksums in the POSEIDON.yml file after you are done. This can be triggered with [`trident update`](trident?id=update-command).
3. Commit and push your changes.
4. Submit a pull request to merge your updates with our repository. We will contact you about this submission as soon as possible.
