-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2024-02-24 12:55:38

local NPC = {}
local 对话 = [[
我行走江湖，有奇闻异事的见闻录，也收集指南录，不知道你有没有？当然，我也不会白拿，我这里有许多宝图。
menu
1|我要兑换
2|我只是路过看看]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
         玩家:兑换藏宝图窗口()
    end
end

return NPC
