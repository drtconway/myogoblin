local events = {}

function events:PLAYER_ENTERING_WORLD(...)
    local args = {...}
    local what = 'PLAYER_ENTERING_WORLD'
    local when = date('%y%m%d%H%M%S')
    local inst = {IsInInstance()}
    local itm = {when = when, inst = inst, args = args}
    local table.insert(items, itm)
end

function events:PLAYER_LEAVING_WORLD(...)
    local args = {...}
    local what = 'PLAYER_ENTERING_WORLD'
    local when = date('%y%m%d%H%M%S')
    local inst = {IsInInstance()}
    local itm = {when = when, inst = inst, args = args}
    local table.insert(items, itm)
end

local frame = CreateFrame('Frame')
frame:SetScript('OnEvent', function(self, event, ...)
    events[event](self, ...)
end)
for k,v in pairs(events) do
    frame:RegisterEvent(k)
end
