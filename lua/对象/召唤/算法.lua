-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-06 09:00:00
-- @Last Modified time  : 2024-08-28 23:05:00

local MYF = require('我的函数')
local 召唤 = require('召唤')

function 召唤:属性_初始化(t)
    if type(t) == 'table' then
        for i, v in ipairs(self.天生技能) do --写入天生技能的位置，不进入技能栏战斗中无法显示。
            table.insert(self.技能, require('对象/法术/技能')({ 名称 = v }))
        end
        ------------
        for i, v in ipairs(self.领悟技能) do --写入天生技能的位置，不进入技能栏战斗中无法显示。
            table.insert(self.技能, require('对象/法术/技能')({ 名称 = v }))
        end
        if type(self.内丹) == 'table' then
            for i, v in ipairs(self.内丹) do
                self.内丹[i] = require('对象/法术/内丹')(v)
            end
        end
    end

    self:刷新属性(t)
    self.顺序 = 1
end

function 召唤:刷新属性()
    self.抗性 = MYF.容错表()
    ---------------计算成长----------------------

    for k, v in pairs(self.天生抗性) do
        self.抗性[k] = self.抗性[k] + v
    end
    for k, v in pairs(self.其它属性.抗性) do
        self.抗性[k] = self.抗性[k] + v
    end
    --self.抗性.防御 = self.等级 * 120
    self:亲密抗性计算()
    self:炼妖属性计算()
    self.最大气血 = math.ceil(self.成长 * self.等级 * (0.7 * self.初血 + self.根骨) + self.初血)
    self.最大魔法 = math.ceil(self.成长 * self.等级 * (0.7 * self.初法 + self.灵性) + self.初法)
    self.攻击 = math.ceil(self.成长 * 0.2 * self.等级 * (0.7 * self.初攻 + self.力量) + self.初攻)
    self.速度 = math.ceil((self.敏捷 + self.初敏) * self.成长)
    self.最大经验 = self:取升级经验()
    self:技能计算()
    for k, v in pairs(self.其它属性) do
        if k ~= '抗性' then
            self[k] = self[k] + v
        end
    end
    ----------------------------------
    if self.气血 > self.最大气血 then
        self.气血 = self.最大气血
    end
    if self.魔法 > self.最大魔法 then
        self.魔法 = self.最大魔法
    end
    self.最大气血 = math.ceil(self.最大气血)
    self.最大魔法 = math.ceil(self.最大魔法)
    self.攻击 = math.ceil(self.攻击)
    self.速度 = math.ceil(self.速度)
    local 抗性上限类 = {'抗水','抗雷','抗火','抗风','抗封印','抗混乱','抗昏睡','抗中毒','抗遗忘','抗鬼火'}
    for i=1,#抗性上限类 do
        if self.抗性[抗性上限类[i]] > 75 then
            self.抗性[抗性上限类[i]] = 75
        end
    end
    --下方为坐骑管制抗性,上限95

    if self.被管制 then
        local zj = __坐骑[self.被管制]
        if zj then
            for k, v in pairs(zj.技能) do
                v:计算(zj, self)
            end
        else
            self.被管制 = nil
        end
    end
    -- self.抗性.连击率 = 99
end

function 召唤:神之石洗点(属性)
    if self[属性] then
        if self[属性] > self.等级 + 10 then
            self[属性] = self[属性] - 10
            self.潜力 = self.潜力 + 10
            self:刷新属性()
            return true
        end
    end
end

function 召唤:亲密抗性计算()
    self.抗性.致命几率 = 3 + 0.1 * (self.亲密 / 10000)
    if self.抗性.致命几率 > 8 then
        self.抗性.致命几率 = 8
    end
    self.抗性.连击率 = 3 + 0.18 * (self.亲密 / 10000)
    if self.抗性.连击率 > 12 then
        self.抗性.连击率 = 12
    end
    self.抗性.连击次数 = 3 + math.floor(0.18 * (self.亲密 / 10000))
    if self.抗性.连击次数 > 9 then
        self.抗性.连击次数 = 9
    end
end

function 召唤:炼妖属性计算()
    for k, v in pairs(self.炼妖) do
        for q,w in pairs(v) do
            if self.抗性[q] then
                self.抗性[q] = self.抗性[q] + w
            end
        end
    end
end

function 召唤:取升级经验()
    local YJK = require('数据库/经验库')
    local r = 0
    if self.点化 == 0 then
        r = YJK.召唤兽经验库[self.等级 + 1]
    else
        r = YJK.召唤兽飞升经验库[self.等级 + 1]
    end
    return r or 99999999
end

function 召唤:取等级上限()-- true 不可升级 false可升级
    local t = { 100, 120, 140, 170 }
    if self.等级>=t[self.转生 + 1] then
        if self.经验 >= self.最大经验 then
            self.经验 = self.最大经验
        end
        return true
    end
    if self.主人.转生==0 then--未转人物,召唤兽不可超过主人15级
        if self.等级 > self.主人.等级 + 15 then
            return true
        else
            return false
        end
    else--已转人物
        if self.等级>160 then--召唤兽160级时主人必须等级高于自己
            if self.等级 > self.主人.等级 then
                return true
            else
                return false
            end
        else
            return false
        end
    end
    return false
end

function 召唤:技能计算()
    local 亲密 = math.floor(self.亲密 / 10000)
    if 亲密 > 5000 then
        亲密 = 5000
    end
    for k, v in pairs(self.技能) do
        if v.名称 == '蹒跚' then
            self.速度 = math.floor(self.速度 - 150 - 亲密 * 0.035)
        elseif v.名称 == '潮鸣电掣' then
            self.速度 = math.floor(self.速度 + 300 + 亲密 * 0.12)
        elseif v.名称 == '倍道兼行' then
            if not self:取技能是否存在('潮鸣电掣') and not self:取技能是否存在('神出鬼没') then
                self.速度 = math.floor(self.速度 + 170)
            end
        elseif v.名称 == '神工鬼力' then --神工鬼力
            if not self:取技能是否存在('鬼神莫测') then
                self.攻击 = math.floor(self.攻击 + 8528)
            end
        elseif v.名称 == '源泉万斛' then
            self.最大魔法 = math.floor(self.最大魔法 + 13598)
        elseif v.名称 == '帐饮东都' then
            if not self:取技能是否存在('大隐于朝') then
                self.最大气血 = math.floor(self.最大气血 + 21000)
            end
        elseif v.名称 == '大隐于朝' then
            if not self:取技能是否存在('潮鸣电掣') then
                self.最大气血 = math.floor(self.最大气血 + 21000 + 亲密 * 13)
            end
        elseif v.名称 == '鬼神莫测' then
            if not self:取技能是否存在('潮鸣电掣') then
                self.攻击 = math.floor(self.攻击 + 8528 + 亲密 * 3.6)
            end
        elseif v.名称 == '神出鬼没' then
            if not self:取技能是否存在('潮鸣电掣') then
                self.速度 = math.floor(self.速度 + 170 + 亲密 * 0.1)
            end
        elseif v.名称 == '仁之木叶神' or v.名称 == '智之水叶神' or v.名称 == '礼之火叶神' or v.名称 == '日月重光' then
            self.抗性.抗封印 = math.floor(self.抗性.抗封印 + 15)
            self.抗性.抗混乱 = math.floor(self.抗性.抗混乱 + 15)
            self.抗性.抗遗忘 = math.floor(self.抗性.抗遗忘 + 15)
        elseif v.名称 == '灵犀诀' then
            self.抗性.抗封印 = math.floor(self.抗性.抗封印 + 8)
            self.抗性.抗混乱 = math.floor(self.抗性.抗混乱 + 8)
            self.抗性.抗遗忘 = math.floor(self.抗性.抗遗忘 + 8)
        elseif v.名称 == '朗月清风' then
            self.抗性.抗封印 = math.floor(self.抗性.抗封印 + 11)
            self.抗性.抗混乱 = math.floor(self.抗性.抗混乱 + 11)
            self.抗性.抗遗忘 = math.floor(self.抗性.抗遗忘 + 11)
        elseif v.名称 == '金铭诀' or v.名称 == '木灵诀' or v.名称 == '厚土诀' or v.名称 == '沧海诀' or v.名称 == '烈火诀' then
            self.抗性.抗封印 = math.floor(self.抗性.抗封印 + 8)
            self.抗性.抗混乱 = math.floor(self.抗性.抗混乱 + 8)
            self.抗性.抗遗忘 = math.floor(self.抗性.抗遗忘 + 8)
            self.抗性.金 = math.floor(self.抗性.金 * 0.5)
            self.抗性.木 = math.floor(self.抗性.木 * 0.5)
            self.抗性.水 = math.floor(self.抗性.水 * 0.5)
            self.抗性.火 = math.floor(self.抗性.火 * 0.5)
            self.抗性.土 = math.floor(self.抗性.土 * 0.5)
            if v.名称 == '金铭诀' then
                self.抗性.金 = self.抗性.金 + 50
            elseif v.名称 == '木灵诀' then
                self.抗性.木 = self.抗性.木 + 50
            elseif v.名称 == '厚土诀' then
                self.抗性.土 = self.抗性.土 + 50
            elseif v.名称 == '沧海诀' then
                self.抗性.水 = self.抗性.水 + 50
            elseif v.名称 == '烈火诀' then
                self.抗性.火 = self.抗性.火 + 50
            end
        elseif v.名称 == '怒仙' then
            self.抗性.水系狂暴几率 = math.floor(self.抗性.水系狂暴几率 + 10 + 亲密 * 0.008)
            self.抗性.火系狂暴几率 = math.floor(self.抗性.火系狂暴几率 + 10 + 亲密 * 0.008)
            self.抗性.雷系狂暴几率 = math.floor(self.抗性.雷系狂暴几率 + 10 + 亲密 * 0.008)
            self.抗性.风系狂暴几率 = math.floor(self.抗性.风系狂暴几率 + 10 + 亲密 * 0.008)
            self.抗性.鬼火狂暴几率 = math.floor(self.抗性.鬼火狂暴几率 + 10 + 亲密 * 0.008)
        elseif v.名称 == '恨仙' then
            self.抗性.忽视抗水 = math.floor(self.抗性.忽视抗水 + 10 + 亲密 * 0.004)
            self.抗性.忽视抗火 = math.floor(self.抗性.忽视抗火 + 10 + 亲密 * 0.004)
            self.抗性.忽视抗雷 = math.floor(self.抗性.忽视抗雷 + 10 + 亲密 * 0.004)
            self.抗性.忽视抗风 = math.floor(self.抗性.忽视抗风 + 10 + 亲密 * 0.004)
            self.抗性.忽视抗鬼火 = math.floor(self.抗性.忽视抗鬼火 + 10 + 亲密 * 0.004)
        end
    end
end