-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2023-09-08 21:24:11


local NPC = {}
local 对话 = [[您有什么需要么？
menu
1|我要出去
2|我还要再看看
]]

function NPC:NPC对话(玩家,i)
    return 对话
end

function NPC:NPC菜单(玩家,i)
    if i=='1' then
        玩家:切换地图(1003, 123, 51)
    end
end



return NPC