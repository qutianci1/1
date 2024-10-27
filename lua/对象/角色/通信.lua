-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-08 12:12:24
-- @Last Modified time  : 2024-04-24 15:06:01

local 角色 = require('角色')

function 角色:通信_初始化()
    local SVR = require('server')
    do
        local kname
        local function send(_, ...)
            if self.cid then
                return SVR[kname](SVR, self.cid, ...)
            end
        end
        self.rpc =
            setmetatable(
            {},
            {
                __index = function(_, k)
                    kname = k
                    return send
                end
            }
        )
    end

    do
        local kname
        local function send(_, ...)
            if self.cid then
                local fun = SVR[kname]
                for _, v in pairs(self.周围玩家) do
                    if not v.离线角色 then
                        fun(SVR, v.cid, ...)
                    end
                end
            end
        end
        self.rpn =
            setmetatable(
            {},
            {
                __index = function(_, k)
                    kname = k
                    return send
                end
            }
        )
    end

    do
        local kname
        local function send(_, ...)
            if self.cid and self.是否组队 and self.队伍 then
                local fun = SVR[kname]
                for _, v in pairs(self.队伍) do
                    if v ~= self and not v.离线角色 then
                        fun(SVR, v.cid, ...)
                    end
                end
            end
        end
        self.rpt =
            setmetatable(
            {},
            {
                __index = function(_, k)
                    kname = k
                    return send
                end
            }
        )
    end

    do
        local kname
        local function send(_, ...)
            if self.cid and self.帮派 and self.帮派 ~= "" then
                local 帮派 = __帮派[self.帮派]
                local fun = SVR[kname]
                --根据你自己的 的成员列表来
                for k, v in pairs(帮派.成员列表) do
                    local P = __玩家[k]
                    if P ~= self and not p.离线角色 then
                        fun(SVR, P.cid, ...)
                    end
                end
            end
        end
        self.rpf =
            setmetatable(
            {},
            {
                __index = function(_, k)
                    kname = k
                    return send
                end
            }
        )
    end
end
