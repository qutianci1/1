-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-03-10 16:38:18
local 任务 = {
    名称 = '花灯报吉1',
    别名 = '花灯报吉-周三',
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
    '#Y周三开启#23#G王母娘娘让代表着祥和与安康的灯灵下凡人间为人们送去祝福，不料有些灯灵却被妖怪感化与妖怪一起祸害人间，各位侠士可组队前往#W东海渔村、长安城东 大唐境内、大唐边境、北俱芦洲、傲来国、蟠桃园后、万寿山#G犒劳各位，只要成功通过一个考验就能成功得到丰厚奖励哦#97',

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
