local A = require "aesop"
local T = require "trie"
local Y = require "types"

local strRadix = function(D)
    return function(d, k)
        if d > D then
            return nil
        end
        if k == nil or d > #k then
            return ''
        end
        return string.sub(k, d, d)
    end
end

local wordRadix = function(D)
    local key = nil
    local words = {}
    return function(d, k)
        if d > D then
            return nil
        end
        if k == nil then
            return ''
        end
        if key ~= k then
            key = nil
            words = {}
        end
        if key == nil then
            key = k
            for w in key:gmatch("[^%s]+") do
                table.insert(words, w)
            end
            j = 1
        end
        if d > #words then
            return ''
        end
        return words[d]
    end
end

function test_radix()
    local s = A[1]
    local radix = strRadix(8)
    assert(radix(1, s) == 'A')
    assert(radix(3, s) == 's')
    assert(radix(5, s) == 'p')
    assert(radix(7, s) == 'a')
    assert(radix(8, s) == 'n')
    assert(radix(9, s) == nil)
end

function test_radix_1()
    local s1 = "The Bear and the Travelers"
    local s2 = "The Beaver"
    local radix = strRadix(8)
    assert(radix(7, s1) == 'a')
    assert(radix(7, s2) == 'a')
    assert(radix(8, s1) == 'r')
    assert(radix(8, s2) == 'v')
end

function test_trie_1()
    local s = A[1]
    local radix = strRadix(8)
    local t = T.Trie:create(radix)
    t:insert(s, 42)
    assert(t:find(s) == 42)
end

function test_trie_2()
    local radix = strRadix(8)
    local t = T.Trie:create(radix)
    local n = #A
    for i = 1,n do
        t:insert(A[i], i)
    end
    for i = 1,n do
        assert(t:find(A[i]) == i)
    end
end

function test_trie_rank_1()
    local radix = strRadix(8)
    local t = T.Trie:create(radix)
    local n = #A
    for i = 1,n do
        t:insert(A[i], i)
        t:check()
    end
    for i = 1,n do
        local r = t:rank(A[i])
        assert(r == i - 1)
    end
end

function test_word_radix_1()
    local s = "The Bear and the Travelers"
    local radix = wordRadix(4)
    assert(radix(1, s) == 'The')
    assert(radix(2, s) == 'Bear')
    assert(radix(3, s) == 'and')
    assert(radix(4, s) == 'the')
    assert(radix(5, s) == nil)
end

function test_word_radix_2()
    local s = "The Bear and the Travelers"
    local radix = wordRadix(8)
    assert(radix(1, s) == 'The')
    assert(radix(2, s) == 'Bear')
    assert(radix(3, s) == 'and')
    assert(radix(4, s) == 'the')
    assert(radix(5, s) == 'Travelers')
    assert(radix(6, s) == '')
    assert(radix(7, s) == '')
    assert(radix(8, s) == '')
    assert(radix(9, s) == nil)
end

function test_trie_rank_2()
    local radix = wordRadix(4)
    local t = T.Trie:create(radix)
    local n = #A
    for i = 1,n do
        t:insert(A[i], i)
        t:check()
    end
    for i = 1,n do
        local r = t:rank(A[i])
        assert(r == i - 1)
    end
end

test_radix()
test_radix_1()
test_trie_1()
test_trie_2()
test_trie_rank_1()
test_word_radix_1()
test_word_radix_2()
test_trie_rank_2()
