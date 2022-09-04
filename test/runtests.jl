using RDataGet
using Test

mat = dataset("psych", "Harman.political")
@test size(mat) == (8, 8)