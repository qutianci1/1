-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-27 14:03:33
-- @Last Modified time  : 2022-08-22 11:37:06

local 事件 = {}

function 事件:定时(ms, fun, ...)
    if not self._定时表 then
        self._定时表 = {}
    end
    self._定时表[fun] = __世界:定时(
        ms * 1000,
        function(...)
            if self._停止所有 then
                return
            end
            local r = ggexpcall(fun, self, ...)
            if type(r) == 'number' then
                r = r * 1000
            end
            return r
        end,
        ...
    )
end

function 事件:删除定时(fun)
    if not fun then
        self._停止所有 = true
    end
end

function 事件:取地图(id)
    local map = __地图[id]
    return map and map.接口
end

function 事件:取随机地图(t)
    if type(t) ~= 'table' then
        return
    end
    local map
    local n = 0
    repeat
        map = __地图[t[math.random(#t)]]
        n = n + 1
    until map or n > 100
    return map and map.接口
end

function 事件:发送世界(...) --69
    __世界:发送世界(...)
end

function 事件:发送系统(...) --71
    __世界:发送系统(...)
end

function 事件:发送信息(...) --114
    __世界:发送信息(...)
end

function 事件:INFO(...) --69
    __世界:INFO(...)
end
return 事件
