-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-04-17 01:29:29

local NPC = {}
local 对话 = [[
我画的图卡，在长安一带也算小有名气。
menu
1|购买属性卡和变身卡
2|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:出售变身卡窗口()
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
