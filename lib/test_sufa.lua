local S = require "sufa"

function test_sufa_create()
    local txt = "GAAATTGCTAACAATTTTGGAATGCTTTGTTAAATTATTTATCTTACATTTTTAATTTCCTAATCTGTAATTTATCTAAGC"
    local sa = S.SuffixArray:create(txt)
    local q = "GGAATGCTTTGTTAAATTATTTC"
    local i, l, s = sa:lcp(q)
    assert(i == 41)
    assert(l == 22)
    assert(string.sub(s, 1, l) == string.sub(q, 1, l))
end

test_sufa_create()
