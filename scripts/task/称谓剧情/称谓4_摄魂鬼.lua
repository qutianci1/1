-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-10 23:09:40
-- @Last Modified time  : 2024-10-26 19:12:37
local 任务 = {
    名称 = '称谓4_摄魂鬼',
    别名 = '摄魂鬼(四称)',
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
    '	前往#Y大唐边境#W找#u#G#m({大唐边境,239,243})幸存者#m#u#W聊聊！',
    '	前往#Y大唐边境#W解决#u#G#m({大唐边境,418,20})摄魂鬼#m#u#Y（对摄魂鬼ALT+A进行攻击）',
    '	打败摄魂鬼，回去告诉#u#G#m({大唐边境,239,243})幸存者#m#u#W这个消息！'
}
local _追踪描述 = {
    '	前往#Y大唐边境#W找#u#G#m({大唐边境,239,243})幸存者#m#u#W聊聊！',
    '	前往#Y大唐边境#W解决#u#G#m({大唐边境,418,20})摄魂鬼#m#u#Y（对摄魂鬼ALT+A进行攻击）',
    '	打败摄魂鬼，回去告诉#u#G#m({大唐边境,239,243})幸存者#m#u#W这个消息！'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end


function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '最近村子里来了个凶猛的妖怪，专门吸人的灵魂，村里的人被杀的差不多了，我是少数的幸存者之一，但我也不知道能不能活到明天，因为那个妖怪每天都会来吸食人的灵魂”.哎"..”听天由命吧..”',
    --1
    '如此猖獗的妖怪?简直当我不存在嘛~告诉我他在哪里?我替你们除害去。',
    --2
    '我不知道，我只是知道他叫#R摄魂鬼#W是住在一个#R边境南的山洞里#W饿了就到这一芾游荡，吸人魂魄。',
    --3
    '呵呵呵，你还算有一套。不过，想要彻底打败我是不可能的。因为我就是传说白骨仙的手下，呵呵呵! !自从我的师傅1 3000年前被天上那群卑鄙的伪君子仗着人多势众关起来以后，我就没遇到过像你这样还算有点实力的家伙了....看在你有点本事的份上，我暂时不会再吃人了，不过，等我的师傅白骨仙完全复活的时候我会把所有人的灵魂都吃掉的，呵呵呵!!!',
    --4
    '变态的家伙-- ..',
    --5
    '你暂时制服了攫魂鬼. .救命之恩，无以回报.....我这有个宝贝你拿去看看有没有用吧。'
    --6
}

function 任务:任务NPC对话(玩家, NPC)
    NPC.头像 = NPC.外形
    if NPC.名称 == '幸存者' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            self.对话进度 = 0
            NPC.台词 = _台词[6]
            self:完成(玩家)
             玩家:刷新追踪面板()
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '幸存者' then
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
                 玩家:刷新追踪面板()
            end
        end
    elseif NPC.名称 == '摄魂鬼' then
        if self.进度 == 2 then
            if self.对话进度 == 1 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[5]
                NPC.结束 = nil
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(150)
    玩家:添加物品({生成物品 {名称 = '龙之鳞', 数量 = 1}})
    玩家:提示窗口('#Y因为你的为民除害，你在这个世界的声望得到获得150点声望和龙之鳞。')

    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:四称完成检测(玩家, '摄魂鬼')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '摄魂鬼' then
        if self.进度 == 1 then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓4_摄魂鬼.lua', self)
            if r then
                self.进度 = 2
                玩家:添加银子(36542)
                玩家:添加经验(254214)
                玩家:常规提示('#Y你打败了摄魂鬼，获得了254214经验和36542银两。')
                 玩家:刷新追踪面板()
                self.对话进度 = 1
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[4]
                NPC.结束 = false
            end
        end
    end
end

local _怪物 = {
    { 名称 = "摄魂鬼", 外形 = 2074, 气血 = 42000, 魔法 = 8000, 攻击 = 3300, 速度 = 180,抗性={物理吸收=20} },
    { 名称 = "冤魂", 外形 = 2049, 气血 = 6000, 魔法 = 8000, 攻击 = 900, 速度 = 80,抗性={物理吸收=10} },
    { 名称 = "士兵", 外形 = 2048, 气血 = 8000, 魔法 = 8000, 攻击 = 900, 速度 = 80,抗性={物理吸收=10} }
    
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
