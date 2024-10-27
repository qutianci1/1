-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-20 06:08:58
-- @Last Modified time  : 2024-08-29 21:45:59
require("json")
local GGF = require('GGE.函数')
local MYF = require('我的函数')
local _召唤库 = require('数据库/召唤库')
local _存档表 = require('数据库/存档属性_召唤')

local 召唤 = class('召唤')

gge.require('对象/召唤/算法')
gge.require('对象/召唤/通信')
gge.require('对象/召唤/战斗')

function 召唤:召唤(t)
    self:加载存档(t)

    self.接口 = require('对象/召唤/接口')(self)
    self:属性_初始化(t)

    if not self.nid then
        self.nid = _生成ID()
    end
    __召唤[self.nid] = self
    self.刷新的属性 = {}
end

function 召唤:更新()
    if next(self.刷新的属性) then
        if self.刷新的属性.是否参战 then
        elseif self.是否参战 then
            if self.刷新的属性.气血 then
                if not self.主人.是否助战 then
                    self.主人.rpc:置召唤气血(self.刷新的属性.气血, self.刷新的属性.最大气血)
                end
            end
            if self.刷新的属性.魔法 then
                if not self.主人.是否助战 then
                    self.主人.rpc:置召唤魔法(self.刷新的属性.魔法, self.刷新的属性.最大魔法)
                end
            end
            if self.刷新的属性.经验 then
                if not self.主人.是否助战 then
                    self.主人.rpc:置召唤经验(self.刷新的属性.经验, self.刷新的属性.最大经验)
                end
            end
            if self.刷新的属性.忠诚 then
                if not self.主人.是否助战 then
                    self.主人.rpc:置召唤忠诚(self.刷新的属性.忠诚, self.刷新的属性.最大忠诚)
                end
            end
            if self.刷新的属性.名称颜色 then
                self.主人.rpc:切换名称的颜色(self.nid, self.名称颜色)
                self.主人.rpn:切换名称的颜色(self.nid, self.名称颜色)
            end
        end
        if self.主人.当前查看召唤 == self then
            self.主人.rpc:请求刷新召唤(self.nid)
        end
        self.刷新的属性 = {}
    end
end

function 召唤:__index(k)
    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end
    return _存档表[k]
end

function 召唤:__newindex(k, v)
    if _存档表[k] ~= nil then
        if self.刷新的属性 then
            self.刷新的属性[k] = v
        end

        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end
--前面加0x后面加FF
local _名称颜色 = {
    0xFF8C00FF, -- 橙色0转
    0xEE82EEFF, -- 粉色1转
    0x7B68EEFF, -- 紫色2转
    0x0000CDFF, -- 深蓝3转
    0x4B0082FF, -- 深紫4转
}

function 召唤:召唤_取名称颜色()
    if _名称颜色[self.转生+1] then
        self.名称颜色 = _名称颜色[self.转生+1]
    end
end

function 召唤:取简要数据() --地图
    return {
        type = 'sum',
        nid = self.nid,
        名称 = self.名称,
        外形 = self.外形,
        染色 = self.染色,
        名称颜色 = self.名称颜色,
        x = self.x,
        y = self.y
    }
end

function 召唤:取界面数据()--加了nid为了右键召唤头像使用道具
    return {
        nid = self.nid,
        名称 = self.名称,
        忠诚 = self.忠诚,
        外形 = self.外形,
        原形 = self.原形, --头像
        气血 = self.气血,
        染色 = self.染色,
        最大气血 = self.最大气血,
        魔法 = self.魔法,
        最大魔法 = self.最大魔法,
        经验 = self.经验,
        最大经验 = self.最大经验
    }
end

function 召唤:取查看数据() --聊天查看
    local nd = {}
    local _召唤库 = require('数据库/召唤库')
    for _, v in self:遍历内丹() do
        table.insert(nd, { 名称 = v.技能, 点化 = v.点化, 转生 = v.转生, 等级 = v.等级 })
    end


    return {
        等级 = self.等级,
        名称 = self.名称,
        外形 = self.外形,
        转生 = self.转生,
        飞升 = self.飞升,
        染色 = self.染色,
        最大气血 = self.最大气血,
        最大魔法 = self.最大魔法,
        攻击 = self.攻击,
        速度 = self.速度,
        初血 = self.初血,
        初法 = self.初法,
        初攻 = self.初攻,
        初敏 = self.初敏,
        龙涎丸 = self.龙涎丸,
        忠诚 = self.忠诚,
        成长 = self.成长,
        气血 = self.气血,
        魔法 = self.魔法,

        金 = self.金,
        木 = self.木,
        水 = self.水,
        火 = self.火,
        土 = self.土,
        技能格子 = self.技能格子,
        技能 = self.技能,
        天生技能 = self.天生技能,
        领悟技能 = self.领悟技能,
        类型 = self.类型,
        内丹 = nd,
        炼妖 = self.炼妖 or { 次数 = 0 },
        天生抗性 = self.天生抗性,
        龙之骨 = self.龙之骨
    }
end

function 召唤:取技能是否存在(name)
    for k, v in ipairs(self.技能) do
        if v == name then
            return true
        end
    end
    return false
end

function 召唤:取存档数据(P)
    local r = {
        rid = P.id,
        nid = self.nid
    }

    for _, k in pairs { '外形', '原名', '等级', '获得时间', '丢弃时间' } do
        r[k] = self[k]
    end
    r.数据 = {}
    for k, v in pairs(_存档表) do
        if self[k] ~= v then
            if k == "龙之骨" then
                r.数据[k] = JSON.stringify(self[k])
            else
                r.数据[k] = self[k]
            end
        end
    end

    -- print("取存档数据")
    -- table.print(self.龙之骨)
    -- table.print(r.数据)
    local nds = {}
    for i, v in ipairs(self.内丹) do
        nds[i] = v:取存档数据(self)
    end
    r.数据.内丹 = nds
    return r
end

function 召唤:遍历内丹()
    return next, self.内丹
end

function 召唤:遍历技能()
    local i = 0
    return function()
        i = i + 1
        if self.技能[i] then
            return i, self.技能[i]
        end
    end
end

function 召唤:加载存档(t)
    if type(t.数据) == 'table' then --加载存档的表
        rawset(self, '数据', t.数据)
        t.数据 = nil
        for k, v in pairs(t) do
            self[k] = v
        end
        for k, v in pairs(_存档表) do
            if type(v) == 'table' and type(self[k]) ~= 'table' then
                self[k] = {}
            end
        end
        if not self.其它属性.抗性 then
            self.其它属性.抗性 = {}
        end
        for i, v in ipairs(self.内丹) do
            self.内丹[i] = require('对象/法术/内丹')(v)
            -- local r = require('对象/法术/内丹')(v)
            -- self.内丹[i] = r
            -- r:属性加(self)
        end
        -- self.成长 = nil 草你妈的老张你个狗东西挖多少坑
        self.是否参战 = self.是否参战 == true
        self.是否观看 = self.是否观看 == true
    else

        rawset(self, '数据', t)
        -- table.print(t.天生抗性)
        self.内丹 = {}
        self.抗性 = {}
        self.天生抗性 = t.天生抗性
        self.其它属性 = { 抗性 = {} }
    end
    if _召唤库[t.原名] then --指向元表 '数据库/召唤库'
        setmetatable(self.数据, { __index = _召唤库[t.原名] })
    else
        warn('召唤库不存在:', t.原名 or t.名称)
    end


    local 龙之骨 = {次数 = 0, 初血 = 0, 初法 = 0, 初攻 = 0, 初敏 = 0}

    -- print(type(self.龙之骨),self.龙之骨)
    if self.龙之骨 == nil or type(self.龙之骨) ~= "string" or self.龙之骨 == "" then
        self.龙之骨 = 龙之骨
    else
        self.龙之骨 = JSON.parse(self.龙之骨) --JSON.parse([[{"初攻":0,"初敏":0,"初法":0,"初血":0,"次数":0}]])
    end
    -- print(self.名称)
    -- table.print(self.龙之骨)
        --龙之骨 = {次数 = 0, 初血 = 0, 初法 = 0, 初攻 = 0, 初敏 = 0},
    -- self.龙之骨 = MYF.容错表(self.龙之骨)
    --self.装备 = MYF.容错表(self.装备)
    self.技能 = {}
    local j = self:取天生技能(self.外形)
    if j then
        self.天生技能 = j
    else
        self.天生技能 = {}
    end
end

function 召唤:超级巫医()
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
    self.忠诚 = 100
end

function 召唤:取巫医消耗()
    return math.ceil((self.最大气血 - self.气血) / 100 + (self.最大魔法 - self.魔法) / 100 +
        (100 - self.忠诚) * 450)
end

function 召唤:添加忠诚度(n)
    if self.忠诚 >= 100 then
        return '#Y召唤兽忠诚已满！'
    end
    self.忠诚 = self.忠诚 + math.floor(n)
    if self.忠诚 > 100 then
        self.忠诚 = 100
    end
    return true
end

function 召唤:删除()
    if self.主人 then
        self.主人.召唤[self.nid] = nil
    end
end

function 召唤:取天生技能(外形)
    for k,v in pairs(_召唤库) do
        if 外形 == v.外形 then
            return v.天生技能
        end
    end
end

function 召唤:取五行(外形)
    local 五行
    for k,v in pairs(_召唤库) do
        if 外形 == v.外形 then
            五行 = {}
            五行.金 = v.金
            五行.木 = v.木
            五行.水 = v.水
            五行.火 = v.火
            五行.土 = v.土
            return 五行
        end
    end
    return
end

function 召唤:洗点处理()
    local a = 0
    for _, v in pairs { '根骨', '灵性', '力量', '敏捷' } do
        a = a + self[v]
    end
    if a == self.等级 * 4 then
        return false
    end

    self.根骨 = self.等级
    self.灵性 = self.等级
    self.力量 = self.等级
    self.敏捷 = self.等级
    self.潜力 = self.等级 * 4 + self.转生 * 30
    self:刷新属性(1)
    return true
end

return 召唤
