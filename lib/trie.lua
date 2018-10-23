local trie = {}

local Trie = {}
local TrieMT = { __index = Trie }

function Trie:create(radix)
    local t = {}
    setmetatable(t, TrieMT)
    t.root = t:makeNode(1)
    t.radix = radix
    return t
end

function Trie:insert(k, v)
    return self:nodeInsert(self.root, k, v, 1)
end

function Trie:find(k)
    return self:nodeFind(self.root, k, 1)
end

function Trie:rank(k)
    return self:nodeRank(self.root, k, 0, 1)
end

function Trie:select(n)
    return self:nodeSelect(self.root, n)
end

function Trie:check()
    return self:nodeCheckCount(self.root)
end

function Trie:makeNode()
    local node = {}
    node.count = 0
    return node
end

function Trie:nodeInsert(node, k, v, d)
    local r = self.radix(d, k)
    if r == nil then
        if node.here == nil then
            node.here = {}
            node.hereCount = 0
        end
        local deltaCount = 0
        if node.here[k] == nil then
            deltaCount = 1
        end
        node.here[k] = v
        node.hereCount = node.hereCount + deltaCount
        node.hereToc = nil
        node.count = node.count + deltaCount
        return deltaCount
    end
    if node.kids == nil then
        node.kids = {}
    end
    if node.kids[r] == nil then
        node.kids[r] = self:makeNode()
    end
    local deltaCount = self:nodeInsert(node.kids[r], k, v, d+1)
    node.count = node.count + deltaCount
    node.kidToc = nil
    return deltaCount
end

function Trie:ensureToc(node)
    if node.here ~= nil and node.hereToc == nil then
        node.hereToc = {}
        for k,v in pairs(node.here) do
            table.insert(node.hereToc, k)
        end
        table.sort(node.hereToc)
    end
    if node.kids ~= nil and node.kidToc == nil then
        node.kidToc = {}
        for k,v in pairs(node.kids) do
            table.insert(node.kidToc, k)
        end
        table.sort(node.kidToc)
    end
end

function Trie:nodeFind(node, k, d)
    local r = self.radix(d, k)
    if r == nil then
        if node.here == nil then
            return nil
        end
        return node.here[k]
    end
    if node.kids == nil or node.kids[r] == nil then
        return nil
    end
    return self:nodeFind(node.kids[r], k, d+1)
end

function Trie:nodeCheckCount(node)
    local n = 0
    if node.here ~= nil then
        for k,v in pairs(node.here) do
            n = n + 1
        end
        assert(node.hereCount == n)
    end
    if node.kids ~= nil then
        for r0,node0 in pairs(node.kids) do
            self:nodeCheckCount(node0)
            n = n + node0.count
        end
    end
    assert(n == node.count)
end

function Trie:nodeRank(node, k, n, d)
    Trie:ensureToc(node)
    if node.here ~= nil then
        for i = 1,#node.hereToc do
            local k0 = node.hereToc[i]
            if k0 >= k then
                return n
            end
            n = n + 1
        end
    end
    local r = self.radix(d, k)
    for i = 1,#node.kidToc do
        local r0 = node.kidToc[i]
        if r0 > r then
            break
        end
        if r0 == r then
            return self:nodeRank(node.kids[r], k, n, d+1)
        end
        local node0 = node.kids[r0]
        n = n + node0.count
    end
    return n
end

function Trie:nodeSelect(node, n)
    assert(i < node.count)
    Trie:ensureToc(node)
    if node.here ~= nil then
        if n < node.hereCount then
            local k = node.hereToc[n]
            local v = node.here[k]
            return k,v
        end
        n = n - here.Count
    end
    for i = 1,#node.kidToc do
        local r0 = node.kidToc[i]
        local node0 = node.kids[r0]
        if n < node0.count then
            return Trie:nodeSelect(node, n)
        end
        n = n - node0.count
    end
    return nil
end

trie.Trie = Trie

return trie
