# Reviewing packages

The role as a reviewer is to help ensuring quality standards for Poseidon's public package archives. Fortunately, many aspects of the Poseidon schema are machine-testable. For example, there are mandatory columns in the Poseidon .janno file (such as the `Poseidon_ID`), and we have automatic validation to make sure that every sample has them.

But there are some aspects we cannot check, such as the scientific correctness of the given information, or don't want to formally check, because they are not included in the core definition of a Poseidon package, but just policy for our public archives. For these, we rely on a checklist every package author has to fill, and finally manual reviews.

!> This documentation only covers reviews for the [Poseidon Community Archive](archive_overview).

Reviewing for Poseidon happens on GitHub. A package submission always comes in the form of a Pull Request. Here are some practial steps to follow when reviewing a new package submission or a change to a previously existing package:

## GitHub Pull Request

Generally you will be invited to review a Pull Request, which you can think of as a stage on which all proposed changes are displayed and listed in a way that let's people comment on the changes. A pull request has four tabs, of which two are relevant:

![](_media/PR_tabs.png)

1. The "Conversation" tab lists a description of the Pull Request and any correspondence/discussion that has already happend on it. Note that the first entry in the conversation comes from the person who opened the Pull Request, so the submitter of the Pull Request. Feel free to add to the discussion anything that you might want to contribute, such as questions, requests for clarifications or even things like "Interesting package, I'll be reviewing it next week".

2. The "Files changed" tab lists all files that are to be changed or added in this Pull Request. This is your main place for review. Files that are not too large can be viewed right on GitHub, by simply clicking on the files. Others may be too large to view in the browser. In this case you can download them, by first clicking on the menu with the three dots on the top right of a file, and selecting "View File". You will then see a button to download the file in the new view again on the top right of the file. 

## What to look for?

The following sections highlight some specific details you should look for in your review. This is not comprehensive, though. A good point of view to assume for a review is to imagine you would want to use the respective Poseidon package yourself. In what state would you want the data to be, ideally? But also consider that the community-archive is supposed to mirror closely how the data was presented in the original publication. For a good review it may be necessary at times, to go back to the original publication and its supplementary material, to verify information that stands out as odd.

### The package title

Every package should have a meaningful title following the archive's naming policy: `<Year>_<Last name of first author>_<Region, time period or special feature of the paper>`. Especially the last point tends to be challenging for package authors. As a reviewer you can make a recommendation, if you think the chosen title is not ideal. Every file in the package (except POSEIDON.yml, README and CHANGELOG) should have the packages name (with different file extensions).

### The POSEIDON.yml file

Look at the POSEIDON.yml file and make sure that it is reasonably complete and [most fields](https://www.poseidon-adna.org/#/standard?id=the-poseidon-package) are filled. 

Based on past experience the following questions need special reviewer attention:

- Are the file checksums present?

### The .bib-file

The bibliography file contains information for the publication(s) that published the samples.

- Does every entry contain a title, the journal, the authors, a doi, a month (!) and the year of publication?

### The .janno File

Looking at the .janno file is easiest if you download the file, as described above, and open it in a text editor (for example, Visual Studio Code with the Rainbow CSV extension), or in a Spreadsheet application like Excel or Libre Office (for this you need to use a trick: Modify the filename and add a `.tsv` to the end, then these tools can simply open them and view in table form).

The file does not have to be complete in the sense that every column specified in the Poseidon schema is present. But the columns that are there should be filled for every sample for which they apply. And certain high-priority fields, like the [location](https://www.poseidon-adna.org/#/janno_details?id=spatial-position) and [dating](https://www.poseidon-adna.org/#/janno_details?id=temporal-position) of samples, should ideally be present.

- Does the file have obvious errors, like shifted columns, or unreadable characters? Unreadable characters may be the result of a wrong character enconding selected by the package author, e.g. caused by copy-and-pasting from a localized supplementary material file. .janno files must be UTF-8 encoded.
- Are the primary group/population names in `Group_Name` as in the original publication? `Group_Name` is a `;`-separated list column, so alternative names (e.g. from the AADR) can be given as well, just not in the first position.
- Are the relationship columns circular, so is a relationship between the samples A and B listed for both samples?
- Do numerical columns, e.g. latitude/longitude coordinates, show an odd pattern of incrementally increasing last digits? This often happens as an undesired side effect of package authors compiling .janno files in a spreadsheet program.
- Is the dating information correctly given? The `Date_Type` `C14` only applies, if the respective radiocarbon date gives a direct estimate of an individuals year of death, and if the uncalibrated age is known and available.
- Is the location and dating information correct and as published? Exactly here, where they may have catastrophic consequences, typos tend to happen.
- Does every sample have an entry in the `Publication` column?
- Do semantically identical entities, e.g archaeological sites, a consistent, identical name within the package? Slightly different spelling of the same entitiy should be avoided.
- Are idiosyncrasies of a given package for certain variables (if there are any) pointed out in helpful `_Note` columns?
- Have all empty columns been removed? A column with only `n/a` does not add anything to the package and can be removed.

