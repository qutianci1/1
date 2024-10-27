-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-04-10 01:06:26
local 任务 = {
    名称 = '称谓1_失踪的小孩',
    别名 = '失踪的小孩(一称)',
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
    '	前往#Y皇宫#W找#u#G#m({皇宫,116,45})魏征#m#u#W聊聊！',
    '	前往#Y长安#W找#u#G#m({长安,351,152})高统领#m#u#W谈谈！',
    '	已经了解了事情真相,前往#皇宫#W找#u#G#m({皇宫,116,45})魏征#m#u#W复命！'
}

local _追踪描述 = {
    '	前往#Y皇宫#W找#u#G#m({皇宫,116,45})魏征#m#u#W聊聊！',
    '	前往#Y长安#W找#u#G#m({长安,351,152})高统领#m#u#W谈谈！',
    '	已经了解了事情真相,前往#皇宫#W找#u#G#m({皇宫,116,45})魏征#m#u#W复命！'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '最近#R长安城#W里走失了不少孩子，你去查访，看看是什么原因。',
    --1
    '魏丞相事情多，这样的小事情我帮忙帮忙也无所谓。',
    --2
    '那劳驾了，长安城里的#G高统领#W见多识广，你可以先找他谈谈。',
    --3
    '小孩消失？我估计一定是妖魔作祟。',
    --4
    '什么妖魔？长安还有妖魔？',
    --5
    '是的，最近妖魔侵袭，听说城外有个叫做#R食婴鬼#w的大魔头，专门吃小孩，定是他干的!',
    --6
    '原来是这样~~我去告诉魏丞相去。',
    --7
    '嗯嗯，要提醒大家都小心啊，外出要结伴而行#110',
    --8
    '谢谢你帮这个忙，看来长安城的安全确实越来越成问题了。这个你拿去吧。听说可以用来打造一些有用的兵器之类的东西，以后消灭邪恶也许还要你帮助呢。',
    --9
    '哇~~丞相出手就是不一样!谢谢啦~'
    --10
}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '魏征' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = '#G'..玩家.名称..'#W，刚好有事找你，最近#R长安城#W里走失了不少孩子，你去查访，看看是什么原因。'
            NPC.结束 = false
        elseif self.进度==2 then
            self.对话进度 = 0
            NPC.台词 = _台词[9]
            NPC.结束 = false
        end
    elseif NPC.名称 == '高统领' and NPC.台词 then
        if self.进度 == 1 then
            self.对话进度 = 0
            NPC.台词 = _台词[4]
            NPC.结束 = false
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '魏征' then
        if self.进度 == 0 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[2]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[3]
                NPC.结束 = nil
                self.进度 = 1
            end
        elseif self.进度==2 then
            if  self.对话进度 == 0 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[10]
                NPC.结束 = nil
                self:完成(玩家)
            end
        end
    elseif NPC.名称 == '高统领' then
        if self.进度 == 1 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[5]
                NPC.结束 = false
            elseif self.对话进度 == 1  then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[6]
                NPC.结束 = false
            elseif self.对话进度 == 2  then
                self.对话进度 = 3 
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[7]
                NPC.结束 = false
            elseif self.对话进度 == 3  then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[8]
                NPC.结束 = nil
                self.进度=2

            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(10)
    玩家:提示窗口('#Y由于你的英勇你在这个世界的名望得到了提升，获得10点声望值。')
    玩家:添加物品({生成物品 {名称 = '千年寒铁', 数量 = 1}})
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:一称完成检测(玩家, '小孩')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if self.进度 == 1 then
        if NPC.名称 == '食婴鬼的手下' then
            local r = true
            --玩家:进入战斗('scripts/task/称谓1_教训飞贼.lua')
            if r then
                self.进度 = 2
                玩家:常规提示('#R你成功的击杀了食婴鬼的手下')
            end
        end
    end
end

function 任务:战斗初始化(玩家)
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
