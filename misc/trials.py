import math
import random

def est(ps):
    mu = sum(ps)
    var = sum([p*(1.0 - p) for p in ps])
    return (mu, math.sqrt(var))

def pval(x, mu, sig):
    return 0.5 * (1 + math.erf((x - mu)/(sig*math.sqrt(2))))

def trial1(N):
    ps = []
    vs = []
    for i in range(N):
        p = random.betavariate(3, 1.5)
        u = random.random()
        ps.append(p)
        vs.append(u < p)
    return (ps, vs)

def trial2(N):
    beta = 0.1
    ps = []
    vs = []
    for i in range(N):
        p = random.betavariate(3, 1.5)
        u = random.random()
        ps.append(p)
        vs.append(u - beta < p)
    return (ps, vs)

B = {'True': True, 'False': False}

for i in xrange(1000):
    (ps, vs) = trial1(100)
    x = sum(vs)
    (mu, sig) = est(ps)
    print 'null', mu, sig, x, pval(x, mu, sig)

for i in xrange(1000):
    (ps, vs) = trial2(100)
    x = sum(vs)
    (mu, sig) = est(ps)
    print 'bad', mu, sig, x, pval(x, mu, sig)
