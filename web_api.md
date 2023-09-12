# Poseidon Web API

To make the data in our [public Poseidon archives](archive_overview) conveniently and reproducibly available we run a web server with an open [API](https://en.wikipedia.org/wiki/Web_API).

It is available at `https://server.poseidon-adna.org` and provides the following endpoints:

| Endpoint                    | Description                                           |
|-----------------------------|-------------------------------------------------------|
| `/packages`                 | returns a list of all packages                        |
| `/groups`                   | returns a list of all groups                          |
| `/individuals`              | returns a list of all samples/individuals             |
| `/zip_file/<package_name>`  | returns a zip file of the package with the given name |

## Endpoints

`/packages`, `/groups`, and `/individuals` return nested JSON-lists that give an overview of the data in the public data archives.

?> Access a JSON list of packages:<br>
   https://server.poseidon-adna.org/packages

These lists have the following general structure:

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
<td style="vertical-align:top">

```
packageInfo[i]
├── packageTitle
├── packageVersion
├── isLatest
├── lastModified
├── description
├── poseidonVersion
└── nrIndividuals
```
</td>
<td style="vertical-align:top">

```
groupInfo[i]
├── groupName
├── packageTitle
├── packageVersion
├── isLatest
└── nrIndividuals
```
</td>
<td style="vertical-align:top">

```
extIndInfo[i]
├── poseidonID
├── groupNames []
├── packageTitle
├── packageVersion
├── isLatest
└── additionalJannoColumns []
```
</td>
</tr>
</table>

With `/zip_file/<package_name>`, one can download a package as a zip-file. 

?> Download one package as a .zip archive:<br>
   https://server.poseidon-adna.org/zip_file/2020_Yu_NorthRussia

## Arguments

The endpoints can be accessed directly, or with additional arguments. These have to be listed after `?`, and must be separated by `&`. See the documentation of individual arguments below.

The most imporant argument is `archive=...`, which serves to select the package archive a given query should be applied to. See the overview [here](archive_overview) for the currently available options `community-archive`, `minotaur-archive` and `aadr-archive`. The archive names are identical to the respecitve GitHub repository names. If `archive=...` is not provided, then the query will target the default `community-archive`.

?> Request a list of packages in the `aadr-archive`:<br>
   https://server.poseidon-adna.org/packages?archive=aadr-archive<br>
   Download a package from this archive:<br>
   https://server.poseidon-adna.org/zip_file/AADR_v54_1_p1_1240K_EuropeAncient?archive=aadr-archive

`client_version=...` is an argument for `/packages`, `/groups`, and `/individuals` to check client-server compatibility (primarily for the trident subcommand `list`). It defaults to the trident version of the server, so usually the latest release version of trident. If the client has a version that is not supported by the server the connection attempt is rejected.

?> Request a list of packages with an old client version:<br>
   https://server.poseidon-adna.org/packages?archive=aadr-archive&client_version=1.2.0.0<br>
   (note how the two arguments were appended here with `&`)

`/zip_file/<package_name>` allows to specify a version of the requested package by appending `?package_version=...`. It defaults to the latest available version of a given package.

?> Download a specific version of a package:<br>
   https://server.poseidon-adna.org/zip_file/AADR_v54_1_p1_1240K_EuropeAncient?archive=aadr-archive&package_version=0.1.2

For `/individuals` the API provides an additional argument: `additionalJannoColumns=...`. It allows to add information from arbitrary .janno file columns into the `additionalJannoColumns` JSON-list.

?> Request the individuals list for the default archive, but with information on the origin country of the samples:<br>
   https://server.poseidon-adna.org/individuals?additionalJannoColumns=Country<br>
   This also works for multiple variables at once, which can be given in a comma-separated list:<br>
   https://server.poseidon-adna.org/individuals?additionalJannoColumns=Latitude,Longitude


## The server implementation

The Poseidon http server is written in Haskell and provided as a hidden subcommand `serve` of the [trident CLI software](trident). The program first scans the given directories for Poseidon packages, then creates zip-files for them, and then starts a HTTP server listening - by default - to port 3000, and providing the APIs listed above.

For those interested in running their own instance of this webserver, for example under `localhost`, the server comes with a short command line help:

```
Usage: trident serve (-d|--baseDir DSL) [-z|--zipDir DIR] [-p|--port PORT]
                     [-c|--ignoreChecksums]
                     [--certFile FILE [--chainFile FILE] --keyFile FILE]

  Serve Poseidon packages via HTTP or HTTPS

Available options:
  -h,--help                Show this help text
  -d,--baseDir DSL         A base path, prepended by the corresponding archive
                           name under which packages in this path are being
                           served. Example: arch1=/path/to/basepath. Can be
                           given multiple times. Multiple paths for the same
                           archive are combined internally. The very first named
                           archive is considered to be the default archive on
                           the server.
  -z,--zipDir DIR          A directory to store .zip files in. If not specified,
                           do not generate .zip files. (default: Nothing)
  -p,--port PORT           The port on which the server listens. (default: 3000)
  -c,--ignoreChecksums     Whether to ignore checksums. Useful for speedup in
                           debugging.
  --certFile FILE          The cert file of the TLS Certificate used for HTTPS.
  --chainFile FILE         The chain file of the TLS Certificate used for HTTPS.
                           Can be given multiple times.
  --keyFile FILE           The key file of the TLS Certificate used for HTTPS.
```

Without the three last options given, the server will listen for unsecured HTTP traffic, which is useful for testing. When given a `--certFile` and a `--keyFile`, the server listens to secure HTTPS traffic. 

If you generate your certificates using [Let's encrypt](https://letsencrypt.org), then the three files are in the following locations:

* `--keyFile /etc/letsencrypt/live/<DOMAIN>/privkey.pem`
* `--certFile /etc/letsencrypt/live/<DOMAIN>/cert.pem`
* `--chainFile /etc/letsencrypt/live/<DOMAIN>/chain.pem`

(note that multiple chain files can be given).
