# RDataGet

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliapsychometricsbazaar.github.io/RDataGet.jl/dev/https://frankier.github.io/RDataGet.jl/dev/)
[![Build Status](https://github.com/frankier/RDataGet.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/frankier/RDataGet.jl/actions/workflows/CI.yml?query=branch%3Amain)

RDataGet gets tabular R datasets from CRAN. It is an alternative to
[RDatasets.jl](https://github.com/JuliaStats/RDatasets.jl/), working on demand,
rather than bundling data.

The basic usage is similar to `RDatasets.jl`. You can install it as follows:

```julia
    Pkg.add("RDataGet")
```

After installing the RDataGet package, you can then load data sets using the
`dataset()` function, which takes the name of a package and a data set as
arguments:

```julia
    using RDataGet
    harman_political = dataset("psych", "Harman.political")
    neuro = dataset("boot", "neuro")
```

## Limitations

This package currently just downloads source packages from CRAN and loads its
dataset into memory in Julia. It does not depend on R itself.

The package has a few limitation, some of which are caused by this design, while
others could be addressed in future:

 * Does not support built-in R datasets, including the `datasets` package, only
   ones which can be downloaded from CRAN
 * Can only load rda/RData/csv.gz files in the data directory
   * As such it does not support packages which generate their data using a
     build script
 * Cannot get any descriptions or further documentation related to the datasets
   from Julia (maybe TODO but needs .Rd parsing)
 * Only supports getting the latest version of each package (TODO)
 * Fixed, very-limited caching strategy
   * The package index is re-downloaded every time we need to download any
     package (so as to find the latest version number) (TODO: should be by-default
     cached per session + longer caching allowed)
   * Packages are downloaded exactly once per session, after which the same data
     is reused until Julia is restarted (TODO: should be
     customisable for longer caching)
