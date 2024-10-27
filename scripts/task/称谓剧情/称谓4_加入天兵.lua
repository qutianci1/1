-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-10-26 19:13:16


local 任务 = {
    名称 = '称谓4_加入天兵',
    别名 = '加入天兵(四称)',
    类型 = '称谓剧情',
    是否可取消 = false,
	是否可追踪 = true
}

function 任务:任务初始化(玩家, ...)
    self.当前战斗=''
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务更新(玩家, sec)
end

local _详情 = {
    '	前往#Y凌霄宝殿#W找#u#G#m({凌霄宝殿,67,50})玉皇大帝#m#u#W聊聊！',
    '	前往#Y天宫#W找#u#G#m({天宫,151,116})李靖#m#u#W聊聊！',
    '	前往#Y凌霄宝殿#W接受#u#G#m({凌霄宝殿,37,35})哪吒#m#u#W和#Y二郎神#W的考验！',
    '	通过了两位先锋官的考验，回去找#u#G#m({天宫,151,116})李靖#m#u#W吧！',
    '	去#Y魔王寨#W找#u#G#m({魔王寨,20,11})牛魔王#m#u#W打探消息！',
    '	让人利用？回天庭问#u#G#m({凌霄宝殿,67,50})玉皇大帝#m#u#W事情真相去。',
    '	下界有功去#Y天宫#W找#u#G#m({天宫,151,116})李靖#m#u#W领取赏赐！'
}

local _追踪描述 = {
    '	前往#Y凌霄宝殿#W找#u#G#m({凌霄宝殿,67,50})玉皇大帝#m#u#W聊聊！',
    '	前往#Y天宫#W找#u#G#m({天宫,151,116})李靖#m#u#W聊聊！',
    '	前往#Y凌霄宝殿#W接受#u#G#m({凌霄宝殿,37,35})哪吒#m#u#W和#Y二郎神#W的考验！',
    '	通过了两位先锋官的考验，回去找#u#G#m({天宫,151,116})李靖#m#u#W吧！',
    '	去#Y魔王寨#W找#u#G#m({魔王寨,20,11})牛魔王#m#u#W打探消息！',
    '	让人利用？回天庭问#u#G#m({凌霄宝殿,67,50})玉皇大帝#m#u#W事情真相去。',
    '	下界有功去#Y天宫#W找#u#G#m({天宫,151,116})李靖#m#u#W领取赏赐！'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '那个忤逆的孙猴子，终于把白骨仙从地狱里给救了出来.....现在他们和地上最大的魔头牛魔王又勾结在一起，最强的妖仙，最强的魔头，最强的尸魔，这三个人一旦联手，三界恐怕真的要走向毁灭了..... 但是我们不会放弃最后的努力! #R托塔李天王#W集结十万天军，正要下界剿灭这干妖孽，你既然身负绝技，为什么不加入我们正义的军队?',
    --1
    '参加天军?能做一个天兵，将来也是个不错的回忆啊。',
    --2
    '李天王的十万天军是最后的希望，为了三界的存亡而尽力吧!',
    --3
    '你要加入天军?那要看看你有没有足够的实力!',
    --4
    '如何证明?',
    --5
    '你看你信心十足，嗯....去#R哪吒三太子#W和#G二郎真君#W那里看看，也许他们会考你吧!他们是我的先锋官，最看重有能力的人才了。如果不通过三太子和二郎真君的考验，我是不会让你加入天军的。',
    --6
    '既而是父王让你来的，好吧，如果你能打败我手下的亲卫兵，我就承认你的实力。',
    --7
    '就是打胜你的亲兵那么简单啊?',
    --8
    '不过就算你胜了你也不要太得意，我只是一半的保证，另外的你要找二郎神君。',
    --9
    '既而是大帅让你来的，好吧，如果你能打败我手下的亲卫兵，我就承认你的实力。',
    --10
    '也是打胜你的亲兵那么简单啊?',
    --11
    '也别太大意，小心了。',
    --12
    '恩，你已经通过了三太子和二高真君的考验，这说明你确实有一定的实力-...孙悟空白骨山正要与牛魔王连手，我们已经没有多少时间了，你就先作为前锋，先去刺探一下#R魔王寨牛魔王#W的虚实吧!',
    --13
    '属下领命! ',
    --14
    '牛魔王乃万魔之首，实力非同小可，你应多加小心。 ',
    --15
    '看你挺面生的不像是我老牛家的人。 ',
    --16
    '啊?是吗?大王你是贵人多忘事吧?',
    --17
    '不对，最近听说天庭下来了个探子，我看你问题不小! !',
    --18
    '不好！这魔头真是精明！',
    --19
    '没错。牛廣王口中的小白就是杀人如麻，双手血腥的白骨仙! !白骨仙是天生的怪胎，她是阴年阴月阴日出生的阴人，也就是所谓的九阴之体，13000年前，白骨仙炼成纯阴妖气，天庭历称发生这场惨烈战斗的日子为当时，整个天界没有一个神仙能够与她抗衡。天界不得已请来佛祖出手收服了这个有史以来最强的女妖，并且一致决定，抹去她的记忆和法力，把她的肉身收押在凤巢里，而灵魂则在地狱的十王降魔阵里受看永远的煎熬。',
    --20
    '既然如此，一切不都了结了吗?怎么现在又发生了 那么多事情呢? ',
    --21
    '本来事情就可以这么解决了，可是那孙猴子不听教诲，反下天宫，居然把白骨仙从十王降魔阵里救了出来.....难以想象，也许又一个“众神末日”又要开始了你下界有功，去#R找托塔李天王#W吧。 ',
    --22
    '嗯，不错，不错，天庭有了你这样的奇才，真是福气啊。现在我决定嘉封你为:雷霆天兵。'
    --23
}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '玉皇大帝' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 5 then
            self.对话进度 = 0
            NPC.台词 = _台词[20]
            NPC.结束 = false
        end
    elseif NPC.名称 == '李靖' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 1 then
            self.对话进度 = 0
            NPC.台词 = _台词[4]
            NPC.结束 = false
        elseif self.进度 == 3 then
            self.对话进度 = 0
            NPC.台词 = _台词[13]
            NPC.结束 = false
        elseif self.进度 == 6 then
            self.对话进度 = 0
            NPC.台词 = _台词[23]
            self:完成(玩家)
            玩家:刷新追踪面板()
        end
    elseif NPC.名称 == '哪吒' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 2 and self.哪吒 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[7]
            NPC.结束 = false
        end
    elseif NPC.名称 == '二郎神' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 2 and self.杨戬 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[10]
            NPC.结束 = false
        end
    elseif NPC.名称 == '牛魔王' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 4 then
            self.对话进度 = 0
            NPC.台词 = _台词[16]
            NPC.结束 = false
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '玉皇大帝' then
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
        elseif self.进度 == 5 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[21]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[22]
                NPC.结束 = nil
                self.进度 = 6
                玩家:刷新追踪面板()
            end
        end
    elseif NPC.名称 == '李靖' then
        if self.进度 == 1 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[5]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[6]
                NPC.结束 = nil
                self.进度 = 2
                self.哪吒 = 0
                self.杨戬 = 0
                玩家:刷新追踪面板()
            end
        elseif self.进度 == 3 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[14]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[15]
                NPC.结束 = nil
                self.进度 = 4
                玩家:刷新追踪面板()
            end
        end
    elseif NPC.名称 == '哪吒' then
        if self.进度 == 2 and self.哪吒 == 0 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[8]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[9]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                NPC.结束 = nil
                self:任务攻击事件(玩家, NPC)
            end
        end
    elseif NPC.名称 == '二郎神' then
        if self.进度 == 2 and self.杨戬 == 0 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[11]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[12]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                NPC.结束 = nil
                self:任务攻击事件(玩家, NPC)
            end
        end
    elseif NPC.名称 == '牛魔王' then
        if self.进度 == 4 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[17]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[18]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[19]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                NPC.结束 = nil
                self:任务攻击事件(玩家, NPC)
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(500)
    玩家:添加银子(8000)
    玩家:添加称谓('雷霆天兵')
    玩家:提示窗口('#Y因为你的义勇参军，你在这个世界的声望得到提升，获得500点声望、8000两银子和雷霆天兵称号。')

    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:四称完成检测(玩家, '天兵')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '哪吒' then
        if self.进度 == 2 and self.哪吒 == 0 then
            self.当前战斗='哪吒'
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓4_加入天兵.lua', self)
            if r then
                self.当前战斗=''
                self.哪吒 = 1
                玩家:添加银子(4568)
                玩家:添加经验(354842)
                玩家:常规提示('#R你打败了三太子的亲兵，获得354842经验和4568银两！')
                if self.杨戬 == 1 then
                    self.进度 = 3
                    玩家:刷新追踪面板()
                end
            end
        end
    elseif NPC.名称 == '二郎神' then
        if self.进度 == 2 and self.杨戬 == 0 then
            self.当前战斗='杨戬'
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓4_加入天兵.lua', self)
            if r then
                self.当前战斗=''
                self.杨戬 = 1
                玩家:添加银子(6568)
                玩家:添加经验(374842)
                玩家:常规提示('#R你打败了二郎神的亲兵，获得374842经验和6568银两！')
                if self.哪吒 == 1 then
                    self.进度 = 3
                    玩家:刷新追踪面板()
                end
            end
        end
    elseif NPC.名称 == '牛魔王' then
        if self.进度 == 4 then
            self.当前战斗='牛魔王'
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓4_加入天兵.lua', self)
            if r then
                self.当前战斗=''
                玩家:添加银子(21945)
                玩家:添加经验(654584)
                玩家:常规提示('你打败了牛魔王，获得了654584经验和21945银两。')
                self.进度 = 5
                玩家:刷新追踪面板()
            end
        end
    end
end

local _怪物 = {
    {
        { 名称 = "神兵", 外形 = 2061,等级=40, 气血 = 42000, 魔法 = 8000, 攻击 = 3800, 速度 = 300,抗性={物理吸收=20} },
    },
    {
        { 名称 = "神兵", 外形 = 2061,等级=40, 气血 = 44000, 魔法 = 8000, 攻击 = 3900, 速度 = 280,抗性={物理吸收=30} },
    },
    {
        { 名称 = "牛魔王", 外形 = 2081,等级=40, 气血 = 84000, 魔法 = 8000, 攻击 = 3900, 速度 = 280,抗性={物理吸收=40},技能={'龙卷雨击','龙腾水溅'} },
        { 名称 = "鼠怪", 外形 = 2021,等级=40, 气血 = 14000, 魔法 = 8000, 攻击 = 900, 速度 = 280,抗性={物理吸收=10} },
        { 名称 = "战神女娲", 外形 = 2289,等级=40, 气血 = 14000, 魔法 = 8000, 攻击 = 900, 速度 = 280,抗性={物理吸收=10} },
        { 名称 = "孤魂", 外形 = 2054,等级=40, 气血 = 14000, 魔法 = 8000, 攻击 = 900, 速度 = 280,抗性={物理吸收=10} }
    }
    
}

local _怪物2 = {
    { 名称 = "神兵", 外形 = 2061,等级=40, 气血 = 44000, 魔法 = 8000, 攻击 = 3900, 速度 = 280,抗性={物理吸收=30} },
}

function 任务:战斗初始化(玩家,数据)
    if 数据.当前战斗=='哪吒' then
        for i = 1, 1 do
            local r = 生成战斗怪物(_怪物[1][i])
            self:加入敌方(i, r)
        end
    elseif 数据.当前战斗=='杨戬' then
        for i = 1, 1 do
            local r = 生成战斗怪物(_怪物[2][i])
            self:加入敌方(i, r)
        end
    elseif 数据.当前战斗=='牛魔王' then
        for i = 1, 4 do
            local r = 生成战斗怪物(_怪物[3][i])
            self:加入敌方(i, r)
        end
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
