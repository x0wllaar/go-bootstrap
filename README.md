# go-bootstrap

A simple way to install Go by building it from source.

This will **bootstrap** the Go installation by first building Go 1.4 using the system C compiler, then will go through the bootstrap chain to build the version you need. This completely removes the need to obtain the Go binaries from anywhere, as only the official repo is used to build Go.

Currently, it does not support selecting a particular point release and will always build the latest one from a particular release branch.

TLDR:

```
git clone https://github.com/x0wllaar/go-bootstrap
cd go-bootstrap
make
./go/bin/go version
```

## Prerequisites

- Git
- A C compiler
- `make`
- Standard Linux tools (bash etc)

Nothing else should be needed.

## Installing Go

The latest Go version:

```
make
```

A specific version:

```
make update-go1.26
```

These commands automatically update to the latest minor release.

Check the makefile for other installation targets, but these should be enough to install Go and keep it updated.

### Custom install location

By default, Go is installed to `go/` in the project directory. You can change this with an environment variable:

```
GO_INSTALL_TARGET=/usr/local/go make update-latest
```

### Custom source repo

By default, https://go.googlesource.com/go is used. You can change this with an environment variable:

```
GO_INSTALL_REPO="https://github.com/golang/go" make update-latest
```

### Custom C compiler

By default, the default system C compiler with `-std=gnu17` flag will be used to compile Go 1.4. You can change this with an environment variable:

```
GO_INSTALL_CC="clang -std=gnu17" make update-latest
```

## Clean up

Remove build trees:

```
make cleantrees
```

Remove everything (build trees + cloned repo + installed Go):

```
make clean
```

Remove the build tree for a specific verion:

```
make cleantree-go1.25
```
