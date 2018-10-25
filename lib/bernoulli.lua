local bernoulli = {}

local special = require('special')

function bernoulli.pvalue(vec)
    local mu = 0
    local var = 0
    local x = 0
    for i = 1,#vec do
        local itm = vec[i]
        mu = mu + itm.p
        var = var + itm.p*(1 - itm.p)
        x = x + itm.v
    end
    return special.pnorm(x, mu, math.sqrt(var))
end

return bernoulli
