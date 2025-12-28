using RDataGet
using Documenter

DocMeta.setdocmeta!(RDataGet, :DocTestSetup, :(using RDataGet); recursive=true)

makedocs(;
    modules=[RDataGet],
    authors="Frankie Robertson <frankie@robertson.name> and contributors",
    repo="https://github.com/JuliaPsychometricsBazaar/RDataGet.jl/blob/{commit}{path}#{line}",
    sitename="RDataGet.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaPsychometricsBazaar.github.io/RDataGet.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaPsychometricsBazaar/RDataGet.jl",
    devbranch="main",
)
