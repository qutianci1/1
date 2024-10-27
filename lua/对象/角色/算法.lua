-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-06 09:00:17
-- @Last Modified time  : 2024-10-18 14:57:52
local MYF = require('我的函数')
local 角色 = require('角色')

function 角色:刷新属性(来源)
    self.抗性 = MYF.容错表 {}
    self:装备抗性计算()
    self:帮派抗性计算()
    self:天生抗性计算()
    self:修正属性计算()
    self:基础属性计算()
    self:附加属性计算()
    self:抗性上限计算()
    self:法宝组合计算()
    self.最大经验 = self:取升级经验()
    self.召唤兽携带上限 = 10 + self.转生 * 3
    self.最大体力=10*(60+self.等级+50*self.转生)
    if self.气血 > self.最大气血 or self.气血 == 0 then
        self.气血 = self.最大气血
    end
    if self.魔法 > self.最大魔法 or self.魔法 == 0 then
        self.魔法 = self.最大魔法
    end
    if 来源 == 1 then
        self.气血 = self.最大气血
        self.魔法 = self.最大魔法
    end
end

--15点抗性,每个法宝最高5点,以100级为上限
function 角色:法宝组合计算()
    local 参战表, 阴阳表 = {}, {}
    for k,v in pairs(self.法宝) do
        if v.参战 ~= 0 then
            table.insert(参战表, k)
            阴阳表[v.参战] = v.阴阳
        end
    end
    if #参战表 >= 3 then
        local 数值 = 0
        local 抗性 = '抗'..self:角色_取卦象(阴阳表)
        for i=1,3 do
            if self.法宝[参战表[i]] then
                数值 = 数值 + self.法宝[参战表[i]].等级 * 0.05
            end
        end
        if 抗性 then
            self.抗性[抗性] = self.抗性[抗性] + 数值
        end
    end
end

function 角色:角色_取卦象(yinyangTable)
    local guaMap = {
        {"阳", "阳", "阳"},  -- 乾为天
        {"阴", "阴", "阴"},  -- 坤为地
        {"阴", "阴", "阳"},  -- 震为雷
        {"阳", "阳", "阴"},  -- 巽为风
        {"阳", "阴", "阴"},  -- 艮为山
        {"阴", "阳", "阳"},  -- 兑为泽
        {"阴", "阳", "阴"},  -- 坎为水
        {"阳", "阴", "阳"}   -- 离为火
    }
    local guaIndex = -1
    for i, gua in ipairs(guaMap) do
        local match = true
        for j, yinyang in ipairs(gua) do
            if yinyang ~= yinyangTable[j] then
                match = false
                break
            end
        end
        if match then
            guaIndex = i
            break
        end
    end
    if guaIndex ~= -1 then
        local 抗性 = ""
        if guaIndex == 1 then
          抗性 = '封印'
        elseif guaIndex == 2 then
          抗性 = '混乱'
        elseif guaIndex == 3 then
          抗性 = '雷'
        elseif guaIndex == 4 then
          抗性 = '风'
        elseif guaIndex == 5 then
          抗性 = '昏睡'
        elseif guaIndex == 6 then
          抗性 = '中毒'
        elseif guaIndex == 7 then
          抗性 = '水'
        elseif guaIndex == 8 then
          抗性 = '火'
        end
        return 抗性
    else
        return
    end
end

function 角色:装备抗性计算()
    if self.装备抗性 then
        for k, v in pairs(self.装备抗性) do
            self.抗性[k] = self.抗性[k] + v
        end
    end
    local 上限抗性 = {'抗风','抗火','抗水','抗雷','抗鬼火','抗震慑','抗震慑气血','抗震慑魔法','物理吸收','连击率','致命几率','反击率','狂暴几率','命中率','躲闪率','反震率','反震程度'}
    for k,v in pairs(self.抗性) do
        for i=1,#上限抗性 do
            if k == 上限抗性[i] then
                if self.抗性[k] > 75 then
                    self.抗性[k] = 75
                end
            end
        end
    end
end

function 角色:附加属性计算()
    self.最大气血 = math.floor(self.最大气血 + self.装备属性.附加气血)
    self.最大气血 = math.floor(self.最大气血 * (1 + self.抗性.HP成长))
    self.最大气血 = math.floor(self.最大气血 * (1 + self.装备属性.气血增加率 * 0.01))

    self.最大魔法 = math.floor(self.最大魔法 + self.装备属性.附加魔法)
    self.最大魔法 = math.floor(self.最大魔法 * (1 + self.抗性.MP成长))
    self.最大魔法 = math.floor(self.最大魔法 * (1 + self.装备属性.魔法增加率 * 0.01))

    self.攻击 = math.floor(self.攻击 + self.装备属性.基础攻击)
    self.攻击 = math.floor(self.攻击 + self.装备属性.附加攻击)
    self.攻击 = math.floor(self.攻击 + (1 + self.装备属性.攻击加成 * 0.01))

    self.速度 = math.floor(self.速度 + self.装备属性.速度 )
    self.速度 = math.floor(self.速度 + self.装备属性.附加速度 )
    self.速度 = math.floor(self.速度 * (1 + self.抗性.SP成长))
end

function 角色:帮派抗性计算()
    if not self.帮派数据.帮派贡献 then
        return
    end
    if not self.帮派数据.守护神 then
        return
    end
    local 主守护,辅守护,震慑守护 = self:获取帮派贡献(self.帮派数据.帮派贡献)
    local 守护表 = {'狂风战神','天雷战神','沧海战神','烈火战神','混乱战神','封印战神','昏睡战神','猛毒战神','鬼火战神','遗忘战神','三尸战神','大力战神','震慑战神'}
    local 抗性表 = {'抗风','抗雷','抗水','抗火','抗混乱','抗封印','抗昏睡','抗中毒','抗鬼火','抗遗忘','抗三尸虫','物理吸收','抗震慑'}
    local a,b
    for i=1,#守护表 do
        if self.帮派数据.守护神.主守护 == 守护表[i] then
            a = i
        elseif self.帮派数据.守护神.辅守护 == 守护表[i] then
            b = i
        end
    end
    if not a or not b then
        return
    end
    if 抗性表[a] then
        if 抗性表[a] == '抗震慑' then
            self.抗性[抗性表[a]] = self.抗性[抗性表[a]] + math.floor(震慑守护 * 100) /100
        else
            self.抗性[抗性表[a]] = self.抗性[抗性表[a]] + math.floor(主守护 * 100) / 100
        end
    end
    if 抗性表[b] then
        self.抗性[抗性表[b]] = self.抗性[抗性表[b]] + math.floor(辅守护 * 100) / 100
    end
end

function 角色:获取帮派贡献(贡献)
    -- 守护神抗性数据
    local 数据 = {
        {1, 0,0, 500},
        {2, 1,0.3, 4000},
        {3, 1,0.6, 13500},
        {4, 2,0.9, 32000},
        {5, 2,1.2, 62500},
        {6, 3,1.5, 108000},
        {7, 3,1.8, 171500},
        {8, 4,2.1, 256000},
        {9, 4,2.4, 364500},
        {10, 5,2.7, 500000},
        {11, 5,3, 665500},
        {12, 6,3.3, 864000},
        {13, 6,3.6, 1098500},
        {14, 7,3.9, 1372000},
        {15, 7,4.2, 1687500},
        {16, 8,4.5, 2048000},
        {17, 8,4.8, 2456500},
        {18, 9,5.1, 2916000},
        {19, 9,5.4, 3429500},
        {20, 10,5.7, 4000000},
        {21, 10,6, 4630500},
        {22, 11,6.3, 5324000},
        {23, 11,6.6, 6083500},
        {24, 12,6.9, 6912000},
        {25, 12,7.2, 7812500},
        {26, 13,7.5, 8788000},
        {27, 13,7.8, 9841500},
        {28, 14,8.1, 10976000},
        {29, 14,8.3, 12194500},
        {30, 15,9, 13500000}
    }
    if 贡献 == 0 then
        return 0,0,0
    end
    if 贡献 >= 13500000 then
        return 30,15,9
    end
    -- 查找目标行
    local 行数 = #数据
    while 行数 > 1 and 数据[行数][4] > 贡献 do
        行数 = 行数 - 1
    end
    -- 计算插值系数
    local 本级贡献 = 数据[行数][4]
    local 下级贡献 = 数据[行数 + 1][4]
    local coef1 = (下级贡献 - 贡献) / (下级贡献 - 本级贡献)
    local coef2 = 1 - coef1
    -- 计算守护神抗性
    local 辅守护 = 数据[行数][2] * coef1 + 数据[行数 + 1][2] * coef2
    local 主守护 = 数据[行数][1] * coef1 + 数据[行数 + 1][1] * coef2
    local 震慑守护 = 数据[行数][3] * coef1 + 数据[行数 + 1][3] * coef2
    -- 返回结果
    return 主守护,辅守护,震慑守护
end

function 角色:天生抗性计算()
    local 临时等级=self.等级
    if 临时等级>162 then 临时等级=162 end
    if self.种族 == 1 then --'人'
        self.抗性.抗混乱 = self.抗性.抗混乱+临时等级 * 0.25
        self.抗性.抗封印 = self.抗性.抗封印+临时等级 * 0.25
        self.抗性.抗昏睡 = self.抗性.抗昏睡+临时等级 * 0.25
        self.抗性.抗中毒 = self.抗性.抗中毒+临时等级 * 0.25
    elseif self.种族 == 2 then --'魔'
        self.抗性.物理吸收 = self.抗性.物理吸收+临时等级 * 0.125
        self.抗性.抗混乱 = self.抗性.抗混乱+临时等级 * 0.125
        self.抗性.抗封印 = self.抗性.抗封印+临时等级 * 0.125
        self.抗性.抗昏睡 = self.抗性.抗昏睡+临时等级 * 0.125
        self.抗性.抗中毒 = self.抗性.抗中毒+临时等级 * 0.125
        self.抗性.抗风 = self.抗性.抗风+临时等级 * 0.083
        self.抗性.抗火 = self.抗性.抗火+临时等级 * 0.083
        self.抗性.抗水 = self.抗性.抗水+临时等级 * 0.083
        self.抗性.抗雷 = self.抗性.抗雷+临时等级 * 0.083
        self.抗性.致命几率 = self.抗性.致命几率+5
        self.抗性.狂暴几率 = self.抗性.狂暴几率+5
    elseif self.种族 == 3 then --'仙'
        self.抗性.抗风 = self.抗性.抗风+临时等级 * 0.25
        self.抗性.抗火 = self.抗性.抗火+临时等级 * 0.25
        self.抗性.抗水 = self.抗性.抗水+临时等级 * 0.25
        self.抗性.抗雷 = self.抗性.抗雷+临时等级 * 0.25
    elseif self.种族 == 4 then --'鬼'
        self.抗性.躲闪率 = self.抗性.躲闪率+临时等级 * 0.25
        self.抗性.抗混乱 = self.抗性.抗混乱+临时等级 * 0.166
        self.抗性.抗封印 = self.抗性.抗封印+临时等级 * 0.166
        self.抗性.抗昏睡 = self.抗性.抗昏睡+临时等级 * 0.166
        self.抗性.抗中毒 = self.抗性.抗中毒+临时等级 * 0.166
        self.抗性.抗遗忘 = self.抗性.抗遗忘+临时等级 * 0.166
        self.抗性.抗鬼火 = self.抗性.抗鬼火+临时等级 * 0.166
        self.抗性.抗三尸虫 = self.抗性.抗三尸虫+临时等级 * 120
        self.抗性.命中率 = self.抗性.命中率+临时等级 * 0.083

        self.抗性.抗风 = self.抗性.抗风 - 临时等级 * 0.125
        self.抗性.抗火 = self.抗性.抗火 - 临时等级 * 0.125
        self.抗性.抗水 = self.抗性.抗水 - 临时等级 * 0.125
        self.抗性.抗雷 = self.抗性.抗雷 - 临时等级 * 0.125
        self.抗性.上善若水 = self.抗性.上善若水-临时等级*100
    end
end

local 修正 = {
    [1001] = {
        {抗混乱 = 10.25, 抗封印 = 10.25, 抗昏睡 = 10.25},
        {抗混乱 = 15.37, 抗封印 = 15.37, 抗昏睡 = 15.37},
        {抗混乱 = 20.5, 抗封印 = 20.5, 抗昏睡 = 20.5}
    },
    [1002] = {
        {抗中毒 = 13.83, 抗毒伤害 = 820, 抗封印 = 10.25, 抗昏睡 = 10.25},
        {抗中毒 = 20.83, 抗毒伤害 = 1230, 抗封印 = 15.37, 抗昏睡 = 15.37},
        {抗中毒 = 27.67, 抗毒伤害 = 1640, 抗封印 = 20.5, 抗昏睡 = 20.5}
    },
    [2001] = {
        {HP成长 = 0.082, MP成长 = 0.082, SP成长 = 0.061},
        {HP成长 = 0.123, MP成长 = 0.123, SP成长 = 0.092},
        {HP成长 = 0.164, MP成长 = 0.164, SP成长 = 0.123}
    },
    [2002] = {
        {HP成长 = 0.082, MP成长 = 0.082, 物理吸收 = 15.37, 抗震慑 = 9.21},
        {HP成长 = 0.123, MP成长 = 0.123, 物理吸收 = 23.05, 抗震慑 = 13.82},
        {HP成长 = 0.164, MP成长 = 0.164, 物理吸收 = 30.74, 抗震慑 = 18.42}
    },
    [3001] = {
        {抗水 = 13.83, 抗雷 = 13.83, 抗风 = 13.83},
        {抗水 = 20.75, 抗雷 = 20.75, 抗风 = 20.75},
        {抗水 = 27.67, 抗雷 = 27.67, 抗风 = 27.67}
    },
    [3002] = {
        {抗水 = 13.83, 抗雷 = 13.83, 抗火 = 13.83},
        {抗水 = 20.75, 抗雷 = 20.75, 抗火 = 20.75},
        {抗水 = 27.67, 抗雷 = 27.67, 抗火 = 27.67}
    },
    [4001] = {
        {抗鬼火 = 13.84, 抗遗忘 = 10.25, 抗三尸虫 = 2050},
        {抗鬼火 = 20.76, 抗遗忘 = 15.38, 抗三尸虫 = 3075},
        {抗鬼火 = 27.68, 抗遗忘 = 20.5, 抗三尸虫 = 4100}
    },
    [4002] = {
        {抗鬼火 = 13.84, 抗遗忘 = 10.25, 反震率 = 5.13, 反震程度 = 10.25},
        {抗鬼火 = 20.76, 抗遗忘 = 15.38, 反震率 = 7.69, 反震程度 = 15.38},
        {抗鬼火 = 27.68, 抗遗忘 = 20.5, 反震率 = 10.25, 反震程度 = 20.5}
    }
}
function 角色:修正属性计算()
    if self.转生记录 then
        for k, v in pairs(self.转生记录) do
            for y, a in pairs(修正[v][k]) do
                self.抗性[y] = self.抗性[y] + a
            end
        end
    end
end

function 角色:刷新装备属性()
    self.装备属性 = MYF.容错表 {}
    self.装备抗性 = MYF.容错表 {}
    for _, v in pairs(self.装备) do
        if v.是否有效 ~= false then
            v:穿上(self)
        end
    end
    -- table.print(self.装备属性)
    self:刷新属性()
end

function 角色:检查装备()
    local list = {}
    for _, v in pairs(self.装备) do
        if v.是否有效 ~= false and v:检查要求(self) ~= true then
            v:脱下(self)
            table.insert(list, v.名称)
        end
    end
    if #list > 0 then
        --你的%s不够，不能装备%s。
        self.rpc:提示窗口('#R%s#W不满足穿带要求！', table.concat(list, ', '))
    end
end

function 角色:基础属性计算()
    local e = (100 - self.等级) / 5
    local 根骨 = self.装备属性.根骨 + self.根骨
    local 灵性 = self.装备属性.灵性 + self.灵性
    local 力量 = self.装备属性.力量 + self.力量
    local 敏捷 = self.装备属性.敏捷 + self.敏捷
    -- print(根骨)
    if self.种族 == 1 then --'人'
        self.最大气血 = (self.等级 + e) * 根骨 * 1.2 + 360
        self.最大魔法 = (self.等级 + e) * 灵性 * 1 + 300
        self.攻击 = (self.等级 + e) * 力量 * 0.95 / 5 + 70
        self.速度 = (10 + 敏捷) * 0.8
    elseif self.种族 == 2 then --魔
        self.最大气血 = (self.等级 + e) * 根骨 * 1.1 + 330
        self.最大魔法 = (self.等级 + e) * 灵性 * 0.6 + 210
        self.攻击 = (self.等级 + e) * 力量 * 1.3 / 5 + 80
        self.速度 = (10 + 敏捷) * 1
    elseif self.种族 == 3 then --仙
        self.最大气血 = (self.等级 + e) * 根骨 * 1 + 300
        self.最大魔法 = (self.等级 + e) * 灵性 * 1.4 + 390
        self.攻击 = (self.等级 + e) * 力量 * 0.7 / 5 + 70
        self.速度 = (10 + 敏捷) * 1
    elseif self.种族 == 4 then --鬼
        self.最大气血 = (self.等级 + e) * 根骨 * 1.25 + 270
        self.最大魔法 = (self.等级 + e) * 灵性 * 1.05 + 350
        self.攻击 = (self.等级 + e) * 力量 * 0.95 / 5 + 80
        self.速度 = (10 + 敏捷) * 0.85
    end
end

local 抗性上限 = {
    {抗封印 = 140, 抗昏睡 = 140, 抗混乱 = 140, 抗遗忘 = 140, 抗中毒 = 100},
    {抗封印 = 110, 抗昏睡 = 110, 抗混乱 = 110, 抗遗忘 = 110, 抗中毒 = 110},
    {抗封印 = 110, 抗昏睡 = 110, 抗混乱 = 110, 抗遗忘 = 110, 抗中毒 = 110},
    {抗封印 = 120, 抗昏睡 = 120, 抗混乱 = 120, 抗遗忘 = 140, 抗中毒 = 110}
}
setmetatable(
    抗性上限,
    {
        __index = function(_, v)
            print('种族不存在', v)
            return {}
        end
    }
)
function 角色:抗性上限计算()
    local 临时上限=0--此处为预留 飞升后人族每10级提高1点抗性上限接口
    if self.种族==1 then
    end
    for k, v in pairs(抗性上限[self.种族]) do
        if self.抗性[k] > v then
            self.抗性[k] = v
        end
    end
end

function 角色:取升级经验()
    local JYK = require('数据库/经验库')
    local 数值 = 10
    数值 = JYK.人物经验库[self.转生 + 1][self.等级 + 1]

    if self.飞升 ~= 0 then
        数值 = JYK.人物经验库[5][self.等级 + 1 - 140]
    end
    if 数值 == nil then
        return 999999999999
    end
    return 数值
end

local 转生值 = {102, 122, 142, 180}
function 角色:取等级上限()
    if self.飞升 ~= 0 and self.等级 >= 200 then
        return true
    end

    if self.飞升 == 0 then
        if self.等级 >= 转生值[self.转生 + 1] then
            local r = self:取升级经验()
            if self.经验 > r then
                self.经验 = r - 1
            end
            return true
        end
    end

    return false
end
