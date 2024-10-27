-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-10 04:16:13
-- @Last Modified time  : 2024-08-20 21:25:29
local NPC = {}
local 对话 = [[
你要去大唐边境吗?我送你一程吧,我的船可是独一无二的哦。
menu
大唐边境
我哪也不去
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='大唐边境' then
        玩家:切换地图(1173, 79, 144)
    end
end

return NPC