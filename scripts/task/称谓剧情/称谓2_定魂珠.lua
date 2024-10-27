-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-04-10 02:31:41
local 任务 = {
    名称 = '称谓2_定魂珠',
    别名 = '定魂珠(二称)',
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
    '	前往#Y皇宫#W找#u#G#m({皇宫,113,42})魏征#m#u#W聊聊吧！',
    '	要获得定魂珠必须去地府阎王殿找#u#G#m({阎王殿,39,27})初江王#m#u#W单挑。#Y(ALT+A攻击初江王)',
    '	拿到定魂珠了，汇报#u#G#m({皇宫,113,42})魏征#m#u#W救皇帝去。#Y(直接对话魏征即可完成任务)'
}

local _追踪描述 = {
    '	前往#Y皇宫#W找#u#G#m({皇宫,113,42})魏征#m#u#W聊聊吧！',
    '	要获得定魂珠必须去地府阎王殿找#u#G#m({阎王殿,39,27})初江王#m#u#W单挑。#Y(ALT+A攻击初江王)',
    '	拿到定魂珠了，汇报#u#G#m({皇宫,113,42})魏征#m#u#W救皇帝去。#Y(直接对话魏征即可完成任务)'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '我不知道该不该告诉你这个糟糕的消息，但是事情确实已经发生了。前几天，我的灵魂作为监斩官被召上天宫，砍了违犯天条的泾河龙王的头。但那恶龙怀恨在心，屡屡来皇宫骚扰。太宗皇帝受了惊吓，三魂四魄离开元身四处飘散，情况十分危险。现在唯一的办法，恐怕只有地府#G初江王#W所拥有的#R定魂珠#W才能为太宗皇帝镇住魂魄，如果迟了话，太宗皇帝恐怕就此不治了!',
    --1
    '去地府找初江王要就行了？',
    --2
    '不， 初江王的宝物只有打败他的人才能获得的。',
    --3
    '哈，小case,我这就去打败他。',
    --4
    '你总是那么可靠，下次有麻烦的时候我还会在拜托你的。最近有人送了我一双神行靴作为报答就送你吧。'
    --5
}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '魏征' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            NPC.台词 = _台词[5]
            self:完成(玩家)
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
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[3]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[4]
                NPC.结束 = nil
                self.进度 = 1
				玩家:刷新追踪面板()
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(60)
    玩家:添加物品({生成装备 {名称 = '神行靴'}})
    玩家:提示窗口('#Y因为你打败鬼界之王，你在这个世界的声望得到了提升，获得60点声望，获得神行靴。')

    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:二称完成检测(玩家, '定魂珠')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if self.进度 == 1 then
        if NPC.名称 == '初江王' then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓2_定魂珠.lua', self)
            if r then
                self.进度 = 2
                -- 玩家:添加物品 { 生成物品 { 名称 = '定魂珠', 数量 = 1 }}
                玩家:添加银子(1206)
                玩家:添加经验(1920)
                玩家:常规提示('#Y你得到1920点经验和1206两银子和定魂珠。')
				玩家:刷新追踪面板()
            end
        end
    end
	玩家:刷新追踪面板()
end

local _怪物 = {
    { 名称 = "初江王", 外形 = 2275, 气血 = 2700, 魔法 = 1, 攻击 = 150, 速度 = 1 }
}

function 任务:战斗初始化(玩家)
    for i = 1, 1 do
        local r = 生成战斗怪物(_怪物[i])
        self:加入敌方(i, r)
    end
	玩家:刷新追踪面板()
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
