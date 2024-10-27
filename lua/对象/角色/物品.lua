-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-26 08:24:16
-- @Last Modified time  : 2024-10-16 13:36:31

local GGF = require('GGE.函数')
local 角色 = require('角色')
local _变身卡库 = require('数据库/变身卡库')


function 角色:物品_初始化()
    local 存档物品 = self.物品
    do
        local _物品表 = {} --实际存放
        self.刷新的物品 = {} --变更的

        self.物品 = --虚假的，用作监视删除，刷新
        setmetatable(
            {},
            {
                __newindex = function(t, i, v)
                    if v then
                        v.rid = self.id
                        v.位置 = i
                        self.刷新的物品[i] = v
                        v:更新来源(self.物品, i)
                    else
                        local k = _物品表[i].nid
                        __垃圾[k] = _物品表[i]
                        __垃圾[k].rid = -1
                        self.刷新的物品[i] = false
                    end

                    _物品表[i] = v
                end,
                __index = _物品表,
                __pairs = function(...)
                    return next, _物品表
                end
            }
        )
    end

    do
        local _装备表 = {} --实际存放
        self.装备 =
        setmetatable(
            {},
            {
                __newindex = function(t, i, v)
                    if v then
                        v.rid = self.id
                        v.位置 = i | 256
                        v:更新来源(self.装备, i)
                    end
                    _装备表[i] = v
                end,
                __index = _装备表,
                __pairs = function(...)
                    return next, _装备表
                end
            }
        )
    end

    do
        local _孩子装备表 = {} --实际存放
        self.孩子装备 =
        setmetatable(
            {},
            {
                __newindex = function(t, i, v)
                    if v then
                        v.rid = self.id
                        v.位置 = i | 1024
                        v:更新来源(self.孩子装备, i)
                    end
                    _孩子装备表[i] = v
                end,
                __index = _孩子装备表,
                __pairs = function(...)
                    return next, _孩子装备表
                end
            }
        )
    end

    do
        local _仓库表 = {} --实际存放
        self.仓库 =
        setmetatable(
            {},
            {
                __newindex = function(t, i, v)
                    if v then
                        v.rid = self.id
                        v.位置 = i | 512
                        v:更新来源(self.仓库, i)
                    else
                        local k = _仓库表[i].nid
                        __垃圾[k] = _仓库表[i]
                        __垃圾[k].rid = -1
                    end
                    _仓库表[i] = v
                end,
                __index = _仓库表,
                __pairs = function(...)
                    return next, _仓库表
                end
            }
        )
    end

    if type(存档物品) == 'table' then
        for _, v in pairs(存档物品) do
            if not __物品[v.nid] or __物品[v.nid].rid == v.rid then
                local k = v.位置
                if k & 256 == 256 then
                    self.装备[k & 255] = require('对象/物品/物品')(v)
                elseif k & 512 == 512 then
                    self.仓库[k & 255] = require('对象/物品/物品')(v)
                elseif k & 1024 == 1024 then
                    self.孩子装备[k & 1023] = require('对象/物品/物品')(v)
                else
                    self.物品[k] = require('对象/物品/物品')(v)
                end
            end
        end
    end

    self:刷新装备属性()
end

function 角色:物品_更新()
    if next(self.刷新的物品) then
        coroutine.xpcall(
            function()
                if self.rpc:请求刷新物品() then
                    local t = {}
                    for k, v in pairs(self.刷新的物品) do
                        t[k] = v and v:取简要数据()
                    end
                    self.rpc:刷新物品(t)
                end
                self.刷新的物品 = {}
            end
        )
    end
end

function 角色:物品_获取(名称)
    for k, v in self:物品_遍历物品() do
        if v.名称 == 名称 then
            return v
        end
    end
end

function 角色:物品_获取数量(名称)
    for k, v in self:物品_遍历物品() do
        if v.名称 == 名称 then
            return v.数量
        end
    end
end

function 角色:物品_扣除数量(名称,数量)
    for k, v in self:物品_遍历物品() do
        if v.名称 == 名称 then
            if v.数量 then
                if v.数量 < 数量 then
                    return false
                end
            else
                return false
            end
            v.数量 = v.数量 - 数量
            if v.数量 <= 0 then
                self.物品[k]:丢弃()
            end
            return true
        end
    end
    return false
end

function 角色:角色_包裹数量() --页数
    -- if gge.isdebug then
    --     return 4
    -- end
    return self.转生 + 1
end

function 角色:物品_遍历物品(p)
    local a, b
    if type(p) == 'number' then
        a = (p - 1) * 24
        b = a + 24
    else
        a, b = 0, self:角色_包裹数量() * 24
    end
    return function()
        a = a + 1
        while a <= b do
            if self.物品[a] then
                return a, self.物品[a]
            end
            a = a + 1
        end
    end
end

function 角色:物品_遍历空位(p)
    local a, b
    if type(p) == 'number' then
        a = (p - 1) * 24
        b = a + 24
    else
        a, b = 0, self:角色_包裹数量() * 24
    end
    return function()
        a = a + 1
        while a <= b do
            if not self.物品[a] then
                return a
            end
            a = a + 1
        end
    end
end

function 角色:物品_遍历所有(p)
    local a, b
    if type(p) == 'number' then
        a = (p - 1) * 24
        b = a + 24
    else
        a, b = 0, self:角色_包裹数量() * 24
    end
    return function()
        a = a + 1
        if a <= b then
            return a, self.物品[a]
        end
    end
end

function 角色:物品_查找空位(p)
    return self:物品_遍历空位(p)()
end

function 角色:物品_查找位置(item, p)
    for i, v in self:物品_遍历物品(p) do
        if v:检查合并(item) then
            return i, v
        end
    end
    return self:物品_遍历空位(p)()
end

function 角色:物品_查找位置2(item, p)
    for i, v in self:物品_遍历物品(p) do
        if v:检查合并2(item) then
            return i, v
        end
    end
    return self:物品_遍历空位(p)()
end

function 角色:物品_交换合并(a, b) --拿起的是a
    local A, B = self.物品[a], self.物品[b]
    if A and B and B:检查合并2(A) then
        if not B:合并(A) then
            B:合并2(A)
            return A, B
        end
        return B
    else
        self.物品[a] = B
        self.物品[b] = A
        return true
    end
end

function 角色:物品_检查空间()
    local 格子 = self:角色_包裹数量() * 24
    for i=1,格子 do
        if not self.物品[i] then
            return i
        end
    end
    return
end

local function _协程遍历空位(self, p)
    return coroutine.wrap(
        function()
            for i in self:物品_遍历空位(p) do
                coroutine.yield(i)
            end
        end
    )
end

function 角色:物品_检查添加(list)
    if type(list) ~= 'table' then
        return
    end
    if #list == 0 then
        return {}
    end
    for i, v in ipairs(list) do
        if ggetype(v) == '物品接口' then
            v = v[0x4253]
            list[i] = v
        end
        if ggetype(v) ~= '物品' then
            return false
        end
    end

    local 位置 = {}
    local 取空 = _协程遍历空位(self)
    for a, item in ipairs(list) do
        if item.是否叠加 then
            for _, v in self:物品_遍历物品() do
                if v:检查合并(item) then
                    位置[a] = v
                    goto continue
                end
            end
        end

        local i = 取空()
        if i then
            位置[a] = i
            goto continue
        end

        do return false end

        ::continue::
    end

    return 位置
end

function 角色:角色_添加物品(lx,sl) --lx名称sl为数量
    local 空位 = self:物品_查找空位()
    if 空位 < sl then
        return '#Y你身上的空位不足,清理空间后再兑换吧'
    end
    local 材料,单价 = '见闻录',3
    if lx == '高级藏宝图' then
        材料,单价 = '见闻录',3
    end
    if lx == '超级藏宝图' then
        材料,单价 = '指南录',5
    end
    local 数量 = self:物品_获取数量(材料)
    if 数量 == nil or 数量 == 0 then
        return
    end
    if math.floor(数量 / 单价) < sl then
        return '#Y你没有足够的#G'..材料
    end
    for i=1,sl do
        self:物品_添加({__沙盒.生成物品 {名称 = lx, 数量 = 1}})
    end
    self:物品_扣除数量(材料,sl * 单价)
    return {提示 = '#Y你获得了'..lx , 见闻录 = self:物品_获取数量('见闻录') , 指南录 = self:物品_获取数量('指南录')}
end

function 角色:角色_添加变身卡(name, count, kind)
    local 空位 = self:物品_查找空位()
    if 空位 < 1 then
        return '#Y你身上的空位不足,清理空间后再来吧'
    end
    local 类型 = {'抗性','物理','强法'}
    if self.银子 < _变身卡库[类型[kind]][name].变身卡价格*count then
        return '#Y你的金钱不足'
    end
    self.银子 = self.银子 - _变身卡库[类型[kind]][name].变身卡价格*count
    self.rpc:提示窗口("#Y你扣除了%s两银子", _变身卡库[类型[kind]][name].变身卡价格*count)

    local 参数 = _变身卡库[类型[kind]][name]
    参数.类型 = 类型[kind]
    self:物品_添加({__沙盒.生成物品 {名称 = name, 数量 = count , 参数 = 参数 }})
end

function 角色:物品_添加(list)
    local 位置 = self:物品_检查添加(list)
    if type(位置) == 'table' then
        for i, v in ipairs(位置) do
            if type(v) == 'number' then
                self.物品[v] = list[i]
                if self.物品[v].数据.名称 == '高级藏宝图' then
                    local _地图 = {1110,1131,1142,1146,1193,1478,1092,1140,1070,1091,1136}
                    local map = __地图[_地图[math.random(#_地图)]]
                    map = map and map.接口
                    while not map do
                        map = __地图[_地图[math.random(#_地图)]]
                        map = map and map.接口
                    end
                    local X, Y = map:取随机坐标()
                    self.物品[v].数据.参数 = {}
                    self.物品[v].数据.参数.地图信息 = {名称 = map.名称 , id = map.id}
                    self.物品[v].数据.参数.坐标 = {x = X, y = Y}
                elseif self.物品[v].数据.名称 == '超级藏宝图' then
                        local _地图 = {1110,1131,1142,1146,1193,1478,1092,1140,1070,1091,1136}
                        local map = __地图[_地图[math.random(#_地图)]]
                        map = map and map.接口
                        while not map do
                            map = __地图[_地图[math.random(#_地图)]]
                            map = map and map.接口
                        end
                        local X, Y = map:取随机坐标()
                        self.物品[v].数据.参数 = {}
                        self.物品[v].数据.参数.地图信息 = {名称 = map.名称 , id = map.id}
                        self.物品[v].数据.参数.坐标 = {x = X, y = Y}
                elseif self.物品[v].数据.名称 == '藏宝图' then
                    local _地图 = {1110,1131,1142,1146,1193,1478,1092,1140,1070,1091,1136}
                    local map = __地图[_地图[math.random(#_地图)]]
                    map = map and map.接口
                    while not map do
                        map = __地图[_地图[math.random(#_地图)]]
                        map = map and map.接口
                    end
                    local X, Y = map:取随机坐标()
                    self.物品[v].数据.参数 = {}
                    self.物品[v].数据.参数.地图信息 = {名称 = map.名称 , id = map.id}
                    self.物品[v].数据.参数.坐标 = {x = X, y = Y}
                elseif self.物品[v].数据.孩子装备 then
                    self.物品[v].数据.装备属性 = {}
                    local 属性条数=math.random(3, 5)
                    local 属性列表={"气质","内力","智力","耐力","悟性"}
                    local 拥有属性={}
                    while #拥有属性<属性条数 do
                      local 随机=math.random(1,#属性列表)
                      拥有属性[#拥有属性+1]=属性列表[随机]
                      table.remove(属性列表,随机)
                    end
                    local 类型 = MYF.取孩子装备类型(self.物品[v].数据.名称)
                    if 类型 == '武器' then
                        local 属性值=MYF.rank(0.1,0.5,属性条数,100)
                        for i=1,属性条数 do
                            self.物品[v].数据.装备属性[拥有属性[i]]=属性值[i]
                        end
                        self.物品[v].数据.性别=MYF.取孩子装备性别限制(self.物品[v].数据.名称)
                    else
                        local 属性值=MYF.rank(0.1,0.5,属性条数,40)
                        for i=1,属性条数 do
                            self.物品[v].数据.装备属性[拥有属性[i]]=属性值[i]
                        end
                        self.物品[v].数据.性别=MYF.取孩子装备性别限制(名称)
                    end
                end
            else
                v:合并(list[i])
            end
        end
        return true
    end
end

--====================================================================================
function 角色:角色_打开物品窗口(nid)
    if nid then
        for i,p in self:遍历队伍() do
            if p.nid == nid then

                p.窗口.物品 = true
                local wx = p.原形
                if p.武器 and p.武器 ~= 0 then
                    wx = p.武器
                end
                return p.银子, p.师贡, p:角色_包裹数量(), wx , p.存银
            end
        end
        self.窗口.物品 = true
        local wx = self.原形
        if self.武器 and self.武器 ~= 0 then
            wx = self.武器
        end
        return self.银子, self.师贡, self:角色_包裹数量(), wx , self.存银
    else
        self.窗口.物品 = true
        local wx = self.原形
        if self.武器 and self.武器 ~= 0 then
            wx = self.武器
        end
        return self.银子, self.师贡, self:角色_包裹数量(), wx , self.存银
    end
end

function 角色:角色_获取存银现金()
    return self.银子, self.存银
end

function 角色:角色_取款操作(数额)
    if self.存银 < 数额 then
        self.rpc:最后对话('你的存银不足,取款失败！')
        return
    end
    self.存银 = self.存银 - 数额
    self.银子 = self.银子 + 数额
    self.rpc:最后对话('这位客官本次取出现银'..数额..',欢迎下次光临#93')
end

function 角色:角色_关闭物品窗口()
    self.窗口.物品 = false
end

function 角色:角色_物品列表(p, sum,nid)
    if nid then
        if type(p) == 'number' then
            for i,c in self:遍历队伍() do
                if c.nid == nid then
                    local r = {}
                    for i, v in c:物品_遍历物品(p) do
                        i = i % 24
                        if i == 0 then
                            i = 24
                        end
                        r[i] = v:取简要数据(c, sum)
                    end
                    return r
                end
            end
        end
        if type(p) == 'number' then
            local r = {}
            for i, v in self:物品_遍历物品(p) do
                i = i % 24
                if i == 0 then
                    i = 24
                end
                r[i] = v:取简要数据(self, sum)
            end
            return r
        end
    else
        if type(p) == 'number' then
            local r = {}
            for i, v in self:物品_遍历物品(p) do
                i = i % 24
                if i == 0 then
                    i = 24
                end
                r[i] = v:取简要数据(self, sum)
            end
            return r
        end
    end
    return {}
end

function 角色:角色_装备列表(nid)
    if nid then
        for i,p in self:遍历队伍() do
            if p.nid == nid then
                local r = {}
                for i, v in pairs(p.装备) do
                    r[i] = v:取简要数据()
                end
                return r
            end
        end
        local r = {}
        for i, v in pairs(self.装备) do
            r[i] = v:取简要数据()
        end
        return r
    else
        local r = {}
        for i, v in pairs(self.装备) do
            r[i] = v:取简要数据()
        end
        return r
    end
end

function 角色:角色_孩子装备列表(x)
    if not self.孩子[x] then
        return "没找到这个孩子"
    end

    local r = {}
    local startIdx = (x - 1) * 4 + 1
    local endIdx = x * 4
    local num = 0
    for i = startIdx, endIdx do
        num = num + 1
        if self.孩子装备[i] then
            r[num] = self.孩子装备[i]:取简要数据()
        end
    end
    return r
end

function 角色:角色_物品使用(i)
    if not self.是否战斗 and not self.是否摆摊 and not self.是否交易 then
        local item = self.物品[i]
        if item then
            if item.是否装备 then
                local r = item:检查要求(self)
                if r == true then
                    item:穿上(self)
                    local n = item.部位
                    self.物品[i] = self.装备[n]
                    self.装备[n] = item
                    self:检查装备()
                    self:刷新装备属性()
                    self:刷新属性()
                    return 3, n
                end
                return r
            elseif item.人物是否可用 then
                local r = item:使用(self.接口)

                if type(r) == 'string' then
                    return 0, r
                elseif self.物品[i] == nil then --删除
                    return 2
                end
                return 1, item:取简要数据()
            end
        end
    end
end

function 角色:角色_召唤物品使用(i, 召唤)
    -- print(string.format('%08x',召唤.染色))
    if not self.是否战斗 and not self.是否摆摊 and not self.是否交易 then
        local item = self.物品[i]
        if item then
            if item.是否装备 then
            elseif item.召唤是否可用 then
                local r = item:使用(召唤.接口)

                if type(r) == 'string' then
                    return 0, r
                elseif self.物品[i] == nil then --删除
                    return 2
                end
                return 1, item:取简要数据()
            end
        end
    end
end

function 角色:角色_取物品信息(i)
    if self.物品[i] then
        return self.物品[i]
    end
end

function 角色:角色_物品丢弃(i, n)
    if self.加锁状态 then
        self.接口:常规提示('#Y高级操作请先解除安全码!请不要将安全码透露给他人')
        return
    end
    if self.是否战斗 and self.是否摆摊 and self.是否交易 then
        return
    end
    if type(i) ~= 'number' then
        return
    end

    if self.物品[i] then
        return self.物品[i]:丢弃(n)
    end
end

function 角色:角色_删除物品(名称)
    for i=1,96 do
        if self.物品[i]~=nil then
            if self.物品[i].名称 == 名称 then
                self.物品[i]:丢弃()
                break
            end
        end
    end
end

function 角色:角色_物品交换(a, b)
    if not self.是否战斗 and not self.是否摆摊 and not self.是否交易 then
        if type(a) == 'number' and type(b) == 'number' and self.物品[a] then
            if b & 0xFF00 ~= 0 then
                b = self:物品_查找空位(b >> 8)
            end
            if b then
                local A, B = self:物品_交换合并(a, b)
                if A == true then
                    return 2 --交换
                elseif B then
                    return 3, A:取简要数据(), B:取简要数据()
                elseif A then
                    return 1, A:取简要数据() --合并
                end
            end
        end
    end
end

function 角色:角色_物品拆分(a, b, n)
    if self.是否战斗 and self.是否摆摊 and self.是否交易 then
        return
    end
    if type(a) ~= 'number' or type(b) ~= 'number' or type(n) ~= 'number' then
        return
    end
    if not self.物品[a] or self.物品[a].数量 < n or n < 1 or self.物品[b] then
        return
    end
    if self.物品[a].数量 == n then
        self:物品_交换合并(a, b)
        return 2
    end
    self.物品[b] = self.物品[a]:拆分(n)
    return 1, self.物品[a]:取简要数据(), self.物品[b]:取简要数据()
end

function 角色:角色_脱下装备(i)
    if not self.是否战斗 and not self.是否摆摊 and not self.是否交易 then
        if type(i) == 'number' and self.装备[i] then
            local n = self:物品_查找空位()
            if n then
                self.物品[n] = self.装备[i]
                if self.装备[i].是否有效 ~= false then
                    self.装备[i]:脱下(self)
                end

                self.装备[i] = nil
                self:检查装备()
                self:刷新装备属性()
                self:刷新属性()
                return true
            end
        end
    end
end

function 角色:角色_物品整理(p)
    if self.是否战斗 or self.是否摆摊 or self.是否交易 then
        return
    end
    local list = {}
    for i, v in self:物品_遍历物品(p) do
        self.物品[i] = nil
        table.insert(list, v)
    end
    table.sort(list, function(a, b)
        return (a.id or 0) < (b.id or 0)
    end)
    local ii = (p - 1) * 24
    for i, v in ipairs(list) do
        self.物品[i+ii] = v
    end
end

function 角色:角色_物品清理(p)
    if self.是否战斗 or self.是否摆摊 or self.是否交易 then
        return
    end
    local list = {}
    for i, v in self:物品_遍历物品(p) do
        self.物品[i]:丢弃()
    end
end
