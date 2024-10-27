-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-10-26 20:38:09


local 任务 = {
    名称 = '称谓6_孽缘',
    别名 = '孽缘(六称)',
    类型 = '称谓剧情',
    是否可取消 = false,
	是否可追踪 = true
}

function 任务:任务初始化(玩家, ...)
    self.徒弟 = {道士 = 0, 术士 = 0, 百万 = 0}
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务更新(玩家, sec)
end

local _详情 = {
	'  前往#Y方寸大殿#W找#u#G#m({方寸大殿,22,8})菩提祖师#m#u#W谈谈！',
	'	问问方寸山上的闲人，让他们加入菩提门下 。闲人分别是:（#u#G#m({方寸后山,50,21})陈百万#m#u、#u#G#m({方寸山,31,23})道士#m#u、#u#G#m({方寸山,31,23})游方术土#m#u#W）',
	'  你已经找到了三个闲人加入菩提门下，快去回复#u#G#m({方寸大殿,22,8})菩提祖师#m#u#W#W吧!#Y（温馨提示：和菩提祖师对话后会进入战斗请做好准备!）'
}

local _追踪描述 = {
	'  前往#Y方寸大殿#W找#u#G#m({方寸大殿,22,8})菩提祖师#m#u#W谈谈！',
	'	问问方寸山上的闲人，让他们加入菩提门下 。闲人分别是:（#u#G#m({方寸后山,50,21})陈百万#m#u、#u#G#m({方寸山,31,23})道士#m#u、#u#G#m({方寸山,31,23})游方术土#m#u#W）',
	'  你已经找到了三个闲人加入菩提门下，快去回复#u#G#m({方寸大殿,22,8})菩提祖师#m#u#W#W吧!#Y（温馨提示：和菩提祖师对话后会进入战斗请做好准备!）'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '哎，自从一万三千年前孙悟空那个孽徒被情欲纠缠，叛出我门下之后，方寸山就整整冷落了1万多年!修仙之人一听这是大闹天宫的魔神孙悟空修炼的地方，就再也不肯来了，于是，我菩提门下这一万多年几乎没有收过什么徒弟!',
    --1
    '这可不妙，那么方寸心法不是要失传了吗?',
    --2
    '要是再没有弟子来学，方寸的心法就要失传了!我看我们挺有缘分的，最近听说有些信徒想来学道，可是却不知道为什么，他们还在方寸山游荡。如果你可以让那几个人加入我菩提门下的话，我会很感谢你的。',
    --3
    '感谢倒是不必了.有什么好处吗，嘿嘿?',
    --4
    '要是你可以让我收上3个以上的门徒，我就告诉你孙悟空和白骨仙之间的因缘纠葛，这可是上下三界最大的秘密!而且我菩提老祖早就算到你会想知道这个秘密了。呵呵。',
    --5
    '老神仙果然老谋深算!哈~不过这个交易不坏。',
    --6
    '是你帮我实现了见一见太上老君的梦想。所以我相信你，我会加入方寸门下好好修行的!',
    --7
    '嘿哩，与人方便与己方便，这不，又搞定了一个。',
    --8
    '多谢你帮我找回剃刀!既然你推荐我去方寸山菩提老祖的门下修炼，我想应该是不错的。我决定加入方寸山这个门派了!我想我在方寸山一定能够修成正果的!',
    --9
    '好，这个搞定了',
    --10
    '恩，我上山这几年正是为了修仙的，不过总是不得其而入，既然你推荐了菩提老祖，我就拜他为师好好修炼吧!',
    --11
    '哇，你真好，什么要求都不提就加入了...',
    --12
    '恩，干的不错，这5 0 0两银子作为辛苦费你，享去吧"- .',
    --13
    '500两?我们当初说好的不是这样吧? ',
    --14
    '为什么不要?嫌少?那好吧，再加5 0 0两.....',
    --15
    '喂，菩提老儿，你不要跟我要花样啊。',
    --16
    '你想怎么样?',
    --17
    '我们当初说好的，你答应告诉孙悟空和白骨仙之间的真正秘密。',
    --18
    '算了吧，那只是跟你说着玩儿的，那不是你能知道的秘密，还是拿着这一千两银子回家去吧.... . ..... .. .......好吧，既然你不死心，我就让你知道知道厉害，让你见识见识灵台方寸菩提祖师最后的奥秘:召唤!战神女娲!'
    --19
}

function 任务:任务NPC对话(玩家, NPC)
    NPC.头像 = NPC.外形
    if NPC.名称 == '菩提祖师' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            self.对话进度 = 0
            NPC.台词 = _台词[13]
            NPC.结束 = false
        end
    elseif NPC.名称 == '道士' and NPC.台词 then
        if self.进度 == 1 and self.徒弟.道士 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[7]
            NPC.结束 = false
        end
    elseif NPC.名称 == '游方术士' and NPC.台词 then
        if self.进度 == 1 and self.徒弟.术士 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[9]
            NPC.结束 = false
        end
    elseif NPC.名称 == '陈百万' and NPC.台词 then
        if self.进度 == 1 and self.徒弟.百万 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[11]
            NPC.结束 = false
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '菩提祖师' then
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
                self.对话进度 = 4
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[5]
                NPC.结束 = false
            elseif self.对话进度 == 4 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[6]
                NPC.结束 = nil
                self.进度 = 1
                玩家:刷新追踪面板()
            end
        elseif self.进度 == 2 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[14]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[15]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[16]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self.对话进度 = 4
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[17]
                NPC.结束 = false
            elseif self.对话进度 == 4 then
                self.对话进度 = 5
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[18]
                NPC.结束 = false
            elseif self.对话进度 == 5 then
                self.对话进度 = 6
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[19]
                NPC.结束 = false
            elseif self.对话进度 == 6 then
                NPC.结束 = nil
                self:任务攻击事件(玩家, NPC)
            end
        end
    elseif NPC.名称 == '道士' then
        if self.进度 == 1 and self.徒弟.道士 == 0 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                self.徒弟.道士 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[8]
                NPC.结束 = nil
                self:徒弟检查(玩家)
            end
        end
    elseif NPC.名称 == '游方术士' then
        if self.进度 == 1 and self.徒弟.术士 == 0 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                self.徒弟.术士 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[10]
                NPC.结束 = nil
                self:徒弟检查(玩家)
            end
        end
    elseif NPC.名称 == '陈百万' then
        if self.进度 == 1 and self.徒弟.百万 == 0 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                self.徒弟.百万 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[12]
                NPC.结束 = nil
                self:徒弟检查(玩家)
            end
        end
    end
end
function 任务:徒弟检查(玩家)
    for _, v in pairs(self.徒弟) do
        if v == 0 then
            return
        end
    end
    self.进度 = 2
    玩家:刷新追踪面板()
end

function 任务:完成(玩家)
    玩家:添加声望(1600)
    玩家:添加经验(1320000)
    玩家:常规提示('#Y你打败了战神女娲，获得了1320000经验,1600声望。')
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:六称完成检测(玩家, '孽缘')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '菩提祖师' then
        if self.进度 == 2 and self.对话进度 == 6 then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓6_孽缘.lua', self)
            if r then
                self:完成(玩家)
                玩家:刷新追踪面板()
            end
        end
    end
end
local _怪物 = {
    { 名称 = "战神女娲", 外形 = 2289, 气血 = 272000, 魔法 = 9101, 攻击 = 1200, 速度 = 333,技能={'日照光华','雷神怒击'} }
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
