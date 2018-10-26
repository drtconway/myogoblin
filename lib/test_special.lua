local S = require('special')

local abs = function(a) 
    if a < 0 then
        return -a
    end
    return a
end

local same = function(a, b, eps)
    local d = abs(a - b)
    if a == 0 then
        return d < eps
    end
    return d/abs(a) < eps
end

function test_lfac()
    local vals = {
        0.0000000, 0.6931472, 1.7917595, 3.1780538, 4.7874917,
        6.5792512, 8.5251614, 10.6046029, 12.8018275, 15.1044126,
        17.5023078, 19.9872145, 22.5521639, 25.1912212, 27.8992714,
        30.6718601, 33.5050735, 36.3954452, 39.3398842, 42.3356165,
        45.3801389, 48.4711814, 51.6066756, 54.7847294, 58.0036052
    }
    for i = 1,#vals do
        local x = vals[i]
        local y = S.lfac(i)
        assert(same(x, y, 1e-6))
    end
end

function test_lchoose()
    local vals = {
        {n = 5, k = 0, r = 0.000000},
        {n = 10, k = 0, r = 0.000000},
        {n = 20, k = 0, r = 0.000000},
        {n = 50, k = 0, r = 0.000000},
        {n = 100, k = 0, r = 0.000000},
        {n = 5, k = 1, r = 1.609438},
        {n = 10, k = 1, r = 2.302585},
        {n = 20, k = 1, r = 2.995732},
        {n = 50, k = 1, r = 3.912023},
        {n = 100, k = 1, r = 4.605170},
        {n = 5, k = 2, r = 2.302585},
        {n = 10, k = 2, r = 3.806662},
        {n = 20, k = 2, r = 5.247024},
        {n = 50, k = 2, r = 7.110696},
        {n = 100, k = 2, r = 8.507143},
        {n = 5, k = 3, r = 2.302585},
        {n = 10, k = 3, r = 4.787492},
        {n = 20, k = 3, r = 7.038784},
        {n = 50, k = 3, r = 9.883285},
        {n = 100, k = 3, r = 11.993498},
        {n = 5, k = 4, r = 1.609438},
        {n = 10, k = 4, r = 5.347108},
        {n = 20, k = 4, r = 8.485703},
        {n = 50, k = 4, r = 12.347138},
        {n = 100, k = 4, r = 15.181915},
        {n = 5, k = 5, r = 0.000000},
        {n = 10, k = 5, r = 5.529429},
        {n = 20, k = 5, r = 9.648853},
        {n = 50, k = 5, r = 14.566342},
        {n = 100, k = 5, r = 18.136825}
    }
    for i = 1,#vals do
        local x = vals[i]
        local r = S.lchoose(x.n, x.k)
        assert(same(x.r, r, 1e-4))
    end
end

function test_pbinom()
    local vals = {
        {n = 10, k = 0, r = 2.824752e-02},
        {n = 20, k = 0, r = 7.979227e-04},
        {n = 50, k = 0, r = 1.798465e-08},
        {n = 100, k = 0, r = 3.234477e-16},
        {n = 10, k = 1, r = 1.493083e-01},
        {n = 20, k = 1, r = 7.637260e-03},
        {n = 50, k = 1, r = 4.033700e-07},
        {n = 100, k = 1, r = 1.418549e-14},
        {n = 10, k = 2, r = 3.827828e-01},
        {n = 20, k = 2, r = 3.548313e-02},
        {n = 50, k = 2, r = 4.449916e-06},
        {n = 100, k = 2, r = 3.082588e-13},
        {n = 10, k = 3, r = 6.496107e-01},
        {n = 20, k = 3, r = 1.070868e-01},
        {n = 50, k = 3, r = 3.219766e-05},
        {n = 100, k = 3, r = 4.425285e-12},
        {n = 10, k = 4, r = 8.497317e-01},
        {n = 20, k = 4, r = 2.375078e-01},
        {n = 50, k = 4, r = 1.719274e-04},
        {n = 100, k = 4, r = 4.721295e-11},
        {n = 10, k = 5, r = 9.526510e-01},
        {n = 20, k = 5, r = 4.163708e-01},
        {n = 50, k = 5, r = 7.228617e-04},
        {n = 100, k = 5, r = 3.992943e-10},
        {n = 10, k = 6, r = 9.894079e-01},
        {n = 20, k = 6, r = 6.080098e-01},
        {n = 50, k = 6, r = 2.493722e-03},
        {n = 100, k = 6, r = 2.788418e-09},
        {n = 10, k = 7, r = 9.984096e-01},
        {n = 20, k = 7, r = 7.722718e-01},
        {n = 50, k = 7, r = 7.264203e-03},
        {n = 100, k = 7, r = 1.653807e-08},
        {n = 10, k = 8, r = 9.998563e-01},
        {n = 20, k = 8, r = 8.866685e-01},
        {n = 50, k = 8, r = 1.825335e-02},
        {n = 100, k = 8, r = 8.504079e-08},
        {n = 10, k = 9, r = 9.999941e-01},
        {n = 20, k = 9, r = 9.520381e-01},
        {n = 50, k = 9, r = 4.023163e-02},
        {n = 100, k = 9, r = 3.851480e-07},
        {n = 10, k = 10, r = 1.000000e+00},
        {n = 20, k = 10, r = 9.828552e-01},
        {n = 50, k = 10, r = 7.885062e-02},
        {n = 100, k = 10, r = 1.555566e-06}
    }
    for i = 1,#vals do
        local x = vals[i]
        local r = S.pbinom(0.3, x.n, x.k)
        assert(same(x.r, r, 1e-4))
    end
end

function test_ppois()
    local vals = {
        {lam = 1.5, k = 0, r = 2.231302e-01},
        {lam = 3.0, k = 0, r = 4.978707e-02},
        {lam = 8.0, k = 0, r = 3.354626e-04},
        {lam = 11.0, k = 0, r = 1.670170e-05},
        {lam = 15.0, k = 0, r = 3.059023e-07},
        {lam = 1.5, k = 1, r = 5.578254e-01},
        {lam = 3.0, k = 1, r = 1.991483e-01},
        {lam = 8.0, k = 1, r = 3.019164e-03},
        {lam = 11.0, k = 1, r = 2.004204e-04},
        {lam = 15.0, k = 1, r = 4.894437e-06},
        {lam = 1.5, k = 2, r = 8.088468e-01},
        {lam = 3.0, k = 2, r = 4.231901e-01},
        {lam = 8.0, k = 2, r = 1.375397e-02},
        {lam = 11.0, k = 2, r = 1.210873e-03},
        {lam = 15.0, k = 2, r = 3.930845e-05},
        {lam = 1.5, k = 3, r = 9.343575e-01},
        {lam = 3.0, k = 3, r = 6.472319e-01},
        {lam = 8.0, k = 3, r = 4.238011e-02},
        {lam = 11.0, k = 3, r = 4.915867e-03},
        {lam = 15.0, k = 3, r = 2.113785e-04},
        {lam = 1.5, k = 4, r = 9.814241e-01},
        {lam = 3.0, k = 4, r = 8.152632e-01},
        {lam = 8.0, k = 4, r = 9.963240e-02},
        {lam = 11.0, k = 4, r = 1.510460e-02},
        {lam = 15.0, k = 4, r = 8.566412e-04},
        {lam = 1.5, k = 5, r = 9.955440e-01},
        {lam = 3.0, k = 5, r = 9.160821e-01},
        {lam = 8.0, k = 5, r = 1.912361e-01},
        {lam = 11.0, k = 5, r = 3.751981e-02},
        {lam = 15.0, k = 5, r = 2.792429e-03},
        {lam = 1.5, k = 6, r = 9.990740e-01},
        {lam = 3.0, k = 6, r = 9.664915e-01},
        {lam = 8.0, k = 6, r = 3.133743e-01},
        {lam = 11.0, k = 6, r = 7.861437e-02},
        {lam = 15.0, k = 6, r = 7.631900e-03},
        {lam = 1.5, k = 7, r = 9.998304e-01},
        {lam = 3.0, k = 7, r = 9.880955e-01},
        {lam = 8.0, k = 7, r = 4.529608e-01},
        {lam = 11.0, k = 7, r = 1.431915e-01},
        {lam = 15.0, k = 7, r = 1.800219e-02},
        {lam = 1.5, k = 8, r = 9.999723e-01},
        {lam = 3.0, k = 8, r = 9.961970e-01},
        {lam = 8.0, k = 8, r = 5.925473e-01},
        {lam = 11.0, k = 8, r = 2.319851e-01},
        {lam = 15.0, k = 8, r = 3.744649e-02},
        {lam = 1.5, k = 9, r = 9.999959e-01},
        {lam = 3.0, k = 9, r = 9.988975e-01},
        {lam = 8.0, k = 9, r = 7.166243e-01},
        {lam = 11.0, k = 9, r = 3.405106e-01},
        {lam = 15.0, k = 9, r = 6.985366e-02},
        {lam = 1.5, k = 10, r = 9.999994e-01},
        {lam = 3.0, k = 10, r = 9.997077e-01},
        {lam = 8.0, k = 10, r = 8.158858e-01},
        {lam = 11.0, k = 10, r = 4.598887e-01},
        {lam = 15.0, k = 10, r = 1.184644e-01},
        {lam = 1.5, k = 11, r = 9.999999e-01},
        {lam = 3.0, k = 11, r = 9.999286e-01},
        {lam = 8.0, k = 11, r = 8.880760e-01},
        {lam = 11.0, k = 11, r = 5.792668e-01},
        {lam = 15.0, k = 11, r = 1.847518e-01},
        {lam = 1.5, k = 12, r = 1.000000e+00},
        {lam = 3.0, k = 12, r = 9.999839e-01},
        {lam = 8.0, k = 12, r = 9.362028e-01},
        {lam = 11.0, k = 12, r = 6.886967e-01},
        {lam = 15.0, k = 12, r = 2.676110e-01},
        {lam = 1.5, k = 13, r = 1.000000e+00},
        {lam = 3.0, k = 13, r = 9.999966e-01},
        {lam = 8.0, k = 13, r = 9.658193e-01},
        {lam = 11.0, k = 13, r = 7.812912e-01},
        {lam = 15.0, k = 13, r = 3.632178e-01},
        {lam = 1.5, k = 14, r = 1.000000e+00},
        {lam = 3.0, k = 14, r = 9.999993e-01},
        {lam = 8.0, k = 14, r = 9.827430e-01},
        {lam = 11.0, k = 14, r = 8.540440e-01},
        {lam = 15.0, k = 14, r = 4.656537e-01},
        {lam = 1.5, k = 15, r = 1.000000e+00},
        {lam = 3.0, k = 15, r = 9.999999e-01},
        {lam = 8.0, k = 15, r = 9.917690e-01},
        {lam = 11.0, k = 15, r = 9.073961e-01},
        {lam = 15.0, k = 15, r = 5.680896e-01},
        {lam = 1.5, k = 16, r = 1.000000e+00},
        {lam = 3.0, k = 16, r = 1.000000e+00},
        {lam = 8.0, k = 16, r = 9.962820e-01},
        {lam = 11.0, k = 16, r = 9.440756e-01},
        {lam = 15.0, k = 16, r = 6.641232e-01},
        {lam = 1.5, k = 17, r = 1.000000e+00},
        {lam = 3.0, k = 17, r = 1.000000e+00},
        {lam = 8.0, k = 17, r = 9.984057e-01},
        {lam = 11.0, k = 17, r = 9.678095e-01},
        {lam = 15.0, k = 17, r = 7.488588e-01},
        {lam = 1.5, k = 18, r = 1.000000e+00},
        {lam = 3.0, k = 18, r = 1.000000e+00},
        {lam = 8.0, k = 18, r = 9.993496e-01},
        {lam = 11.0, k = 18, r = 9.823135e-01},
        {lam = 15.0, k = 18, r = 8.194717e-01},
        {lam = 1.5, k = 19, r = 1.000000e+00},
        {lam = 3.0, k = 19, r = 1.000000e+00},
        {lam = 8.0, k = 19, r = 9.997471e-01},
        {lam = 11.0, k = 19, r = 9.907105e-01},
        {lam = 15.0, k = 19, r = 8.752188e-01},
        {lam = 1.5, k = 20, r = 1.000000e+00},
        {lam = 3.0, k = 20, r = 1.000000e+00},
        {lam = 8.0, k = 20, r = 9.999060e-01},
        {lam = 11.0, k = 20, r = 9.953289e-01},
        {lam = 15.0, k = 20, r = 9.170291e-01}
    }
    for i = 1,#vals do
        local x = vals[i]
        local r = S.ppois(x.lam, x.k)
        assert(same(x.r, r, 1e-4))
    end

end

function test_erf()
    local vals = {
        { x = -4, y = -1.0000000},
        { x = -3, y = -0.9999779},
        { x = -2, y = -0.9953223},
        { x = -1, y = -0.8427008},
        { x = 0, y = 0.0000000},
        { x = 1, y = 0.8427008},
        { x = 2, y = 0.9953223},
        { x = 3, y = 0.9999779},
        { x = 4, y = 1.0000000}
    }
    for i = 1,#vals do
        local x = vals[i].x
        local y = vals[i].y
        local z = S.erf(x)
        assert(same(y, z, 1e-3))
    end
end

function test_logBeta()
    local vals = {
        {a = 1, b = 1, r = 0.0000000},
        {a = 2, b = 1, r = -0.6931472},
        {a = 3, b = 1, r = -1.0986123},
        {a = 4, b = 1, r = -1.3862944},
        {a = 5, b = 1, r = -1.6094379},
        {a = 1, b = 2, r = -0.6931472},
        {a = 2, b = 2, r = -1.7917595},
        {a = 3, b = 2, r = -2.4849066},
        {a = 4, b = 2, r = -2.9957323},
        {a = 5, b = 2, r = -3.4011974},
        {a = 1, b = 3, r = -1.0986123},
        {a = 2, b = 3, r = -2.4849066},
        {a = 3, b = 3, r = -3.4011974},
        {a = 4, b = 3, r = -4.0943446},
        {a = 5, b = 3, r = -4.6539604},
        {a = 1, b = 4, r = -1.3862944},
        {a = 2, b = 4, r = -2.9957323},
        {a = 3, b = 4, r = -4.0943446},
        {a = 4, b = 4, r = -4.9416424},
        {a = 5, b = 4, r = -5.6347896},
        {a = 1, b = 5, r = -1.6094379},
        {a = 2, b = 5, r = -3.4011974},
        {a = 3, b = 5, r = -4.6539604},
        {a = 4, b = 5, r = -5.6347896},
        {a = 5, b = 5, r = -6.4457198},
    }
    for i = 1,#vals do
        local x = vals[i]
        local r = S.logBeta(x.a, x.b)
        assert(same(x.r, r, 1e-3))
    end
end

function test_pnorm()
    local vals = {
        { x = -4, y = 3.167124e-05},
        { x = -3, y = 1.349898e-03},
        { x = -2, y = 2.275013e-02},
        { x = -1, y = 1.586553e-01},
        { x = 0, y = 5.000000e-01},
        { x = 1, y = 8.413447e-01},
        { x = 2, y = 9.772499e-01},
        { x = 3, y = 9.986501e-01},
        { x = 4, y = 9.999683e-01},
    }
    for i = 1,#vals do
        local x = vals[i].x
        local y = vals[i].y
        local z = S.pnorm(x)
        assert(same(y, z, 1e-3))
    end
end

test_lfac()
test_lchoose()
test_pbinom()
test_ppois()
test_erf()
test_logBeta()
test_pnorm()
