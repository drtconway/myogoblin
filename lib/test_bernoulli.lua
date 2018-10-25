local B = require('bernoulli')

local V = require('bernoulli_data')

local abs = function(x)
    if x < 0 then
        return -x
    else
        return x
    end
end

function test_pvalue_good()
    local gP, gMu, gSig, gZ = B.pvalue(V.good)
    assert(abs(gZ) < 2)
end

function test_pvalue_bad()
    local bP, bMu, bSig, bZ = B.pvalue(V.bad)
    assert(abs(bZ) > 2)
end

test_pvalue_good()
test_pvalue_bad()
