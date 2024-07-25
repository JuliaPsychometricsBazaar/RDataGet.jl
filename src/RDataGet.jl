"""
$(README)
"""
module RDataGet

if isdefined(Base, :Experimental) && isdefined(Base.Experimental, Symbol("@optlevel"))
@eval Base.Experimental.@optlevel 1
end

using Reexport
using RData
using CSV
using CodecZlib
using CodecBzip2
using CodecXz
@reexport using DataFrames
using DocStringExtensions

export dataset, datasets, cran_arrow_artifact

@template (FUNCTIONS, METHODS, MACROS) =
    """
    $(TYPEDSIGNATURES)
    $(DOCSTRING)
    """

include("cran.jl")
include("packages.jl")
include("datasets.jl")
include("dataset.jl")
include("artifacts.jl")

end
