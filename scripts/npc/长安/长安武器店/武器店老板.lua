-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-29 08:42:29
-- @Last Modified time  : 2022-08-17 05:41:46
local NPC = {}
local 对话 = [[
行家一出手，就知有没有，你想买什么？
menu
1|我想买点东西
2|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/长安兵器.lua')
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
