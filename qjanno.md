# qjanno CLI software

`qjanno` is a command line tool to run SQL queries on .janno (and arbitrary .csv and .tsv) files. This is an adjusted version and hard fork of the qsh package (https://github.com/itchyny/qhs). It is written in Haskell and openly available on [GitHub](https://github.com/poseidon-framework/qjanno/).

[![CI](https://github.com/poseidon-framework/qjanno/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/poseidon-framework/qjanno/actions/workflows/main.yml)
[![Coverage Status](https://img.shields.io/codecov/c/github/poseidon-framework/qjanno/main.svg)](https://codecov.io/github/poseidon-framework/qjanno?branch=main)
[![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/poseidon-framework/qjanno?include_prereleases) ![GitHub all releases](https://img.shields.io/github/downloads/poseidon-framework/qjanno/total)](https://github.com/poseidon-framework/qjanno/releases)

To download the latest stable release version of `qjanno` click here:
[📥 Linux](https://github.com/poseidon-framework/qjanno/releases/latest/download/qjanno-Linux) |
[📥 macOS](https://github.com/poseidon-framework/qjanno/releases/latest/download/qjanno-macOS) |
[📥 Windows](https://github.com/poseidon-framework/qjanno/releases/latest/download/qjanno-Windows.exe)

So in Linux you can run the following commands to get started:

```bash
# download the current stable release binary
wget https://github.com/poseidon-framework/qjanno/releases/latest/download/qjanno-Linux
# make it executable
chmod +x qjanno-Linux
# run it
./qjanno-Linux -h
```

On GitHub you will also find [older release versions](https://github.com/poseidon-framework/qjanno/releases) and [instructions to build qjanno from source](https://github.com/poseidon-framework/qjanno#for-haskell-developers). The relevant changes from one version to the next are documented in this [changelog](https://github.com/poseidon-framework/qjanno/blob/master/CHANGELOG.md).

## Guide for qjanno

qjanno is a fork of the [qhs](https://github.com/itchyny/qhs) software tool, which is, in turn, inspired by the CLI tool [q](https://github.com/harelba/q). All of them enable SQL queries on delimiter-separated text files (e.g. .csv or .tsv). For qjanno we copied the source code of qhs v0.3.3 (MIT-License) and adjusted it to provide a smooth experience with a special kind of .tsv file: The Poseidon [.janno](janno_details.md) file.

Unlike `trident` or `xerxes` it does not have a complete understaning of the .janno-file structure, though, and (mostly) treats it like a normal .tsv file. It does not validate the files upon reading and takes them at face value. Still .janno files are given special consideration: With the `d(...)` pseudo-function they can be searched recursively and loaded together into one table.

qjanno still supports most features of qhs, so it can still read .csv and .tsv files independently or in conjunction with .janno files.

### How does this work?

On startup, qjanno creates an [SQLite](https://www.sqlite.org) database [in memory](https://www.sqlite.org/inmemorydb.html). It then reads the requested, structured text files, attributes each column a type (either character or numeric) and writes the contents of the files to tables in the in-memory database. It finally sends the user-provided query to the database, waits for the result, parses it and returns it on the command line.

### The interface

### Query examples

