-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-20 05:27:53
-- @Last Modified time  : 2022-09-03 17:10:59
local 角色 = require('角色')

function 角色:称谓_初始化()
    self.称谓列表 = {}
end

function 角色:角色_打开称谓窗口()
    local r = self:角色_取称谓列表()
    return r
end

function 角色:角色_更换称谓(i)
    if not self.称谓列表[i] then
        return false
    end
    self.称谓 = self.称谓列表[i]
    local r = self:角色_取称谓列表()
    self.rpc:切换称谓(self.nid, self.称谓)
    self.rpn:切换称谓(self.nid, self.称谓)
    return r
end

function 角色:角色_隐藏称谓()
    self.称谓 = ''
    local r = self:角色_取称谓列表()
    self.rpc:切换称谓(self.nid, self.称谓)
    self.rpn:切换称谓(self.nid, self.称谓)

    return r
end

function 角色:角色_删除称谓(t)
    for k, v in pairs(self.称谓列表) do
        if v == t then
            table.remove(self.称谓列表, k)
        end
    end
    if self.称谓 == t then
        self.称谓 = ''
    end
    local r = self:角色_取称谓列表()
    return r
end

function 角色:角色_添加称谓(t)
    for k, v in pairs(self.称谓列表) do
        if v == t then
            return false
        end
    end
    self.称谓 = t
    table.insert(self.称谓列表, t)
    self.rpc:提示窗口("#Y恭喜你获得了一个新的称谓：" .. t)
    return true
end

function 角色:角色_取称谓列表()
    if not self.是否战斗 then
        local r = { self.称谓 }

        for k, v in self:遍历称谓() do
            r[k + 1] = v
        end
        return r
    end
end

function 角色:遍历称谓()
    return next, self.称谓列表
end

function 角色:取称谓是否存在(r)
    for _, v in self:遍历称谓() do
        if v == r then
            return true
        end
    end
    return false
end


