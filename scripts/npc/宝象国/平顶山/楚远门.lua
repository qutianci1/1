-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2022-06-16 19:42:15
local NPC = {}
local 对话 = [[我们一家四兄弟可都是这附近名声在外的车夫，赶车又快又稳!这位爷，出远门么?
menu
平顶山胡杨林
万寿山
我什么都不想做 
]]
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='万寿山' then
        玩家:切换地图(101299, 9, 99)
    elseif i=='平顶山胡杨林' then
        玩家:切换地图(1537, 20, 99)
    end
end



return NPC