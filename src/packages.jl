global __package_dirs = Dict()


function is_data(header)
    bits = split(header.path, "/")
    length(bits) >= 2 && bits[2] == "data"
end

function get_package(package_name, cran_mirror=default_cran_mirror)
    verlookup = available_packages()
    if !(package_name in keys(verlookup))
        error("Could not find '$package_name' on CRAN")
    end
    version = verlookup[package_name]
    tgz_name = package_name * "_" * version * ".tar.gz"
    url = cran_mirror * "src/contrib/" * tgz_name
    path = Downloads.download(url)
    tar_gz = open(path)
    tar = GzipDecompressorStream(tar_gz)
    data_files = Tar.extract(is_data, tar)
    joinpath(data_files, package_name, "data")
end

function get_package_cached(package_name, cran_mirror=default_cran_mirror)
    if package_name in keys(__package_dirs)
        return __package_dirs[package_name]
    end
    dir = get_package(package_name, cran_mirror)
    __package_dirs[package_name] = dir
    return dir
end
