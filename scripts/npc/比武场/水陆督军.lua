-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2023-09-08 21:26:12


local NPC = {}
local 对话 = [[阁下有何贵干？
menu
准备好了
我再想想
]]

local 对话1 = [[阁下有何贵干？
menu
我要出去
]]


function NPC:NPC对话(玩家)
    if 玩家:检查水陆开关() then
        return 对话
    else
        return 对话1
    end
end

function NPC:NPC菜单(玩家,i)
    if i == '我要出去' then
        玩家:切换地图(1003, 123, 51)
    elseif i == '准备好了' then
        return 玩家:水陆大会准备()
    end
end



return NPC