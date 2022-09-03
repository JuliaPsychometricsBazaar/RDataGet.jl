# RDataGet

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://frankier.github.io/RDataGet.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://frankier.github.io/RDataGet.jl/dev/)
[![Build Status](https://github.com/frankier/RDataGet.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/frankier/RDataGet.jl/actions/workflows/CI.yml?query=branch%3Amain)

Alternative to [RDatasets.jl](https://github.com/JuliaStats/RDatasets.jl/)
which simply grabs datasets directly from CRAN.

The basic usage is similar to `RDatasets.jl`. You can install it as follows:

    Pkg.add("RDataGet.jl")

After installing the RDataGet package, you can then load data sets using the
`dataset()` function, which takes the name of a package and a data set as
arguments:

    using RDataGet
    iris = dataset("datasets", "iris")
    neuro = dataset("boot", "neuro")
