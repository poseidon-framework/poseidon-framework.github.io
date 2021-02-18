# Poseidon-http-server

The Poseidon-http-server is a server software written in Haskell and provided together with `trident` in the [poseidon-hs github repository](https://github.com/poseidon-framework/poseidon-hs). This tool powers our central [repository server](repos).

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
