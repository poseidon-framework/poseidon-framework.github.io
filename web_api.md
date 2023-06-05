# Poseidon Web API

To make the data in our [Public Poseidon Archives](repo_overview) conveniently and reproducibly available we run a web server with an open and free [API](https://en.wikipedia.org/wiki/Web_API).

It provides the following endpoints:

1. `https://server.poseidon-adna.org/packages`: returns a list of all packages.
2. `https://server.poseidon-adna.org/groups`: returns a list of all groups.
3. `https://server.poseidon-adna.org/individuals`: returns a list of all individuals.
4. `https://server.poseidon-adna.org/zip_file/<package_name>`: returns a zip file of the package with the given name.

The endpoints can be accessed directly, or with additional arguments. These have to be listed after `?`, and must be separated by `&`. See the documentation of individual arguments below the general description of the endpoints.

## Endpoints

### `/packages`, `/groups`, and `/individuals`

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
<td style="vertical-align:top">

```
packageInfo[i]
├── title
├── description
├── packageVersion
├── lastModified
├── poseidonVersion
└── nrIndividuals
```
</td>
<td style="vertical-align:top">

```
groupInfo[i]
├── groupName
├── packageNames []
└── nrIndividuals
```
</td>
<td style="vertical-align:top">

```
extIndInfo[i]
├── Poseidon_ID
├── Group_Names []
├── packageTitle
├── packageVersion
└── additionalJannoColumns []
```
</td>
</tr>
</table>

Note the `additionalJannoColumns` argument for `/individuals` to request additional variables.

### `/zip_file/<package_name>`

With `/zip_file/<package_name>`, one can download a package as a zip-file, for example [https://server.poseidon-adna.org/zip_file/2020_Yu_NorthRussia](https://server.poseidon-adna.org/zip_file/2020_Yu_NorthRussia).

Note the `package_version` argument to request a specific version of a package.

## Arguments

### `client_version`

`client_version=...` is an argument for `/packages`, `/groups`, and `/individuals` to check client-server compatibility (primarily for the trident subcommand `list`). It defaults to the trident version of the server, so usually the latest release version of trident. If the client has a version that is not supported by the server the connection attempt is rejected.

### `additionalJannoColumns`

For `/individuals` the API provides an additional argument: `additionalJannoColumns=...`. It allows to add information from arbitrary .janno file columns into the `additionalJannoColumns` JSON-list. For example `https://server.poseidon-adna.org/individuals?additionalJannoColumns=Country` will return the individuals list, but now with information on the origin country of a sample (e.g. `"additionalJannoColumns":[["Country","Greenland"]]`).

### `package_version`

`/zip_file/<package_name>` also allows to specify the specific version of the requested package by appending `?package_version=...`, so e.g. `package_version=1.0.1`. It defaults to the latest available version.

## The server implementation

The Poseidon http server is written in Haskell and provided as a hidden subcommand `serve` of the [trident CLI software](trident). The program first scans the given directories for Poseidon packages, then creates zip-files for them, and then starts a HTTP server listening - by default - to port 3000, and providing the APIs listed above.

For those interested in running their own instance of this webserver, for example under `localhost`, the server comes with a short command line help:

```
Usage: trident serve (-d|--baseDir DIR) [-z|--zipDir DIR] [-p|--port PORT]
                     [-c|--ignoreChecksums]
                     [--certFile CERTFILE [--chainFile CHAINFILE]
                       --keyFile KEYFILE]

  Serve Poseidon packages via HTTP or HTTPS

Available options:
  -h,--help                Show this help text
  -d,--baseDir DIR         a base directory to search for Poseidon Packages
                           (could be a Poseidon repository)
  -z,--zipDir DIR          a directory to store Zip files in. If not specified,
                           do not generate zip files
  -p,--port PORT           the port on which the server listens (default: 3000)
  -c,--ignoreChecksums     whether to ignore checksums. Useful for speedup in
                           debugging
  --certFile CERTFILE      The cert file of the TLS Certificate used for HTTPS
  --chainFile CHAINFILE    The chain file of the TLS Certificate used for HTTPS.
                           Can be given multiple times
  --keyFile KEYFILE        The key file of the TLS Certificate used for HTTPS
```

Without the three last options given, the server will listen for unsecured HTTP traffic, which is useful for testing. When given a `--certFile` and a `--keyFile`, the server listens to secure HTTPS traffic. 

If you generate your certificates using [Let's encrypt](https://letsencrypt.org), then the three files are in the following locations:

* `--keyFile /etc/letsencrypt/live/<DOMAIN>/privkey.pem`
* `--certFile /etc/letsencrypt/live/<DOMAIN>/cert.pem`
* `--chainFile /etc/letsencrypt/live/<DOMAIN>/chain.pem`

(note that multiple chain files can be given).
