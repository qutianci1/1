-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2023-09-14 20:30:38
require("json")
local _存档表 = require('数据库/存档属性_法宝')
local 法宝 = class('法宝')
local GGF = require('GGE.函数')

function 法宝:初始化(t)
    self:加载存档(t)

    if not self.nid then
        self.nid = _生成ID()
    end
    __法宝[self.nid] = self
end

function 法宝:__index(k)
    local 数据 = rawget(self, '数据')
    if 数据 and 数据[k] ~= nil then
        return 数据[k]
    end
    return _存档表[k]
end

function 法宝:__newindex(k, v)
    if _存档表[k] ~= nil then
        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

function 法宝:取存档数据(P)
    local r = {
        rid = P.id,
        nid = self.nid
    }
    for _, k in pairs { '名称', '主人', '阴阳', '等级', '灵气', '灵气上限', '道行', '升级道行', '参战' } do
        r[k] = self[k]
    end
    r.数据 = {}
    for k, v in pairs(_存档表) do
        if type(v) ~= 'table' and self[k] ~= v then
            r.数据[k] = self[k]
        end
    end
    return r
end

function 法宝:加载存档(t)
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
        self.灵气 = 600 + self.等级 * 30
        self.灵气上限 = 600 + self.等级 * 30
        self.升级道行 = math.pow(self.等级 + 1 , 3)
    end
end

return 法宝
