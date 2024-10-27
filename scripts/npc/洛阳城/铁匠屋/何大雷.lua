-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:58
-- @Last Modified time  : 2024-03-11 16:14:21

local NPC = {}
local 对话 = [[
我是专门为别人升级神兵的，我也可以帮你补充神兵灵气，你需要我帮忙吗？
menu
1|升级神兵
2|精炼神兵
3|我要炼化神兵
4|打造神兵石
5|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:神兵升级窗口()
    elseif i == '2' then
        玩家:神兵强化窗口()
    elseif i == '3' then
        玩家:神兵精炼窗口()
    elseif i == '4' then
        玩家:神兵炼化窗口()
    end
end

return NPC
