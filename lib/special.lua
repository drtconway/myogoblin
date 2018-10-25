local special = {}

local pi = 3.14159265358979323846264338327950288
local logPi = math.log(pi)

local lfacSmall = {math.log(1), math.log(2), math.log(6), math.log(24), math.log(120),
                   math.log(720), math.log(5040), math.log(40320), math.log(362880), math.log(3628800)}
function special.lfac(n)
    if n <= 1 then
        return 0.0
    end
    if n <= 10 then
        return lfacSmall[n]
    end
    -- Ramanujan's approximation
    return n * math.log(n) - n + math.log(n*(1 + 4*n*(1 + 2*n)))/6 + logPi / 2.0
end

function special.lchoose(n, k)
    assert(n >= k)
    if n == 0 or n == k then
        return 0.0
    end
    return special.lfac(n) - (special.lfac(n - k) + special.lfac(k))
end

function special.erf(x)
    if x < 0 then
        return - special.erf(-x)
    end

    local p = 0.3275911
    local a = {0.254829592, -0.284496736, 1.421413741, -1.453152027, 1.061405429}

    local t = 1.0 / (1.0 + p*x)
    local ti = 1.0
    local s = 0.0
    for i = 1,5 do
        ti = ti * t
        s = s + a[i]*ti
    end
    return 1 - s*math.exp(-x*x)
end

function special.pnorm(x, mu, sig)
    if mu == nil then
        mu = 0.0
    end
    if sig == nil then
        sig = 1.0
    end
    return 0.5 * (1 + special.erf((x - mu)/(sig*math.sqrt(2))))
end

return special
