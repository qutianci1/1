-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-08 23:30:11
-- @Last Modified time  : 2022-08-27 11:43:19

-- local function _get(s, name)
--     local 脚本 = __脚本[s] and __脚本[s].BUFF
--     if type(脚本) == 'table' then
--         if name then
--             return 脚本[name]
--         end
--         return 脚本
--     end
-- end

local 战斗BUFF = class('战斗BUFF')

function 战斗BUFF:初始化(buff, 来源)
    self.buff = buff
    self.来源 = 来源
    self.回合数 = 1
end

function 战斗BUFF:__index(k)
    local buff = rawget(self, 'buff')
    if buff then
        return buff[k]
    end
end

function 战斗BUFF:BUFF回合开始(...)
    self.回合数 = self.回合数 + 1
    local func = self.buff.BUFF回合开始
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('BUFF回合开始 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗BUFF:BUFF指令开始(...)
    local func = self.buff.BUFF指令开始
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('BUFF指令开始 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗BUFF:BUFF被物理攻击前(...)
    local func = self.buff.BUFF被物理攻击前
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('BUFF被物理攻击前 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗BUFF:BUFF被法术攻击前(...)
    local func = self.buff.BUFF被法术攻击前
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('BUFF被法术攻击前 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗BUFF:BUFF回合结束(...)
    local func = self.buff.BUFF回合结束
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('BUFF回合结束 发生错误 ', self.id)
        end
    end
end

function 战斗BUFF:BUFF添加前(...)
    local func = self.buff.BUFF添加前
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('BUFF添加前 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗BUFF:BUFF添加后(...)
    local func = self.buff.BUFF添加后
    if type(func) == 'function' then
        local r, err = ggexpcall(func, self, ...)
        if r == gge.FALSE then
            warn('BUFF添加后 发生错误 ', self.id)
        end
        return r
    end
end

function 战斗BUFF:删除()
    self.来源:删除BUFF(self)
end

return 战斗BUFF
