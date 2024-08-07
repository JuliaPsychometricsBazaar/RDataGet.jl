using UrlDownload

const default_cran_mirror = "https://cloud.r-project.org/"

const cran_mirror_doc = """
An alternative `cran_mirror` can be specified, by default `default_cran_mirror=
"$(default_cran_mirror)"` is used.
"""

function parse_description(description)
    name = nothing
    version = nothing
    for line in split(description, "\n")
        if startswith(line, "Package: ")
            name = split(line, ": ")[2]
        elseif startswith(line, "Version: ")
            version = split(line, ": ")[2]
        end
    end
    return name, version
end

function parse_packages(packages)
    packages = String(packages)
    verlook = Dict()
    for description in split(packages, "\n\n")
        name, version = parse_description(description)
        if name !== nothing && version !== nothing
            verlook[name] = version
        end
    end
    verlook
end

function available_packages()
    urldownload(
        "https://cloud.r-project.org/src/contrib/PACKAGES.gz",
        true;
        parser = parse_packages,
        compress = :gzip
    )
end
