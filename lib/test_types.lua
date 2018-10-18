local T = require "types"


function test_nil_type()
    local x = nil
    local y = 1
    assert(T.Nil(x))
    assert(not T.Nil(y))
end

function test_str_type()
    local x = nil
    local y = 1
    local z = "foo"
    assert(not T.Str(x))
    assert(not T.Str(y))
    assert(T.Str(z))
end

function test_num_type()
    local x = nil
    local y = 1
    local z = "foo"
    assert(not T.Num(x))
    assert(T.Num(y))
    assert(not T.Num(z))
end

function test_bool_type()
    local x = nil
    local y = 1
    local z = "foo"
    local w = true
    assert(not T.Bool(x))
    assert(not T.Bool(y))
    assert(not T.Bool(z))
    assert(T.Bool(w))
end

function test_fun_type()
    local x = nil
    local y = 1
    local z = "foo"
    local w = function () return true end
    assert(not T.Fun(x))
    assert(not T.Fun(y))
    assert(not T.Fun(z))
    assert(T.Fun(w))
end

function test_list_type()
    local x = nil
    local y = 1
    local z = { 'foo', 'bar', 'baz' }
    local w = { a = 'foo', b = 'bar', c = 'baz' }
    local v = { 23, 45, 56 }
    assert(not T.List(T.Str)(x))
    assert(not T.List(T.Str)(y))
    assert(T.List(T.Str)(z))
    assert(not T.List(T.Str)(w))
    assert(not T.List(T.Str)(v))
end

function test_map_type()
    local x = nil
    local y = 1
    local z = { 'foo', 'bar', 'baz' }
    local w = { a = 'foo', b = 'bar', c = 'baz' }
    local v = { a = {'foo'}, b = {}, c = {'baz', 'qux'} }
    assert(not T.Map(T.Str,T.Num)(x))
    assert(not T.Map(T.Str,T.Num)(y))
    assert(T.Map(T.Num,T.Str)(z))
    assert(T.Map(T.Str,T.Str)(w))
    assert(T.Map(T.Str,T.List(T.Str))(v))
end

function test_named_type()
    local b = {}
    b["P"] = T.Str
    b["Q"] = T.List(T.Str)
    b["R"] = T.Map(T.Str,T.Named(b, "R"))
    local x = "foo"
    assert(T.Named(b, "P")(x))
    assert(not T.Named(b, "Q")(x))
    local y = {a = {b = {c = {}}}}
    assert(T.Named(b, "R")(y))
end

function test_or_type()
    local t = T.Or(T.Str, T.Num)
    local x = nil
    local y = 1
    local z = 'foo'
    local w = {'foo'}
    assert(not t(x))
    assert(t(y))
    assert(t(z))
    assert(not t(w))
end

function test_tuple_type()
    local t = T.Tuple(T.Str, T.Num, T.List(T.Bool))
    local x = nil
    local y = 1
    local z = {'foo', 1, {true, true, false}}
    local w = {'foo', 1, {true, true, false}, 'bar', 'baz'}
    assert(not t(x))
    assert(not t(y))
    assert(t(z))
    assert(not t(w))
end

test_nil_type()
test_str_type()
test_num_type()
test_bool_type()
test_fun_type()
test_list_type()
test_map_type()
test_named_type()
test_or_type()
test_tuple_type()

