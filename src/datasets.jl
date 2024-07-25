function datasets_from_pkg_dir(pkg_dir)
    [rsplit(pth, "."; limit=2)[1] for pth in readdir(pkg_dir) if occursin(r"\.rda$|\.RData|\.csv.gz", pth)]
end

"""
Lists the datasets found in the data directory of the `package_name` R package
along with some basic metadata in a DataFrame.

$(cran_mirror_doc)

This will currently cause all datasets in the package to be cached.
"""
function datasets(package_name, cran_mirror=default_cran_mirror)
    package_dir = get_package_cached(package_name, cran_mirror)
    datasets = datasets_from_pkg_dir(package_dir)
    packages = []
    rows = []
    cols = []
    for dataset_name in datasets
        df = dataset(package_name, dataset_name)
        push!(packages, package_name)
        row = nothing
        col = nothing
        if hasmethod(size, Tuple{typeof(df)})
            sz = size(df)
            if length(sz) == 2
                row = sz[1]
                col = sz[2]
            end
        end
        push!(rows, row)
        push!(cols, col)
    end
    DataFrame(Package=packages, Dataset=datasets, Title=datasets, Rows=rows, Cols=cols)
end