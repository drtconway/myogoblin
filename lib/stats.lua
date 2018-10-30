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
stats.logGamma = logGamma

function logFac(n)
    return logGamma(n + 1)
end
stats.logFac = logFac

function logChoose(n, k)
    return logFac(n) - (logFac(n - k) + logFac(k))
end
stats.logChoose = logChoose

function binom(n, p)
    local q = 1.0 - p
    local lp = math.log(p)
    local lq = math.log(q)

    local binom = {}
    function binom.mean()
        return p*n
    end

    function binom.median()
        return math.floor(p*n)
    end

    function binom.var()
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

return stats
