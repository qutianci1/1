-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:56
-- @Last Modified time  : 2024-10-15 00:19:10

local 任务 = {
    名称 = '转生任务3',
    别名 = '转生重来',
    类型 = '转生任务',
    是否可取消 = false
}

function 任务:任务初始化()
    if not self.进度 then
        self.进度 = 1
        self.对话进度 = 0
    end
end

local _描述 = {
    "#W你感到周身圆满，修为再难寸进，隐约有一丝阴霾缠绕心头，去找#G孟婆#W谈谈吧",
    "去地府找#G地藏王#W索取生死符。",
    "去白骨山打败#G罗刹女#W获得生死符。",
    "去洛阳城找#Y玄阴仙子（155，134）#W借#G月光宝盒#W一用。",
    "回地府找#G孟婆#W。",
}


function 任务:任务取详情()
    return _描述[self.进度]
end

local _台词 = {
    [[
人生一世，草木一春。孩子，你可以选择重新来过。要投胎转世么?
#R注意:转生完毕请立即重新进入游戏。
menu
1|好的，我做好准备了
99|不，我还有心愿未了
]]   ,
    "好孩子，找来月光宝盒和地藏王菩萨的生死符，婆婆就给你做碗汤喝，你就可以重新再来啦。",
    "你可是来取生死符的么?不过你来晚了，生死符昨夜被白骨山的罗刹女盗去了。能否打败他取回生死符就看你的造化了。",
    "臭贼！快将地藏王菩萨的生死符交出来心#47！",
    "有本事就从姑奶奶这里拿走#28！",
    "上仙果然法力高强#83，这生死符我就交给你了#17",
    [[
    玄阴之气充满玄阴宝鉴，时空之i就会立刻开启，届时大闹天宫就会开启。
    menu
    1|仙子姐姐，借你的月光宝盒一用#R（扣除5000000银两）
    99|我就是来看看你
    ]],




}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == "孟婆" then
        if self.进度 == 1 or self.进度==5 then
            NPC.台词 = _台词[1]
        end
    elseif NPC.名称 == "地藏王" then
        if self.进度 == 2 then
            NPC.台词 = _台词[3]
            self.进度 = 3
        end
    elseif NPC.名称 == "罗刹女" then
        if self.进度 == 3 then
            NPC.台词 = _台词[4]
            NPC.头像 = 玩家.原形
            NPC.结束 = false
        end
    elseif NPC.名称 == "玄阴仙子" then
        if self.进度==4 then
            NPC.台词 = NPC.台词.."\nmenu\n1|仙子姐姐，借你的月光宝盒一用（500W两）\n99|我就是来看看你"
        end



    end
end

function 任务:任务NPC菜单(玩家, NPC, i)

    if NPC.名称 == "孟婆" then
        if self.进度 == 1 then
            if i == "1" then
                self.进度 = 2
                NPC.台词 = _台词[2]
            end
        elseif self.进度 == 5 then

            local r = 玩家:转生条件检测()
            if r then
                if type(r) == 'string' then
                    玩家:提示窗口('#Y'..r)
                end
                return r
            end
            local d, e =
            玩家:取物品是否存在("生死符"),
            玩家:取物品是否存在("月光宝盒")
            if d and e  then
            else
                玩家:最后对话("我要的东西呢？")
            return
            end
            local 种族, 性别, 外形 = 玩家:转生窗口()
            if 种族 then
                r = 玩家:转生条件检测(性别)
                if r then
                    return r
                end
                local a, b =
                玩家:取物品是否存在("生死符"),
                玩家:取物品是否存在("月光宝盒")

                if a and b  then
                    a:减少(1)
                    b:减少(1)
                    玩家:转生处理(种族, 性别, 外形)
                    玩家:最后对话("转生成功，请重新登录游戏。")
                    self:删除()
                end

            end

        end
    elseif NPC.名称 == "罗刹女" then
        if self.进度 == 3 then
            if not i then
                if not self.对话进度 or self.对话进度 == 0 then
                    NPC.头像 = NPC.外形
                    NPC.台词 = _台词[5]
                    NPC.结束 = false
                    self.对话进度 = 1
                elseif self.对话进度 == 1 then
                    self:任务攻击事件(玩家, NPC)
                    self.对话进度 = 0
                end

            end
        end
    elseif NPC.名称 == "玄阴仙子" then
        if self.进度 == 4 then

            if 玩家.银子 < 5000000 then
                玩家:最后对话("你没有那么多银子，准备好500W再来找我吧！")
                return
            end
            if 玩家:添加物品({ 生成物品 { 名称 = '月光宝盒', 数量 = 1 } }) then
                玩家:扣除银子(5000000)
                self.进度=5
            else
                玩家:最后对话("包裹空间不足！")
            end


           -- :添加物品({ 生成物品 { 名称 = '生死符', 数量 = 1 } })
        end
    end









end

function 任务:修改进度(n)
    self.进度 = n
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '罗刹女' then
        if self.进度 == 3 then
            玩家:进入战斗('scripts/task/转生任务3.lua', NPC)
        end
    end
end

local _小怪外形 = {
    [1] = 0,
    [2] = 0048,
    [3] = 0048,
    [4] = 0048,
    [5] = 0047,
    [6] = 0047,
    [7] = 0047,
    [8] = 0046,
    [9] = 0046,
    [10] = 0046,
}

function 任务:战斗初始化(玩家, NPC)
    local _技能表 = {'百日眠', '失心狂乱', '四面楚歌', '万毒攻心', '天诛地灭', '九龙冰封', '袖里乾坤', '九阴纯火', '阎罗追命'}
    local selectedSkills = {}
    for i = 1, 9 do
        local index = math.random(1, #_技能表)
        table.insert(selectedSkills, _技能表[index])
        _技能表[index] = _技能表[#_技能表]
        table.remove(_技能表)
    end
    local _怪物 = {}
    for i = 1, 1 do
        _怪物[i] = {外形 = NPC.外形, 名称 = NPC.名称, 等级 = 140 , 攻初值 = 600, 敏初值 = math.random(800, 1100), 血初值 = 1600, 法初值  = 200, 是否消失 = false, AI = {'互相拉血'}, 技能 = {{名称 = '阎罗追命' , 熟练度 = 18000},{名称 = '含情脉脉' , 熟练度 = 18000},{名称 = '乾坤借速' , 熟练度 = 18000},{名称 = '万毒攻心' , 熟练度 = 18000}}}
        local r = 生成战斗怪物(生成怪物属性(_怪物[i] , '普通'))
        self:加入敌方(i, r)
    end

    for i = 2, 10 do
        _怪物[i] = {外形 = _小怪外形[i], 名称 = "罗刹宝宝", 等级 = 140, 攻初值 = math.random(600, 900), 敏初值 = math.random(500, 800), 血初值 = 500, 法初值  = 200, 是否消失 = false, AI = {'互相拉血'}, 技能 = {{名称 = selectedSkills[i - 1] , 熟练度 = 15000}} , 内丹 = { { 技能 = "浩然正气", 转生 = 2, 等级 = 140 } }}
        local r = 生成战斗怪物(生成怪物属性(_怪物[i] , '普通'))
        self:加入敌方(i, r)
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(s)
    if s then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                local r = v.对象.接口:取任务('转生任务3')
                if r then
                    if r.进度 == 3 then
                        if v.对象.接口:添加物品({ 生成物品 { 名称 = '生死符', 数量 = 1 } }) then
                            v.对象.接口:最后对话("上仙果然法力高强#83，这生死符我就交给你了#17")
                            r:修改进度(4)
                        end
                    end
                end
            end
        end
    end


end

return 任务
