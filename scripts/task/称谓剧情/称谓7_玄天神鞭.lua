-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-11 04:48:56
-- @Last Modified time  : 2024-10-26 21:04:02
local 任务 = {
    名称 = '称谓7_玄天神鞭',
    别名 = '玄天神鞭(七称)',
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
	'  前往#Y北俱芦洲#W找#u#G#m({北俱芦洲,143,136})沙铁匠#m#u#W谈谈！',
	'  去#Y天宫#W问问#u#G#m({天宫,148,118})李靖#m#u#W玄天铁鞭落到了那里。',
	'  去#Y狮驼岭#W打败#u#G#m({狮驼岭,20,20})多头神魔#m#u#W。#Y（ ALT+A攻击多头神魔）',
	'  解决掉多头神魔去#Y天宫#W问问#u#G#m({天宫,148,118})李靖#m#u#W那复命。',
	'  将玄天铁鞭交给#u#G#m({北俱芦洲,143,136})沙铁匠#m#u#W。'
}

local _追踪描述 = {
	'  前往#Y北俱芦洲#W找#u#G#m({北俱芦洲,143,136})沙铁匠#m#u#W谈谈！',
	'  去#Y天宫#W问问#u#G#m({天宫,148,118})李靖#m#u#W玄天铁鞭落到了那里。',
	'  去#Y狮驼岭#W打败#u#G#m({狮驼岭,20,20})多头神魔#m#u#W。#Y（ ALT+A攻击多头神魔）',
	'  解决掉多头神魔去#Y天宫#W问问#u#G#m({天宫,148,118})李靖#m#u#W那复命。',
	'  将玄天铁鞭交给#u#G#m({北俱芦洲,143,136})沙铁匠#m#u#W。'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '你知不知道，这世界上有一种叫做#R玄天铁鞭#W的宝贝，用它打造出来的装备能够破除仙人的金身。',
    --1
    '还有这么厉害的东东?',
    --2
    '这是所有铁匠都在梦寐以求的东西，为了这件宝贝，我把自己的铁匠铺交给了龙天兵， 而我在世界上游历不断的寻找，我终于打听到那件宝贝可能在天宫#R托塔天王#W手里的消息，不过，我是个凡人，没有办法到天言去，但我无论如何也想见那玄天铁鞭一眼。 我知道你是这个世界上最神通广大的人，你能帮忙我借来一看吗? ',
    --3
    '好，我就帮你完成这个心愿!',
    --4
    '玄天铁鞭是33层兜率天最大的秘宝，是唯一能破山人万年不破之金身的法宝。本来是不可以给你的，不过看你上次在征讨牛魔王的战役里表现不错，这样吧，#R狮驼岭的多头神魔#W触犯天条我正好要找人惩罚他，天宫目前又抽不出人手，你就先去把多头神魔给解决了再说吧。',
    --5
    ' 晕，你是利用我当苦力吧?',
    --6
    '干的不错，作为奖励，玄天铁鞭就借你一用吧!',
    --7
    '多谢多谢。',
    --8
    '这是真的玄天铁鞭!我终于见到了!',
    --9
    '哈哈，这下你满足了吧?',
    --10
    '谢谢你，这件我亲手打出来的装备就送给你吧!'
    --11
}

function 任务:任务NPC对话(玩家, NPC)
     NPC.头像 = NPC.外形
    if NPC.名称 == '沙铁匠' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 4 then
                local a =  玩家:取物品是否存在("玄天铁鞭")
                if a  then
                else
                    NPC.台词 = "我要的东西呢？"
                    return
                end
                local  b =    玩家:取物品是否存在("玄天铁鞭")
                if  b then
                        b:减少(1)
                end

                    self.对话进度 = 0
                   NPC.台词 = _台词[9]
                    NPC.结束 = false

        end
    elseif NPC.名称 == '李靖' and NPC.台词 then
        if self.进度 == 1 then
            self.对话进度 = 0
            NPC.台词 = _台词[5]
            NPC.结束 = false
        elseif self.进度 == 3 then
            self.对话进度 = 0
            NPC.台词 = _台词[7]
            NPC.结束 = false
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '沙铁匠' then
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
                self.进度 = 1
                玩家:刷新追踪面板()
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[4]
                NPC.结束 = nil
            end
        elseif self.进度 == 4 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[10]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[11]
                NPC.结束 = nil
                self:完成(玩家)
                玩家:刷新追踪面板()
            end
        end
    elseif NPC.名称 == '李靖' then
        if self.进度 == 1 then
            if self.对话进度 == 0 then
                self.进度 = 2
                玩家:刷新追踪面板()
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[6]
                NPC.结束 = nil
            end
        elseif self.进度 == 3 then
            if self.对话进度 == 0 then
                self.进度 = 4
                玩家:刷新追踪面板()
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[8]
                NPC.结束 = nil
                玩家:添加物品({生成物品 {名称 = '玄天铁鞭', 数量 = 1}})
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(1000)
   -- 获得一件7级衣服！
    玩家:常规提示('#Y你帮助凡人见到了三界的密宝玄天铁鞭，你在个世界的声望获得了提升，你得到了1000点声望。')
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:七称完成检测(玩家, '神鞭')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    -- if NPC.名称 == '沙铁匠' then
        if self.进度 == 4 then
            if items[1] and items[1].名称 == '玄天铁鞭' then --
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
					玩家:常规提示('#Y给予了'..NPC.名称..items[1].名称)
					玩家:常规提示('#Y与沙铁匠对话')
                    self.对话进度 = 0
                    NPC.头像 = NPC.外形
                    NPC.结束 = false
                end
            end
        end
    -- end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '多头神魔' then
        if self.进度 == 2 then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓7_玄天神鞭.lua', self)
            if r then
                玩家:添加银子(65425)
                玩家:添加经验(880000)
                玩家:常规提示('#R你打败了多头神魔，获得880000经验和65425银两。')
                self.进度 = 3
                玩家:刷新追踪面板()
            end
        end
    end
end

local _怪物 = {
    { 名称 = "多头精怪", 外形 = 2089, 气血 = 84000, 魔法 = 8000, 攻击 = 13000, 速度 = 460,抗性={物理吸收=50} },
    { 名称 = "鼠怪", 外形 = 2021, 气血 = 24000, 魔法 = 18000, 攻击 = 13000, 速度 = 460,抗性={物理吸收=10},技能={'乘风破浪'} },
    { 名称 = "鼠怪", 外形 = 2021, 气血 = 24000, 魔法 = 18000, 攻击 = 13000, 速度 = 460,抗性={物理吸收=10},技能={'飞沙走石'} },
    { 名称 = "鼠怪", 外形 = 2021, 气血 = 24000, 魔法 = 18000, 攻击 = 13000, 速度 = 460,抗性={物理吸收=10},技能={'太乙生风'} },
    { 名称 = "鼠怪", 外形 = 2021, 气血 = 24000, 魔法 = 18000, 攻击 = 13000, 速度 = 460,抗性={物理吸收=10},技能={'风雷涌动'} },
}

function 任务:战斗初始化(玩家)
    for i = 1, 5 do
        local r = 生成战斗怪物(_怪物[i])
        self:加入敌方(i, r)
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
