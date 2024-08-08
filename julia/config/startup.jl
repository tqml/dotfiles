try
    using Revise
    using OhMyREPL
    using FilePathsBase; 
    using FilePathsBase: /
catch e
    @warn "Error initializing Revise"
    @warn e  
end
