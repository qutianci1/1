-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2023-08-19 18:29:13

local 接口 = {
    名称 = true,
    等级 = true,
    技能 = true,
    种族 = true,
    灵性 = true,
    根骨 = true,
    力量 = true,
    几座 = true,
    管制 = true
}

function 接口:学习技能(name)
    if #self.技能 >= 2 then
        return "只能学习两种技能！"
    end
    for _, v in self:遍历技能() do
        if v.名称 == name then
            return "不能学习已有技能"
        end
    end
    local r = require('对象/法术/坐骑')({ 名称 = name })
    table.insert(self.技能, r)
    self.刷新的属性.技能 = true
end

function 接口:坐骑_乘骑(v)
    return self:坐骑_乘骑(v)
end

function 接口:是否拥有技能()
    return self:是否拥有技能()
end

function 接口:取拥有技能()
    return self:取拥有技能()
end

function 接口:修改坐骑技能(原始, 替换)
    return self:修改坐骑技能(原始, 替换)
end

function 接口:添加经验(n)
    return self:添加经验(n)
end

function 接口:添加熟练(n)
    return self:添加熟练(n)
end

function 接口:取技能熟练()
    return self:取技能熟练()
end

function 接口:筋骨提气丸()
    local 上限 = 3
    local ll = self:取坐骑初值上限(self.种族, self.几座)
    if self.初灵 < ll.灵性 + 上限 or self.初力 < ll.力量 + 上限 or self.初根 < ll.根骨 + 上限 then
        if self.初灵 < ll.灵性 + 上限 then
            self.初灵 = self.初灵 + 1
        end

        if self.初力 < ll.力量 + 上限 then
            self.初力 = self.初力 + 1
        end

        if self.初根 < ll.根骨 + 上限 then
            self.初根 = self.初根 + 1
        end
        self:刷新属性()
        return true
    end
    return "#Y你的坐骑初值已满！"
end

--===============================================================================
if not package.loaded.坐骑接口_private then
    package.loaded.坐骑接口_private = setmetatable({}, { __mode = 'k' })
end
local _pri = require('坐骑接口_private')

local 坐骑接口 = class('坐骑接口')

function 坐骑接口:初始化(P)
    _pri[self] = P
    self.是否坐骑 = true
end

function 坐骑接口:__index(k)
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

return 坐骑接口
