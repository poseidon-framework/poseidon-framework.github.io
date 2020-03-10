# poseidon-framework.github.io 

Repository for the [poseidon-framework.github.io](https://poseidon-framework.github.io) website.  
Built with [Docsify](https://docsify.js.org).


## How to add content ?

- Add your content as [markdown](https://jhildenbiddle.github.io/docsify-themeable/#/markdown) files by marking a pull request to this repository. 

- You can either add your files at the root directory, or put them in subdirectories.
  - Subdirectories should have a dedicated `README.md` file.

- Example structure:
    ```
    .
    ├── home.md
    |   ...
    ├── folder
    │   ├── README.md
    │   └── ...
    
    ```

- If you add a new markdown file, don't forget to add it in the [_sidebar.md](_sidebar.md) file. Headers within a Markdown file are added automatically to the sidebar.

- **DO NOT EDIT `index.html`** 
- **DO NOT RENAME `home.md`**

## Optional (but recommended)

Install Docsify to render locally the website with [npm](https://www.npmjs.com/get-npm) (Node.js Package Manager): `npm i docsify-cli -g`