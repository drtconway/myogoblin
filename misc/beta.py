import math
import sys

def same(a, b, eps):
    d = abs(a - b)
    if a == 0:
        return d < eps
    return d/abs(a) < eps

def logAdd(a, b):
    """
    return log(exp(a) + exp(b))
    """
    x = max(a, b)
    y = min(a, b)
    w = y - x
    return x+math.log1p(math.exp(w))

facTbl = {}
facTblMisses = 0
facTblHits = 0
def fac(n):
    global facTbl
    global facTblHits
    global facTblMisses
    if n == 0:
        return 1
        n0 = n
    if n not in facTbl:
        p = 1
        i = 1
        while i <= n:
            if i not in facTbl:
                p *= i
                facTbl[i] = p
            else:
                p = facTbl[i]
            i += 1
        facTblMisses += 1
    else:
        facTblHits += 1
    return facTbl[n]

def choose(n, k):
    return fac(n)/(fac(n - k)*fac(k))

def contFrac(aa, bb):
    eps = 1e-12
    fjm1 = max(bb(0), eps)
    fj = fjm1
    Cjm1 = fjm1
    Djm1 = 0
    for j in xrange(1,30):
        aj = aa(j)
        bj = bb(j)
        Dj = max(bj + aj*Djm1, eps)
        Cj = max(bj + aj/Cjm1, eps)
        Dj = 1.0/Dj
        deltaj = Cj*Dj
        fj = fjm1*deltaj
        if abs(deltaj - 1) < eps:
            break
        fjm1 = fj
        Cjm1 = Cj
        Djm1 = Dj
    return fj

def logGamma(z):
    #if z == 1:
    #    return 0.0
    #z2 = z*z
    #z3 = z2*z
    #z5 = z3*z2
    #return z*math.log(z) - z - 0.5*math.log(z/(2*math.pi)) + 1.0/(12*z) + 1.0/(360*z3) + 1.0/(1260*z5)

    x0 = 9

    if z < x0:
        n = int(math.floor(x0) - math.floor(z))
        p = 1.0
        for k in range(n):
            p *= z+k
        return logGamma(z + n) - math.log(p)
    else:
        z2 = z*z
        z3 = z2*z
        z5 = z3*z2
        return z*math.log(z) - z - 0.5*math.log(z/(2*math.pi)) + 1.0/(12*z) + 1.0/(360*z3) + 1.0/(1260*z5)

def logFac(n):
    return logGamma(n + 1)

def logChoose(n, k):
    return logFac(n) - (logFac(n - k) + logFac(k))

def test_logGamma():
    vals = [
        (0.5, 0.5723649),
        (1.0, 0.0000000),
        (1.5, -0.1207822),
        (2.0, 0.0000000),
        (2.5, 0.2846829),
        (3.0, 0.6931472),
        (3.5, 1.2009736),
        (4.0, 1.7917595),
        (4.5, 2.4537366),
        (5.0, 3.1780538),
        (5.5, 3.9578140),
        (6.0, 4.7874917),
        (6.5, 5.6625621),
        (7.0, 6.5792512),
        (7.5, 7.5343642),
        (8.0, 8.5251614),
        (8.5, 9.5492673),
        (9.0, 10.6046029),
        (9.5, 11.6893334),
        (10.0, 12.8018275),
        (20.0, 39.33988),
        (30.0, 71.25704)
    ]

    for (z, r) in vals:
        r0 = logGamma(z)
        assert same(r, r0, 1e-4)

def logBeta(a, b):
    return logGamma(a) + logGamma(b) - logGamma(a + b)

def beta(a, b):
    return math.exp(logGamma(a) + logGamma(b) - logGamma(a + b))

def test_beta():
    vals = [
        (2, 2, 0.166666667),
        (3, 2, 0.083333333),
        (4, 2, 0.050000000),
        (5, 2, 0.033333333),
        (2, 3, 0.083333333),
        (3, 3, 0.033333333),
        (4, 3, 0.016666667),
        (5, 3, 0.009523810),
        (2, 4, 0.050000000),
        (3, 4, 0.016666667),
        (4, 4, 0.007142857),
        (5, 4, 0.003571429),
        (2, 5, 0.033333333),
        (3, 5, 0.009523810),
        (4, 5, 0.003571429),
        (5, 5, 0.001587302)
    ]

    for (a, b, r) in vals:
        r0 = beta(a, b)
        assert same(r, r0, 1e-5)

def pbetaLin(a, b, x):
    if b > a:
        return 1.0 - pbetaLin(b, a, 1.0 - x)
    y = 1.0 - x
    lx = math.log(x)
    ly = math.log(y)
    m = a
    n = a + b - 1
    s = 0
    j = m
    while j <= n:
        c = choose(n, j)
        lc = math.log(c)
        if lc < 700:
            t = c * (x**j) * (y**(n-j))
        else:
            t = math.exp(lc + j*lx + (n-j)*ly)
        s += t
        j += 1
    return s

def pbetaLog(a, b, x):
    if b > a:
        return 1.0 - pbetaLog(b, a, 1.0 - x)
    y = 1.0 - x
    lx = math.log(x)
    ly = math.log(y)
    m = a
    n = a + b - 1
    ls = None
    j = m
    while j < n:
        lc = logChoose(n, j)
        lt = lc + j*lx + (n-j)*ly
        if ls is None:
            ls = lt
        else:
            ls = logAdd(ls, lt)
        j += 1
    return math.exp(ls)

def pbeta(a, b, x):
    v = logChoose(a + b, min(a, b))
    if v < 150:
        return pbetaLin(a, b, x)
    else:
        return pbetaLog(a, b, x)

def test_pbeta_1():
    ns = [2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000]
    for n in ns:
        a = n
        b = n
        x = 0.5
        r = 0.5
        r0 = pbeta(a, b, x)
        assert same(r, r0, 1e-3)

def test_pbeta_2():
    vals = [
        (2, 100, 0.01, 2.679353e-01),
        (5, 100, 0.01, 4.057936e-03)
    ]

    for (a, b, x, r) in vals:
        r0 = pbeta(a, b, x)
        assert same(r, r0, 1e-3)


test_logGamma()
test_beta()
test_pbeta_1()
test_pbeta_2()
