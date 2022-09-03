using UrlDownload


function parse_packages(packages)
    packages = String(packages)
    verlook = Dict()
    for package in split(packages, "\n\n")
        name = nothing
        version = nothing
        for line in split(package, "\n")
            if startswith(line, "Package: ")
                name = split(line, ": ")[2]
            elseif startswith(line, "Version: ")
                version = split(line, ": ")[2]
            end
        end
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
