-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-25 11:21:11
-- @Last Modified time  : 2024-08-24 21:52:10

local _ENV = setmetatable({}, {__index = _G})
local JYK = require('数据库/经验库')
local KXK = require('数据库/抗性库')
local BBK = require('数据库/召唤库')

function _ENV:技能计算()
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
        elseif v.名称 == '神工鬼力' then
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

function _ENV:刷新属性(编号)
    _ENV.初始抗性(self)
    --_ENV.亲密抗性计算(self)
    _ENV.初始五行(self)
    _ENV.成长计算(self)
    _ENV.初值计算(self)

    self.最大经验 = _ENV.取经验(self)
    _ENV.天生抗性计算(self)
    -- _ENV.技能计算(self)
    _ENV.炼妖属性计算(self)

    for i = 1, #上限范围 do
        if self.数据[编号][上限范围[i]] > 75 then
            self.数据[编号][上限范围[i]] = 75
        end
    end

    if self.管制 ~= nil then
        if 玩家数据[self.数字id].坐骑.数据[self.管制.编号] == nil then
            self.管制 = nil
            return
        end
        for i = 1, #玩家数据[self.数字id].坐骑.数据[self.管制.编号].技能 do
            self:坐骑技能属性(编号, 玩家数据[self.数字id].坐骑.数据[self.管制.编号].技能[i].名称, 玩家数据[self.数字id].坐骑.数据[self.管制.编号].技能[i].熟练度)
        end
    end

    if self.气血 > self.最大气血 then
        self.气血 = self.最大气血
    end
    if self.魔法 > self.最大魔法 then
        self.魔法 = self.最大魔法
    end
    self.最大气血 = math.ceil(self.最大气血)
    self.最大魔法 = math.ceil(self.最大魔法)
    self.伤害 = math.ceil(self.伤害)
    self.速度 = math.ceil(self.速度)
end

return _ENV
