-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-14 19:39:24
-- @Last Modified time  : 2023-05-13 11:51:20

local NPC = {}
local 对话 = {
[[我是专门为本帮成员驯养召唤兽的召唤兽驯养师，召唤兽经过我的驯养以后会增加和主人之间的亲密度哦，有什么能帮到你的吗?
menu
我要驯养召唤兽
什么都不想做]],
[[我是专门为本帮成员驯养召唤兽的召唤兽驯养师，召唤兽经过我的驯养以后会增加和主人之间的亲密度哦，有什么能帮到你的吗?
menu
我想停止驯养
什么都不想做]],
}
--其它对话
function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('驯养召唤兽')
    if r then
        return 对话[2]
    end
    return 对话[1]
end

function NPC:NPC菜单(玩家, i)
    if i == '我要驯养召唤兽' then
        玩家:召唤兽驯养()
    elseif i == '我想停止驯养' then
        local r = 玩家:取任务('驯养召唤兽')
        if r then
            r:删除()
        end
    end
end

return NPC
