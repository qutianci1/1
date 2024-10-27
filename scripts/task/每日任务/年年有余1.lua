-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-03-10 16:38:18
local 任务 = {
    名称 = '年年有余1',
    别名 = '神兵升级',
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
    '#Y神兵升級攻略，2级神兵=1级神兵+干年寒铁 3级神兵=2级神兵+天外飞石 4级神兵=3級補兵+盘古精铣 5級神兵=4级神兵＋补天神石 6级神兵=5级神兵+六魂之玉#23神兵精炼：4级以上神兵+1-3级神兵精炼 失败后 不会消失主神兵#23',

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
