-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-03-10 16:38:18
local 任务 = {
    名称 = '花灯报吉2',
    别名 = '1-10级装备打造',
    类型 = '攻略',
    是否可取消 = false
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务更新(玩家, sec)
end

local _详情 = {
    '#Y在长安桥找冯铁匠打造 2级装备：使用 1級装备十乌金 3級装备：使用1～2級装备十金刚石 4极装备，使用1～级装备十寒铁 6級装备，使用1～4级装备十百炼精铁 6級装备：使用1～5級装备十龙之鳞 7級装备：使用1～6級装备＋千年寒铁 8級装备，使用1～7个級装备十天外飞石 9级装备：使用1～8名级装备十盘古精铁 10級装备：使用1~9級装备十补天神石',

}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end



function 任务:任务NPC对话(玩家, NPC)

end

function 任务:任务NPC菜单(玩家, NPC, i)

end

function 任务:完成(玩家)

end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)

end



function 任务:战斗初始化(玩家)

end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
