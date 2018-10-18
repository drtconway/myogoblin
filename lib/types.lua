local types = {}

function types.Any(v)
    return true
end

function types.Nil(v)
    return v == nil
end

function types.Str(v)
    return type(v) == "string"
end

function types.Num(v)
    return type(v) == "number"
end

function types.Bool(v)
    return type(v) == "boolean"
end

function types.Fun(v)
    return type(v) == "function"
end

function types.List(t)
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

function types.Map(t, u)
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

function types.Named(b, n)
    return function(v)
        assert(type(b) == "table", "bindings must be a table")
        assert(type(n) == "string", "the type name must be a string")
        assert(type(b[n]) == "function", "the named type '" .. n .. "' does not exist in the bindings")
        return b[n](v)
    end
end

function types.Or(...)
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

function types.Tuple(...)
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

function types.check(f, r, ...)
    local ts = {...}
    return function(...)
        local us = {...}
        assert(#ts >= #us, "function called with too many arguments")
        for i = 1,#ts do
            assert(ts[i](us[i]), "argument " .. i .. " is not well typed.")
        end
        local v = {f(...)}
        -- unwrap singleton returns,
        -- even though defaulty representations are evil.
        if #v == 1 then
            v = v[1]
            assert(r(v), "return value is not well typed.")
            return v
        end
        assert(r(v), "return value is not well typed.")
        return table.unpack(v)
    end
end

return types
