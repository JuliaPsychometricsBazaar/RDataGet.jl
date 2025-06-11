using RDataGet
using Test

political = dataset("psych", "Harman.political")
@test political isa Matrix
@test size(political) == (8, 8)

neuro = dataset("boot", "neuro")
@test neuro isa Matrix
@test size(neuro) == (469, 6)

tcals = dataset("catR", "tcals")
@test tcals isa DataFrame
@test size(tcals) == (85, 5)