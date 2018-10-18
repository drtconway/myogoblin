require "types"


function test_nil_type()
    local x = nil
    local y = 1
    assert(Nil(x))
    assert(not Nil(y))
end

function test_str_type()
    local x = nil
    local y = 1
    local z = "foo"
    assert(not Str(x))
    assert(not Str(y))
    assert(Str(z))
end

function test_num_type()
    local x = nil
    local y = 1
    local z = "foo"
    assert(not Num(x))
    assert(Num(y))
    assert(not Num(z))
end

function test_bool_type()
    local x = nil
    local y = 1
    local z = "foo"
    local w = true
    assert(not Bool(x))
    assert(not Bool(y))
    assert(not Bool(z))
    assert(Bool(w))
end

function test_fun_type()
    local x = nil
    local y = 1
    local z = "foo"
    local w = function () return true end
    assert(not Fun(x))
    assert(not Fun(y))
    assert(not Fun(z))
    assert(Fun(w))
end

function test_list_type()
    local x = nil
    local y = 1
    local z = { 'foo', 'bar', 'baz' }
    local w = { a = 'foo', b = 'bar', c = 'baz' }
    local v = { 23, 45, 56 }
    assert(not List(Str)(x))
    assert(not List(Str)(y))
    assert(List(Str)(z))
    assert(not List(Str)(w))
    assert(not List(Str)(v))
end

function test_map_type()
    local x = nil
    local y = 1
    local z = { 'foo', 'bar', 'baz' }
    local w = { a = 'foo', b = 'bar', c = 'baz' }
    local v = { a = {'foo'}, b = {}, c = {'baz', 'qux'} }
    assert(not Map(Str,Num)(x))
    assert(not Map(Str,Num)(y))
    assert(Map(Num,Str)(z))
    assert(Map(Str,Str)(w))
    assert(Map(Str,List(Str))(v))
end

function test_named_type()
    local b = {}
    b["P"] = Str
    b["Q"] = List(Str)
    b["R"] = Map(Str,Named(b, "R"))
    local x = "foo"
    assert(Named(b, "P")(x))
    assert(not Named(b, "Q")(x))
    local y = {a = {b = {c = {}}}}
    assert(Named(b, "R")(y))
end

function test_or_type()
    local t = Or(Str, Num)
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
    local t = Tuple(Str, Num, List(Bool))
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

