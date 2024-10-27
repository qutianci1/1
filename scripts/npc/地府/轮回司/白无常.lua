-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-13 07:44:42
-- @Last Modified time  : 2024-08-23 13:15:18
local NPC = {}
local 对话 = [[你命不该绝，我送你还阳吧。
menu
长安 天宫
五指山 我什么都不想做 
长寿村
傲来国
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='长安' then
        玩家:切换地图(1001, 208, 114)
    elseif i=='长寿村' then
        玩家:切换地图(1070, 51, 19)
    elseif i=='傲来国' then
        玩家:切换地图(1092, 220, 213)
    elseif i=='五指山' then
        玩家:切换地图(1194, 157, 47)
    elseif i=='天宫' then
        玩家:切换地图(1111, 124, 80)
    end
end



return NPC