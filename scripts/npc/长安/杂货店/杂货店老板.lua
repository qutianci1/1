-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-29 08:42:29
-- @Last Modified time  : 2022-09-02 10:12:30
local NPC = {}
local 对话 = [[
我们是小本生意，如果还抽那么高的税，可就活不下去了。
menu
1|我想买点东西
2|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/长安杂货店.lua')
    end
end

return NPC
