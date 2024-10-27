-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-03-10 16:38:18
local 任务 = {
    名称 = '200环1',
    别名 = '200环-每天',--显示的任务名字
    类型 = '每日活动',
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
    '#Y前往长安248.91守园大将领取！奖励：大量大话币！#28',

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
