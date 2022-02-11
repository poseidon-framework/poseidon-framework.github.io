# The Public Poseidon Repository

We, so the [Department of Archaeogenetics](https://www.eva.mpg.de/archaeogenetics/index.html) at the Max Planck Institute for Evolutionary Anthropology and many affiliated colleagues around the world, maintain a public repository that serves as a central hub for most data we use, produce and publish.

<a class="github-button" href="https://github.com/poseidon-framework/published_data/issues" data-icon="octicon-issue-opened" data-show-count="true" aria-label="Issue poseidon-framework/published_data on GitHub">Report an issue</a>
<a class="github-button" href="https://github.com/poseidon-framework/published_data" data-icon="octicon-star" data-show-count="true" aria-label="Star poseidon-framework/published_data on GitHub">Star this project</a>

While we're planning a more interactive web interface to explore the available data, at this point you can reach it i) through [this](https://poseidon-framework.github.io/published_data/) very simple page, ii) through our [Web-API](#the-dag-poseidon-webserver), or iii) through the [`trident`](trident#fetch-command) command line software.

## Our git repositories

We opted to monitor our repositories with [Git](https://git-scm.com) to ensure clean version management on the file level. The context data in a Poseidon package is text data that can be stored and maintained easily with line-wise version control. Unfortuntaly that does not hold true for the large genotype data files. They are not suitable to be handled in Git directly. Instead we rely on Github's [large file storage system](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github), which works, but comes with a number of technical hurdles and drawbacks both for us and the user.

We generally do _not_ recommend to use the github repositories for end-user-level access to our packages, so to download the data. We do recommend that you work through Github, though, if you would like to submit an issue or suggest changes to the data (e.g. via a 
Pull Request).

The relevant Github repository is available [here](https://github.com/poseidon-framework/published_data).

## The DAG-Poseidon Webserver

We have a webserver running, which currently has several APIs implemented (see [server](server)), including

1. `/packages`: Using [https://c107-224.cloud.gwdg.de/packages](https://c107-224.cloud.gwdg.de/packages), one receives a JSON-list of packages available at the server. Each JSON entry has a title, a description, a last-modified date and a package version.
2. Under `<package_name>/zip_file`, one can download a package as a zip-file, for example [https://c107-224.cloud.gwdg.de/zip_file/2020_Yu_NorthRussia](https://c107-224.cloud.gwdg.de/zip_file/2020_Yu_NorthRussia).

The webserver is powered by an HTTP server program called `poseidon-http-server` (see also [server](server)), whose source-code can be reviewed at the [same repository](https://github.com/poseidon-framework/poseidon-hs) as `trident` is sourced. For those interested to run their own instance of this webserver, for example under `localhost`, the server comes with a short command line help. It gets installed via `stack install`, similarly to `trident`. The program first scans the given directories for Poseidon packages, then creates zip-files for them, and then starts a HTTP server listening - by default - to port 3000, and providing the two APIs listed above.

## Contributing to our central repositories

The Poseidon framework has a strongly decentralized philosophy and relies very much on a community of users willing to prepare and improve the data in the repositories. To ensure a professional and welcoming atmosphere we would first of all like to ask you to respect our [Contributor Code of Conduct](conduct.md) in all interactions with the Poseidon team and other users on Github and beyond.

There are two basic ways you can contribute to Poseidon:

1) If you identify a mistake in any package metadata, be it context data (`.janno`-files), package-meta-data (`POSEIDON.yml`) or bibliographic information (`.bib` files), we welcome contributions to correct or extend that data. This goes most easily through our github-package, which you can fork, commit changes and ask for Pull requests. You can also use the [issue tracker](https://github.com/poseidon-framework/published_data/issues) on github (for which you can find some help [here](https://lab.github.com/githubtraining/introduction-to-github)). See below for more details on this.

2) If you would like to provide a new package, we would welcome you preparing the meta-data for that new package as far as you can and commiting this package - without the genotype data - as a pull request to our [github-repo](https://github.com/poseidon-framework/published_data). The genetic data we would like to process ourselves, to ensure maximum compatibility with the existing database and to minimise batch effects. So if you want us to add an entirely new package with genetic data, please share with us the raw data, such as BAM or fastq-files, so that we can generate the data and include it into a new Poseidon package.

If you want to prepare a Poseidon dataset for one of the repositories or fix mistakes in the data, you should follow the procedures outlined here. We assume you have some basic knowledge about using a command line software like `trident`, and how to handle Git and Github. If not, then you can become knowledgable quickly at least about the latter, for example [here](https://lab.github.com/githubtraining/introduction-to-github).


### Modifying the context data of a package in one of the public repositories (individual or group names in .fam, context information in .janno or .bib) 

1. Fork and clone our central [github repository](https://github.com/poseidon-framework/published_data).
2. Add the new package (without genotype data), or modify an existing package's metadata.
3. Commit and push your changes.
4. Submit a pull request to merge your updates with our repository. We will contact you about this submission as soon as possible.
