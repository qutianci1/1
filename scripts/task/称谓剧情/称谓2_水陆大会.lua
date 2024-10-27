-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-04-28 17:27:36
local 任务 = {
    名称 = '称谓2_水陆大会',
    别名 = '水陆大会(二称)',
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
	'  前往#Y长安(215,188)#W找#u#G#m({长安,215,188})袁天罡#m#u#W聊聊吧！',
	'  前往#Y化生寺#W找#u#G#m({玄空僧房,27,14})玄奘#m#u#W主持水陆大会',
	'  玄奘不乐意去做水陆大会的主持，要回去找#u#G#m({长安,215,188})袁天罡#m#u#W谈谈！',
}

local _追踪描述 = {
	'  前往#Y长安(215,188)#W找#u#G#m({长安,215,188})袁天罡#m#u#W聊聊吧！',
	'  前往#Y化生寺#W找#u#G#m({玄空僧房,27,14})玄奘#m#u#W主持水陆大会',
	'  玄奘不乐意去做水陆大会的主持，要回去找#u#G#m({长安,215,188})袁天罡#m#u#W谈谈！',
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end

function 任务:任务取详情(玩家)
    return _详情[self.进度+1]
end

local _台词 = {
    '我听说地狱的十王降魔阵已被孙悟空和白骨仙联手夹攻破坏。如果这件事是真的话，那就是三界形成以来的最大的危机。如果我们不能阻止孙悟空和白骨山联手，地狱就要在人间界和天界重现了，如今之计，只有必要开一个宣扬佛法的水陆大会，超度天下亡灵，消解他们的怨毒仇恨之气，而仇恨之气减退，白骨仙的妖力也就会自然减弱。',
    --1
    '不是说世人都诵小乘佛法吗？',
    --2
    '小乘佛法只能度己，不能度人，整个长安，天下间懂得大乘佛法只有一个人除了他以外，没有其他人有资格担当这个水陆大会主持一职!',
    --3
    '那这个人是谁呢？',
    --4
    '天机不可泄露，如果你是有心人，你一定找得到。',
    --5

    '担当水陆大会的主持一职?很遗憾，贫僧并不想去做这件事。不是我不愿意去化解天下亡灵的怨毒之气，而是我根本没有这个能力，真正的大乘佛法在西天，我佛如来有经三藏，谈天，说地，度鬼，只有这三藏真经，才能真正化解天下的仇恨。所以，你还是另诸高明吧。',
    --6
    '原来玄奘法师也是浪得虚名啊!这就告辞。',
    --7
    '袁大师，玄奘法师说没有三藏真经他也不会大乘佛法，你开水陆大会还是另请高明吧。',
    --8
    '哦，传闻毕竟有误，看来开水陆大会的时机未到!可是此去西天有十万八千里路程，而孙悟空又被白骨仙引诱走上魔障之路，取经一事遥连无期，世界的希望到底在哪里呢? ?哎--.. '
    --9
}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '袁天罡' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            self.对话进度 = 0
            NPC.头像 = 玩家.原形
            NPC.台词 = _台词[8]
            NPC.结束 = false
        end
    elseif NPC.名称 == '玄奘' and NPC.台词 then
        if self.进度 == 1 then
            self.对话进度 = 0
            NPC.台词 = _台词[6]
            NPC.结束 = false
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '袁天罡' then
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
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[4]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[5]
                NPC.结束 = nil
                self.进度 = 1
				玩家:刷新追踪面板()
            end
        elseif self.进度 == 2 then
            if self.对话进度 == 0 then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[9]
                NPC.结束 = nil
                self:完成(玩家)
				玩家:刷新追踪面板()
            end
        end
    elseif NPC.名称 == '玄奘' then
        if self.进度 == 1 then
            if self.对话进度 == 0 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[7]
                NPC.结束 = nil
                self.进度 = 2
				玩家:刷新追踪面板()
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(30)
    玩家:提示窗口('#Y因为你辛苦打探，你在这个世界的声望得到提升，获得30点声望。')

    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:二称完成检测(玩家, '水陆')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)

end

local _怪物 = {
    { 名称 = "山贼之灵", 外形 = 2045, 气血 = 11200, 魔法 = 8000, 攻击 = 2300, 速度 = 260,抗性={物理吸收=20} }
}

function 任务:战斗初始化(玩家)
    local r = 生成战斗怪物(_怪物[1])
    self:加入敌方(1, r)
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
