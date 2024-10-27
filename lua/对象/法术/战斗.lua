-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-27 12:04:11
-- @Last Modified time  : 2024-05-09 22:52:11

local function _get(s, name)
    local 脚本 = __脚本[s]
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

local 战斗技能 = class('战斗技能')
function 战斗技能:法术施放(...)
    local func = _get(self.脚本, '法术施放')
    if type(func) == 'function' then
        if self.熟练度 then
            -- print(self.是否召唤)
            self:添加熟练度(1)
        end
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('法术施放 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗技能:法术施放后(...)
    local func = _get(self.脚本, '法术施放后')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('法术施放后 发生错误 ', self.id)
        end
    end
end

function 战斗技能:法术取目标(...)
    local func = _get(self.脚本, '法术取目标')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('法术取目标 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗技能:法术取消耗(...)
    local func = _get(self.脚本, '法术取消耗')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('法术取消耗 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗技能:法术取目标数(a,c)
    local func = _get(self.脚本, '法术取目标数')
    if type(func) == 'function' then
        local r = { ggexpcall(func, self,a,c) }
        if r[1] == gge.FALSE then
            warn('法术取目标数 发生错误 ', self.id)
        end
        return table.unpack(r)
    end
end

function 战斗技能:法术取目标数事件()
    local func = _get(self.脚本, '法术取目标数事件')
    if type(func) == 'function' then
        local r = { ggexpcall(func, self) }
        if r[1] == gge.FALSE then
            warn('法术取目标数事件 发生错误 ', self.id)
        end
        return table.unpack(r)
    end
end

function 战斗技能:法术取描述(...)
    local func = _get(self.脚本, '法术取描述')
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('法术取描述 发生错误 ', self.id)
        end
        return r
    end
end

return 战斗技能
