local sufa = {}

local SuffixArray = {}
local SuffixArrayMT = { __index = SuffixArray }

function SuffixArray:create(txt)
    local suf = {}
    setmetatable(suf, SuffixArrayMT)
    suf.txt = txt
    suf.idx = {}
    for i = 1,#txt do
        suf.idx[i] = i
    end
    suf:sort()
    return suf
end

function SuffixArray:size()
    return #self.txt
end

function SuffixArray:get(i)
    return string.sub(self.txt, self.idx[i], -1)
end

function SuffixArray:lcp(s)
    local i = self:lowerBound(s)
    if i > 1 then
        local a = self:get(i-1)
        local p = self:lcpStrStr(s, a)
        local b = self:get(i)
        local q = self:lcpStrStr(s, b)
        if p >= q then
            return i - 1, p, a
        else
            return i, q, b
        end
    else
        local b = self:get(i)
        return i, self:lcpStrStr(s, b), b
    end
end

function SuffixArray:lowerBound(s)
    for i = 1,self:size() do
        local j = self.idx[i]
        if not self:lessIdxStr(j, s) then
            return i
        end
    end
    return self:size()
end

function SuffixArray:sort()
    local cmp = function(i,j)
        return self:lessIdxIdx(i,j)
    end
    table.sort(self.idx, cmp)
end

function SuffixArray:lessIdxIdx(i, j)
    local txt = self.txt
    local n = #txt
    while i <= n and j <= n do
        local a = string.sub(txt, i, i)
        local b = string.sub(txt, j, j)
        if a < b then
            return true
        end
        if a > b then
            return false
        end
        i = i + 1
        j = j + 1
    end
    -- if i the end of the of the array then it's less,
    -- otherwise j must have and it's not less.
    return i == n
end

function SuffixArray:lessIdxStr(i, s)
    local txt = self.txt
    local n = #txt
    local j = 1
    local m = #s
    while i <= n and j <= m do
        local a = string.sub(txt, i, i)
        local b = string.sub(s, j, j)
        if a < b then
            return true
        end
        if a > b then
            return false
        end
        i = i + 1
        j = j + 1
    end
    assert((i > n) or (j > m))
    return i > n
end

function SuffixArray:lcpStrStr(s, t)
    local n = #s
    local m = #t
    local i = 1
    while i <= n and i <= m do
        local a = string.sub(s, i, i)
        local b = string.sub(t, i, i)
        if a ~= b then
            break
        end
        i = i + 1
    end
    return i-1
end

sufa.SuffixArray = SuffixArray

return sufa
