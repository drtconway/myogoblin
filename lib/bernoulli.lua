local bernoulli = {}

local special = require('special')

function bernoulli.pvalue(vec)
  local mu = 0
  local var = 0
  local x = 0
  for p,q in pairs(vec) do
      mu = mu + p
      var = var + p*(1 - p)
      x = x + q
  end
  return special.gauss(x, mu, math.sqrt(var))
end

return bernoulli
