-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:21
-- @Last Modified time  : 2023-06-30 02:02:41
local NPC = {}
local 对话 = [[
加油哦#24我看好你们哦
menu
1|我想离开这个鬼地方
2|取消
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local 新对话 = '你确定离开吗？\nmenu\n确定\n取消'
        return 新对话
    elseif i == '确定' then
        玩家:切换地图(1001, 227, 210)
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
