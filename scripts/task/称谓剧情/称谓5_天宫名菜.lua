-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-10-26 20:36:57

local 任务 = {
    名称 = '称谓5_天宫名菜',
    别名 = '天宫名菜(五称)',
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
    '	前往#Y大唐边境#W找#u#G#m({大唐边境,439,129})雷鸟#m#u#W聊聊！',
    '	去#Y天宫#W找#u#G#m({天宫,57,97})仙女#m#u#W要天宫的名菜。#R（对话结束后进入战斗）',
    '	将天宫的名菜交给#u#G#m({大唐边境,439,129})雷鸟#m#u'
}
local _追踪描述 = {
    '	前往#Y大唐边境#W找#u#G#m({大唐边境,439,129})雷鸟#m#u#W聊聊！',
    '	去#Y天宫#W找#u#G#m({天宫,57,97})仙女#m#u#W要天宫的名菜。#R（对话结束后进入战斗）',
    '	将天宫的名菜交给#u#G#m({大唐边境,439,129})雷鸟#m#u'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '大王的婚事在即，如果能有#R“天宫的名菜 ”#W锦上添花的话， 大王一定会非常高兴的!',
    --1
    '天宫的名菜是嫦娥姐姐亲手烹调的菜式，是三界最美味的，怎么可能轻易给你呢?别痴心妄想了，回去吧。',
    --2
    '受人之托，忠人之事，不拿到我是不会走的。',
    --3
    '...什么?你还不走?真是不到黄河心不死...好吧，我就给你一次机会，如果你能打赢嫦娥姐姐的玉兔的话，我就把“天宫的名菜“给你!',
    --4
    '打就打，谁怕谁啊！',
    --5
    '哇，是天宫名菜也!你真的做到了!太厉害了!我真的好崇拜你哦！！请让我称呼你为“无所不能的人”吧！我身上的这个宝贝百炼精铁也请你拿去！',
    --6



}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '雷鸟' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            self.进度 = 1
            玩家:刷新追踪面板()
        elseif self.进度 == 2 then
                local a =  玩家:取物品是否存在("天宫的名菜")
                if a  then
                else
                    NPC.台词 = "我要的东西呢？"
                    return
                end
                local  b =    玩家:取物品是否存在("天宫的名菜")
                if  b then
                        b:减少(1)
                end
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[6]
                self:完成(玩家)
                玩家:刷新追踪面板()
        end
    elseif NPC.名称 == '仙女' and NPC.台词 then
        if self.进度 == 1 then
            self.对话进度 = 0
            NPC.台词 = _台词[2]
            NPC.结束 = false
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '仙女' then
        if self.进度 == 1 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[3]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[4]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[5]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                NPC.结束 = nil
                self:任务攻击事件(玩家, NPC)
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(400)
    玩家:添加银子(8000)
    玩家:添加物品({生成物品 {名称 = '百炼精铁', 数量 = 1}})
    玩家:添加称谓('无所不能')
    玩家:提示窗口('#Y你完成了雷鸟人的托付，你在这个世界的声望得到了提升，获得400点声望,和无所不能称号。')
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:五称完成检测(玩家, '名菜')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    -- if NPC.名称 == '雷鸟' then
        if self.进度 == 2 then
            if items[1] and items[1].名称 == '天宫的名菜' then --
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
					玩家:常规提示('#Y给予了'..NPC.名称..items[1].名称)
                    NPC.头像 = NPC.外形
                    NPC.台词 = _台词[6]
                    self:完成(玩家)
                    玩家:刷新追踪面板()
                end
            end
        end
    -- end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '仙女' then
        if self.进度 == 1 and self.对话进度 == 3 then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓5_天宫名菜.lua', self)
            if r then
                玩家:添加物品({生成物品 {名称 = '天宫的名菜', 数量 = 1}})
                self.进度 = 2
                玩家:刷新追踪面板()
            end
        end
    end
end

local _怪物 = {
    { 名称 = "玉兔", 外形 = 2001, 气血 = 85000, 魔法 = 1, 攻击 = 5200, 速度 = 260 }
}

function 任务:战斗初始化(玩家)
    for i = 1, 1 do
        local r = 生成战斗怪物(_怪物[i])
        self:加入敌方(i, r)
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
