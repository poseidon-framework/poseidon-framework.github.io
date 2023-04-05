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

...