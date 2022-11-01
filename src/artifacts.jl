using Arrow
using DataFrames
using OhMyArtifacts
using Serialization


const rdataget_artifacts = Ref{String}()

function __init__()
    rdataget_artifacts[] = @my_artifacts_toml!(versioned=false)
end

function mk_artifact_name(package_name, version, dataset_name, varname)
    "cran__" * package_name * "__" * version * "__" * dataset_name * (isnothing(varname) ? "" : ("__" * varname))
end

JL_SER_MAGIC = Vector{UInt8}(b"7JL")

function load_artifact(path)
    magic = open(f -> read(f, 3), path)
    if magic == JL_SER_MAGIC 
        return deserialize(path)
    else
        return DataFrame(Arrow.Table(path))
    end
end

function serialize_artifact(io, data::Union{CSV.File, DataFrame})
    Arrow.write(io, data)
end

function serialize_artifact(io, data)
    serialize(io, data)
end

function cran_arrow_artifact(package_name, dataset_name, varname=nothing, version="auto"; cran_mirror=default_cran_mirror)
    @debug "Saving RDataGet.jl artifact metadata to $(rdataget_artifacts[])" 
    if dataset_name == varname
        # normalise this case for the artifact name
        varname = nothing
    end
    name = mk_artifact_name(package_name, version, dataset_name, varname)
    additional_name = nothing
    filename = name * ".arrow"
    hash = my_artifact_hash(name, rdataget_artifacts[])
    if isnothing(hash)
        hash = create_my_artifact() do artifact_dir
            full_path = joinpath(artifact_dir, filename)
            open(full_path, "w") do io
                package, got_version = get_package_cached(package_name, cran_mirror)
                if version == "auto"
                    additional_name = mk_artifact_name(package_name, got_version, dataset_name, varname)
                end
                tbl = table_from_data_dir(package, dataset_name, varname) 
                serialize_artifact(io, tbl)
            end
            return full_path 
        end
        bind_my_artifact!(rdataget_artifacts[], name, hash)
    end
    if additional_name !== nothing
        additional_name_hash = my_artifact_hash(additional_name, rdataget_artifacts[])
        if isnothing(additional_name_hash)
            bind_my_artifact!(rdataget_artifacts[], additional_name, hash)
        else
            # Assert hashes are the same?
        end
    end
    return load_artifact(my_artifact_path(hash))
end