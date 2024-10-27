-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-27 04:44:10
-- @Last Modified time  : 2024-10-19 00:29:02
local 战斗对象 = require('战斗对象')

function 战斗对象:事件_初始化()
    do
        local kname
        local function event(_, ...)
            for i, v in pairs(self.BUFF列表) do
                local fun = v[kname]
                if type(fun) == 'function' then
                    local r = { coroutine.xpcall(fun, v, ...) }
                    if r[1] ~= coroutine.FALSE and r[1] ~= nil then
                        return table.unpack(r)
                    end
                end
            end
            for i, v in pairs(self.法术列表) do
                --if v.是否被动 then
                    local fun = v[kname]
                    if type(fun) == 'function' then
                        local r = { coroutine.xpcall(fun, v, ...) }
                        if r[1] ~= coroutine.FALSE and r[1] ~= nil then
                            return table.unpack(r)
                        end
                    end
                --end
            end
        end

        self.ev =
        setmetatable(
            {},
            {
                __index = function(_, k)
                    kname = k
                    return event
                end
            }
        )
    end
end

function 战斗对象:生成镜像()
    local r = {

    }
    return setmetatable(
        r,
        {
            __index = self,
            __newindex = self
        }
    )
end

function 战斗对象:取技能nid(名称)
    local 编号 = 0
    for n=1,#self.主动技能 do
        if self.主动技能[n].名称 == 名称 then
            编号 = self.主动技能[n].nid
        end
    end
    return 编号
end

function 战斗对象:取技能名称(nid)
    local 名称 = 0
    for n=1,#self.主动技能 do
        if self.主动技能[n].nid == nid then
            名称 = self.主动技能[n].名称
        end
    end
    return 名称
end

function 战斗对象:是否PK()
    return self.战场.脚本 == nil
end

function 战斗对象:是否我方(目标)
    if self.位置 < 11 then
        return 目标.位置 < 11
    else
        return 目标.位置 > 10
    end
end

function 战斗对象:是否敌方(目标)
    if self.位置 < 11 then
        return 目标.位置 > 10
    else
        return 目标.位置 < 11
    end
end

function 战斗对象:遍历敌方()
    if self.位置 < 11 then
        return self.战场:遍历敌方()
    else
        return self.战场:遍历我方()
    end
end

function 战斗对象:遍历我方()
    if self.位置 < 11 then
        return self.战场:遍历我方()
    else
        return self.战场:遍历敌方()
    end
end

function 战斗对象:遍历玩家()
    self.战场:遍历玩家()
end

function 战斗对象:遍历敌方玩家()
    if self.位置 < 11 then
        return self.战场:遍历敌方玩家()
    else
        return self.战场:遍历我方玩家()
    end
end

function 战斗对象:遍历我方玩家()
    if self.位置 < 11 then
        return self.战场:遍历我方玩家()
    else
        return self.战场:遍历敌方玩家()
    end
end

function 战斗对象:遍历敌方存活()
    local list = {}
    for k, v in self:遍历敌方() do
        if not v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历我方存活()
    local list = {}
    for k, v in self:遍历我方() do
        if not v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历敌方死亡()
    local list = {}
    for k, v in self:遍历敌方() do
        if v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历我方死亡()
    local list = {}
    for k, v in self:遍历我方() do
        if v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历我方死亡玩家()
    local list = {}
    for k, v in self:遍历我方() do
        if v.是否死亡 and v.是否玩家 then
            list[k] = v
        end
    end
    return next, list
end


function 战斗对象:遍历敌方存活玩家()
    local list = {}
    for k, v in self:遍历敌方() do
        if v.是否玩家 and not v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历我方存活玩家()
    local list = {}
    for k, v in self:遍历我方() do
        if v.是否玩家 and not v.是否死亡 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历敌方召唤()
    local list = {}
    for k, v in self:遍历敌方() do
        if v.是否召唤 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:遍历我方召唤()
    local list = {}
    for k, v in self:遍历我方() do
        if v.是否召唤 then
            list[k] = v
        end
    end
    return next, list
end

function 战斗对象:取我方指定单位存活(name)
    local 存活 = 0
    for k, v in self:遍历我方() do
        if v.名称 == name and not v.是否死亡 then
            存活 = 存活 + 1
        end
    end
    return 存活
end

function 战斗对象:取敌方方随机指定种族单位(种族)
    local 单位 = 0
    for k, v in self:遍历敌方() do
        if v.种族 then
            if v.种族 == 种族 and not v.是否死亡 then
                单位 = v.位置
                break
            end
        end
    end
    return 单位
end

function 战斗对象:取召唤信息(位置)
    for k, v in self:遍历我方() do
        if v.位置 == 位置 then
            return v
        end
    end
end

function 战斗对象:取我方死亡单位()
    local list = {}
    for k, v in self:遍历我方() do
        if v.是否死亡 then
            table.insert(list, v)
        end
    end
    if #list > 0 then
        return list[math.random(#list)].位置
    end
    return nil
end

function 战斗对象:取我方死亡()
    local list = {}
    for k, v in self:遍历我方() do
        if v.是否死亡 then
            table.insert(list, v)
        end
    end
    return list
end

function 战斗对象:取敌方存活(f)
    local list = {}
    for i, v in self:遍历敌方存活() do
        if not f or f ~= v then
            table.insert(list, v)
        end
    end
    return list
end

function 战斗对象:取敌方存活数()
    return #self:取敌方存活()
end

function 战斗对象:取首目标()
    local 战场 = self.战场
    local 首目标 = self.目标
    local r = 战场:取对象(首目标)
    if r and not r.是否死亡 then
        return r
    end
end

function 战斗对象:取我方存活(f)
    local list = {}
    for i, v in self:遍历我方存活() do
        if not f or f ~= v then
            table.insert(list, v)
        end
    end
    return list
end

function 战斗对象:取我方存活数()
    return #self:取我方存活()
end

function 战斗对象:取物理目标()
    local v = self.战场:取对象(self.目标)
    if v and not v.是否隐身 and not v.是否死亡 and not v:取BUFF('封印') then
        return v
    end
    for i, v in self:遍历敌方存活() do
        if not v.是否隐身 and not v.是否死亡 and not v:取BUFF('封印') then
            return v
        end
    end
end

function 战斗对象:取主人目标(位置)
    for k, v in self.战场:遍历玩家() do
        if v.位置 == 位置 then
            return v
        end
    end

end

function 战斗对象:取转移对象()
    local list = {}
    for k, v in self:遍历敌方() do
        if not v.是否死亡 and not v:取BUFF('封印') then
            table.insert(list, v)
        end
    end
    if #list > 0 then
        return list[math.random(#list)]
    end
end

function 战斗对象:取法术目标(名称)
    local 法术 = self.当前法术
    local list
    local 函数 = '取'
    函数 = 函数 .. (法术.敌方可用 and '敌方' or '我方')
    函数 = 函数 .. (法术.存活可用 and '存活' or '死亡')
    if 名称 == '倩女幽魂' or 名称 == '一曲销魂' or 名称 == '银索金铃' or 名称 == '大手印' or 名称 == '锦襕袈裟' then
        local rr = self:取首目标()
        if rr then
            if (rr.位置 <= 10 and self.位置 <= 10) or (rr.位置 > 10 and self.位置 > 10) then
                函数 = '取我方存活'
            else
                函数 = '取敌方存活'
            end
        end
    elseif 名称 == '互相拉血' then
        函数 = '取我方死亡'
    end

    list = 法术:法术取目标(self)
    if type(list) == 'table' then
        return list
    else
        local n, fun = 法术:法术取目标数(self.孩子增益)
        print(n)
        if 名称=='血海深仇' or 名称=='落日熔金' then
            if self:取我方玩家倒地数量()>=4 then
                n=n+1 fun=fun+1
            end
        end
        if type(n) == 'number' then
            list = self[函数](self, self:取首目标())
            if type(fun) == 'function' then
                if 名称 == '狮王之怒' or 名称 == '魔神附身' then
                    local function fun(a , b)
                        return a.攻击 > b.攻击
                    end
                else
                    local function fun(a , b)
                        return a.速度 > b.速度
                    end
                end
                table.sort(list, fun)
            end
            local r = self:取首目标()
            if r then
                table.insert(list, 1, r)
            end
            if not 法术.程府 and 名称 ~= '大手印' then
                local i = 1
                repeat
                    if list[i] then
                        if list[i]:取BUFF('封印') then
                            table.remove(list, i)
                        else
                            i = i + 1
                        end
                    end
                until not list[i]
            end
            if fun then
                list = { table.unpack(list, 1, n) }
            elseif #list > 0 then
                local nl = {}

                table.insert(nl, table.remove(list, 1))

                for i = 1, n - 1 do
                    if #list > 0 then
                        table.insert(nl, table.remove(list, math.random(#list)))
                    end
                end
                list = nl
            end
        else
            list = self[函数](self, 1)
        end
    end

    for i, v in ipairs(list) do
        list[i] = v
    end

    return list
end

function 战斗对象:取我方玩家倒地数量()
    local n = 0
    for k, v in self:遍历我方() do
        if v.是否死亡 and v.是否玩家 then
            n = n + 1
        end
    end
    return n
end

function 战斗对象:遍历法术()
    return next, self.法术列表
end

function 战斗对象:取BUFF(name)
    return self.BUFF列表[name]
end

function 战斗对象:取内丹(name)
    for k, v in pairs(self.内丹列表) do
        if v.名称 == name then
            return v
        end
    end
end

function 战斗对象:添加BUFF(buff)
    if not self.当前数据 or type(buff) ~= 'table' then
        return
    end

    buff = require('战斗/对象/BUFF')(buff, self)

    if buff.名称 and self.ev:BUFF添加前(buff, self) ~= false then
        local o = self.BUFF列表[buff.名称]
        if o then
            o.回合数 = 9999
            o:BUFF回合结束(self)
        end

        self.BUFF列表[buff.名称] = buff
        self.ev:BUFF添加后(buff, self)
        self.当前数据:添加BUFF(buff.id)
        return buff
    end
end

function 战斗对象:删除BUFF(buff)
    if not self.当前数据 then
        return
    end

    if type(buff) == 'string' then
        if self.BUFF列表[buff] then
            self.当前数据:删除BUFF(self.BUFF列表[buff].id)
            self.BUFF列表[buff] = nil
        end
    else
        self.当前数据:删除BUFF(buff.id)
        self.BUFF列表[buff.名称] = nil
    end
end

function 战斗对象:增加气血(v, ...)
    -- print('增加气血了',...)
    if not self.当前数据 then
        return
    end
    self.气血 = self.气血 + v
    if self.气血>self.最大气血 then
        self.气血=self.最大气血
    end
    self.当前数据:气血(v, ...)
    if self.是否死亡 then
        self.当前数据:复活()
        self.是否死亡 = false
    end
    -- print(self.是否死亡)
end

function 战斗对象:减少气血(v, ...)
    if not self.当前数据 then
        return
    end
    self.气血 = self.气血 - v
    self.当前数据:气血(-v, ...)

    if self.气血 <= 0 then
        self.气血 = 0
        self.是否死亡 = true
    end

    if self.是否死亡 then
        if self.是否消失 then
            self.战场:退出(self.位置)
        end
        self.当前数据:死亡(self.是否消失)
    end
end

function 战斗对象:增减气血(v)
    if not self.当前数据 then
        return
    end
    if v >= 0 then
        self:增加气血(v, 1)
    else
        self:减少气血(v, 1)
    end
end

function 战斗对象:增加魔法(v, ...)
    if not self.当前数据 then
        return
    end
    self.魔法 = self.魔法 + v
    if self.魔法 > self.最大魔法 then
        self.魔法 = self.最大魔法
    end
    self.当前数据:魔法(v, ...)
end

function 战斗对象:减少魔法(v, ...)
    if not self.当前数据 then
        return
    end
    self.魔法 = self.魔法 - v
    self.当前数据:魔法(-v, ...)

    if self.魔法 <= 0 then
        self.魔法 = 0
    end
end

function 战斗对象:可视减少魔法(v)
    if not self.当前数据 then
        return
    end
    self.魔法 = self.魔法 - v
    self.当前数据:魔法(-v, 2)

    if self.魔法 <= 0 then
        self.魔法 = 0
    end
end

function 战斗对象:增减魔法(v)
    if not self.当前数据 then
        return
    end
    if v >= 0 then
        self:增加魔法(v, 1)
    else
        self:减少魔法(v, 1)
    end
end

function 战斗对象:双加(a, b)
    if not self.当前数据 then
        return
    end
    if a >= 0 then
        self:增加气血(a, 2)
        self:增加魔法(b, 2)
    else
        self:减少气血(a, 2)
        self:减少魔法(b, 2)
    end
end

function 战斗对象:减少怨气(v, ...)
    self.怨气 = self.怨气 - v
    if self.怨气 <= 0 then
        self.怨气 = 0
    end
end

function 战斗对象:提示(内容)
    if not self.当前数据 then
        return
    end
    --self.当前数据.位置 = self.位置
    self.当前数据:提示(内容)
end

function 战斗对象:取我方指定单位(name)
    local 位置 = 0
    for k, v in self:遍历我方() do
        if v.名称 == name then
            位置 = v.位置
        end
    end
    return 位置
end

function 战斗对象:随机我方存活目标() --混乱
    local list = {}
    for k, v in self:遍历我方() do
        if not v.是否死亡 and v.位置 ~= self.位置 and not v:取BUFF('封印') then
            table.insert(list, v)
        end
    end
    if #list > 0 then
        return list[math.random(#list)].位置
    end
end

function 战斗对象:随机敌方存活目标() --混乱
    local list = {}
    for k, v in self:遍历敌方() do
        if not v.是否死亡 and not v:取BUFF('封印') then
            table.insert(list, v)
        end
    end
    if #list > 0 then
        return list[math.random(#list)].位置
    end
    return 0
end

function 战斗对象:随机敌方(n, fun)
    local list = {}
    for k, v in self:遍历敌方() do
        if not fun or fun(v) then
            table.insert(list, v)
        end
    end
    if #list > 0 and n > 0 then
        if n == 1 then
            return { list[math.random(#list)] }
        else
            while #list > n do
                table.remove(list, math.random(#list))
            end
            return list
        end
    end
    return {}
end
