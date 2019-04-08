using Test, PolynomialBases
using InteractiveUtils

# regression test
for basis_type in subtypes(PolynomialBases.NodalBasis{PolynomialBases.Line})
    println(devnull, "  ", basis_type(1))
    for p in 0:20, T in (Float32, Float64)
        basis = try
            basis_type(p, T)
        catch m
            isa(m, DomainError) && continue
            throw(m)
        end
        xmin, xmax = 0.25, 0.9
        x = similar(basis.nodes)
        ξ = similar(x)
        map_from_canonical!(x, basis.nodes, xmin, xmax, basis)
        map_to_canonical!(ξ, x, xmin, xmax, basis)
        @test ξ ≈ basis.nodes atol=10*eps(T)
    end
end
