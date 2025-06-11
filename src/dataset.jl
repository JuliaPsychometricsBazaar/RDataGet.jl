import Tar
import Downloads
using Tables: istable
using FileTypes: matcher
using FileTypes.FileType: TypeGz, TypeBz2, TypeXz
using RData
using DataFrames
using CSV
using CodecZlib
using CodecBzip2
using CodecXz

"""
Tries to find `dataset_name` the data directory of the R package
`package_name`. The data table is loaded directly from an RData or CSV file in
package source. Sometimes, not all columns can be successfully typed from CSVs,
and so `types` can be provided which will be passed to `CSV.File`.

$(cran_mirror_doc)

After first load, the data will be cached as an arrow file.
"""
function dataset(package_name, dataset_name, types=nothing, cran_mirror=default_cran_mirror)
    tab = table_from_data_dir(get_package_cached(package_name, cran_mirror)[1], dataset_name, types)
    if istable(tab)
        return DataFrame(tab)
    else
        return collect(tab)
    end
end

const RDATA_EXTS = [".rda", ".RData"]
const CSV_EXTS = [".csv", ".CSV"]
const TSV_EXTS = [".tab", ".txt", ".TXT"]
const COMPRESSED_EXTS = ["", ".gz", ".bz2", ".xz"]

function load_rdata(rdaname, dataset_name, varname)
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

function load_tab(csvname, varname, types; delim=",")
    if !isnothing(varname)
        error("Cannot specify varname for CSV files")
    end
    decompressor = x -> x
    type = matcher(csvname)
    if type == TypeBz2
        decompressor = Bzip2DecompressorStream
    elseif type == TypeXz
        decompressor = XzDecompressorStream
    elseif type == TypeGz
        decompressor = GzipDecompressorStream
    end
    return open(csvname,"r") do io
        uncompressed = IOBuffer(read(decompressor(io)))
        return CSV.File(
            uncompressed,
            delim=delim,
            quotechar='\"',
            missingstring="NA",
            types=types
        )
    end
end

function table_from_data_dir(basename, dataset_name, varname=nothing, types=nothing)
    tried = []
    function candidate_exts(exts, other_exts=[""])
        for final_ext in other_exts
            for ext in exts
                path = joinpath(basename, string(dataset_name, ext, final_ext))
                push!(tried, path)
                if isfile(path)
                    return path
                end
            end
        end
        return nothing
    end

    rdaname = candidate_exts(RDATA_EXTS; )
    if !isnothing(rdaname)
        return load_rdata(rdaname, dataset_name, varname)
    end

    csvname = candidate_exts(CSV_EXTS, COMPRESSED_EXTS)
    if !isnothing(csvname)
        return load_tab(csvname, varname, types)
    end

    tsvname = candidate_exts(TSV_EXTS, COMPRESSED_EXTS)
    if !isnothing(tsvname)
        return load_tab(tsvname, varname, types; delim="\t")
    end

    error("Unable to locate dataset from any of:\n" * join(tried, "\n"))
end
