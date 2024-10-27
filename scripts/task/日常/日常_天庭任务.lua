-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-04-11 04:21:56
-- @Last Modified time  : 2024-08-26 13:36:42

local 任务 = {
    名称 = '日常_天庭任务',
    别名 = '天庭任务',
    类型 = '常规玩法',
    是否可取消 = true,
    是否可追踪 = true
}

function 任务:任务初始化()
end

function 任务:任务取详情(玩家)
    return string.format(
        '#Y任务目的:#r#W阻止御马监四个妖魔吸取天地精华。当前天庭任务是由#Y%s#W领导的挑战#r#u#G#m({%s,%s,%s})%s#m#u#Y%s#W/1次#r#u#G#m({%s,%s,%s})%s#m#u#Y%s#W/1次#r#u#G#m({%s,%s,%s})%s#m#u#Y%s#W/1次#r#u#G#m({%s,%s,%s})%s#m#u#Y%s#W/1次#r#W(剩余#R%d#W分钟)'
        , self.队长, '御马监', 103, 15, '万年熊王', self.万年熊王, '御马监', 27, 65, '三头妖王',
        self.三头妖王, '御马监', 175, 56, '蓝色妖王', self.蓝色妖王, '御马监', 137, 106, '黑山妖王',
        self.黑山妖王,
        (self.时间 - os.time()) // 60)
end

local _追踪描述 =
'阻止御马监#u#G#m({%s,%s,%s})%s#m#u#Y%s#W/1,#u#G#m({%s,%s,%s})%s#m#u#Y%s#W/1,#u#G#m({%s,%s,%s})%s#m#u#Y%s#W/1,#u#G#m({%s,%s,%s})%s#m#u#Y%s#W/1,吸取天地精华#r#W剩余时间:%s'

function 任务:任务取追踪(玩家)
    local map = 玩家:取地图(1199)
    if map then
        return string.format(_追踪描述, '御马监', 103, 15, '万年熊王', self.万年熊王, '御马监', 27, 65,
            '三头妖王', self.三头妖王, '御马监', 175, 56, '蓝色妖王', self.蓝色妖王, '御马监', 137,
            106, '黑山妖王', self.黑山妖王, os.date("!%H:%M:%S", (self.时间 - os.time()))) --任务.别名,任务.类别,
    end
end

function 任务:任务更新(sec, 玩家)
    if self.时间 <= sec then
        self:任务取消(玩家)
        self:删除()
        玩家:提示窗口('#Y你的天庭任务已超时。')
    end
end

function 任务:任务取消(玩家)
    玩家.其它.天庭次数 = 0
end

function 任务:任务更新(sec)
    if self.时间 - os.time() <= 0 then
        self:删除()
    end
end

function 任务:任务上线(玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
    end
end

function 任务:添加任务(玩家)
    if not 玩家.是否组队 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end
    -- if 玩家:取队伍人数() < 3 then
    --     玩家:常规提示('#Y需要3个人以上的组队来帮我！')
    --     return
    -- end
    local t = {}
    for _, v in 玩家:遍历队伍() do
        if v:判断等级是否低于(70) then
            table.insert(t, v.名称)
        end
    end

    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于70级,无法领取')
        return
    end

    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_天庭任务') then
            table.insert(t, v.名称)
        end
    end

    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end
    self.队伍 = {}
    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
        v.其它.天庭次数 = v.其它.天庭次数 + 1
        if v.其它.天庭次数 > 10 then
            v.其它.天庭次数 = 1
        end
        v:添加任务(self)
    end
    self.时间 = os.time() + 30 * 60
    self.队长 = 玩家.名称
    self.万年熊王 = 0
    self.三头妖王 = 0
    self.蓝色妖王 = 0
    self.黑山妖王 = 0
    self.自动数据 = {
        { "万年熊王", 0 },
        { "三头妖王", 0 },
        { "蓝色妖王", 0 },
        { "黑山妖王", 0 },
    }
    self.自动 = { 名称 = "万年熊王" }
    玩家:自动任务({ 类型 = "日常_天庭任务", id = 1199, x = 103, y = 15 })
    玩家:刷新追踪面板()
    return true
end

function 任务:完成(玩家)
    local r = 玩家:取任务('日常_天庭任务')
    if 玩家.是否组队 then
        if r then
            for _, v in 玩家:遍历队伍() do
                local rr = v:取任务('日常_天庭任务')
                if rr and r.nid == rr.nid then
                    rr:删除()
                    --self:掉落包(v, v.其它.天庭次数, 1)
                end
            end
        end
        for _, nid in ipairs(self.队伍) do
            local r = 玩家:取玩家(nid)
            if r then
                local w = 玩家:取任务('日常_天庭任务')
                if w then
                    w:删除()
                end
            end
        end
    elseif r then
        self:删除()
    end
    玩家:刷新追踪面板()
end

function 任务:掉落包(玩家, 次数)
    local 银子 = math.floor(2000 * (1 + 次数 * 0.22))
    --local 师贡 = 20000
    local 经验 = math.floor((13000 + 玩家.等级 * 600) * (1 + 次数 * 0.13))
    local r = 玩家:取任务('引导_天庭任务')
    if r then
        r:添加进度(玩家)
    end
    
    if 玩家:判断等级是否高于(142) then
        玩家:添加参战召唤兽经验(经验, "日常_天庭任务")
        -- 玩家:常规提示("#Y适合任务90-142级玩家参与！")
        return
    end
    玩家:添加任务经验(经验, "天庭")
    玩家:添加银子(银子, "天庭")
    --玩家:添加师贡(师贡)
    玩家:添加活力(15)

    local 奖励 = 是否奖励(1006, 玩家.等级, 玩家.转生)
    if 次数 == 10 then
        奖励 = 是否奖励(1005, 玩家.等级, 玩家.转生)
    end
    if 奖励 ~= nil and type(奖励) == 'table' then
        local r = 生成物品 { 名称 = 奖励.道具信息.道具, 数量 = 奖励.道具信息.数量, 参数 = 奖励
            .道具信息.参数 }
        if r then
            玩家:添加物品({ r })
            if 奖励.道具信息.是否广播 == 1 and 奖励.广播 ~= nil then
                玩家:发送系统(奖励.广播, 玩家.名称, r.ind, r.名称)
            end
        end
    end
end

function 任务:打败怪物(玩家, 名称)
    self[名称] = 1
    self:掉落包(玩家, 玩家.其它.天庭次数)
    if self.万年熊王 == 1 and self.三头妖王 == 1 and self.蓝色妖王 == 1 and self.黑山妖王 == 1 then
        玩家:增加活动限制次数('天庭任务')
        self:完成(玩家)
    end
end

--===============================================

local _台词 = '没想到，居然还是让你们找到了本王\nmenu\n1|妖孽，看剑#126\n2|我认错妖了。#76'
function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '万年熊王' and NPC.台词 then
        if self.万年熊王 == 0 then
            NPC.台词 = _台词
        end
    elseif NPC.名称 == '三头妖王' and NPC.台词 then
        if self.三头妖王 == 0 then
            NPC.台词 = _台词
        end
    elseif NPC.名称 == '蓝色妖王' and NPC.台词 then
        if self.蓝色妖王 == 0 then
            NPC.台词 = _台词
        end
    elseif NPC.名称 == '黑山妖王' and NPC.台词 then
        if self.黑山妖王 == 0 then
            NPC.台词 = _台词
        end
    end
end

local _npc = {
    万年熊王 = 1,
    三头妖王 = 2,
    蓝色妖王 = 3,
    黑山妖王 = 4,
}
local _自动排序 = {
    万年熊王 = { 类型 = "日常_天庭任务", id = 1199, x = 103, y = 15 },
    三头妖王 = { 类型 = "日常_天庭任务", id = 1199, x = 27, y = 65 },
    蓝色妖王 = { 类型 = "日常_天庭任务", id = 1199, x = 175, y = 56 },
    黑山妖王 = { 类型 = "日常_天庭任务", id = 1199, x = 137, y = 106 },
}

function 任务:任务NPC菜单(玩家, NPC, i)
    -- print('任务NPC菜单')
    -- table.print(NPC)
    if not _npc[NPC.名称] then
        return
    end
    if i == '1' then
        local r = 玩家:进入战斗('scripts/task/日常/日常_天庭任务.lua', NPC)
        if r then
            self.自动数据[_npc[NPC.名称]][2] = 1
            for _, v in ipairs(self.自动数据) do
                if v[2] == 0 then
                    self.自动 = { 名称 = v[1] }
                    玩家:自动任务(_自动排序[v[1]])
                    return
                end
            end
        end
        玩家:自动任务_战斗结束(r)
    end
end

--===============================================

local 外形表 = { 2023, 2008, 2019, 2021, 2038, 2024, 2068, 2060, 2041, 2014 }
local 技能表 = { { "魔音摄心", "追神摄魄", "夺命勾魂" }, { "雷神怒击", "日照光华", "雷霆霹雳" },
    { "三味真火", "地狱烈火", "天雷怒火" }, { "断肠烈散", "蛇蝎美人", "追魂迷香" },
    { "魔音摄心", "魔之飞步", "急速之魔" }, { "龙啸九天", "龙卷雨击", "龙腾水溅" },
    { "太乙生风", "飞砂走石", "乘风破浪" }, { "情真意切", "谗言相加", "反间之计" },
    { "雷神怒击", "雷霆霹雳", "日照光华" }, { "三味真火", "地狱烈火", "天雷怒火" } }

local function 取万年熊王信息(玩家, 等级, 转生)
    local 战斗单位 = {
        {
            名称 = "万年熊王",
            外形 = 6551,
            等级 = 等级,
            血初值 = 2100,
            法初值 = 0,
            攻初值 = 1500,
            敏初值 = 80,
            -- 内丹 = {{ 技能 = "浩然正气", 转生 = 2, 等级 = 70 }},
            是否消失 = false
        }
    }
    战斗单位[1].抗性 = {}
    战斗单位[1].抗性.连击率 = 50
    战斗单位[1].抗性.连击次数 = 3
    战斗单位[1].抗性.忽视防御几率 = 60
    战斗单位[1].抗性.忽视防御程度 = 60
    战斗单位[1].抗性.物理吸收 = 40
    战斗单位[1].抗性.抗混乱 = 50
    战斗单位[1].抗性.抗封印 = 25
    战斗单位[1].抗性.抗遗忘 = 25
    战斗单位[1].抗性.抗昏睡 = 20
    战斗单位[1].抗性.抗风 = 10
    战斗单位[1].抗性.抗水 = 10
    战斗单位[1].抗性.抗雷 = 10
    战斗单位[1].抗性.抗火 = 10
    战斗单位[1].抗性.抗鬼火 = 10
    for n = 2, 5 do
        战斗单位[n] = {
            名称 = "喽啰",
            外形 = 外形表[math.random(#外形表)],
            等级 = 等级,
            血初值 = 1200,
            法初值 = 500,
            攻初值 = 20,
            敏初值 = 50,
            施法几率 = 50,
            是否消失 = false,
            -- 内丹 = {{ 技能 = "浩然正气", 转生 = 2, 等级 = 70 }},
            技能 = 技能表[math.random(#技能表)]
        }
    end
    return 战斗单位
end

local function 取三头妖王信息(玩家, 等级, 转生)
    local 战斗单位 = {
        {
            名称 = "三头妖王",
            外形 = 2074,
            等级 = 等级,
            血初值 = 1700,
            法初值 = 800,
            攻初值 = 84,
            敏初值 = 80,
            施法几率 = 50,
            是否消失 = false,
            -- 内丹 = {{ 技能 = "浩然正气", 转生 = 2, 等级 = 70 }},
            技能 = { { 名称 = '天诛地灭', 熟练 = 6000 } },
        }
    }
    for n = 2, 5 do
        战斗单位[n] = {
            名称 = "喽啰",
            外形 = 外形表[math.random(#外形表)],
            等级 = 等级,
            血初值 = 1200,
            法初值 = 500,
            攻初值 = 20,
            敏初值 = 50,
            施法几率 = 50,
            是否消失 = false,
            -- 内丹 = {{ 技能 = "浩然正气", 转生 = 2, 等级 = 70 }},
            技能 = 技能表[math.random(#技能表)]
        }
    end
    return 战斗单位
end

local function 取蓝色妖王信息(玩家, 等级, 转生)
    local 战斗单位 = {
        {
            名称 = "蓝色妖王",
            外形 = 6550,
            等级 = 等级,
            血初值 = 1700,
            法初值 = 800,
            攻初值 = 84,
            敏初值 = 80,
            施法几率 = 50,
            是否消失 = false,
            -- 内丹 = {{ 技能 = "浩然正气", 转生 = 2, 等级 = 70 }},
            技能 = { { 名称 = '失心狂乱', 熟练 = 6000 } },
        }
    }
    for n = 2, 5 do
        战斗单位[n] = {
            名称 = "喽啰",
            外形 = 外形表[math.random(#外形表)],
            等级 = 等级,
            血初值 = 1200,
            法初值 = 500,
            攻初值 = 20,
            敏初值 = 50,
            施法几率 = 50,
            是否消失 = false,
            -- 内丹 = {{ 技能 = "浩然正气", 转生 = 2, 等级 = 70 }},
            技能 = 技能表[math.random(#技能表)]
        }
    end
    return 战斗单位
end

local function 取黑山妖王信息(玩家, 等级, 转生)
    local 战斗单位 = {
        {
            名称 = "黑山妖王",
            外形 = 2073,
            等级 = 等级,
            血初值 = 1700,
            法初值 = 800,
            攻初值 = 84,
            敏初值 = 80,
            施法几率 = 50,
            是否消失 = false,
            -- 内丹 = {{ 技能 = "浩然正气", 转生 = 2, 等级 = 70 }},
            技能 = { { 名称 = '万毒攻心', 熟练 = 4000 } },
        }
    }
    for n = 2, 5 do
        战斗单位[n] = {
            名称 = "喽啰",
            外形 = 外形表[math.random(#外形表)],
            等级 = 等级,
            血初值 = 1200,
            法初值 = 500,
            攻初值 = 20,
            敏初值 = 50,
            施法几率 = 50,
            是否消失 = false,
            -- 内丹 = {{ 技能 = "浩然正气", 转生 = 2, 等级 = 70 }},
            技能 = 技能表[math.random(#技能表)]
        }
    end
    return 战斗单位
end

function 任务:战斗初始化(玩家, NPC)
    local 等级 = 玩家:取队伍最高等级()
    local 转生 = 玩家:取队伍最高转生()
    if NPC.名称 == "万年熊王" then
        local t = 取万年熊王信息(玩家, 等级, 转生)
        for k, v in pairs(t) do
            local 难度 = '简单'
            if k == 1 then
                难度 = nil
            end
            local r = 生成战斗怪物(生成怪物属性(v, 难度))
            self:加入敌方(k, r)
        end
    elseif NPC.名称 == "三头妖王" then
        local t = 取三头妖王信息(玩家, 等级, 转生)
        for k, v in pairs(t) do
            local 难度 = '简单'
            if k == 1 then
                难度 = '中等'
            end
            local r = 生成战斗怪物(生成怪物属性(v, 难度))
            self:加入敌方(k, r)
        end
    elseif NPC.名称 == "蓝色妖王" then
        local t = 取蓝色妖王信息(玩家, 等级, 转生)
        for k, v in pairs(t) do
            local 难度 = '简单'
            if k == 1 then
                难度 = '中等'
            end
            local r = 生成战斗怪物(生成怪物属性(v, 难度))
            self:加入敌方(k, r)
        end
    elseif NPC.名称 == "黑山妖王" then
        local t = 取黑山妖王信息(玩家, 等级, 转生)
        for k, v in pairs(t) do
            local 难度 = '简单'
            if k == 1 then
                难度 = '中等'
            end
            local r = 生成战斗怪物(生成怪物属性(v, 难度))
            self:加入敌方(k, r)
        end
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(s)
    if s then
        local zg = self:取对象(11)
        if zg then
            for k, v in self:遍历我方() do
                if v.是否玩家 then
                    local r = v.对象.接口:取任务("日常_天庭任务")
                    local z = v.对象.接口:取乘骑坐骑()
                    if z then
                        z:添加经验(5)
                        z:添加熟练(5)
                    end
                    if r then
                        r:打败怪物(v.对象.接口, zg.名称)
                    end
                end
            end
        end
    end
end

return 任务
