-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-08-19 09:24:24

local NPC = {}

local 对话 = [[
老神仙说了，呆在长寿村能像他一样长寿，什么？不信你去问他，我送你过去吧。#R(50级以下玩家不收取费用，1转100以下收取师贡。)
menu
1|大唐边境南
2|我哪儿也不去
]]

function NPC:NPC对话(玩家,i)
    return 对话
end
                    
function NPC:NPC菜单(玩家,i)
    if i == '1' then
        玩家:切换地图(1173, 25, 13)
    end
end
                    
function NPC:NPC给予(玩家,cash,items)
    return '你给我什么东西？'
end
return NPC
                