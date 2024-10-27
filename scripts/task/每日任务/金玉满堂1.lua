-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-03-10 16:38:18
local 任务 = {
    名称 = '金玉满堂1',
    别名 = '11-15级装备打造',
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
    '#Y在作坊打造11級装备生产公式=10级新装备＋千年寨铁十血玲珑12级装备生产公式一11級全新装备＋天外飞石十血玲珑13级装备生产公式一12级全新装备＋盘古精铁+血玲珑14级装备生产公式一13级全新装备十补天神石十血玲珑15级装备生产公式--14级全新装备+六魂之玉+血玲珑炼化公式：装备+内丹精华+血珍珑＋九彩+九彩+九彩开光公式：武器＋九玄仙玉炼器公式：武器+落魂砂 注:武器+落魂砂+神功笔录可保留原属性',

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
