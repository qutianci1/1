-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-03-13 14:32:39
-- @Last Modified time  : 2024-05-08 22:41:47

--可以访问的属性
local 接口 = {
    id = true,
    名称 = true,
    飞行 = true,
    PK = true
}
--可以访问的方法
function 接口:遍历玩家()
end

function 接口:遍历NPC()
    return self.NPC
end

function 接口:遍历跳转()
end
function 接口:取NPC(id)
    return self.NPC[id]
end
function 接口:添加NPC(t)
    local r = self:添加NPC(t)
    return r and r.nid
end

function 接口:删除NPC(nid)
    return self:删除NPC(nid)
end

function 接口:取随机坐标(...)
    return self:随机坐标(...)
end

function 接口:取随机坐标(...)
    return self:随机坐标(...)
end

function 接口:发送系统(...) --71
    __世界:发送系统(...)
end


if not package.loaded.角色接口_private then
    package.loaded.角色接口_private = setmetatable({}, {__mode = 'k'})
end
local _pri = require('角色接口_private')
local 地图接口 = class('地图接口')

function 地图接口:初始化(P)
    _pri[self] = P
end

function 地图接口:__index(k)
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

function 地图接口:__pairs(k)
    return 接口
end
return 地图接口
