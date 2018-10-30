local stats = {}

local pi = 3.14159265358979323846264338327950288
local log_pi = math.log(pi)
local log_2 = math.log(2)

function abs(x)
    if x < 0 then
        return -x
    else
        return x
    end
end

function min(a, b)
    if a <= b then
        return a
    else
        return b
    end
end

function max(a, b)
    if a >= b then
        return a
    else
        return b
    end
end

function minMax(a, b)
    if a >= b then
        return b, a
    else
        return a, b
    end
end

function cont(aa, bb, n)
    local r = 0
    local i = n
    while i > 0 do
        local a = aa(i)
        local b = bb(i)
        r = b / (a + r)
        i = i - 1
    end
    return aa(0) + r
end

function cont2(aa, bb, N)
    local C = aa(0)
    local D = 1 / aa(1)
    local dC = bb(1)*D
    local C = C + dC
    local n = 1
    while true do
        n = n + 1
        local ai = aa(n)
        local bi = bb(n)
        D = 1/(D*bi + ai)
        dC = (ai*D - 1) * dC
        C = C + dC
        if abs(dC/C) < 1e-12 then
            break
        end
    end
    return C
end

function log1p(x)
    if abs(x) >= 1 then
        return math.log(1 + x)
    end
    local mx = -x
    local mxn = 1
    local s = 0
    local n = 0
    while true do
        n = n + 1
        mxn = mxn * mx
        s = s - mxn/n
        if abs(mxn/s) < 1e-12 then
            return s
        end
    end
end

function expm1(x)
    if abs(x) >= 1 then
        return math.exp(x) - 1
    end
    local s = 0
    local n = 0
    local xn = 1
    local nfac = 1
    while true do
        n = n + 1
        xn = xn * x
        nfac = nfac * n
        t = xn / nfac
        s = s + t
        if abs(t/s) < 1e-12 then
            return s
        end
    end
end

function log1mexp(x)
    local a = -x
    if a < log_2 then
        return math.log(-expm1(x))
    else
        return log1p(-math.exp(x))
    end
end

function log1pexp(x)
    if x <= -37 then
        return math.exp(x)
    elseif x < 18 then
        return log1p(math.exp(x))
    elseif x < 33.3 then
        return x + math.exp(-x)
    else
        return x
    end
end

function logAdd(a, b)
    local y, x = minMax(a, b)
    local w = y - x
    return x + log1pexp(w), w
end

function logFac(n)
    return logGamma(n + 1)
end
stats.logFac = logFac

function logChoose(n, k)
    return logFac(n) - (logFac(n - k) + logFac(k))
end
stats.logChoose = logChoose

function choose(N, K)
    local J,I = minMax(N - K, K)
    local a = 1
    local n = I + 1
    local j = 1
    while n <= N and j <= J do
        a = a * n / j
        n = n + 1
        j = j + 1
    end
    while n <= N do
        a = a * n
        n = n + 1
    end
    while j <= J do
        a = a * j
        j = j + 1
    end
    return a
end
stats.choose = choose

function logGamma(z)
    local x0 = 9

    if z < x0 then
        local n = math.floor(x0) - math.floor(z)
        p = 1.0
        for k = 0,n-1 do
            p = p * (z+k)
        end
        return logGamma(z + n) - math.log(p)
    else
        z2 = z*z
        z3 = z2*z
        z5 = z3*z2
        return z*math.log(z) - z - 0.5*math.log(z/(2*math.pi)) + 1.0/(12*z) + 1.0/(360*z3) + 1.0/(1260*z5)
    end
end
function gamma(z)
    return math.exp(logGamma(z))
end
stats.logGamma = logGamma
stats.gamma = gamma

function logLowerGamma(s, x)
    local lx = math.log(x)
    local lgs = logGamma(s)
    local g = lgs + math.log(s)
    local w = -g
    local k = 0
    while true do
        k = k + 1
        g = g + math.log(s + k)
        local t = k * lx - g
        w = logAdd(w, t)
        if t - w < -45 then
            break
        end
    end
    return s*lx + lgs - x + w
end

function logBeta(a, b)
    return logGamma(a) + logGamma(b) - logGamma(a + b)
end
function beta(a, b)
    return math.exp(logBeta(a, b))
end
stats.logBeta = logBeta
stats.beta = beta

function lowerBetaLin(a, b, x)
    local y = 1 - x
    local m = a
    local n = a + b - 1
    local s = 0
    for j = m,n do
        local c = choose(n, j)
        local t = c * (x^j) * (y^(n-j))
        s = s + t
    end
    return s
end

function lowerBetaLog(a, b, x)
    local y = 1 - x
    local lx = math.log(x)
    local ly = log1p(-x)
    local m = a
    local n = a + b - 1
    local s = nil
    for j = m,n do
        local lc = logChoose(n, j)
        local t = lc  + j*lx + (n-j)*ly
        if s == nil then
            s = t
        else
            s = logAdd(s, t)
        end
    end
    return math.exp(s)
end

function lowerBeta(a, b, x)
    if a < b then
        return 1.0 - lowerBeta(b, a, 1 - x)
    end
    local v = logChoose(a + b, b)
    if v < 100 then
        return lowerBetaLin(a, b, x)
    else
        return lowerBetaLog(a, b, x)
    end
end

stats.lowerBeta = lowerBeta

function binom(n, p)
    local q = 1.0 - p
    local lp = math.log(p)
    local lq = log1p(-p)

    local binom = {}

    function binom.mean()
        return p*n
    end

    function binom.median()
        -- multiple medians are possible.
        -- we return the lower bound median.
        return math.floor(p*n)
    end

    function binom.var()
        -- return the variance
        return n*p*q
    end

    function binom.pmf(k, log)
        local lpmf = logChoose(n, k)
        if log then
            return lpmf
        else
            return math.exp(lpmf)
        end
    end

    function binom.cdf(k, upper, log)
        local s = n*lq
        for i = 1,k do
            t = logChoose(n, i) + i*lp + (n - i)*lq
            s = logAdd(s, t)
        end
        if upper then
            s = log1mexp(s)
        end
        if log then
            return s
        else
            return math.exp(s)
        end
    end
    return binom
end
stats.binom = binom
stats.dbinom = function(k, n, p, log)
    return binom(n, p).pmf(k, log)
end
stats.pbinom = function(k, n, p, upper, log)
    return binom(n, p).cdf(k, upper, log)
end

function pois(lam)
    local llam = math.log(lam)

    local pois = {}

    function pois.mean()
        return lam
    end

    function pois.median()
        return max(0, math.floor(lam + 1/3 - 0.02/lam))
    end

    function pois.var()
        return lam
    end

    function pois.pmf(k, log)
        local lpmf = k*llam  - lam - logFac(k)
        if log then
            return lpmf
        else
            return math.exp(lpmf)
        end
    end

    function pois.cdf(k, log, upper)
        local s = 0
        local ifac = 0
        for i = 1,k do
            ifac = ifac + math.log(i)
            local t = i*llam - ifac
            s = logAdd(s, t)
        end
        if upper then
            s = log1mexp(s)
        end
        if log then
            return s
        else
            return math.exp(s)
        end
    end

    return pois
end
stats.pois = pois
stats.dpois = function(k, lam, log)
    return pois(lam).pmf(k, log)
end
stats.ppois = function(k, lam, upper, log)
    return pois(lam).cdf(k, upper, log)
end

function geom(p)
    local q = 1 - p
    local lp = math.log(p)
    local lq = log1p(-p)

    local geom = {}

    function geom.mean()
        return q/p
    end

    function geom.median()
        return math.ceil(-1/math.log(q, 2)) - 1
    end

    function geom.var()
        return q/(p*p)
    end

    function geom.pmf(k, log)
        local lpmf = k*lq + lp
        if log then
            return lpmf
        else
            return math.exp(lpmf)
        end
    end

    function geom.cdf(k, upper, log)
        local s = (k+1)*lq
        if not upper then
            s = log1mexp(s)
        end
        if log then
            return s
        else
            return math.exp(s)
        end
    end

    return geom
end
stats.geom = geom
stats.dgeom = function(k, p, log)
    return geom(p).pmf(k, log)
end
stats.pgeom = function(k, p, upper, log)
    return geom(p).cdf(k, upper, log)
end

function gamma_(a, b)
    local lb = math.log(b)
    local lga = logGamma(a)

    local gamma_ = {}

    function gamma_.mean()
        return a / b
    end

    function gamma_.median()
        return nil
    end

    function gamma_.var()
        return a/(b*b)
    end

    function gamma_.pdf(x, log)
        local lx = math.log(x)
        local lpdf = a*lb + (a-1)*lx - b*x - lga
    end

    function gamma_.cdf(x, upper, log)
        local lcdf = logLowerGamma(a, b*x) - logGamma(a)
        if upper then
            lcdf = log1mexp(lcdf)
        end
        if log then
            return lcdf
        else
            return math.exp(lcdf)
        end
    end

    return gamma_
end
stats.gamma_ = gamma_
stats.dgamma = function(x, a, b, log)
    return gamma_(a, b).pdf(x, log)
end
stats.pgamma = function(x, a, b, upper, log)
    return gamma_(a, b).cdf(x, upper, log)
end

function beta_(a, b)
    local lbab = logBeta(a, b)

    local beta_ = {}

    function beta_.mean()
        return a / (a + b)
    end

    function beta_.median()
        if a > 1 and b > 1 then
            return (a - 1/3)/(a + b - 1/3)
        else
            return nil
        end
    end

    function beta_.var()
        return (a*b)/((a + b)^2 * (a + b + 1))
    end

    function beta_.pdf(x, log)
        local y = 1 - x
        local lx = math.log(x)
        local ly = log1p(-x)
        local lpdf = (a - 1)*lx + (b - 1)*ly - lbab
        if log then
            return lpdf
        else
            return math.exp(lpdf)
        end
    end

    function beta_.cdf(x, upper, log)
        local p = lowerBeta(a, b, x)
        if upper then
            p = 1.0 - p
        end
        if log then
            return math.log(p)
        else
            return p
        end
    end

    return beta_
end

return stats
