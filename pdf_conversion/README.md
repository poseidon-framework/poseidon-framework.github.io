For automatic `.pdf` generation a GitHub Action [here](../.github/workflows/addPDF.yml) runs upon every push to the `master` branch. It performs the following steps:

1. Check out the repo.
2. Install `pandoc` and `pdflatex`.
3. Modify some markdown documents to cut away parts that are undesirable in their `.pdf` version.
4. Loop through each file in [`pdf_conversion_list.tsv`](pdf_conversion_list.tsv) and run `pandoc` to generate the `target` file from the `source`.
	- `pandoc` uses the configuration in [`pandoc_pdf_config.yml`](pandoc_pdf_config.yml), which in turn pulls in the `.tex` files in this directory at various points.
	- It also integrates the bibliography information in [`references.bib`](../references.bib) to render proper citations in the resulting .pdf files.
5. Commit and push the changes to any `.pdf` files if they have changed or been added by step 4..
