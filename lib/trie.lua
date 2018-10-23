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
    return self:nodeInsert(self.root, k, v)
end

function Trie:find(k)
    return self:nodeFind(self.root, k)
end

function Trie:rank(k)
    return self:nodeRank(self.root, k, 0)
end

function Trie:select(n)
    return self:nodeSelect(self.root, n)
end

function Trie:check()
    return self:nodeCheckCount(self.root)
end

function Trie:makeNode(depth)
    local node = {}
    node.depth = depth
    node.count = 0
    node.toc = nil
    node.kids = {}
    return node
end

function Trie:nodeInsert(node, k, v)
    local r = self.radix(node.depth, k)
    if r == nil then
        local deltaCount = 0
        if node.kids[k] == nil then
            deltaCount = 1
        end
        node.kids[k] = v
        node.count = node.count + deltaCount
        return deltaCount
    end
    if node.kids[r] == nil then
        node.kids[r] = self:makeNode(node.depth + 1)
    end
    local deltaCount = self:nodeInsert(node.kids[r], k, v)
    node.count = node.count + deltaCount
    node.toc = nil
    return deltaCount
end

function Trie:ensureToc(node)
    if node.toc ~= nil then
        return
    end
    node.toc = {}
    for k,v in pairs(node.kids) do
        table.insert(node.toc, k)
    end
    table.sort(node.toc)
end

function Trie:nodeFind(node, k)
    local r = self.radix(node.depth, k)
    if r == nil then
        return node.kids[k]
    end
    if node.kids[r] == nil then
        return nil
    end
    return self:nodeFind(node.kids[r], k)
end

function Trie:nodeCheckCount(node)
    local r = self.radix(node.depth)
    if r == nil then
        local n = 0
        for k,v in pairs(node.kids) do
            n = n + 1
        end
        assert(node.count == n)
        return
    end
    local n = 0
    for r0,node0 in pairs(node.kids) do
        self:nodeCheckCount(node0)
        n = n + node0.count
    end
    assert(n == node.count)
end

function Trie:nodeRank(node, k, n)
    local r = self.radix(node.depth, k)
    Trie:ensureToc(node)
    if r == nil then
        for i = 1,#node.toc do
            local k0 = node.toc[i]
            if k0 >= k then
                return n
            end
            n = n + 1
        end
        return n
    end
    for i = 1,#node.toc do
        local r0 = node.toc[i]
        if r0 > r then
            break
        end
        if r0 == r then
            return self:nodeRank(node.kids[r], k, n)
        end
        local node0 = node.kids[r0]
        n = n + node0.count
    end
    return n
end

function Trie:nodeSelect(node, n)
    assert(i < node.count)
    Trie:ensureToc(node)
    local r = self.radix(node.depth)
    if r == nil then
        local k = node.toc[n]
        local v = node.kids[k]
        return k,v
    end
    for i = 1,#node.toc do
        local r0 = node.toc[i]
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
