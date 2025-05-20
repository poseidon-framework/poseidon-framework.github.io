# Reviewing packages in the Poseidon Community Archive

The role as a reviewer is to help ensuring quality standards for Poseidon. Fortunately, many aspects of the Poseidon schema are machine-testable. For example, there are mandatory columns in the Poseidon Janno file (such as the PoseidonID), and we have automatic validation to make sure that every sample has indeed a PoseidonID. We also can make sure automatically, that the number of samples in the Janno-File matches the number of samples provided in the genotype files.

But there are some aspects we cannot check, for example whether the entries in the Janno file are scientifically correct. For this, we rely on manual reviews to bring all packages to a common standard.

Reviewing for Poseidon happens on github. Specifically, a package submission is a Pull Request. You don't have to understand every aspect of that, but practically here are some steps to follow:

## 1. Navigate to the github Pull Request of the new package that is to be reviewed

You will be invited to review a Pull Request, which you can think of as a stage on which all changes that are proposed (whether a new package should be added, or an existing one should be changed), are displayed and listed in a way that let's people comment on the changes. A pull request has four tabs, of which two are relevant:

![](_media/PR_tabs.png)

1. The "Conversation" tab lists a description of the Pull Request and any correspondence/discussion that has already happend on it. Note that the first entry in the Conversation comes from the person who opened the Pull Request, so the submitter of the Pull Request. Feel free to add to the discussion anything that you might want to contribute, such as questions, requests for clarifications or even things like "Interesting package, I'll be reviewing it next week".

2. The "Files changed" tab lists all files that are to be changed or added in this Pull Request. This is your main place for review. Files that are not too large can be viewed right on github, by simply clicking on the files. Others may be too large to view in the browser. In this case you can download them, by first clicking on the menu with the three dots on the top right of a file, and selecting "View File". You will then see a button to download the file in the new view again on the top right of the file. 

We will highlight some tipps to check in the following sections

## 1. Look at the POSEIDON.yml file

Look at the POSEIDON.yml file and make sure that it is reasonably complete and [most fields](https://www.poseidon-adna.org/#/standard?id=the-poseidon-package) are filled.

## 2. Look at the Bib-file

The bibliography file contains information for the publication(s) that published the samples. Make sure it contains a title, the journal, the authors, a doi and a month and year of the publication.

## 3. Take a look at the Janno File
This is easiest if you download the file, as described above, and open it in a good text editor (for example, Visual Studio Code with the Rainbow CSV extension), or in a Spreadsheet application like Excel or Libre Office (for this you need to use a trick: Modify the filename and add a `.tsv` to the end, then these tools can simply open them and view in table form).

In the Janno File, you should scan the file for obvious errors, like shifted columns, or unreadable characters. The most important fields are about the [Location](https://www.poseidon-adna.org/#/janno_details?id=spatial-position) and [dates](https://www.poseidon-adna.org/#/janno_details?id=temporal-position).

