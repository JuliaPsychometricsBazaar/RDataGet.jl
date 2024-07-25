import Tar
import Downloads
using RData
using DataFrames
using CSV
using CodecZlib

"""
Tries to find `dataset_name` the data directory of the R package
`package_name`. The data table is loaded directly from an RData or CSV file in
package source. Sometimes, not all columns can be successfully typed from CSVs,
and so `types` can be provided which will be passed to `CSV.File`.

$(cran_mirror_doc)

After first load, the data will be cached as an arrow file.
"""
function dataset(package_name, dataset_name, types=nothing, cran_mirror=default_cran_mirror)
    return DataFrame(table_from_data_dir(get_package_cached(package_name, cran_mirror), dataset_name, types))
end

function table_from_data_dir(basename, dataset_name, varname=nothing, types=nothing)
    rdas = [
        joinpath(basename, string(dataset_name, ".rda")),
        joinpath(basename, string(dataset_name, ".RData"))
    ]
    for rdaname in rdas
        if isfile(rdaname)
            data = load(rdaname)
            if isnothing(varname)
                key = dataset_name
            else
                key = varname
            end
            if !haskey(data, key)
                errmsg = "Could not find variable $key in .rda dataset $dataset_name, available keys: $(keys(data))"
                if isnothing(varname)
                    errmsg *= " (Hint: try specifying the variable name explicitly)"
                end
                error(errmsg)
            end
            return data[key]
        end
    end

    csvname = joinpath(basename, string(dataset_name, ".csv.gz"))
    if isfile(csvname)
        if !isnothing(varname)
            error("Cannot specify varname for CSV files")
        end
        return open(csvname,"r") do io
            uncompressed = IOBuffer(read(GzipDecompressorStream(io)))
            return CSV.File(
                uncompressed,
                delim=',',
                quotechar='\"',
                missingstring="NA",
                types=types
            )
        end
    end
    error("Unable to locate dataset from " * rdas[1] * " or " * rdas[2] * " or " * csvname)
end
