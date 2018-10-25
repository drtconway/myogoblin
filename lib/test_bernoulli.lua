local B = require('bernoulli')

local V = require('bernoulli_data')

function test_pvalue_good()
    for k,v in pairs(V) do print(k) end
    local p = B.pvalue(V.good)
    print(p)
end

test_pvalue_good()
