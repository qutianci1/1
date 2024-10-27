-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-25 17:16:26
-- @Last Modified time  : 2024-07-31 12:28:43
local function _get(s, name)
    if not s then
        return
    end
    local 脚本 = __脚本[s]
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

local 战场 = class('战场')

function 战场:初始化(脚本, arg)
    self._数据 = {}
    self._对象表 = {}
    self._观战表 = {}
    self.是否结束 = nil
    self.回合数 = 1
    if 脚本 then
        self.脚本 = 脚本
        local func = _get(self.脚本, '战斗初始化')
        if type(func) == 'function' then
            ggexpcall(func, self, table.unpack(arg))
        end
        -- if ggexpcall(v.战斗结束, 战场, self.接口, table.unpack(arg)) ~= gge.FALSE then
        -- end
        self.是否惩罚 = _get(self.脚本, '是否惩罚')
    end
end

-- function 战场:__index(k)
--     local 脚本 = rawget(self, '脚本')
--     if 脚本 then
--         return 脚本[k]
--     end
-- end

function 战场:更新()
end

function 战场:发送(...) --对话
    -- for k,v in pairs(self._观战表) do
    --     if v.是否玩家 then
    --         v:发送(...)
    --     end
    -- end
end

function 战场:脚本战斗回合开始(...)
    local func = _get(self.脚本, '战斗回合开始')
    if type(func) == 'function' then
        ggexpcall(func, self, ...)
    end
end

function 战场:脚本战斗回合结束(...)
    local func = _get(self.脚本, '战斗回合结束')
    if type(func) == 'function' then
        ggexpcall(func, self, ...)
    end
end

function 战场:脚本战斗开始(...)
    local func = _get(self.脚本, '战斗开始')
    if type(func) == 'function' then
        ggexpcall(func, self, ...)
    end
end

function 战场:脚本战斗结束(...)
    local func = _get(self.脚本, '战斗结束')
    if type(func) == 'function' then
        ggexpcall(func, self, ...)
    end
end

function 战场:加入敌方(i, 对象, ...)
    if i >= 1 and i <= 10 then
        return self:加入(i + 10, 对象, ...)
    elseif i >= 21 and i <= 25 then
        return self:加入(i + 5, 对象, ...)
    end
end

function 战场:加入我方(i, 对象, ...)
    if (i >= 1 and i <= 10) or (i >= 21 and i <= 25) then
        return self:加入(i, 对象, ...)
    end
end

function 战场:加入(i, 对象, ...)
    if i < 1 or i > 31 then
        return
    end
    对象 = require('战斗/对象/对象')(i, 对象, self, ...)
    self._对象表[i] = 对象
    return 对象
end

function 战场:遍历敌方()
    return function(list, i)
        for n = i + 1, 20 do
            if list[n] then
                return n, list[n]
            end
        end
    end, self._对象表, 10
end

function 战场:遍历我方()
    return function(list, i)
        for n = i + 1, 10 do
            if list[n] then
                return n, list[n]
            end
        end
    end, self._对象表, 0
end

function 战场:遍历敌方玩家()
    return function(list, i)
        for n = i + 1, 20 do
            if list[n] and list[n].是否玩家 then
                return n, list[n]
            end
        end
    end, self._对象表, 10
end

function 战场:遍历我方玩家()
    return function(list, i)
        for n = i + 1, 10 do
            if list[n] and list[n].是否玩家 then
                return n, list[n]
            end
        end
    end, self._对象表, 0
end

function 战场:遍历玩家()
    return function(list, i)
        for n = i + 1, 20 do
            if list[n] and list[n].是否玩家 then
                return n, list[n]
            end
        end
    end, self._对象表, 0
end

function 战场:退出(i,助战)
    local 对象 = self._对象表[i]
    if 对象 then
        对象:战斗结束(助战)
        self._对象表[i] = nil
    end
    return 对象
end

function 战场:取对象(i)
    return self._对象表[i]
end

function 战场:取助战对象() -- 助战问题所在
    local 助战表 = {}
    for k, v in self:遍历玩家() do
        if v.是否玩家 and v.离线角色 then
            助战表[k] = v
        end
    end
    return 助战表
end

function 战场:遍历对象()
    return next, self._对象表
end

function 战场:指令开始()
    local t = {}
    for k, v in self:遍历对象() do
        t[k] = require('战斗/回合数据')()
        v:置接收数据(t[k])
    end
    return t
end

function 战场:指令结束()
    for k, v in self:遍历对象() do
        v:置接收数据(nil)
    end
end

function 战场:取敌方存活数()
    local n = 0
    for k, v in self:遍历敌方() do
        if not v.是否死亡 then
            n = n + 1
        end
    end
    return n
end

function 战场:取我方存活数()
    local n = 0
    for k, v in self:遍历我方() do
        if not v.是否死亡 then
            n = n + 1
        end
    end
    return n
end

function 战场:取数据(位置) --取战场正确数据
    local t = {}
    for k, v in self:遍历对象() do
        t[k] = v:取数据(位置)
    end
    -- print('===========')
    -- table.print(t)
    -- print('===========')
    return t
end

function 战场:战斗开始()
    __战场[self] = self
    self:脚本战斗开始()
    for k, v in pairs(self._对象表) do
        v:战斗开始()
    end
    self.来源 = coroutine.running()

    coroutine.xpcall(
        function()
            self:_战斗循环()
            self.退出定时 = 引擎:定时(
                200,
                function()
                    coroutine.xpcall(
                        function()
                            self:战斗结束()
                            self:脚本战斗结束(self.是否结束 == 1)
                            coroutine.xpcall(self.来源, self.是否结束 == 1) --1敌方全死
                        end
                    )
                end
            )
        end
    )

    return coroutine.yield()
end

function 战场:战斗结束()
    __战场[self] = nil
    for k, v in pairs(self._观战表) do
        coroutine.xpcall(
            function()
                v.rpc:退出战斗()
                v.是否观战 = false
                v.rpn:删除状态(v.nid, 'vs') --周围
                self._观战表[k] = nil
            end
        )
    end
    for k, v in pairs(self._对象表) do
        if v.是否玩家 then
            coroutine.xpcall(
                function()
                    v:战斗结束()
                    -- v.接口:刷新追踪面板()
                    v.rpc:退出战斗()
                end
            )
        else
            v:战斗结束()
        end
    end
end

--======================================================================
function 战场:_阶段_进入战斗(_ENV)
    self:指令开始()
    for k, v in self:遍历对象() do
        v:进入战斗()
    end
    self:指令结束()
    for k, v in self:遍历玩家() do
        if v.是否玩家 and not v.是否机器人 and not v.离线角色 then
            等待表[k] = v
            coroutine.xpcall(
                function()
                    local r = v.rpc:进入战斗(self:取数据(k), v.位置, self.回合数)
                    _继续(1, 1, k)
                end
            )
        end
    end

    self.定时 = _超时(10000)
    coroutine.yield()
end

function 战场:_阶段_打开菜单(_ENV)
    阶段 = 2
    for k, v in pairs(对象表) do
        if v.是否玩家 and v.是否机器人 then
            coroutine.xpcall(
                function()
                    v:机器人指令()
                end
            )
        end
        if v.是否玩家 and not v.是否机器人 and not v.离线角色 then
            玩家表[k] = v
            等待表[k] = v
            coroutine.xpcall(
                function()
                    local hhs = 回合数
                    if not v.离线角色 then
                        v:打开菜单(60)
                        if 阶段 == 2 and hhs == self.回合数 then
                            for _, P in v:遍历我方玩家() do
                                P.rpc:战斗操作(v.位置)
                            end
                            等待表[k] = nil
                        end
                    end
                end
            )
        elseif v.是否玩家 and v.离线角色 then
            离线玩家表[k] = v
        end
    end

    local 秒 = 0
    self.定时 = 引擎:定时(
        1000,
        function(ms)
            秒 = 秒 + 1
            if self.是否结束 then
                for k, v in pairs(等待表) do
                    v:强退自动战斗(true)
                    等待表[k] = nil
                end
                _CALL()
                return
            elseif 秒 >= 60 then
                for k, v in pairs(等待表) do
                    v:自动战斗(true)
                    v:执行自动()
                    等待表[k] = nil
                end
                _CALL()
                return
            elseif 秒 >= 3 then
                for k, v in pairs(离线玩家表) do

                    if v:执行自动() then
                        离线玩家表[k] = nil
                    end
                end                
                for k, v in pairs(玩家表) do
                    if v:执行自动() then
                        等待表[k] = nil
                    end
                end
                if not next(等待表) then
                    _CALL()
                    return
                end
            elseif 秒 >= 0 then
                if not next(等待表) then
                    _CALL()
                    return
                end
            end
            return ms
        end
    )
    coroutine.yield()
end

function 战场:_阶段_回合开始(_ENV)
    阶段 = 3
    local 数据 = self:指令开始()
    for k, v in pairs(对象表) do
        v:回合开始()
    end

    self:指令结束()

    for k, v in pairs(玩家表) do
        等待表[k] = v
        coroutine.xpcall(
            function()
                v:回合开始数据(数据)
                _继续(3, 回合数, k)
            end
        )
    end
    self.定时 = _超时(2000)
    coroutine.yield()
end

function 战场:_阶段_回合演算(_ENV)
    阶段 = 4
    local 先手表 = {}
    for k, v in pairs(对象表) do
        table.insert(先手表, v)
    end
    table.sort(先手表, _速度排序)

    local 数据 = {}
    while next(先手表) do
        local v = table.remove(先手表, 1)
        table.insert(数据, v:回合演算())

        if self.重新排序 then
            table.sort(先手表, _速度排序)
            self.重新排序 = nil
        end
        for k, v in pairs(对象表) do
            if v.昏睡解除 then
                if not v.已行动 then
                    table.insert(先手表, v)
                    table.sort(先手表, _速度排序)
                end
                v.昏睡解除 = nil
            end
        end
        if self:取敌方存活数() == 0 then --敌方
            self.是否结束 = 1
            break
        end
        if self:取我方存活数() == 0 then
            self.是否结束 = 2
            break
        end
    end

    for k, v in pairs(玩家表) do --逃跑会删除 对象表，所以用玩家表
        等待表[k] = v
        coroutine.xpcall(
            function()
                v:回合演算数据(数据)
                _继续(4, 回合数, k)
            end
        )
    end
    if #self._观战表 > 0 then
        for k, v in pairs(self._观战表) do
            coroutine.xpcall(
                function()
                    v.rpc:战斗数据(数据)
                end
            )
        end
    end
    local tempTime = 30000
       -- if self.是否结束 ~= nil then
       --     tempTime = 2000
       -- end
    self.定时 = _超时(tempTime)
    coroutine.yield()
end

function 战场:_阶段_回合结束(_ENV)
    阶段 = 5
    local 数据 = self:指令开始()
    for k, v in pairs(对象表) do
        v:回合结束()
    end
    self:指令结束()

    for k, v in pairs(玩家表) do --BUFF被动
        等待表[k] = v
        coroutine.xpcall(
            function()
                v:回合结束数据(数据)
                _继续(5, 回合数, k)
            end
        )
    end

    self.定时 = _超时(2000)
    coroutine.yield()
end

function 战场:强制结束()
    self.是否结束 = 2
    self.定时:删除()
    self:战斗结束()
end

function 战场:_战斗循环()
    local _ENV = setmetatable({ self = self }, { __index = _G })
    co = coroutine.running()

    阶段 = 1
    等待表 = {}
    对象表 = self._对象表
    离线玩家表 = {}
    function _速度排序(a, b)
        if __配置.乱敏 then
            local 速度差 = math.abs(a.速度 - b.速度)
            local 几率乱敏 = 0.3
            if math.random() <= 几率乱敏 then
                if 速度差 <= 300 then
                    return a.速度 < b.速度
                else
                    return a.速度 > b.速度
                end
            else
                return a.速度 > b.速度
            end
        else
            return a.速度 > b.速度
        end
    end

    function _CALL()
        if coroutine.xpcall(co) == coroutine.FALSE then
            for k, v in pairs(玩家表) do
                coroutine.xpcall(
                    function()
                        v.rpc:提示窗口('#R崩了#15')
                    end
                )
            end
            self:战斗结束()
            coroutine.xpcall(self.来源)
        end
    end

    function _超时(时间)
        return 引擎:定时(
            时间,
            function(ms)
                for k, v in pairs(等待表) do --超时
                    v:自动战斗(true)
                    等待表[k] = nil
                end
                _CALL()
            end
        )
    end

    function _继续(_阶段, _回合数, k)
        if 阶段 == _阶段 and _回合数 == self.回合数 then
            等待表[k] = nil
            if not next(等待表) then
                self.定时:删除()
                _CALL()
            end
            return true
        end
    end

    self:_阶段_进入战斗(_ENV) --1

    --========================================================================
    repeat
        if self.回合数 >= 150 then
            self:战斗结束()
            return
        end
        玩家表 = {}
        回合数 = self.回合数
        -- if not self.是否结束 then
            self:_阶段_打开菜单(_ENV) --2
        -- end
        -- if not self.是否结束 then
            self:_阶段_回合开始(_ENV) --3
        -- end
        -- if not self.是否结束 then
            self:_阶段_回合演算(_ENV) --4
        -- end
        -- if not self.是否结束 then
            self:_阶段_回合结束(_ENV) --5
        -- end
        self.回合数 = self.回合数 + 1
    until self.是否结束

    阶段 = 6

    return self.是否结束
end

return 战场
