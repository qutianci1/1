-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-06 14:16:38
-- @Last Modified time  : 2024-08-27 11:13:51
local _存档表 = require('数据库/存档属性_技能')
local function _get(s, name)
    local 脚本 = __脚本[s]
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

local 战斗技能 = require('对象/法术/战斗')
local 技能 = class('技能', 战斗技能)
function 技能:初始化(t)
    self:加载存档(t)
    if not self.nid then
        self.nid = _生成ID()
    end
    __技能[self.nid] = self
    self.脚本 = string.format("scripts/skill/门派/%s.lua", self.名称)
    if self.类别 == '门派' then
        self.阶段 = self.id % 10
    end
end

function 技能:__index(k)
    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end

    local r = _get(rawget(self, '脚本'), k)
    if r ~= nil then
        return r
    end
    return _存档表[k]
end

function 技能:__newindex(k, v)
    if _存档表[k] ~= nil then
        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

function 技能:取描述()
    local fun = _get(self.脚本, '法术取描述')
    if type(fun) == 'function' then
        return ggexpcall(fun, self)
    end
    return '无'
end

function 技能:转换(name)
    self.名称=name
    self.脚本=string.format( "scripts/skill/门派/%s.lua",name)
end


function 技能:取消耗()
    local fun = _get(self.脚本, '法术取消耗')
    if type(fun) == 'function' then
        return ggexpcall(fun, self)
    end
    return -1
end

local _熟练度上限 = { 10000, 15000, 20000, 25000 }
function 技能:刷新熟练度上限(P)
    self.熟练度上限 = _熟练度上限[P.转生 + 1]
end

function 技能:添加熟练度(v)
    self.熟练度 = self.熟练度 + v
    if self.熟练度上限 and self.熟练度 > self.熟练度上限 then --召唤没有上限
        self.熟练度 = self.熟练度上限
    end
end

function 技能:取存档数据(P)
    local r = {
        rid = P.id,
        nid = self.nid,
        名称 = self.名称,
        熟练度 = self.熟练度,
    }
    r.数据 = self.数据
    return r
end

function 技能:加载存档(t)
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
    else
        rawset(self, '数据', t)
    end
end

return 技能
