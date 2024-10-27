-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-03-10 16:38:18
local 任务 = {
    名称 = '地煞星1',
    别名 = '游戏上线',
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
    '#Y上线后在 游戏盟主盟处领取新手剧情 一直跟新手剧情直到30级 去小鬼 日常升级查看任务界面可接任务#23队伍搭配=男魔+女魔+仙族+仙族睡人#23注意：新手前期：人族180敏 仙族380敏 魔族580敏 抽秒睡#23游戏存在乱敏设置，请提升敏序差距，避免乱敏',

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
