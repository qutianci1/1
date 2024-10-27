-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:56
-- @Last Modified time  : 2024-10-26 22:36:43


local 任务 = {
    名称 = '称谓9_蟠桃园的山妖',
    别名 = '蟠桃园的山妖(九称)',
    类型 = '称谓剧情',
    是否可取消 = false,
	是否可追踪 = true
}

function 任务:任务初始化(玩家, ...)
    self.挑战 = {山妖 = 0, 山鬼 = 0}
    self.当前目标=''
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务更新(玩家, sec)

end

local _详情 = {
	'  前往#Y御马监#W找#u#G#m({御马监,62,111})采星仙女#m#u#W谈谈！',
	'  解决#Y蟠桃园后#W里骚扰的怪物，打败#u#G#m({蟠桃园后,18,200})野山妖#m#u#W，和#u#G#m({蟠桃园后,10,135})山鬼#m#u#W。（ALT+A攻击怪物）',
	'  前往#Y御马监#W找#u#G#m({御马监,62,111})采星仙女#m#u#W汇报！',
}
local _追踪描述 = {
	'  前往#Y御马监#W找#u#G#m({御马监,62,111})采星仙女#m#u#W谈谈！',
	'  解决#Y蟠桃园后#W里骚扰的怪物，打败#u#G#m({蟠桃园后,18,200})野山妖#m#u#W，和#u#G#m({蟠桃园后,10,135})山鬼#m#u#W。（ALT+A攻击怪物）',
	'  前往#Y御马监#W找#u#G#m({御马监,62,111})采星仙女#m#u#W汇报！',
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '因为下界妖气太盛，天宫的防护减弱了，蟠桃园里居然来了两只山妖捣乱，把三千年一熟的蟠桃偷吃的干干净净，我不知道如何是好，你能帮忙我去清理这些可恶的怪物吗?我会报答你的。',
    --1
    '好，包在我身上。',
    --2
    '当年的齐天大圣孙悟空也曾经管理过蟠桃园，如果他还在的话，这些小鬼山妖怎么敢来嚣张啊?',
    --3
    '呵呵，看起来你们还是很想念他的嘛。',
    --4
    '哎......还是要多谢你清理了蟠桃园，我这有个宝贝就送给你吧。'
    --5
}

function 任务:任务NPC对话(玩家, NPC)
    NPC.头像 = NPC.外形
    if NPC.名称 == '采星仙女' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            self.对话进度 = 0
            NPC.台词 = _台词[3]
            NPC.结束 = false
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '采星仙女' then
        if self.进度 == 0 then
            if self.对话进度 == 0 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[2]
                self.进度 = 1
                玩家:刷新追踪面板()
            end
        elseif self.进度 == 2 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[4]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[5]
                NPC.结束 = nil
                self:完成(玩家)
                玩家:刷新追踪面板()
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(7000)
    玩家:添加银子(100000)

    玩家:常规提示('#Y你完成了采星仙女的嘱托,得得了7000声望和100000金钱。')
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:九称完成检测(玩家, '山妖')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)

    if NPC.名称 == '野山妖' then
        if self.进度 == 1 and self.挑战.山妖 == 0 then
            self.当前目标 = '山妖'
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓9_蟠桃园的山妖.lua')
            if r then
                self.当前目标 = ''
                self.挑战.山妖 = 1
                if self.挑战.山鬼 == 1 then
                    self.进度 = 2
                    玩家:刷新追踪面板()
                end
            end
        end
    elseif NPC.名称 == '山鬼' then
        if self.进度 == 1 and self.挑战.山鬼 == 0 then
            self.当前目标 = '山鬼'
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓9_蟠桃园的山妖.lua')
            if r then
                self.当前目标 = ''
                self.挑战.山鬼 = 1
                if self.挑战.山妖 == 1 then
                    self.进度 = 2
                    玩家:刷新追踪面板()
                end
            end
        end
    end
end

local _怪物 = {
    { 名称 = "野山妖", 外形 = 2025,等级 = 90, 气血 = 183000, 魔法 = 1, 攻击 = 6888, 速度 = 299,抗性 = { 连击率 = 30, 连击次数 = 3,狂暴几率 = 10, 致命几率 = 10, 抗昏睡 = 30, 抗混乱 = 30, 抗封印 = 30 } },
    { 名称 = "野蛮王", 外形 = 2026,等级 = 90, 气血 = 163000, 魔法 = 20000, 攻击 = 3888, 速度 = 329,技能 = { '幽冥鬼火' } },
    { 名称 = "野树妖", 外形 = 2010,等级 = 90, 气血 = 263000, 魔法 = 20000, 攻击 = 2888, 速度 = 29,技能 = { '三味真火' } }
}

local __怪物 = {
    { 名称 = "山鬼", 外形 = 2025,等级 = 90, 气血 = 163000, 魔法 = 20000, 攻击 = 2888, 速度 = 329,技能 = { '幽冥鬼火' } },
    { 名称 = "鬼凤", 外形 = 2026,等级 = 90, 气血 = 163000, 魔法 = 20000, 攻击 = 2888, 速度 = 329,技能 = { '幽冥鬼火' } },
    { 名称 = "鬼龙", 外形 = 2010,等级 = 90, 气血 = 163000, 魔法 = 20000, 攻击 = 2888, 速度 = 329,技能 = { '幽冥鬼火' } }
}


function 任务:战斗初始化(玩家)
    local 当前目标
    if self.当前目标 then
        当前目标 = self.当前目标
    else
        local r = 玩家:取任务('称谓9_蟠桃园的山妖')
        if r then
            当前目标 = r.当前目标
        end
    end
    if 当前目标 then
        if 当前目标 == '山妖' then
            for i = 1, 3 do
                local r = 生成战斗怪物(_怪物[i])
                self:加入敌方(i, r)
            end
        elseif 当前目标 == '山鬼' then
            for i = 1, 3 do
                local r = 生成战斗怪物(__怪物[i])
                self:加入敌方(i, r)
            end
        end
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
