local special = {}

function special.erf(x)
    local s = 0.0
    if x < 0.0 then
        s = -1
    elseif x > 0.0 then
        s = 1
    end
    local pi = 3.14159265359
    local a = (8*(pi - 3))/(3*pi*(4 - pi))
    return s * math.sqrt(1.0 - math.exp(-x*x  * (4/pi + a*x*x) / (1 + a*x*x)))
end

function special.gauss(x, mu, sig)
    return 0.5 * (1 + special.erf((x - mu)/(sig*math.sqrt(2))))
end

return special
