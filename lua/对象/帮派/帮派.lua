-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-09-07 13:51:44
-- @Last Modified time  : 2024-08-23 10:22:29
local GGF = require('GGE.函数')
local _存档表 = require('数据库/存档属性_帮派')
local _munpack = require('cmsgpack.safe').unpack
local 帮派 = class('帮派')

local 职位数量上限={帮主=1,副帮主=1,左护法=1,右护法=1,长老=4,堂主=6,香主=6,精英=24,帮众=99999}
local 职位管理级别={帮主=1,副帮主=2,左护法=3,右护法=3,长老=4,堂主=5,香主=6,精英=7,帮众=8}
local 职位俸禄 = {帮主=1225000,副帮主=1109000,左护法=900000,右护法=900000,长老=625000,堂主=400000,香主=225000,精英=100000,帮众=60000}--每周,官方10倍

function 帮派:帮派(t,v)
    self:加载存档(t,v)
    if not self.nid then
        self.nid = _生成ID()
    end
    __帮派[self.名称] = self
end

function 帮派:__index(k)
    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end
    return _存档表[k]
end

function 帮派:__newindex(k, v)
    if _存档表[k] ~= nil then
        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

function 帮派:进入地图(P)
    local 编号=1218
    if self.等级 > 1 and self.等级 < 4 then
        编号=1219
    elseif self.等级>4 then
        编号=1226
    end
    if not self.地图 then
        self.地图 = self:生成帮派(编号)
        self.地图:添加跳转({
            X = 150,
            Y = 7,
            tid = 1001,
            tX = 166,
            tY = 98
        })
    end
    --判断队友
    P:移动_切换地图(self.地图, 3060, 2090)
end

function 帮派:生成帮派(编号)
    local 地图 = __沙盒.生成地图(编号)
    地图:添加NPC {
        名称 = "帮派总管",
        外形 = 3011,
        脚本 = 'scripts/npc/帮派/帮派总管.lua',
        X = 27,
        Y = 84,
        帮派 = self}

    地图:添加NPC {
        名称 = "账房先生",
        外形 = 3089,
        脚本 = 'scripts/npc/帮派/账房先生.lua',
        X = 64,
        Y = 108,
        帮派 = self}
    地图:添加NPC {
        名称 = "帮派守护",
        外形 = 2077,
        脚本 = 'scripts/npc/帮派/帮派守护.lua',
        X = 55,
        Y = 69,
        帮派 = self}
    地图:添加NPC {
        名称 = "坐骑驯养师",
        外形 = 3043,
        脚本 = 'scripts/npc/帮派/坐骑驯养师.lua',
        X = 142,
        Y = 50,
        帮派 = self}
    地图:添加NPC {
        名称 = "召唤兽驯养师",
        外形 = 3061,
        脚本 = 'scripts/npc/帮派/召唤兽驯养师.lua',
        X = 148,
        Y = 45,
        帮派 = self}

    return 地图
end

function 帮派:帮派升级()
    self.等级 = self.等级 + 1
    local 人数上限 = {150,200,225,1000,2000}
    if 人数上限[self.等级] then
        self.最大成员数量 = 人数上限[self.等级]
    end
end

function 帮派:获取帮派数据(P) --客户端获取数据
    self:更新成员信息()
    local 返回数据    = {}
    返回数据.名称     = self.名称
    返回数据.创始人   = self.创始人
    返回数据.成员数量 = self:取成员人数()
    返回数据.战绩值 = self.战绩值
    返回数据.财产值 = self.帮派资金
    返回数据.建设度 = self.建设度
    返回数据.等级     = self.等级
    返回数据.名望值 = self.名望值
    返回数据.帮主     = self.帮主
    返回数据.威望值 = self.威望值
    返回数据.成员上限 = self.最大成员数量

    返回数据.宗旨     = self.宗旨
    返回数据.申请列表 = self.申请列表
    返回数据.成员列表 = self.成员列表
    返回数据.核心成员 = self.核心成员
    return 返回数据
end

function 帮派:更新成员信息()
    for k, v in self:遍历成员() do
        if __玩家[k]==nil then
            v.状态='离线'
        else
            v.名字 = __玩家[k].名称
            v.ID = __玩家[k].id
            v.NID = __玩家[k].nid
            -- v.原型 = __玩家[k].原型
            v.等级 = __玩家[k].等级
            v.转生 = __玩家[k].转生
            v.种族 = __玩家[k].种族
            v.性别 = __玩家[k].性别
            v.模型 = __玩家[k].原形
            v.成就 = __玩家[k].帮派数据.帮派成就
            v.贡献 = __玩家[k].帮派数据.帮派贡献
            v.职务 = v.职务
            v.管理级别 = 职位管理级别[v.职务]
            v.状态 = '在线'
        end
    end
end

function 帮派:任命官职(职务,nid)
    if self:取成员(nid) then
        local 新职务=self:取成员(nid).职务
        if 职务==新职务 then
            return '职务并没有变动'
        end
        local 数量=0
        for k,v in pairs(self.成员列表) do
            if v.职务==职务 then
                数量=数量+1
            end
        end
        if 数量>=职位数量上限[职务] then
            return '当前职位已达上限,无法继续任命'
        end
        self.成员列表[nid].职务=职务
        return true
    end
    return '不存在这位成员'
end

function 帮派:ID取成员(id)
    for k, v in self:遍历成员() do
        if v.ID == id then
            return v
        end
    end
end

function 帮派:取成员(nid)
    return self.成员列表[nid]
end

function 帮派:遍历成员()
    return next, self.成员列表
end

function 帮派:取成员人数()
    local n = 0
    for k, v in self:遍历成员() do
        n = n + 1
    end
    return n
end

function 帮派:是否可升级()
    local 升级建设度 = {20000 , 60000 , 120000 , 200000}
    if 升级建设度[self.等级] then
        if self.建设度 >= 升级建设度[self.等级] then
            return true
        end
    end
    -- return true
    return false
end

function 帮派:成员添加(P, 职务,名称)
    if not self.成员列表[P.nid] then
        P.帮派 = self.名称
        -- P:添加称谓(名称..'帮主')
        -- table.print(P)
        self.成员列表[P.nid] = {
            名字 = P.名称,
            ID = P.id,
            NID = P.nid,
            -- 原型 = P.原型,
            等级 = P.等级,
            转生 = P.转生,
            种族 = P.种族,
            性别 = P.性别,
            模型 = P.原形,
            成就 = P.帮派数据.帮派成就,
            贡献 = P.帮派数据.帮派贡献,
            职务 = 职务,
            管理级别 = 职位管理级别[职务],
            状态 = '在线'
        }
        self.成员数量=self:取成员人数()
        return true
    end
end

function 帮派:成员删除(t)
    if self.成员列表[t.nid] then
        self.成员列表[t.nid] = nil
        self.成员数量=self:取成员人数()
        return true
    end
end

function 帮派:成员上线(P)
    if self.成员列表[P.nid] then
        self.成员列表[P.nid].状态 = '在线'
        return true
    end
end

function 帮派:申请加入(P)
    local 重复=false
    for i=1,#self.申请列表 do
        if self.申请列表[i].nid == P.nid then
            重复 = true
        end
    end
    if 重复 then
        return '你已存在申请列表中'
    end
    table.insert(self.申请列表,{nid=P.nid,名字=P.名称,种族=P.种族,性别=P.性别,转生=P.转生,等级=P.等级})
end

function 帮派:响应帮派(P)
    if self.响应 > 10 then
        return
    end
    self.响应 = self.响应 + 9 --直接创建成功
    self:成员添加(P, "帮众")
    table.insert(self.响应列表, P.nid)
    return true
end

function 帮派:加载存档(t,v) --读取存档
    if v then --读取数据库数据
        if type(t) == 'table' then
            rawset(self, '数据', _munpack(t.数据))
            for k, v in pairs(_存档表) do
                if type(v) == 'table' and type(self[k]) ~= 'table' then
                    self[k] = {}
                end
            end
            for k, v in pairs(_munpack(t.数据)) do
                self[k] = v
            end
            t.数据 = nil
            for k, v in pairs(t) do
                self[k] = v
            end
        else
            rawset(self, '数据', t)
        end
    else --新建帮派
        if type(t.数据) == 'table' then --新建帮派
            rawset(self, '数据', t.数据)
            for k, v in pairs(t) do
                self[k] = v
            end
            for k, v in pairs(_存档表) do
                if type(v) == 'table' and type(self[k]) ~= 'table' then
                    self[k] = {}
                end
            end
        else
            rawset(self, '数据', t)
            self.成员列表 = {}
        end
    end

end

function 帮派:取存档数据()--定时存储接口
    local r = {
        nid = self.nid,
        名称 = self.名称,
        帮主 = self.帮主,
        等级 = self.等级
    }
    r.数据 = {}
    for k, v in pairs(_存档表) do
        r.数据[k]=v
    end
    for k, v in pairs(self.数据) do
        r.数据[k]=v
    end
    return r
end

return 帮派
