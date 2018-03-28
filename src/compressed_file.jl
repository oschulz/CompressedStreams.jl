struct CompressedFile
    filename::String
end

export CompressedFile


Base.open(file::CompressedFile, mode::AbstractString = "r") = begin
    filename = file.filename

    if mode == "r"
        if endswith(filename, ".gz")
            open(`gzip -d -c $filename`, "r", STDOUT)[1]
        elseif endswith(filename, ".bz2")
            try
                open(`pbzip2 -d -c $filename`, "r", STDOUT)[1]
            catch
                info("pbzip2 doesn't seem to be available, falling back to standard bzip2")
                open(`bzip2 -d -c $filename`, "r", STDOUT)[1]
            end
        elseif endswith(filename, ".xz")
            open(`xz -d -c $filename`, "r", STDOUT)[1]
        else
            open(`cat $filename`, "r", STDOUT)[1]
        end
    else
        @assert false
    end
end
