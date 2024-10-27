-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-04-10 01:04:30
local 任务 = {
    名称 = '称谓1_教训食婴鬼手下',
    别名 = '教训食婴鬼手下(一称)',
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
	'	前往#Y程府厢房(15,18)#W找#u#G#m({长安,307,224})程夫人#m#u#W聊聊！',
	'	前往#Y长安城东(172,221)#W找到#u#G#m({长安城东,172,221})食婴鬼的手下#m#u#W并杀了他。#Y（ALT+A食婴鬼的手下）',
	'   前往#Y程府厢房(15,18)#W找#u#G#m({长安,307,224})程夫人#m#u#W你打败坏蛋的消息'
}


local _追踪描述 = {
	'	前往#Y程府厢房(15,18)#W找#u#G#m({长安,307,224})程夫人#m#u#W聊聊！',
	'	前往#Y长安城东(172,221)#W找到#u#G#m({长安城东,172,221})食婴鬼的手下#m#u#W并杀了他。#Y（ALT+A食婴鬼的手下）',
	'	前往#Y程府厢房(15,18)#W找#u#G#m({长安,307,224})程夫人#m#u#W你打败坏蛋的消息'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end

function 任务:任务取详情(玩家)
    return _详情[self.进度+1]
end

local _台词 = {
    '我的小宝昨晚上被#R食婴鬼的手下#W抢走了! 听说食婴鬼会吃掉他，你能救救我的孩子吗?我唯一的孩子啊!如果他死了，我也不要活了!',
    --1
    '可怜的母亲！你放心我一定会帮你伸张正义的！',
    --2
    '那我就拜托你了，昨晚有人在长安城东看见了食婴鬼的手下！',
    --3
    '好，我这就去杀了他们。',
    --4
    '谢谢你，你的大恩大德，奴冢永世不忘!这点奴家的心意就请收下吧。'
    --5
}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '程夫人' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            self.对话进度 = 0
            NPC.台词 = _台词[5]
            self:完成(玩家)
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '程夫人' then
        if self.进度 == 0 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[2]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[3]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[4]
                NPC.结束 = nil
                self.进度 = 1
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加银子(5000)
    玩家:添加声望(25)
    玩家:提示窗口('#Y由于你的英勇你在这个世界的名望得到了提升，获得25点声望值和5000两银子。')
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:一称完成检测(玩家, '手下')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if self.进度 == 1 then
        if NPC.名称 == '食婴鬼的手下' then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓1_教训食婴鬼手下.lua', self)
            if r then
                self.进度 = 2
                玩家:常规提示('#R你成功的击杀了食婴鬼的手下')
            end
        end
    end
end

local _怪物 = {
    { 名称 = "食婴鬼的手下", 外形 = 2017, 气血 = 1080, 魔法 = 1, 攻击 = 59, 速度 = 1 },
    { 名称 = "家丁", 外形 = 2047, 气血 = 650, 魔法 = 1, 攻击 = 59, 速度 = 1 },
    { 名称 = "家丁", 外形 = 2047, 气血 = 650, 魔法 = 1, 攻击 = 59, 速度 = 1 }
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
