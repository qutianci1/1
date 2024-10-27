-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-11 00:43:33
-- @Last Modified time  : 2024-10-26 20:32:09
local 任务 = {
    名称 = '称谓5_找到紫霞',
    别名 = '找到紫霞(五称)',
    类型 = '称谓剧情',
    是否可取消 = false,
	是否可追踪 = true
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务更新(玩家, sec)
end

local _详情 = {
    '	前往#Y傲来国#W找#u#G#m({傲来国,307,39})紫霞#m#u#W谈谈孙悟空。',
    '	到#Y地狱迷宫#W杀死，#u#G#m({地狱迷宫二层,20,20})绝地魔#m#u#W把紫青宝剑抢回来! （ ALT+A攻击绝地魔）',
    '	将紫青宝剑交给#u#G#m({傲来国,307,39})紫霞#m#u'
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _追踪描述 = {
    '	前往#Y傲来国#W找#u#G#m({傲来国,307,39})紫霞#m#u#W谈谈孙悟空。',
    '	到#Y地狱迷宫#W杀死，#u#G#m({地狱迷宫二层,20,20})绝地魔#m#u#W把紫青宝剑抢回来! （ ALT+A攻击绝地魔）',
    '	将紫青宝剑交给#u#G#m({傲来国,307,39})紫霞#m#u'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end

local _台词 = {
    '你就是紫霞？',
    --1
    '紫青宝剑！.......谢谢你，小木猴回来了，可是那小石猴不知什么时候才会回来。'
    --2
}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '紫霞' and NPC.台词 then
        if self.进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[1]
                NPC.结束 = false
        elseif self.进度 == 2 then
                local a =  玩家:取物品是否存在("紫青宝剑")
                if a  then
                else
                    NPC.台词 = "我要的东西呢？"
                    return
                end
                local  b =    玩家:取物品是否存在("紫青宝剑")
                if  b then
                        b:减少(1)
                end
            NPC.头像 = NPC.外形
             NPC.台词 = _台词[2]
            self:完成(玩家)
            玩家:刷新追踪面板()
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if self.进度 == 0 then
            if self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = '你是何人?'
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 ='(我是猴子派来的救兵#25)，我想和你谈谈孙悟空'
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self.对话进度 = 4
                NPC.头像 = NPC.外形
                NPC.台词 = '绝地魔把我的紫青宝剑抢走了，我怕他用我的剑骗孙悟空，你帮我拿回来'
                NPC.结束 = false
            elseif self.对话进度 == 4 then
                NPC.头像 = 玩家.原形
                NPC.台词 = '小事一桩，义不容辞#89'
                NPC.结束 = nil
                self.进度 = 1
                玩家:刷新追踪面板()
            end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(800)
    玩家:添加银子(16000)
    玩家:提示窗口('#Y你完成了紫霞仙子的托付，你在这个世界的声望得到了提升，获得800点声望。')
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:五称完成检测(玩家, '紫霞')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    -- if NPC.名称 == '紫霞' then
        if self.进度 == 2 then
            if items[1] and items[1].名称 == '紫青宝剑' then --
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    NPC.头像 = NPC.外形
                    玩家:常规提示('#Y给予了'..NPC.名称..items[1].名称)
					玩家:常规提示('紫青宝剑谢谢你，小木猴回来了，可是那小石猴不知什么时候才会回来。')
                    self:完成(玩家)
                    玩家:刷新追踪面板()
                end
            end
        end
    -- end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '绝地魔' then
        if self.进度 == 1 then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓5_找到紫霞.lua', self)
            if r then
                玩家:添加物品({生成物品 {名称 = '紫青宝剑', 数量 = 1}})
                self.进度 = 2
                玩家:刷新追踪面板()
            end
        end
    end
end

local _怪物 = {
    { 名称 = "绝地魔", 外形 = 2072, 气血 = 67200, 魔法 = 1, 攻击 = 1200, 速度 = 321 },
    { 名称 = "无头鬼", 外形 = 2056, 气血 = 7500, 魔法 = 1, 攻击 = 65, 速度 = 100 },
    { 名称 = "无身鬼", 外形 = 2057, 气血 = 7500, 魔法 = 1, 攻击 = 65, 速度 = 100 }
}

function 任务:战斗初始化(玩家)
    for i = 1, 3 do
        local r = 生成战斗怪物(_怪物[i])
        self:加入敌方(i, r)
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
