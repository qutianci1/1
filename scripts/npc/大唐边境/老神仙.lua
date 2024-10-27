-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2023-04-08 21:32:21
local NPC = {}
local 对话 = [[长寿村是一个修仙的好去处，你要是想像我这样长寿的话，就多去那呆着，要我带你过去吗?
menu
长寿村外
大雁塔
我什么都不想做
]]
--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='长寿村外' then
        玩家:切换地图(1091, 39, 92)
    elseif  i=='大雁塔'  then
        玩家:切换地图(1001, 55, 209)
    end
    
end



return NPC