# Poseidon Web API

To make the data in our [Public Poseidon Archives](repo_overview) conveniently and reproducibly available we run a web server with an open and free [API](https://en.wikipedia.org/wiki/Web_API).

It provides the following endpoints:

1. `https://server.poseidon-adna.org/packages`: returns a list of all packages.
2. `https://server.poseidon-adna.org/groups`: returns a list of all groups.
3. `https://server.poseidon-adna.org/individuals`: returns a list of all individuals.
4. `https://server.poseidon-adna.org/zip_file/<package_name>?package_version=1.0.1`: returns a zip file of the package with the given name and the given version. If no version is given, it returns the latest.

The different endpoints can be accessed directly, or with additional arguments. `?client_version=...` is a general argument for all of them to check client-server compatibility (for the trident subcommands `list` and `fetch`). It defaults to the trident version of the server, so usually the latest release version.

## `/packages`, `/groups`, and `/individuals`

`/packages`, `/groups`, and `/individuals` return nested JSON-lists that give an overview of the data in the public data archives. These lists have the following general structure:

```
├── serverMessage
│   ├── 0
│   ├── 1
│   └── ...
└── serverResponse
    ├── constructor
    └── packageInfo | groupInfo | extIndInfo
        ├── 0
        ├── 1
        └── ...
```

`packageInfo`, `groupInfo`, and `extIndInfo` are lists of objects, where each object has the following fields:

<table>
<tr>
<th>packageInfo</th>
<th>groupInfo</th>
<th>extIndInfo</th>
</tr>
<tr>
<td style="vertical-align:top">

```
title
description
packageVersion
lastModified
poseidonVersion
nrIndividuals
```
</td>
<td style="vertical-align:top">

```
groupName
packageNames []
nrIndividuals
```
</td>
<td style="vertical-align:top">

```
Poseidon_ID
Group_Names []
packageTitle
packageVersion
additionalJannoColumns []
```
</td>
</tr>
</table>


## `/zip_file`

&additionalJannoColumns=


The return data type JSON

We have a webserver running, which currently has several APIs implemented (see [server](server)), including

1. `/packages`: Using [https://c107-224.cloud.gwdg.de/packages](https://c107-224.cloud.gwdg.de/packages), one receives a JSON-list of packages available at the server. Each JSON entry has a title, a description, a last-modified date and a package version.
2. Under `<package_name>/zip_file`, one can download a package as a zip-file, for example [https://c107-224.cloud.gwdg.de/zip_file/2020_Yu_NorthRussia](https://c107-224.cloud.gwdg.de/zip_file/2020_Yu_NorthRussia).

The webserver is powered by an HTTP server program called `poseidon-http-server` (see also [server](server)), whose source-code can be reviewed at the [same repository](https://github.com/poseidon-framework/poseidon-hs) as `trident` is sourced. For those interested to run their own instance of this webserver, for example under `localhost`, the server comes with a short command line help. It gets installed via `stack install`, similarly to `trident`. The program first scans the given directories for Poseidon packages, then creates zip-files for them, and then starts a HTTP server listening - by default - to port 3000, and providing the two APIs listed above.

The server is now implemented as a (hidden) subcommand of trident: `serve`. It returns helpful error messages, if an incompatible version of trident tries to connect to it. And it is now capable of serving multiple (so not just the latest, but also older) versions of one package, which is an important step towards computational reproducibility of Poseidon-based pipelines.

All Server-APIs except for `zip_file` now return a complex JSON datatype with server messages and a payload. The messages contain standard messages like a greeting and in the future perhaps also deprecation warnings. Some APIs also provide information or warnings in the server messages.

All APIs except for `zip_file` also accept an additional parameter `?client_version=X.X.X`, so that the server may in the future respond to old clients that an update is needed in order to understand the API. Our `trident list --remote` functionality already makes use of this.



## The server implementation

The Poseidon http server is written in Haskell and provided as a hidden subcommand of `trident` in the [poseidon-hs github repository](https://github.com/poseidon-framework/poseidon-hs). This tool powers our central [repository server](repos).

Installing with `stack install` inside the cloned poseidon-hs repository will install `poseidon-http-server` alongside `trident`. A command line help lists the various command line options:

```
Usage: poseidon-http-server [--version] (-d|--baseDir DIR) [-p|--port PORT] 
                            [-i|--ignoreGenoFiles] 
                            [--certFile CERTFILE [--chainFile CHAINFILE]
                              --keyFile KEYFILE]
  poseidon-http-server is a HTTP Server to provide information about Poseidon
  package repositories. More information:
  https://github.com/poseidon-framework/poseidon-hs. Report issues:
  https://github.com/poseidon-framework/poseidon-hs/issues

Available options:
  -h,--help                Show this help text
  --version                Show version
  -d,--baseDir DIR         a base directory to search for Poseidon Packages
                           (could be a Poseidon repository)
  -p,--port PORT           the port on which the server listens (default: 3000)
  -i,--ignoreGenoFiles     whether to ignore the bed and SNP files. Useful for
                           debugging
  --certFile CERTFILE      The cert file of the TLS Certificate used for HTTPS
  --chainFile CHAINFILE    The chain file of the TLS Certificate used for HTTPS.
                           Can be given multiple times
  --keyFile KEYFILE        The key file of the TLS Certificate used for HTTPS
```

Without the three last options given, the server will listen for unsecured HTTP traffic, which is useful for testing. When at least a `--certFile` and a `--keyFile` is given, the server listens to secure HTTPS traffic. (Providing only one of the two results in an error). 

If you generate your certificates using [Let's encrypt](https://letsencrypt.org), then the three files are in the following locations:

* `--keyFile /etc/letsencrypt/live/<DOMAIN>/privkey.pem`
* `--certFile /etc/letsencrypt/live/<DOMAIN>/cert.pem`
* `--chainFile /etc/letsencrypt/live/<DOMAIN>/chain.pem`

(note that multiple chain files can be given).

The server software - similarly to most `trident` commands - looks for posiedon packages inside the given base directory, creates or updates zip files for each package, and then provides the following endpoints:

* `/packages` provides a JSON-list of packages available at the server. Each JSON entry has a title, a description, a last-modified date and a package version.
* `/package_table` provides a HTML table of packages with download links, available at the server.
* `/zip_file/\<package_name\>` provides a zip-file for downloading the given package.
* `/individuals_all` provides a JSON-list, with each entry having a name of the individual, the group of the individual, and the package name. This API is kept only for backwards-compatibility. `/janno_all` is mean as a more powerful alternative.
* `/janno_all` provides a list of pairs of package name and Janno-entries.