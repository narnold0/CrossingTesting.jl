@testset "Floyd Warshall" begin
    g3 = path_graph(5)
    d = [0 1 2 3 4; 5 0 6 7 8; 9 10 0 11 12; 13 14 15 0 16; 17 18 19 20 0]
    for g in testgraphs(g3)
        z = @inferred(floyd_warshall_shortest_paths(g, d))
        @test z.dists[3, :][:] == [7, 6, 0, 11, 27]
        @test z.parents[3, :][:] == [2, 3, 0, 3, 4]

        @test @inferred(enumerate_paths(z))[2][2] == []
        @test @inferred(enumerate_paths(z))[2][4] ==
            enumerate_paths(z, 2)[4] ==
            enumerate_paths(z, 2, 4) ==
            [2, 3, 4]
    end
    g4 = path_digraph(4)
    d = ones(4, 4)
    for g in testdigraphs(g4)
        z = @inferred(floyd_warshall_shortest_paths(g, d))
        @test length(enumerate_paths(z, 4, 3)) == 0
        @test length(enumerate_paths(z, 4, 1)) == 0
        @test length(enumerate_paths(z, 2, 3)) == 2
    end

    g5 = DiGraph([1 1 1 0 1; 0 1 0 1 1; 0 1 1 0 0; 1 0 1 1 0; 0 0 0 1 1])
    d = [0 3 8 0 -4; 0 0 0 1 7; 0 4 0 0 0; 2 0 -5 0 0; 0 0 0 6 0]
    for g in testdigraphs(g5)
        z = @inferred(floyd_warshall_shortest_paths(g, d))
        @test z.dists == [0 1 -3 2 -4; 3 0 -4 1 -1; 7 4 0 5 3; 2 -1 -5 0 -2; 8 5 1 6 0]
    end

    @testset "enumerate_paths infinite loop bug" begin
        g = SimpleGraph(2)
        add_edge!(g, 1, 2)
        add_edge!(g, 2, 2)
        @test enumerate_paths(floyd_warshall_shortest_paths(g)) ==
            Vector{Vector{Int}}[[[], [1, 2]], [[2, 1], []]]

        g = SimpleDiGraph(2)
        add_edge!(g, 1, 1)
        add_edge!(g, 1, 2)
        add_edge!(g, 2, 1)
        add_edge!(g, 2, 2)
        @test enumerate_paths(floyd_warshall_shortest_paths(g)) ==
            Vector{Vector{Int}}[[[], [1, 2]], [[2, 1], []]]
    end
end
