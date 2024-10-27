-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 16:51:23
-- @Last Modified time  : 2024-08-22 11:08:17

local NPC = {}
local 对话 = [["东临碣石，以观沧海，水何澹澹，山岛竦峙.....想要去哪里呢?"
menu
1|东海渔村 
2|长安桥
99|我什么都不想做
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='1' then
        玩家:切换地图(1208, 179, 19)
    elseif i=='2' then
        玩家:切换地图(1001, 208, 114)
    end
end



return NPC