Any = function(v)
    return true
end

Nil = function(v)
    return v == nil
end

Str = function(v)
    return type(v) == "string"
end

Num = function(v)
    return type(v) == "number"
end

Bool = function(v)
    return type(v) == "boolean"
end

Fun = function(v)
    return type(v) == "function"
end

List = function(t)
    assert(type(t) == "function")
    return function(v)
        -- check it's a table
        if type(v) ~= "table" then
            return false
        end
        -- check the consecutive numeric keys from 1; and
        -- check that the corresponding values have the expected type.
        local n = 1
        while v[n] ~= nil do
            if not t(v[n]) then
                return false
            end
            n = n + 1
        end
        -- check that there are no keys that we didn't already check
        for j,w in pairs(v) do
            if type(j) ~= 'number' or j < 1 or j >= n then
                return false
            end
        end
        -- if we got here, then we're all good.
        return true
    end
end

Map = function(t, u)
    assert(type(t) == "function")
    assert(type(u) == "function")
    return function(v)
        -- check it's a table
        if type(v) ~= "table" then
            return false
        end
        for j,w in pairs(v) do
            -- check all the keys and values have the expected types
            if not t(j) or not u(w) then
                return false
            end
        end
        return true
    end
end

Named = function(b, n)
    return function(v)
        assert(type(b) == "table", "bindings must be a table")
        assert(type(n) == "string", "the type name must be a string")
        assert(type(b[n]) == "function", "the named type '" .. n .. "' does not exist in the bindings")
        return b[n](v)
    end
end

Or = function(...)
    local ts = {...}
    local n = #ts
    return function(v)
        for i = 1,n do
            if ts[i](v) then
                return true
            end
        end
        return false
    end
end

Tuple = function(...)
    local ts = {...}
    local n = #ts
    return function(v)
        -- check it's a table
        if type(v) ~= "table" then
            return false
        end
        -- check the sequence of values
        for i = 1,n do
            if not ts[i](v[i]) then
                return false
            end
        end
        -- check for any other keys
        for j,w in pairs(v) do
            if ts[j] == nil then
                return false
            end
        end
        return true
    end
end

