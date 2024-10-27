-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-10-26 19:12:28


local 任务 = {
    名称 = '称谓4_四琉璃碎片',
    别名 = '四琉璃碎片(四称)',
    类型 = '称谓剧情',
    是否可取消 = false,
	是否可追踪 = true
}

function 任务:任务初始化(玩家, ...)
    self.碎片 = {袁天罡 = 0, 转轮王 = 0, 天寿老人 = 0, 沙和尚 = 0}
    self.王母接收碎片 = 0
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务更新(玩家, sec)
end

local _详情 = {
    '	前往#Y凌霄宝殿#W找#u#G#m({凌霄宝殿,78,47})王母娘娘#m#u#W聊聊！',
    '	寻找失散人间的4块琉璃盏碎片。（#W分别去找长安的#u#G#m({长安,215,188})袁天罡#m#u、#u#G#m({阎王殿,50,23})转轮王#m#u、#u#G#m({长寿村,27,23})天寿老人#m#u、#u#G#m({大唐边境,78,157})沙和尚#m#u#Y(需要战斗)#W）',
    '	你已经找到了4片琉璃盏，快去#Y凌霄宝殿#W找#u#G#m({凌霄宝殿,78,47})王母娘娘#m#u#W吧。#Y（将4片琉璃盏ALT+G给予王母娘娘）'
}

local _追踪描述 = {
    '	前往#Y凌霄宝殿#W找#u#G#m({凌霄宝殿,78,47})王母娘娘#m#u#W聊聊！',
    '	寻找失散人间的4块琉璃盏碎片。（#W分别去找长安的#u#G#m({长安,215,188})袁天罡#m#u、#u#G#m({阎王殿,50,23})转轮王#m#u、#u#G#m({长寿村,27,23})天寿老人#m#u、#u#G#m({大唐边境,78,157})沙和尚#m#u#Y(需要战斗)#W）',
    '	你已经找到了4片琉璃盏，快去#Y凌霄宝殿#W找#u#G#m({凌霄宝殿,78,47})王母娘娘#m#u#W吧。#Y（将4片琉璃盏ALT+G给予王母娘娘）'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '我无法向你表达我心中的愤怒....可恨的孙悟空....反出天界，和牛魔王联手，大闹天宫我都可以不在乎，但他居然打碎了我最珍爱的琉璃盏! !那是和天地诞生一同出现的宝贝，拥有强大的灵气，因此才能镇住天下群妖....现在居然被那个猴头打破! !就算千刀万剐也不能我心头之恨!',
    --1
    '这个事情我早就知道了，如今有没有挽回的可能呢？',
    --2
    '琉璃盏碎成了四块......落到了人间，我希望有人能帮我找回来，虽然复原它是不可能的了，但我还是希望那四块碎片还是可以稍微增强一些天地灵气的... ...',
    --3
    '我可以去帮你找啊，不过你知道掉哪里了吗?',
    --4
    '据千里眼的观察回报，一块落在了长安#R袁天罡#W的手上，一块被长寿村#R天寿老人#W得到，一块在地狱的#G转轮王#W那里，还有一块....似乎是在流沙河... ...因为妖气重千里眼也没有看清楚。',
    --5
    '收到~我这就去帮你拿回来。',
    --6
    '琉璃盏的碎片确实有一块在我手上， 那是非常珍贵的宝物，如果落到邪魔歪道的手里，会造成可怕的后果... .不过，你打败食婴鬼，勇闯地狱十王降魔阵，这些事迹我都知道的，所以你应该是可以信任的，这块琉璃盏的碎片你拿去吧。',
    --7
    '琉璃盏的碎片?那个无聊的东西啊，我差点就丢掉了,既然你要就给你吧。',
    --8
    '琉璃盏的碎片?活活，这可是孙猴子大闹天言才流落人间的宝物啊，怎么可以随随便便就给你呢... ...什么?你一定想要?也罢，拿#R2000#W两银子来吧。',
    --9
    '好的，不就是2000两嘛，我给~',
    --10
    '呵呵，你出手还真大方。能不能再给#R2000#W两?',
    --11
    '没想到你还真有钱啊....与其这样不如再给#R2000#W两吧?',
    --12
    '呵呵，事不过三，这块琉璃盏的碎片你拿去吧。',
    --13
    '这样还差不多。饶了你这回。',
    --14
    '你要找琉璃盏的碎片?哎. ..我原来就是守护琉璃盏的人...我本来是神，官封卷帘大将，职责就是守卫琉璃盏... ...没想到孙猴子那混蛋大闹天宫，将琉璃盏打破，我也被贬落凡间，沦落到这里当个妖怪，靠吃人为生--你想要琉瑞盏的碎片?妖怪我最佩服的就是有能力的人了，赢了我手中从铲先。',
    --15
    '这样还差不多。饶了你这回。',
    --16
    '还有三个碎片呢。',
    --17
    '还有二个碎片呢。',
    --18
    '还有一个碎片呢。',
    --19
    '哼哼，我终于拿到这些碎片了......多谢你如果原意的话，你可以加入我手下的瑶池御林军，恩，这件宝物就当做见面礼吧。'
    --20
}

function 任务:任务NPC对话(玩家, NPC)
    NPC.头像 = NPC.外形
    if NPC.名称 == '王母娘娘' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            if self.琉璃盏碎片==4 then
                self.王母接收碎片 = self.王母接收碎片 + 1
                NPC.台词 = _台词[self.王母接收碎片 + 16]
                if self.王母接收碎片 == 4 then
                    self:完成(玩家)
                end
            end
        end
    elseif NPC.名称 == '袁天罡' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 1 and self.碎片.袁天罡 == 0 then
            self.对话进度 = 0
            if 玩家:添加物品({生成物品 {名称 = '琉璃盏碎片', 数量 = 1}}) then
                NPC.台词 = _台词[7]
                self.碎片.袁天罡 = 1
                self:琉璃进度检查(玩家)
            else
                NPC.台词 = '你的包裹满了，清理一下再来找我！'
            end
        end
    elseif NPC.名称 == '转轮王' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 1 and self.碎片.转轮王 == 0 then
            self.对话进度 = 0
            if 玩家:添加物品({生成物品 {名称 = '琉璃盏碎片', 数量 = 1}}) then
                NPC.台词 = _台词[8]
                self.碎片.转轮王 = 1
                self:琉璃进度检查(玩家)
            else
                NPC.台词 = '你的包裹满了，清理一下再来找我！'
            end
        end
    elseif NPC.名称 == '天寿老人' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 1 and self.碎片.天寿老人 == 0 then
            self.对话进度 = 0
            if 玩家:添加物品({生成物品 {名称 = '琉璃盏碎片', 数量 = 1}}) then
                NPC.台词 = _台词[13]
                self.碎片.天寿老人 = 3
                self:琉璃进度检查(玩家)
            else
                NPC.台词 = '你的包裹满了，清理一下再来找我！'
            end
        end
    -- elseif NPC.名称 == '沙和尚' and NPC.台词 then
    --     if self.进度 == 1 and self.碎片.沙和尚 == 0 then
    --         -- if 玩家:取可用格子(1) then
    --             self.对话进度 = 0
    --             NPC.台词 = _台词[15]
    --             NPC.结束 = false
    --         -- else
    --             -- NPC.台词 = '你的包裹满了，清理一下再来找我！'
    --         -- end
    --     end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '王母娘娘' then
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

        end
    elseif NPC.名称 == '天寿老人' then
        if self.进度 == 1 then
            if self.碎片.天寿老人 == 0 then
                if self.对话进度 == 0 then
                    NPC.头像 = 玩家.原形
                    NPC.台词 = _台词[10]
                    NPC.结束 = nil
                end
            elseif self.碎片.天寿老人 == 3 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[14]
                NPC.结束 = nil
                玩家:添加物品({生成物品 {名称 = '琉璃盏碎片', 数量 = 1}})
                self:琉璃进度检查(玩家)
            end
        end
    elseif NPC.名称 == '沙和尚' then
        if self.进度 == 1 and self.碎片.沙和尚 == 0 then
			NPC.头像 = 玩家.原形
            NPC.台词 = _台词[15]
            NPC.结束 = nil
            self:任务攻击事件(玩家, NPC)
        end
    end
end

function 任务:琉璃进度检查(玩家)
    for k, v in pairs(self.碎片) do
        if k ~= '天寿老人' and v == 0 then
            return
        elseif k == '天寿老人' and v ~= 3 then
            return
        end
    end
    self.进度 = 2
    玩家:刷新追踪面板()
end

function 任务:完成(玩家)
    玩家:添加声望(250)
    玩家:添加称谓('瑶池御林军')
    玩家:提示窗口('#Y因为你的胆大心细，你在这个世界的声望得到提升，获得250点声望和瑶池御林军称号。')

    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:四称完成检测(玩家, '琉璃')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    if self.进度 == 1 then
        if cash then --
            if cash >= 2000 then
                if self.碎片.天寿老人 < 3 and 玩家:扣除银子(2000) then
                    self.碎片.天寿老人 = self.碎片.天寿老人 + 1
                    NPC.头像 = NPC.外形
                    NPC.台词 = _台词[self.碎片.天寿老人 + 10]
                    if self.碎片.天寿老人 == 3 then
                        NPC.结束 = false
                    end
                end
            end
        end
    elseif self.进度 == 2 then
        if items[1] and items[1].名称 == '琉璃盏碎片' then --
            if items[1].数量 >= 1 then
                items[1]:接受(1)
                self.王母接收碎片 = self.王母接收碎片 + 1
                NPC.台词 = _台词[self.王母接收碎片 + 16]
				    玩家:常规提示('#Y给予了'..NPC.名称..items[1].名称..self.王母接收碎片..'个')
                if self.王母接收碎片 == 4 then
                    self:完成(玩家)
                    玩家:刷新追踪面板()
                end
            end
        end
    end
    -- if NPC.名称 == '天寿老人' then
    --     if self.进度 == 1 then
    --         if cash then --
    --             if cash >= 2000 then
    --                 if self.碎片.天寿老人 < 3 and 玩家:取可用格子(1) and 玩家:扣除银子(2000) then
    --                     self.碎片.天寿老人 = self.碎片.天寿老人 + 1
    --                     NPC.头像 = NPC.外形
    --                     NPC.台词 = _台词[self.碎片.天寿老人 + 10]
    --                     if self.碎片.天寿老人 == 3 then
    --                         NPC.结束 = false
    --                     end
    --                 end
    --             end
    --         end
    --     end
    -- elseif NPC.名称 == '王母娘娘' then
    --     if self.进度 == 2 then
    --         if items[1] and items[1].名称 == '琉璃盏碎片' then --
    --             if items[1].数量 >= 1 then
    --                 items[1]:接受(1)
    --                 self.王母接收碎片 = self.王母接收碎片 + 1
    --                 NPC.台词 = _台词[self.王母接收碎片 + 16]
    --                 if self.王母接收碎片 == 4 then
    --                     self:完成(玩家)
    --                 end
    --             end
    --         end
    --     end
    -- end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '沙和尚' then
        if self.进度 == 1 and self.碎片.沙和尚 == 0 then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓4_四琉璃碎片.lua', self)
            if r then
                self.碎片.沙和尚 = 1
                玩家:添加物品({生成物品 {名称 = '琉璃盏碎片', 数量 = 1}})
                self:琉璃进度检查(玩家)
                玩家:添加银子(9844)
                玩家:添加经验(258417)
                玩家:常规提示('你打败了沙和尚，获得了琉璃盏碎片！')
            end
        end
    end
end

local _怪物 = {
    { 名称 = "沙和尚", 外形 = 2092,等级=40, 气血 = 38000, 魔法 = 8000, 攻击 = 3900, 速度 = 280,抗性={物理吸收=20},技能={'飞沙走石','龙腾水溅'} },
    { 名称 = "老虎", 外形 = 2028,等级=40, 气血 = 8000, 魔法 = 8000, 攻击 = 900, 速度 = 180,抗性={物理吸收=10} },
    { 名称 = "银狐", 外形 = 2039,等级=40, 气血 = 8000, 魔法 = 8000, 攻击 = 900, 速度 = 180,抗性={物理吸收=10} }
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
