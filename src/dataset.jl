import Tar
import Downloads
using RData
using DataFrames
using CSV
using CodecZlib


const default_cran_mirror = "https://cloud.r-project.org/"


function dataset(package_name, dataset_name, types=nothing, cran_mirror=default_cran_mirror)
    dataset_from_data_dir(get_package_cached(package_name, cran_mirror), dataset_name, types)
end

function dataset_from_data_dir(basename, dataset_name, types=nothing)
    rdas = [
        joinpath(basename, string(dataset_name, ".rda")),
        joinpath(basename, string(dataset_name, ".RData"))
    ]
    for rdaname in rdas
        if isfile(rdaname)
            return load(rdaname)[dataset_name]
        end
    end

    csvname = joinpath(basename, string(dataset_name, ".csv.gz"))
    if isfile(csvname)
        return open(csvname,"r") do io
            uncompressed = IOBuffer(read(GzipDecompressorStream(io)))
            DataFrame(
                CSV.File(uncompressed, delim=',', quotechar='\"', missingstring="NA",
                types=types)
            )
        end
    end
    error("Unable to locate dataset from " * rdas[1] * " or " * rdas[2] * " or " * csvname)
end