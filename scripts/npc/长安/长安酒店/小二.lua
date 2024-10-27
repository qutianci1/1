-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:58
-- @Last Modified time  : 2023-09-12 09:14:33

local NPC = {}
local 对话 = [[
别看我只是个小二,长安消息可就数我最灵通了，最近在这里住店的过往商人经常提起有强盗的事情,想不想听听?不过你要给我好处费哦,500两一条消息。
menu
1|听听无妨⋯⋯
2|还是别多管闲事了⋯⋯
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then

    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
