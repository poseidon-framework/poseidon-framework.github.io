# Public Poseidon Archives

We, so the [Department of Archaeogenetics](https://www.eva.mpg.de/archaeogenetics/index.html) at the Max Planck Institute for Evolutionary Anthropology and many affiliated colleagues around the world, maintain public repositories that serves as a central hub for most data we use, produce and publish.

At the moment there are two archives: [published_data](https://github.com/poseidon-framework/published_data) and [poseidon-aadr](https://github.com/poseidon-framework/poseidon-aadr).

## How to access this data

While we're planning a more interactive web interface to explore the available data, at this point you can reach it i) through a simple [Public repository viewer](https://poseidon-framework.github.io/published_data/) webpage, ii) through our [Web-API](web_api), or iii) through the [`fetch`](trident#fetch-command) command of the trident command line software.

### Our git repositories

We opted to monitor our repositories with [Git](https://git-scm.com) to ensure clean version management on the file level. The context data in a Poseidon package is text data that can be stored and maintained easily with line-wise version control. Unfortunately that does not hold true for the large genotype data files. They are not suitable to be handled in Git directly. Instead we rely on Github's [large file storage system](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github), which works, but comes with a number of technical hurdles and drawbacks both for us and the user.

We generally do _not_ recommend to use the github repositories for end-user-level access to our packages, so to download the data. We do recommend that you work through Github, though, if you would like to submit an issue or suggest changes to the data (e.g. via a Pull Request).
