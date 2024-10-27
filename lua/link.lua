-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-03-13 14:32:39
-- @Last Modified time  : 2024-09-05 01:05:57

local CLT, REG = require('GOL.RPCClient')()


function CLT:断开事件(id, op, err)
    引擎:print('\x1b[31;1m内网服务连接断开\x1b[0m', op, err)
end


function REG:注册账号(...)
    return __存档.注册账号(...)
end

function REG:修改密码(...)
    return __存档.修改密码(...)
end

--====================================================================

local ip = __配置.内网.地址
local port = __配置.内网.端口
local name = __配置.内网.服名
if CLT:连接(ip, port) then
    coroutine.xpcall(function()
        if CLT:验证('xy2link') then
            CLT:连接服名(name)
            引擎:print('\x1b[32;1m内网服务连接成功\x1b[0m', ip, port)
        else
            引擎:print('\x1b[31;1m内网服务连接失败\x1b[0m', ip, port)
        end
    end)
else
    引擎:print('\x1b[31;1m内网服务连接失败\x1b[0m', ip, port)
end


return CLT
