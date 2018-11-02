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

function cont(aa, bb)
    -- continued fraction notation is inconsistent
    -- with some taking a_i to be numerators and b_i
    -- denominators, and some the other way around.
    -- The folloing assumes a_i to be numerator.
    local dm = 1e-300
    local a1 = aa(1)
    local b1 = bb(1)
    local f = aa(1)/bb(1)
    C = a1/dm
    D = 1/b1
    n = 2
    while true do
        local an = aa(n)
        local bn = bb(n)

        D = D * an + bn
        if D == 0 then D = dm end

        C = bn + an/C
        if C == 0 then C = dm end

        D = 1/D
        local delta = C*D
        f = f * delta
        n = n + 1
        if abs(delta - 1) < 1e-12 then
            return f
        end
    end
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
stats.logLowerGamma = logLowerGamma

function lowerGamma(s, x)
    return math.exp(logLowerGamma(s, x))
end
stats.lowerGamma = lowerGamma

function logUpperGammaInner(s, x)
    local M
    local N
    if x == 0 then
        M, N = 1, gamma(s)
    end

    local aa1 = function(n)
        if n == 1 then
            return 1
        end
        return -(n - 1)*(n - s - 1)
    end
    local aa2 = function(n) return aa1(n + 1) end

    local bb1 = function(n)
        return x + 2*n - 1 - s
    end
    local bb2 = function(n) return bb1(n + 1) end

    if x == s - 1 then
        M = aa1(1) / cont(aa2, bb2, s)
    else
        M = cont(aa1, bb1, s)
    end
    N = s*math.log(x) - x
    return M, N
end

function logUpperGamma(s, x)
    M, N = logUpperGammaInner(s, x)
    return N + math.log(M)
end
stats.logUpperGamma = logUpperGamma

function upperGamma(s, x)
    M, N = logUpperGammaInner(s, x)
    return M * math.exp(N)
end
stats.upperGamma = upperGamma

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

function erf(x)
    if x < 0 then
        return 1 - erf(-x)
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
stats.erf = erf

function erfc(x)
    if x < -0.5 then
        return 2 - erfc(-x)
    end
    if x < 0 then
        return 1 + erf(-x)
    end
    local c1 = -1.09500814703333
    local c2 = -0.75651138383854
    return math.exp(c1*x + c2*x*x)
    -- local a = 2.7889
    -- return exp(-x*x)*(a/((a-1)*sqrt(pi*x*x) + sqrt(pi*x*x+a*a)))
end
stats.erfc = erfc

function logErfc(x)
    if x < 0 then
        return log1p(erf(-x))
    end
    local c1 = -1.09500814703333
    local c2 = -0.75651138383854
    return c1*x + c2*x*x
end

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
stats.beta_ = beta_
stats.dbeta = function(x, a, b, log)
    return beta_(a, b).pdf(x, log)
end
stats.pbeta = function(x, a, b, upper, log)
    return beta_(a, b).cdf(x, upper, log)
end

function norm(mu, sig)
    local qtps2 = math.sqrt(2*pi*sig^2)
    local lqtps2 = math.log(qtps2)
    local sr2 = sig*math.sqrt(2)
    local l2 = math.log(0.5)

    local norm = {}

    function norm.mean()
        return mu
    end

    function norm.median()
        return mu
    end

    function norm.var()
        return sig^2
    end

    function norm.pdf(x, log)
        local mzo2 = -(x - mu)^2 / (2*sig^2)
        if log then
            return mzo2 - lqtps2
        else
            return math.exp(mzo2) / qtps2
        end
    end

    function norm.cdf(x, upper, log)
        local z = (x - mu)/sr2
        if log then
            if upper then
                return 0.5 * logErfc(z)
            else
                return 0.5 * logErfc(-z)
            end
        else
            if upper then
                return 0.5 * erfc(z)
            else
                return 0.5 * erfc(-z)
            end
        end
    end
end
stats.norm = norm
stats.dnorm = function(x, mu, sig, log)
    return norm(mu, sig).pdf(x, log)
end
stats.pnorm = function(x, mu, sig, upper, log)
    return norm(mu, sig).cdf(x, upper, log)
end

function chisq(k)
    local l2 = math.log(2)
    local lgko2 = logGamma(k/2)

    local chisq = {}

    function chisq.mean()
        return k
    end

    function chisq.median()
        return k * (1 - 2/(9*k))^3
    end

    function chisq.var()
        return 2*k
    end

    function chisq.pdf(x, log)
        local lx = math.log(x)
        local lpdf = (k/2 - 1)*lx - x/2 - ((k/2)*l2 + lgko2)
        if log then
            return lpdf
        else
            return math.exp(lpdf)
        end
    end

    function chisq.cdf(x, upper, log)
        local lcdf
        if upper then
            lcdf = logUpperGamma(k/2, x/2) - lgko2
        else
            lcdf = logLowerGamma(k/2, x/2) - lgko2
        end
        if log then
            return lcdf
        else
            return math.exp(lcdf)
        end
    end

    return chisq
end
stats.chisq = chisq
stats.dchisq = function(k, x, log)
    return chisq(k).pdf(x, log)
end
stats.pchisq = function(k, x, upper, log)
    return chisq(k).cdf(x, upper, log)
end

return stats
