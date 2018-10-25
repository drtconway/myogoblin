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
test_erf()
test_pnorm()
