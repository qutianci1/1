-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-20 06:12:22
-- @Last Modified time  : 2024-10-18 20:46:58
--可以访问的属性
local 接口 = {
    初血 = true,
    初法 = true,
    初攻 = true,
    初敏 = true,
    名称 = true,
    外形 = true,
    原形 = true,
    等级 = true,
    转生 = true,
    点化 = true,
    亲密 = true,
    忠诚 = true,
    魔法 = true,
    染色 = true,
    最大魔法 = true,
    气血 = true,
    最大气血 = true
}
--可以访问的方法

local _召唤库 = require('数据库/召唤库')

function 接口:提示窗口(...)
    self.主人.rpc:提示窗口(...)
end

function 接口:常规提示(...)
    self.主人.rpc:常规提示(...)
end

function 接口:神之石洗点(属性)
    return self:神之石洗点(属性)
end

function 接口:判断是否满血(v)
    if self.是否战斗 then
        return false
    end
    if v then
        if self.气血 == self.最大气血 then
            return true
        end
    end
end

function 接口:判断是否满蓝(v)
    if self.是否战斗 then
        return false
    end
    if v then
        if self.魔法 == self.最大魔法 then
            return true
        end
    end
end

function 接口:增减气血(v)
    if type(v) == 'number' then
        if self.气血 >= self.最大气血 then
            return
        end
        self.气血 = self.气血 + math.floor(v)
        if self.气血 > self.最大气血 then
            self.气血 = self.最大气血
        end
        return self.气血
    end
    return
end

function 接口:增减魔法(v)
    if type(v) == 'number' then
        if self.魔法 >= self.最大魔法 then
            return
        end
        self.魔法 = self.魔法 + math.floor(v)
        if self.魔法 > self.最大魔法 then
            self.魔法 = self.最大魔法
        end
        return self.魔法
    end
    return
end

function 接口:双加(q, m)
    if type(q) == 'number' and type(m) == 'number' then
        self.气血 = self.气血 + math.floor(q)
        self.魔法 = self.魔法 + math.floor(m)
        if self.魔法 > self.最大魔法 then
            self.魔法 = self.最大魔法
        end

        if self.气血 > self.最大气血 then
            self.气血 = self.最大气血
        end
        return self.魔法
    end
end

function 接口:刷新属性(初值)
    if 初值 then
        self.初血 = self.初血 + 初值
        self.初敏 = self.初敏 + 初值
    end
    self:刷新属性()
end

function 接口:添加亲密度(n, r)
    local s = 30000000
    if r == 2 then
        s = 50000000
    end
    if self.亲密 >= s then
        return false
    end
    self.亲密 = self.亲密 + math.floor(n)
    if self.亲密 > s then
        self.亲密 = s
    end
    self:亲密抗性计算()
    for k, v in self:遍历内丹() do
        v:重新计算属性(self)
    end
    return true
end

function 接口:解除技能格子(n)
    if self.技能格子.封印 + 1 > 1 then
        self.技能格子.封印 = self.技能格子.封印 - 1
        self.技能格子.已开 = self.技能格子.已开 + 1
        return true
    else
        return false
    end
end

function 接口:添加领悟技能(n)
    local 领悟技能 = {'神工鬼力','倍道兼行','源泉万斛','帐饮东都'}
    local 技能格子 = self.技能格子
    if #self.领悟技能 >= self.技能格子.已开 then
        return false
    end
    local 尝试次数 = 8
    local 随机技能
    repeat
        if 尝试次数 <= 0 then
            return false
        end
        尝试次数 = 尝试次数 - 1
        随机技能 = 领悟技能[math.random(1, #领悟技能)]
        local 重复 = false
        for i, v in ipairs(self.领悟技能) do
            if v == 随机技能 then
                重复 = true
                break
            end
        end
    until not 重复
    -- table.insert(self.领悟技能, 随机技能)
    self.领悟技能[#self.领悟技能+1] = 随机技能
    return true
end



function 接口:添加经验(n)
    if self:取等级上限() then
        return false
    end
    local yk = self.主人:任务_获取('VIP月卡')
    if yk then
        n = math.floor(n * 1.3)
    end
    local 之前等级 = self.等级
    self.经验 = self.经验 + math.floor(n)
    if self.经验 < self.最大经验 then
        -- self.主人.rpc:置召唤经验(self.经验, self.最大经验)
    end
    if not self.主人.离线角色 then
        self.主人.rpc:提示窗口("#Y你的召唤兽#R" .. self.名称 .. "#Y获得了" .. math.floor(n) .. "#Y点经验。")
    end
    if self.经验 >= self.最大经验 then
        while self.经验 >= self.最大经验 and not self:取等级上限() do
            self.经验 = self.经验 - self.最大经验
            self.等级 = self.等级 + 1
            self.根骨 = self.根骨 + 1
            self.灵性 = self.灵性 + 1
            self.力量 = self.力量 + 1
            self.敏捷 = self.敏捷 + 1
            self.潜力 = self.潜力 + 4
            self.忠诚 = 100
            self.最大经验 = self:取升级经验()
            self.亲密 = self.亲密 + self.等级 * 15
            self:亲密抗性计算()
            for k, v in self:遍历内丹() do
                v:重新计算属性(self)
            end
        end
        -- self.主人.rpc:置召唤经验(self.经验, self.最大经验)
    end
    if 之前等级 ~= self.等级 then
        self:刷新属性()
        self.气血 = self.最大气血
        self.魔法 = self.最大魔法
        self.主人.rpc:置召唤气血(self.气血, self.最大气血)
        self.主人.rpc:置召唤魔法(self.魔法, self.最大魔法)
        self.主人.rpc:刷新召唤兽属性窗口(self:召唤_取窗口属性()) --刷新召唤兽属性栏
    end
    return true
end

function 接口:添加战斗经验(n)
    if self.主人.task:任务添加召唤战斗经验(self.接口) ~= false then
        接口.添加经验(self, n)
    end
end

function 接口:添加内丹经验(n)
    n=math.floor( n )
    local r = false
    for _, v in ipairs(self.内丹) do
        if v:添加经验(n, self) then
            r = true
            if not self.主人.离线角色 then
                self.主人.rpc:提示窗口("#Y%s的内丹#G%s#Y获得了#R%s#Y点经验", self.名称, v.技能, n)
            end
        end
    end
    self.刷新的属性.内丹 = true
    return r
end

function 接口:添加聚气丹经验(n)
    n=math.floor( n )
    local r = false
    if #self.内丹 == 0 then
        return false
    end
    local t = math.random(1, #self.内丹)
    local function 遍历内丹等级(t)
        if self.内丹[t].等级 >= 100 and self.内丹[t].转生 == 0 then
            return false
        elseif self.内丹[t].等级 == 120 and self.内丹[t].转生 == 1 then
            return false
        elseif self.内丹[t].等级 == 140 and self.内丹[t].转生 == 2 then
            return false
        elseif self.内丹[t].等级 == 170 and self.内丹[t].转生 == 3 then
            return false
        end
        if self.转生 == 0 and self.内丹[t].等级 <= self.等级 then
            return true
        elseif self.转生 == 1 and self.内丹[t].等级 <= self.等级 and self.内丹[t].转生 == 1 then
            return true
        elseif self.转生 == 2 and self.内丹[t].等级 <= self.等级 and self.内丹[t].转生 == 2 then
            return true
        elseif self.转生 == 3 and self.内丹[t].等级 <= self.等级 and self.内丹[t].转生 == 3 then
            return true
        elseif self.转生 == 1 and self.内丹[t].等级 <= 120 and self.内丹[t].转生 < 1 then
            return true
        elseif self.转生 == 2 and self.内丹[t].等级 <= 140 and self.内丹[t].转生 < 2 then
            return true
        elseif self.转生 == 3 and self.内丹[t].等级 <= 170 and self.内丹[t].转生 < 3 then
            return true
        end
        return false
    end
    if #self.内丹 == 1 then
        if not 遍历内丹等级(t) then
            for i = 1, #self.内丹 do
                if 遍历内丹等级(i) then
                    t = i
                end
            end
        end
    elseif #self.内丹 == 2 then
        local 几率 = math.random(1, 2)
        if 遍历内丹等级(1) and 遍历内丹等级(2) then
            t = 几率
        else
            for i = 1, #self.内丹 do
                if 遍历内丹等级(i) then
                    t = i
                end
            end
        end
    elseif #self.内丹 == 3 then
        if 遍历内丹等级(1) and 遍历内丹等级(2) and 遍历内丹等级(3) then
            local 几率 = math.random(1, 3)
            t = 几率
        elseif not 遍历内丹等级(1) and 遍历内丹等级(2) and 遍历内丹等级(3) then
            local 几率 = math.random(2, 3)
                t = 几率
        elseif 遍历内丹等级(1) and 遍历内丹等级(2) and not 遍历内丹等级(3) then
            local 几率 = math.random(1, 2)
                t = 几率
        else
            for i = 1, #self.内丹 do
                if 遍历内丹等级(i) then
                    t = i
                end
            end
        end
    end
    if 遍历内丹等级(t) then
        self.内丹[t].经验 = self.内丹[t].经验 + n
        if self.内丹[t].经验 >= self.内丹[t].最大经验 then
            self.内丹[t].等级 = self.内丹[t].等级 + 1
            self.内丹[t].最大经验 = require('数据库/经验库').内丹经验库[self.内丹[t].等级]
            self.内丹[t].经验 = self.内丹[t].经验 - self.内丹[t].最大经验
        end
        r = true
        if not self.主人.离线角色 then
            self.主人.rpc:提示窗口("#Y%s的内丹#G%s#Y获得了#R%s#Y点经验", self.名称, self.内丹[t].技能, n)
        end
    end
    self.刷新的属性.内丹 = true
    return r
end

function 接口:添加物品(t)
    return self.主人.接口:添加物品(t)
end

function 接口:超级巫医()
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
    self.忠诚 = 100

end

function 接口:添加忠诚度(n)
    return self:添加忠诚度(n)
end

function 接口:添加元气(n)
    if type(n) ~= "number" then
        return
    end
    local 元气 = 0
    local 内丹
    for _, v in ipairs(self.内丹) do
        if v.最大元气 - v.元气 > 元气 then
            元气 = v.最大元气 - v.元气
            内丹 = v
        end
    end

    if 内丹 then
        内丹:增减元气(n)
        self.刷新的属性.内丹 = true
        self.主人.rpc:常规提示("#Y%s#W内丹元气获得补充！", 内丹.技能)
        return true
    end
end

function 接口:添加内丹(t)
    if ggetype(t) == '物品接口' then
        t = t[0x4253]
        if self.接口:取内丹是否存在(name) then
            return
        end
        local r = require('对象/法术/内丹') {
            技能 = t.技能,
            等级 = t.等级,
            经验 = t.经验,
            元气 = t.元气,
            转生 = t.转生,
            点化 = t.点化,
        }
        table.insert(self.内丹, r)
        r:属性加(self)
        t:删除()
        self:刷新属性()
        return true
    end
end

function 接口:取内丹数量()
    return #self.内丹
end

function 接口:取内丹是否存在(name)
    for _, v in ipairs(self.内丹) do
        if v.技能 == name then
            return true
        end
    end
end

function 接口:使用龙涎丸()
    if self.类型 ~= 4 then
        return 1
    end
    if self.龙涎丸 >= 9 then
        return 2
    end
    self.龙涎丸 = self.龙涎丸 + 1
    self.成长 = self.成长 + 0.02
    if self.龙涎丸 == 9 then
        local 方案 = self.主人.rpc:请求召唤染色方案(self.外形)
        if 方案 then
            local 部位数量  = #方案
            local 随机方案 = math.random(1,#方案[1])
            local 方案编号 = string.format('0x%02d010101',随机方案)
            self.染色 = tonumber(方案编号)
            self.主人.rpc:常规提示("#Y你的召唤兽#G%s#Y变得焕然一新！", self.名称)
        end
    end
    self:刷新属性()
    return 3
end

function 接口:使用九转易筋丸()
    if self.转生 ~= 0 then
        return false
    end
    self.转生 = 1
    self.等级 = 0
    self.根骨 = 0
    self.灵性 = 0
    self.力量 = 0
    self.敏捷 = 0
    self.潜力 = 30
    self.经验 = 0
    self.成长 = self.成长 + 0.1
    self.最大经验 = self:取升级经验()
    self:召唤_取名称颜色()
    self:刷新属性(1)
    return true
end

function 接口:使用超级变色丹(对象)
    if self.类型 > 2 then
        return '#Y这种类型的召唤兽无法使用变色丹'
    end
    if self.外形 == 2111 or self.外形 == 2114 or self.外形 == 2203 then
        return '#Y这种类型的召唤兽无法使用变色丹'
    end
    if not _召唤库[self.原形] then
        return '#Y未找到这个类型的召唤兽'
    end
    if  self.成长 < _召唤库[self.原形].成长 + _召唤库[self.原形].元气提升 + self.龙之骨.次数 * 0.01 + self.转生 * 0.1 then
        return '#Y变色丹只可以对高成长召唤兽使用'
    end
    local 方案 = self.主人.rpc:请求召唤染色方案(self.外形)
    if 方案 ~= nil then
        local 部位数量  = #方案
        local 随机方案 = math.random(1,#方案[1])
        local 方案编号 = string.format('0x%02d010101',随机方案)
        if 方案编号 == '0x03010101' then--守护专用色
            方案编号 = '0x01010101'
        end
        self.染色 = tonumber(方案编号)
        return true,随机方案
    else
        return false
    end
end

function 接口:使用变色丹(名称)--变色丹参数
    if not _召唤库[名称] then
        return '#Y未找到这个类型的召唤兽'
    end
    if self.成长 < _召唤库[名称].成长 + _召唤库[名称].元气提升 + self.龙之骨.次数 * 0.01 + self.转生 * 0.1 then
        return '#Y变色丹只可以对高成长召唤兽使用'
    end
    if self.类型 > 2 then
        return '#Y这种类型的召唤兽无法使用变色丹'
    end
    if self.外形 == 2111 or self.外形 == 2114 or self.外形 == 2203 then
        return '#Y这种类型的召唤兽无法使用变色丹'
    end
    if self.外形 == _召唤库[名称].外形 then
        local 方案 = self.主人.rpc:请求召唤染色方案(self.外形)
        if 方案 ~= nil then
            local 部位数量  = #方案
            local 随机方案 = math.random(1,#方案[1])
            local 方案编号 = string.format('0x%02d010101',随机方案)
            if 方案编号 == '0x03010101' then--守护专用色
                方案编号 = '0x01010101'
            end
            self.染色 = tonumber(方案编号)
            return true,随机方案
        else
            return false
        end
    else
        return false
    end
end

function 接口:使用元气丹(名称)
    if not _召唤库[名称] then
        return '#Y未找到这个类型的召唤兽'
    end
    if self.成长 >= _召唤库[名称].成长 + _召唤库[名称].元气提升 + self.龙之骨.次数 * 0.01 + self.转生 * 0.1 then
        return '#Y你的召唤兽已经是高成长了'
    end
    if self.成长 - self.龙之骨.次数 * 0.01 - self.转生 * 0.1 < _召唤库[名称].成长 then
        return '#Y你的召唤兽成长率未满,还是不要吃元气丹的好#17'
    end
    if self.类型 > 2 then
        return '#Y这种类型的召唤兽无法使用元气丹'
    end
    if self.外形 == 2111 or self.外形 == 2114 or self.外形 == 2203 then
        return '#Y这种类型的召唤兽无法使用元气丹'
    end
    if self.外形 == _召唤库[名称].外形 then
        self.成长 = self.成长 + _召唤库[名称].元气提升
        if math.random() <= 20 then
            local 方案 = self.主人.rpc:请求召唤染色方案(self.外形)
            if 方案 ~= nil then
                local 部位数量  = #方案
                local 随机方案 = math.random(1,#方案[1])
                local 方案编号 = string.format('0x%02d010101',随机方案)
                if 方案编号 == '0x03010101' then--守护专用色
                    方案编号 = '0x01010101'
                end
                self.染色 = tonumber(方案编号)
                self.主人.rpc:常规提示('#Y你的召唤兽颜色发生了变化。#17')
            end
        end
        return true,_召唤库[名称].元气提升
    else
        return false
    end
end

function 接口:使用超级元气丹()
    if not _召唤库[self.原形] then
        return '#Y未找到这个类型的召唤兽'
    end
    if self.成长 >= _召唤库[self.原形].成长 + _召唤库[self.原形].元气提升 + self.龙之骨.次数 * 0.01 + self.转生 * 0.1 then
        return '#Y你的召唤兽已经是高成长了'
    end
    if self.成长 - self.龙之骨.次数 * 0.01 - self.转生 * 0.1 < _召唤库[self.原形].成长 then
        return '#Y你的召唤兽成长率未满,还是不要吃元气丹的好#17'
    end
    if self.类型 > 2 then
        return '#Y这种类型的召唤兽无法使用元气丹'
    end
    if self.外形 == 2111 or self.外形 == 2114 or self.外形 == 2203 then
        return '#Y这种类型的召唤兽无法使用元气丹'
    end
    self.成长 = self.成长 + _召唤库[self.原形].元气提升
    if math.random() <= 20 then
        local 方案 = self.主人.rpc:请求召唤染色方案(self.外形)
        if 方案 ~= nil then
            local 部位数量  = #方案
            local 随机方案 = math.random(1,#方案[1])
            local 方案编号 = string.format('0x%02d010101',随机方案)
            if 方案编号 == '0x03010101' then--守护专用色
                方案编号 = '0x01010101'
            end
            self.染色 = tonumber(方案编号)
            self.主人.rpc:常规提示('#Y你的召唤兽颜色发生了变化。#17')
        end
    end
    return true,_召唤库[self.外形].元气提升
end

function 接口:洗点()
    return self:洗点处理()
end

function 接口:使用龙之骨()
    local s = 3
    if self.点化 ~= 0 then
        s = 5
    end

    if self.龙之骨.次数 >= s then
        return false
    end
    local jl = math.random(1,5)
    local tbl = {}

    if jl == 1 then
        self.龙之骨.初血 = self.龙之骨.初血 + 2
        self.龙之骨.初法 = self.龙之骨.初法 + 2
        self.龙之骨.初攻 = self.龙之骨.初攻 + 2
        self.龙之骨.初敏 = self.龙之骨.初敏 + 2
        self.初血 = self.初血 + 2
        self.初法 = self.初法 + 2
        self.初攻 = self.初攻 + 2
        self.初敏 = self.初敏 + 2
        tbl.最大气血 = self.最大气血
        tbl.最大魔法 = self.最大魔法
        tbl.攻击 = self.攻击
        tbl.速度 = self.速度
    elseif jl == 2 then
        self.龙之骨.初敏 = self.龙之骨.初敏 + 6
        self.初敏 = self.初敏 + 6
        tbl.速度 = self.速度
    elseif jl == 3 then
        self.龙之骨.初法 = self.龙之骨.初法 + 6
        self.初法 = self.初法 + 6
        tbl.最大魔法 = self.最大魔法
    elseif jl == 4 then
        self.龙之骨.初攻 = self.龙之骨.初攻 + 6
        self.初攻 = self.初攻 + 6
        tbl.攻击 = self.攻击
    else
        self.龙之骨.初血 = self.龙之骨.初血 + 6
        self.初血 = self.初血 + 6
        tbl.最大气血 = self.最大气血
    end
    self.龙之骨.次数 = self.龙之骨.次数 + 1
    self.成长 = self.成长 + 0.01
    self:刷新属性()
    local str = ""
    for i,v in pairs(tbl) do
        str = str .. i .. "增加了" .. (self[i] - v) .. "点,"
    end
    self.主人.rpc:提示窗口('#Y你的' .. self.名称 .. '吃了#R龙之骨#Y,召唤兽的'..str)
    return true
end

function 接口:清空龙之骨()
    if self.龙之骨.次数 == 0 then
        return false
    end
    self.成长 = self.成长 - self.龙之骨.次数 * 0.01

    for _, v in pairs { "初血", "初法", "初攻", "初敏" } do
        self[v] = self[v] - self.龙之骨[v]
    end
    self.龙之骨 = { 次数 = 0, 初血 = 0, 初法 = 0, 初攻 = 0, 初敏 = 0 }
    self:刷新属性()
    self.主人.rpc:提示窗口('#Y你的' .. self.名称 .. '发生了些许变化,龙之骨效果已清除！')
    return true
end

function 接口:转生处理()
    if self.转生 >= 3 then
        self.主人.rpc:常规提示("#Y目前最高转生3转")
        return
    end
    local dkx = { 100, 120, 140 }
    if self.等级 < dkx[self.转生 + 1] then
        self.主人.rpc:常规提示("#Y等级不满足转生条件")
        return
    end
    local qmx = { 100000, 200000, 300000 }
    if self.亲密 < qmx[self.转生 + 1] then
        self.主人.rpc:常规提示("#Y亲密不满足转生条件")
        return
    end
    self.亲密 = self.亲密 - qmx[self.转生 + 1]
    self.转生 = self.转生 + 1
    self.等级 = 0
    self.根骨 = 0
    self.灵性 = 0
    self.力量 = 0
    self.敏捷 = 0
    self.潜力 = self.转生 * 30
    self.成长 = self.成长 + 0.1
    if self.飞升 == 3 then
        self.潜力 = self.潜力 + 60
    end
    if self.化形 then
        self.潜力 = self.潜力 + 60
    end
    self:召唤_取名称颜色()
    self:刷新属性()
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
    self.主人.rpc:常规提示("#Y转生成功！")
    return true
end

function 接口:神兽更换造型(外观)
    if self.类型 < 5 then
        self.主人.rpc:常规提示("#Y只有旧版神兽才可以更换造型！")
        return
    end
    local 序号 = 1
    if 外观 == '一飞外观' then
        序号 = 2
    elseif 外观 == '二飞外观' then
        序号 = 3
    end
    local 外形表 = {
        {2030,2011,2109},
        {2031,2070,2107},
        {2032,2071,2107},
        {2035,2065,2106},
        {2036,2064,2108},
        {2037,2023,2110}
    }
    local _造型表
    for k,v in pairs(外形表) do
        if self.原型 then
            if self.原型 == v[1] then
                _造型表 = v
            end
        end
    end
    if self.飞升 + 1 < 序号 then
        self.主人.rpc:常规提示("#Y你的神兽还没有解锁这个造型！")
        return
    end
    if not _造型表 then
        self.主人.rpc:常规提示("#Y只有旧版神兽才可以更换造型！")
        return
    end
    if self.主人.银子 < 1000000 then
        self.主人.rpc:常规提示("#Y你身上的银两不足1000000")
        return
    end
    self.主人:角色_扣除银子(1000000, "更变造型", 1)
    self.外形 = _造型表[序号]
    local j = self:取天生技能(self.外形)
    if j then
        self.天生技能 = j
    else
        self.天生技能 = {}
    end
    local w = self:取五行(self.外形)
    if w then
        self.金 = w.金
        self.木 = w.木
        self.水 = w.水
        self.火 = w.火
        self.土 = w.土
    end
    self.主人.rpc:常规提示("#Y你的召唤兽已更换造型")
end

local _飞升 = {
    { lv = 50, zs = 0, 次数 = 1 },
    { lv = 100, zs = 0, 次数 = 2 },
    { lv = 100, zs = 1, 次数 = 3 },
}
function 接口:飞升处理()
    if self.类型 < 5 then
        self.主人.rpc:常规提示("#Y只有神兽才可以飞升！")
        return
    elseif self.飞升 >= 3 then
        self.主人.rpc:常规提示("#Y一只召唤兽最多只能飞升3次")
        return
    end
    local v = _飞升[self.飞升 + 1]
    if self.转生 < v.zs or self.等级 < v.lv then
        self.主人.rpc:常规提示("#Y" .. v.zs .. "转" .. v.lv .. "级才能飞升" .. self.飞升 + 1 .. "次")
        return
    end
    if self.飞升 == 2 then
        if self.主人.银子 < 5000000 then
            self.主人.rpc:常规提示("你身上的银两不足！")
            return
        end
        self.主人:角色_扣除银子(5000000, "飞升处理", 1)
    end
    local 外形表 = {2030,2031,2032,2035,2036,2037,2011,2070,2071,2065,2064,2023}
    local 进阶表 = {2011,2070,2071,2065,2064,2023,2109,2107,2107,2106,2108,2110}
    local 变形
    for i=1,#外形表 do
        if self.外形 == 外形表[i] then
            变形 = 进阶表[i]
        end
    end
    self.飞升 = self.飞升 + 1
    if self.飞升 == 1 then
        self.成长 = self.成长 + 0.1
        if 变形 then
            self.原型 = self.外形
            self.外形 = 变形
        end
        self.主人.rpc:常规提示("#Y你的召唤兽"..self.名称.."已成功飞升！")
    elseif self.飞升 == 2 then
        self.成长 = self.成长 + 0.05
        if 变形 then
            self.外形 = 变形
        end
        self.主人.rpc:常规提示("#Y你的召唤兽"..self.名称.."已成功飞升！")
    elseif self.飞升 == 3 then
        return true
    end
    local j = self:取天生技能(self.外形)
    if j then
        self.天生技能 = j
    else
        self.天生技能 = {}
    end
    local w = self:取五行(self.外形)
    if w then
        self.金 = w.金
        self.木 = w.木
        self.水 = w.水
        self.火 = w.火
        self.土 = w.土
    end
    self:属性_初始化(self)
    self:刷新属性()
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
end

function 接口:飞升3处理(初值)
    if self.类型 < 5 then
        self.主人.rpc:常规提示("#Y只有神兽才可以飞升！")
        return
    end
    if self.飞升 ~= 3 then
        self.主人.rpc:常规提示("#Y你的召唤兽并没有飞升3次！")
        return
    end
    if self.飞升初值 ~= 0 then
        self.主人.rpc:常规提示("#Y你的召唤兽已经提升过初值！")
        return
    end
    if self[初值] then
        self[初值] = self[初值] + 60
        self.飞升初值 = 初值
        self.主人.rpc:常规提示("#Y你的召唤兽"..初值.."提高了60点！")
        self:刷新属性()
    else
        添加最后对话(id,'获取选择失败'..初值)
    end
end

-- function 接口:灵兽园领悟()
--     local 奖励几率 = math.random(100)
--     local 技能 = ''
--     if 奖励几率 <= 88 then
--         -- 技能 = 取低级兽诀(self:取领悟信息(编号),self..技能)
--     elseif 奖励几率 <= 99 then --10
--         --技能 = 取高级兽诀2(self:取领悟信息(编号),self..技能)
--         -- 广播消息({内容=format("#R/%s#QL/在王母娘娘的兽园中偶遇灵兽，毫不犹豫的让自己#R/%s#QL/向其学习了#G/[%s]#QL/技能#89" ,角色名称,召唤兽名称,技能),频道="xt"},id)
--     else
--         -- 技能="？？？"
--         -- 广播消息({内容=format("#R/%s#QL/在王母娘娘的兽园中偶遇灵兽，毫不犹豫的让自己#R/%s#QL/向其学习了#G/[%s]#QL/技能#89" ,角色名称,召唤兽名称,技能),频道="xt"},id)
--     end
--     local 人物经验 = 7621 * self.主人.等级
--     local 召唤兽经验 = 7621 * self.主人.等级 * 1.5
--     local 内丹经验 = 7621 * self.主人.等级 * 1.5
--     --玩家数据[id].角色:添加经验(人物经验,"灵兽园领悟",1)
--     --   if 玩家数据[id].角色.数据.参战信息~=nil then
--     --     self:获得经验(玩家数据[id].角色.数据.参战宝宝.认证码,召唤兽经验,id,"灵兽园领悟")
--     --     self:获得内丹经验(玩家数据[id].角色.数据.参战宝宝.认证码,内丹经验,id,"灵兽园领悟")
--     --   end
--     if #self.技能 >= 6 then
--         return
--     --"当前技能已满！领悟失败！"
--     end
--     if #self.技能 >= self.已开格子 then
--         return
--     --"当前技能格子尚未学习技能！领悟失败！"
--     end

--     --- self:添加技能(技能,编号)
-- end

function 接口:选择飞升初值(事件)
    if self.飞升 ~= 3 then
        return
        --"只有飞升3次的神兽才可以进行此操作！"
    end
    -- if self.飞升初值 then
    --   return--"初值一经选择无法更换"
    -- end

    self.飞升初值 = 事件
    --self.数据[编号][事件表[事件]]=self.数据[编号][事件表[事件]]+60
    --添加最后对话(id,self.名称..事件.."提升60")
    self:刷新属性()
end

function 接口:换神兽模型(外形)
    if self.飞升 < 3 then
        return '只有飞升3次的老版神兽才可以进行此操作！'
    end
    if self.类型 ~= 5 then
        return '只有飞升3次的老版神兽才可以进行此操作！'
    end
    -- if 取银子(id) < 10000000 then
    --     常规提示(id, '没有钱，我很难给你办事啊！')
    --     return
    -- end
    --玩家数据[id].角色:扣除银子(10000000, 0, 0, '换神兽模型', 1)
    self.外形 = 外形
    -- local n = 大话宝宝库(模型)
    -- self.数据[编号].天生技能 = {}
    -- self.数据[编号].天生技能 = n.天生技能
end

--===============================================================================
if not package.loaded.召唤接口_private then
    package.loaded.召唤接口_private = setmetatable({}, { __mode = 'k' })
end
local _pri = require('召唤接口_private')

local 召唤接口 = class('召唤接口')

function 召唤接口:初始化(P)
    _pri[self] = P
    self.是否召唤 = true
end

function 召唤接口:__index(k)
    if k == 0x4253 then
        return _pri[self]
    end
    local r = 接口[k]
    local P = _pri[self]
    if r == true then
        return P[k]
    elseif r then
        return function(_, ...)
            return r(P, ...)
        end
    end
end

return 召唤接口
