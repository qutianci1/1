-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2024-10-15 19:08:10

local _存档表 = require('数据库/存档属性_坐骑')
local _坐骑经验库 = require('数据库/经验库').坐骑经验库
local 坐骑 = class('坐骑')
local GGF = require('GGE.函数')
function 坐骑:初始化(t)
    self:加载存档(t)
    self.接口 = require('对象/坐骑/接口')(self)
    if not self.nid then
        self.nid = _生成ID()
    end
    __坐骑[self.nid] = self
    self.刷新的属性 = {}
    for _, nid in pairs(self.管制) do
        if __召唤[_] then
            __召唤[_].被管制 = self.nid
            __召唤[_]:刷新属性()
        end
    end
end

function 坐骑:更新()
    if next(self.刷新的属性) then

        self.刷新的属性 = {}
    end
end

function 坐骑:__index(k)
    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end
    return _存档表[k]
end

function 坐骑:__newindex(k, v)
    if _存档表[k] ~= nil then
        if self.刷新的属性 then
            self.刷新的属性[k] = v
        end

        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

function 坐骑:取存档数据(P)
    local r = {
        rid = P.id,
        nid = self.nid
    }
    for _, k in pairs { '名称', '几座', '等级' } do
        r[k] = self[k]
    end
    r.数据 = {}
    for k, v in pairs(_存档表) do
        if type(v) ~= 'table' and self[k] ~= v then
            r.数据[k] = self[k]
        end
    end
    local 管制 = {}
    for k, v in pairs(self.管制) do
        管制[k] = v.nid
    end
    r.数据.管制 = 管制
    local 技能 = {}
    for k, v in pairs(self.技能) do
        技能[k] = v:取存档数据()
    end
    r.数据.技能 = 技能
    return r
end

function 坐骑:加载存档(t)
    -- print('加载存档')
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
        for i, v in ipairs(self.技能) do
            self.技能[i] = require('对象/法术/坐骑')(v)
        end
        for _, nid in pairs(self.管制) do
            if __召唤[nid] then
                self.管制[nid] = __召唤[nid]
                __召唤[nid].被管制 = self.nid
                __召唤[nid]:刷新属性()
            end
        end
    else
        rawset(self, '数据', t)
        local r = self:取坐骑初值信息(self.种族, self.几座)
        self.等级 = 0
        self.经验 = 0
        self.最大经验 = 10
        self.体力 = 1000
        self.最大体力 = 1000
        self.技能 = {}
        self.管制 = {}
        self.灵性 = r.灵性
        self.力量 = r.力量
        self.根骨 = r.根骨
        self.初灵 = r.灵性
        self.初力 = r.力量
        self.初根 = r.根骨
        self.是否乘骑 = false
    end
end

function 坐骑:取坐骑初值信息(种族, 几座)
    local list = {}
    local 初值系数 = {
        [1] = { 1, 3, 1 },
        [2] = { 1, 2, 2 },
        [3] = { 3, 1, 1 },
        [4] = { 2, 1, 2 },
        [5] = { 1, 1, 3 },
        [6] = { { 1, 0, 4 }, { 0, 4, 1 }, { 4, 0, 1 }, { 0, 2, 3 } }
    }
    -- if 几座 ~= 6 then
    --     list.灵性 = 初值系数[几座][1] * math.random(3,6)
    --     list.力量 = 初值系数[几座][2] * math.random(3,6)
    --     list.根骨 = 初值系数[几座][3] * math.random(3,6)
    -- else
    --     if 种族 ~= 4 then
    --         list.灵性 = 初值系数[几座][种族][1] * math.random(6)
    --         list.力量 = 初值系数[几座][种族][2] * math.random(6)
    --         list.根骨 = 初值系数[几座][种族][3] * math.random(6)
    --     else
    --         list.灵性 = 初值系数[几座][种族][1] * math.random(6)
    --         list.力量 = 初值系数[几座][种族][2] * math.random(6) + 3
    --         list.根骨 = 初值系数[几座][种族][3] * math.random(6) + 4
    --     end
    -- end
        if 几座 ~= 6 then
        list.灵性 = 初值系数[几座][1] * 6
        list.力量 = 初值系数[几座][2] * 6
        list.根骨 = 初值系数[几座][3] * 6
    else
        if 种族 ~= 4 then

            list.灵性 = 初值系数[几座][种族][1] * 6
            list.力量 = 初值系数[几座][种族][2] * 6
            list.根骨 = 初值系数[几座][种族][3] * 6
        else
            list.灵性 = 初值系数[几座][种族][1] * 6
            list.力量 = 初值系数[几座][种族][2] * 6 + 3
            list.根骨 = 初值系数[几座][种族][3] * 6 + 4
        end
    end
    return list
end

function 坐骑:取坐骑初值上限(种族, 几座)
    local list = {}
    local 初值系数 = {
        [1] = { 1, 3, 1 },
        [2] = { 1, 2, 2 },
        [3] = { 3, 1, 1 },
        [4] = { 2, 1, 2 },
        [5] = { 1, 1, 3 },
        [6] = { { 1, 0, 4 }, { 0, 4, 1 }, { 4, 0, 1 }, { 0, 2, 3 } }
    }
    if 几座 ~= 6 then
        list.灵性 = 初值系数[几座][1] * 6
        list.力量 = 初值系数[几座][2] * 6
        list.根骨 = 初值系数[几座][3] * 6
    else
        if 种族 ~= 4 then

            list.灵性 = 初值系数[几座][种族][1] * 6
            list.力量 = 初值系数[几座][种族][2] * 6
            list.根骨 = 初值系数[几座][种族][3] * 6
        else
            list.灵性 = 初值系数[几座][种族][1] * 6
            list.力量 = 初值系数[几座][种族][2] * 6 + 3
            list.根骨 = 初值系数[几座][种族][3] * 6 + 4
        end
    end
    return list
end

function 坐骑:刷新属性()
    self.灵性 = math.floor(self.初灵 + self.等级 / 20 * self.初灵)
    self.根骨 = math.floor(self.初根 + self.等级 / 20 * self.初根)
    self.力量 = math.floor(self.初力 + self.等级 / 20 * self.初力)
    self.最大经验 = _坐骑经验库[self.等级 + 1]
end

function 坐骑:坐骑_乘骑(v)
    if self.主人.当前坐骑 then
        self.主人.当前坐骑.是否乘骑 = false
        self.主人.当前坐骑 = nil
        self.主人.外形 = self.主人.原形
    end
    self.是否乘骑 = v == true
    if self.是否乘骑 then
        self.主人.当前坐骑 = self
        self.主人.外形 = 5000 + self.主人.原形 * 10 + self.几座
    end
    return self.是否乘骑
end

function 坐骑:坐骑_取窗口属性()
    local list = {
        nid = self.nid,
        名称 = self.名称,
        等级 = self.等级,
        体力 = self.体力,
        最大体力 = self.最大体力,
        经验 = self.经验,
        最大经验 = self.最大经验,
        灵性 = self.灵性,
        力量 = self.力量,
        根骨 = self.根骨,
        是否乘骑 = self.是否乘骑,
        几座 = self.几座,
        外形 = 5000 + self.主人.原形 * 10 + self.几座,

    }

    return list
end

function 坐骑:是否拥有技能()
    local s = 0
    for k,v in pairs(self.技能) do
        s = s + 1
    end
    return s
end

function 坐骑:取拥有技能()
    local list = {}
    for k,v in pairs(self.技能) do
        list[#list + 1] = v.名称
    end
    return list
end

function 坐骑:修改坐骑技能(原始, 替换)
    for k,v in pairs(self.技能) do
        if v.名称 == 原始 then
            v.名称 = 替换
            self.技能[k] = require('对象/法术/坐骑')(v)
            return '已经完成技能替换'
        end
    end
    return '我找到可替换技能'
end

function 坐骑:取技能熟练(n)
    local s = {}
    for k,v in pairs(self.技能) do
        s[#s + 1] = v.熟练度
    end
    table.sort(s, function(a, b)
        return a > b
    end)
    return s[1]
end

function 坐骑:添加熟练(n)
    for k,v in pairs(self.技能) do
        v.熟练度 = v.熟练度 + n
        if v.熟练度 > 100000 then
            v.熟练度 = 100000
        end
    end
    for k,v in pairs(self.管制) do
        local s = __召唤[k]
        s:刷新属性()
    end
    return true
end

function 坐骑:添加经验(n)
    if self.等级 >= 100 then
        return
    end
    self.经验 = self.经验 + n
    while self.经验 >= self.最大经验 do
        self:升级处理()
        self.最大经验 = _坐骑经验库[self.等级 + 1]
    end
    return true
end

function 坐骑:升级处理()
    if self.等级 >= 100 then
        return
    end
    self.等级 = self.等级 + 1
    self.灵性 = self.灵性 + 1
    self.力量 = self.力量 + 1
    self.根骨 = self.根骨 + 1
    for k,v in pairs(self.管制) do
        local s = __召唤[k]
        s:刷新属性()
    end
end

function 坐骑:遍历技能()
    return next, self.技能
end

function 坐骑:坐骑_取技能列表()
    local list = {}
    for k, v in self:遍历技能() do
        table.insert(list, {
            名称 = v.名称,
            nid = v.nid,
            熟练度 = v.熟练度,
            描述 = v:取描述(self)

        })
    end
    return list
end

function 坐骑:删除技能(name)

end

function 坐骑:坐骑_管制召唤(nid)
    local s = __召唤[nid]
    if s and s.rid == self.rid then
        if self.管制[s.nid] then
            self.管制[s.nid] = nil
            s.被管制 = nil
            s:刷新属性()
            return 0
        else
            local gz = 0
            for k, v in pairs(self.管制) do
                gz = gz + 1
            end
            if gz >= 2 then
                return "#Y最多管制两只召唤兽！"
            end
            self.管制[s.nid] = s
            s.被管制 = self.nid
            s:刷新属性()
            return 1
        end
    end
end

function 坐骑:坐骑_清除管制()
    if self.管制 then
        for nid, s in pairs(self.管制) do
            if __召唤[nid] then
                __召唤[nid].被管制 = nil
                __召唤[nid]:刷新属性()
            end
        end
        self.管制 = {}
        return true
    end
    return false
end




return 坐骑
