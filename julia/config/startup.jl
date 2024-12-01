try
    using Revise
    using OhMyREPL
    using FilePathsBase
catch e
    @warn "Error initializing Revise"
    @warn e
end
