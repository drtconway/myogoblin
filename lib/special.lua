local special = {}

local pi = 3.14159265358979323846264338327950288
local logPi = math.log(pi)

local min = function(a, b)
    if a <= b then
        return a
    else
        return b
    end
end

local max = function(a, b)
    if a >= b then
        return a
    else
        return b
    end
end

function logAdd(a, b)
    local x = max(a, b)
    local y = min(a, b)
    local w = y - x
    return x + math.log(1+math.exp(w))
end

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

function special.logGamma(z)
    if z == 1 then
        return 0.0
    end
    local z2 = z*z
    local z3 = z2*z
    local z5 = z3*z2
    return z*math.log(z) - z - 0.5*math.log(z/(2*pi)) + 1.0/(12*z) + 1.0/(360*z3) + 1.0/(1260*z5)
end

function special.logBeta(a, b)
    return special.logGamma(a) + special.logGamma(b) - special.logGamma(a + b)
end

function special.dbinom(p, n, k)
    local r = special.lchoose(n, k) + k*math.log(p) + (n-k)*math.log(1-p)
    return math.exp(r)
end

function special.pbinom(p, n, k)
    local lp = math.log(p)
    local l1mp = math.log(1 - p)
    local r = n*l1mp
    for i = 1,k do
        local t = special.lchoose(n, i) + i*lp + (n-i)*l1mp
        r = logAdd(r, t)
    end
    return math.exp(r)
end

function special.dpois(lam, k)
    return math.exp((k*math.log(lam) - lam) - special.lfac(k))
end

function special.ppois(lam, k)
    local llam = math.log(lam)
    local r = 0.0
    for i = 1,k do
        local t = i*llam - special.lfac(i)
        r = logAdd(r, t)
    end
    return math.exp(r - lam)
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
