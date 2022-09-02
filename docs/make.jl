using RDataGet
using Documenter

DocMeta.setdocmeta!(RDataGet, :DocTestSetup, :(using RDataGet); recursive=true)

makedocs(;
    modules=[RDataGet],
    authors="Frankie Robertson <frankie@robertson.name> and contributors",
    repo="https://github.com/frankier/RDataGet.jl/blob/{commit}{path}#{line}",
    sitename="RDataGet.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://frankier.github.io/RDataGet.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/frankier/RDataGet.jl",
    devbranch="main",
)
