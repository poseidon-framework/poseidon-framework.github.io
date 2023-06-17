# Public Poseidon Archives

We, so the [Department of Archaeogenetics](https://www.eva.mpg.de/archaeogenetics/index.html) at the Max Planck Institute for Evolutionary Anthropology and many affiliated colleagues around the world, maintain public repositories that serves as a central hub for most data we use, produce and publish.

At the moment there are three archives, which are described below:

- [The Poseidon Community Archive (PCA)]()
- [The Poseidon Minotaur Archive (PMA)]()
- [The Poseidon AADR Archive (PAA)]()

We opted to maintain these archives with [Git](https://git-scm.com) on [GitHub](https://github.com/poseidon-framework) to ensure clean version management on the file level. The context data in a Poseidon package is text data that can be stored and maintained easily with line-wise version control. Unfortunately that does not hold true for the large genotype data files. They are not suitable to be handled in Git directly. Instead we rely on GitHub's [large file storage system](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github), which comes with a number of technical hurdles and drawbacks both for developers and users of the Poseidon archives.

We therefore generally do _not_ recommend to use the GitHub repositories for end-user-level access to the data. While we're planning a more interactive web interface, at this point you can explore and download it through

- a simple [archive viewer webpage](https://poseidon-framework.github.io/published_data/)
- our [Web-API](web_api)
- the [`fetch`](trident#fetch-command) and [`list --remote`](trident#list-command) commands of the trident command line software

We do recommend that you work through GitHub, though, if you want to report an issue or suggest changes to the data (as described [here](archive_submission_guide.md)).

## The Poseidon Community Archive (PCA)

...

## The Poseidon Minotaur Archive (PMA)

...


## The Poseidon AADR Archive (PAA)

...

