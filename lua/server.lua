-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-03-13 14:32:39
-- @Last Modified time  : 2024-09-05 01:07:25

local SVR, REG = require('GOL.RPCServer')()
local GGF = require('GGE.函数')

--setmetatable({}, { __mode = 'v' })
do
    --RPC直达
    function SVR:绑定角色()
        for k, v in pairs(require('对象/角色/角色')) do
            if k:sub(1, 6) == '角色' then
                REG[k] = function(_, id, ...)
                    if _角色[id] and _角色[id].主角色 then
                        local r = { ggexpcall(v, _角色[id].主角色, ...) }
                        if r[1] == gge.FALSE then
                            -- _角色[id].主角色.rpc:提示窗口('#R崩了#15')
                        else
                            return table.unpack(r)
                        end
                    else
                        __世界:print('角色不存在', id,_角色[id])
                    end
                end
            end
        end
    end

    SVR:绑定角色()
    --RPC直达
    function SVR:绑定召唤()
        for k, v in pairs(require('对象/召唤/召唤')) do
            if k:sub(1, 6) == '召唤' then
                REG[k] = function(_, id, nid, ...)
                    if _角色[id] and _角色[id].主角色 then
                        if __召唤[nid] then
                            local r = { ggexpcall(v, __召唤[nid], ...) }
                            if r[1] == gge.FALSE then
                                -- _角色[id].主角色.rpc:提示窗口('#R崩了#15')
                            else
                                return table.unpack(r)
                            end
                        else
                            __世界:print('召唤不存在', nid)
                        end
                    end
                end
            end
        end
    end

    SVR:绑定召唤()
    --RPC直达
    function SVR:绑定宠物()
        for k, v in pairs(require('对象/宠物')) do
            if k:sub(1, 6) == '宠物' then
                REG[k] = function(_, id, nid, ...)
                    if _角色[id] and _角色[id].主角色 then
                        if __宠物[nid] then
                            return ggexpcall(v, __宠物[nid], ...)
                        else
                            __世界:print('宠物不存在', nid)
                        end
                    end
                end
            end
        end
    end

    SVR:绑定宠物()


    function SVR:绑定坐骑()
        for k, v in pairs(require('对象/坐骑/坐骑')) do
            if k:sub(1, 6) == '坐骑' then
                REG[k] = function(_, id, nid, ...)
                    if _角色[id] and _角色[id].主角色 then
                        if __坐骑[nid] then
                            local r = { ggexpcall(v, __坐骑[nid], ...) }
                            if r[1] == gge.FALSE then
                                -- _角色[id].主角色.rpc:提示窗口('#R崩了#15')
                            else
                                return table.unpack(r)
                            end
                        else
                            __世界:print('坐骑不存在', nid)
                        end
                    end
                end
            end
        end
    end

    SVR:绑定坐骑()

    function SVR:绑定法宝()
        for k, v in pairs(require('对象/法宝/法宝')) do
            if k:sub(1, 6) == '法宝' then
                REG[k] = function(_, id, nid, ...)
                    if _角色[id] and _角色[id].主角色 then
                        if __法宝[nid] then
                            return ggexpcall(v, __法宝[nid], ...)
                        else
                            __世界:print('法宝不存在', nid)
                        end
                    end
                end
            end
        end
    end

    SVR:绑定法宝()

end
--====================================================================
local _连接 = {}
function SVR:连接事件(id, ip, port)
    _连接[id] = nil
    return false --连接需要验证
end

function SVR:断开事件(id, op, err)
    if _角色[id] then
        coroutine.xpcall(function()
            if err == 0 then
                if not _角色[id].主角色:下线() then
                    warn('下线失败：', _角色[id].主角色.名称)
                end
            else
                _角色[id].主角色:掉线()
            end
            warn("角色已经断开！！！！！！！")
            -- _角色[id] = nil
        end)
    end
end

function SVR:验证事件(id, ver)
    if ver == '1.6' then --TODO
        return true --验证通过
    end

    return false
end

--====================================================================

function REG:ping()
    return true
end

function REG:登录_验证账号(id, 账号, 密码)
    local user = __存档.验证账号(账号, 密码)
    if user then
        _连接[id] = user.id
        return __存档.角色列表(_连接[id],user)
    end
    return '#R账号或密码错误!'
end

function REG:登录_进入游戏(id, i,数据)
    if _连接[id] then
        local t = __存档.角色列表(_连接[id])[i]
        if t and not __玩家[t.nid] then
            local data = __存档.角色读档(t.nid)
            if _角色[id] == nil then _角色[id] = {子角色={}} end
            _角色[id].子角色[t.nid]= require('对象/角色/角色')(data)
            _角色[id].主角色 = _角色[id].子角色[t.nid]
            if _角色[id].主角色.封号 == '否' then
                _角色[id].主角色.是否助战 = false
                _角色[id].主角色:上线(id,数据)
                return true
            else
                _角色[id].主角色:下线()
                _角色[id].主角色.是否助战 = nil
                _角色[id].主角色 = nil
                return false
            end
        end
        return false
    end
end

function REG:离线角色_快速加入(id)
    local 角色数据  =  __存档.角色列表(_连接[id])
    local 返回数据  = {}
    for i,v in pairs(角色数据) do
        返回数据[#返回数据+1] = {v,i}
        if __玩家[v.nid] then
            返回数据[#返回数据][1].在线 = true
        end
    end
    return 返回数据
end

function REG:离线登录_进入游戏(id, i,数据)
    local 角色数据  =  __存档.角色列表(_连接[id])
    local t = 角色数据[tonumber(i)]
    local existence
    for i,v in pairs(角色数据) do
        if v.nid == t.nid then
            existence = i
            break
        end
    end
    if existence and t and not __玩家[t.nid] then
        local data = __存档.角色读档(t.nid)
        if _角色[id] == nil then return end
        if not _角色[id].主角色.是否组队 or not _角色[id].主角色.是否队长 then
            return '#R只有队长才可进行此操作'
        elseif #_角色[id].主角色.队伍 == 5 then
            return '#R队伍已经满员了。'
        end
        if _角色[id].子角色 == nil then _角色[id].子角色 = {} end
        _角色[id].子角色[t.nid] = require('对象/角色/角色')(data)
        if _角色[id].子角色[t.nid].封号 == '否' then
            _角色[id].子角色[t.nid]:离线上线(id,t)
            _角色[id].子角色[t.nid].是否助战 = true
            return true
        else
            _角色[id].子角色[t.nid]:下线()
            _角色[id].子角色[t.nid].是否助战 = nil
            _角色[id].子角色[t.nid] = nil
            return false
        end
    end
    return false
end

function REG:登录_强制进入游戏(id, i)
    print(_连接[id],id,"强制进入游戏")
    if _连接[id] then
        local t = __存档.角色列表(_连接[id])[i]
        local P = t and __玩家[t.nid]
        if P then
            if P.离线角色 then
                return "该角色已经加入助战，请T出队伍后重新上线操作！"
            end
            if _角色[id] == nil then _角色[id] = {子角色={}} end
            _角色[id].主角色 = P
            _角色[id].子角色[P.nid] = P
            return _角色[id].主角色:重新上线(id)
        end
    else
        return "强制进入游戏失败，连接id不存在"
    end
end

function REG:取连接id(id)
    return _连接[id]
end

function REG:登录_创建角色(id, 名称, 外形)
    if _连接[id] then
        return __存档.角色创建(_连接[id], 名称, 外形)
    end
end

function REG:获取公告(id)
    return 'test'
end

function REG:获取区服(id)
    return {}
end

function REG:是否开放注册(id)
    return true
end

function REG:注册账号(id, 区名, 账号, 密码, 安全, 体验, QQ)
    return __存档.注册账号(账号, 密码, 安全, 体验, QQ)
end

--====================================================================

function REG:取物品描述(id, nid)
    if __物品[nid] then
        return __物品[nid]:取描述()
    end
end

function REG:生成物品(id, 道具)
    if 道具 then
        local dj = __沙盒.生成指定装备 { 名称 = 道具.名称,等级=道具.等级 }
        return dj
    end
end


function REG:取物品是否可交易(id, nid)
    if __物品[nid] then
        return __物品[nid]:取物品是否可交易()
    end
end

local function 聊天信息处理(内容)
    for i = 64, 73 do
        内容 = 内容:gsub('#' .. i, '##' .. i)
    end
    内容 = 内容:gsub('#100', '##100')
    for i = 114, 116 do
        内容 = 内容:gsub('#' .. i, '##' .. i)
    end
    for i = 154, 158 do
        内容 = 内容:gsub('#' .. i, '##' .. i)
    end
    内容 = 内容:gsub('#212', '##212')
    return 内容
end

function REG:界面聊天(id, 内容, 频道)
    if _角色[id].主角色.禁言 == '是' then
        _角色[id].主角色.rpc:提示窗口('#Y你已被禁言,如有疑问请联系管理员')
        return
    end
    local P = _角色[id].主角色
    if P and type(内容) == 'string' then
        内容 = 聊天信息处理(内容)
        if 频道 == 1 then --当前
            P:聊天_发送周围(内容)
        elseif 频道 == 2 then --队伍
            P:聊天_发送队伍(内容)
        elseif 频道 == 3 then --帮派
            P:聊天_发送帮派(内容)

        elseif 频道 == 4 then --世界
            P:聊天_发送世界(内容)
        elseif 频道 == 5 then --GM
            P:聊天_发送GM(内容)
        elseif 频道 == 6 then --传音
            P:聊天_发送私聊(内容)
        elseif 频道 == 7 then --信息
            P:聊天_发送信息(内容)
        elseif 频道 == 8 then --经济
            P:聊天_发送经济(内容)
        elseif 频道 == 9 then --夫妻
            P:聊天_发送夫妻(内容)
        elseif 频道 == 0 then --游侠
            P:聊天_发送游侠(内容)
        end
    end
end
function REG:上报BUG(id,err)
    local P = _角色[id].主角色
    if err then
        -- print('客户端id:',P.id,'BUG:',err)
    end
end
function REG:test5(id, v)
    local P = _角色[id].主角色
    if P then
        -- P:物品_添加 {
        --     __沙盒.生成物品 {名称 = '草果', 数量 = 1}
        -- }
        --P:任务_添加(__沙盒.生成任务({名称 = '模板'}))

        -- P:刷新属性()
        if P.是否战斗 then
        else
            coroutine.xpcall(
                function()
                    P.接口:进入战斗('scripts/war/模板.lua')
                end
            )
        end
    end
end

function REG:test6(id, v)
    -- local P = _角色[id]
    -- if P then
    --     local r = P:任务_获取('模板').接口
    --     r.进度 = r.进度 + 2
    -- end
    coroutine.yield()
end

function REG:查询角色(id,data)
    local 名称 = _角色[id].主角色.名称
    local 权限 = false
    for i=1,#__管理角色 do
        if __管理角色[i] == 名称 then
            权限 = true
        end
    end
    if not 权限 then
        return '你没有管理权限'
    end
    local 结果 = false
    local 玩家数据 = {}
    for k,v in pairs(__玩家) do
        if v.名称 == data then
            结果 = true
            玩家数据 = v
        end
    end
    if not 结果 then
        return '未找到此玩家'
    end
    return {名称 = 玩家数据.名称 , 状态 = '在线' , 禁言 = 玩家数据.禁言 or '否' , 封号 = 玩家数据.封号 or '否' , 仙玉 = 玩家数据.仙玉,uid = 玩家数据.uid}
end

function REG:强制下线(id,data)
    local 名称 = _角色[id].主角色.名称
    local 权限 = false
    for i=1,#__管理角色 do
        if __管理角色[i] == 名称 then
            权限 = true
        end
    end
    if not 权限 then
        return '你没有管理权限'
    end
    local 结果 = false
    local 玩家数据 = {}
    for k,v in pairs(__玩家) do
        if v.名称 == data then
            结果 = true
            玩家数据 = v
        end
    end
    if not 结果 then
        return '未找到此玩家'
    end
    __玩家[玩家数据.nid]:下线()
    return '该玩家已下线'
end

function REG:强制所有玩家下线(id)
    print(111)
    local 名称 = _角色[id].主角色.名称
    local 权限 = false
    for i=1,#__管理角色 do
        if __管理角色[i] == 名称 then
            权限 = true
        end
    end
    if not 权限 then
        return '你没有管理权限'
    end
    
    -- 遍历所有玩家，强制他们下线
    for k,v in pairs(__玩家) do
        __玩家[k]:下线()
    end
    
    return '所有玩家已下线'
end

function REG:修改禁言(id,data)
    local 名称 = _角色[id].主角色.名称
    local 权限 = false
    for i=1,#__管理角色 do
        if __管理角色[i] == 名称 then
            权限 = true
        end
    end
    if not 权限 then
        return '你没有管理权限'
    end
    local 结果 = false
    local 玩家数据 = {}
    for k,v in pairs(__玩家) do
        if v.名称 == data then
            结果 = true
            玩家数据 = v
        end
    end
    if not 结果 then
        return '未找到此玩家'
    end
    if __玩家[玩家数据.nid].禁言 == '否' then
        __玩家[玩家数据.nid].禁言 = '是'
        return '该玩家已被禁言'
    else
        __玩家[玩家数据.nid].禁言 = '否'
        return '该玩家已被解除禁言'
    end
end

function REG:修改封号(id,data)
    local 名称 = _角色[id].主角色.名称
    local 权限 = false
    for i=1,#__管理角色 do
        if __管理角色[i] == 名称 then
            权限 = true
        end
    end
    if not 权限 then
        return '你没有管理权限'
    end
    local 结果 = false
    local 玩家数据 = {}
    for k,v in pairs(__玩家) do
        if v.名称 == data then
            结果 = true
            玩家数据 = v
        end
    end
    if not 结果 then
        return '未找到此玩家'
    end
    if __玩家[玩家数据.nid].封号 == '否' then
        __玩家[玩家数据.nid].封号 = '是'
        return '该玩家已被禁止上线'
    else
        __玩家[玩家数据.nid].封号 = '否'
        return '该玩家已被允许上线'
    end
end

function REG:修改仙玉(id,data,v)
    local 名称 = _角色[id].主角色.名称
    local 权限 = false
    for i=1,#__管理角色 do
        if __管理角色[i] == 名称 then
            权限 = true
        end
    end
    if not 权限 then
        return '你没有管理权限'
    end
    local 结果 = false
    local 玩家数据 = {}
    for k,v in pairs(__玩家) do
        if v.名称 == data then
            结果 = true
            玩家数据 = v
        end
    end
    if not 结果 then
        return '未找到此玩家'
    end
    玩家数据.仙玉 = v
    local 当前时间 = os.date("%Y-%m-%d %H:%M:%S")
    local loginxy = string.format("%s - 管理员: %s, 玩家: %s, 修改前仙玉: %d, 修改后仙玉: %d",
                                  当前时间, 名称 or "未知", 玩家数据 and 玩家数据.名称 or "未知",  更新前仙玉 or 0, v or 0)
    MYF.写出管理日志('管理日志.txt', loginxy)
    return '修改成功'
end

function REG:添加物品(id,data,w)
    local 名称 = _角色[id].主角色.名称
    local 权限 = false
    for i=1,#__管理角色 do
        if __管理角色[i] == 名称 then
            权限 = true
        end
    end
    if not 权限 then
        return '你没有管理权限'
    end
    local 结果 = false
    local 玩家数据 = {}
    for k,v in pairs(__玩家) do
        if v.名称 == data then
            结果 = true
            玩家数据 = v
        end
    end
    if not 结果 then
        return '未找到此玩家'
    end
    local 物品信息 = GGF.分割文本(w, '*')
    if type(物品信息) == 'table' and 物品信息[1] and 物品信息[2] then
        if type(物品信息[1]) == 'string' and type(tonumber(物品信息[2])) == 'number' then
            物品信息[2] = 物品信息[2] + 0
            local 物品表 = {}
            local 物品 = __沙盒.生成物品{名称 = 物品信息[1]}
            if 物品 then
                if 物品.是否叠加 then
                    物品.数量 = 物品信息[2]
                    table.insert(物品表, 物品)
                else
                    for i = 1, 物品信息[2] do
                        table.insert(物品表, __沙盒.生成物品{名称 = 物品信息[1]})
                    end
                end
                if 玩家数据:物品_添加(物品表) then
                    local 当前time = os.date("%Y-%m-%d %H:%M:%S")
                    local login = string.format("%s - 管理员: %s, 玩家: %s, 物品: %s, 数量: %d",
                    当前time,
                    名称 or "未知",
                    玩家数据 and 玩家数据.名称 or "未知",
                    物品 and 物品.名称 or "未知物品",
                    物品 and 物品.数量 or 0)
                    MYF.写出管理日志('管理日志.txt', login)
                    return '发送物品成功'
                else
                    return '目标物品栏不足'
                end
            end
        end
    end
    return '修改成功'
end

function REG:快捷禁言(id,nid)
    local 名称 = _角色[id].主角色.名称
    local 权限 = false
    for i=1,#__管理角色 do
        if __管理角色[i] == 名称 then
            权限 = true
        end
    end
    if not 权限 then
        _角色[id].主角色.rpc:提示窗口('你没有管理权限')
        return
    end
    if __玩家[nid] then
        if __玩家[nid].禁言 == '否' then
            __玩家[nid].禁言 = '是'
            _角色[id].主角色.rpc:提示窗口('该玩家已被禁言')
            return
        else
            _角色[id].主角色.rpc:提示窗口('该玩家已处于禁言中')
            return
        end
    end
end


function REG:游戏存档(id,nid)
    local 名称 = _角色[id].主角色.名称
    local 权限 = false
    for i=1,#__管理角色 do
        if __管理角色[i] == 名称 then
            权限 = true
        end
    end
    if not 权限 then
        _角色[id].主角色.rpc:提示窗口('你没有管理权限')
        return
    end
    if __玩家[nid] then
    print('开始存档')
    for _, v in pairs(__玩家) do
                v:存档()
            end
            local list = {}
            for k, v in pairs(__垃圾) do
                if v.rid == -1 then
                    list[k] = { 表名 = ggetype(v), nid = v.nid }
                end
            end
            __垃圾 = {}
            __存档.删除垃圾(list)

            list = {}
            for _, v in pairs(__帮派) do
                list[v.nid] = v:取存档数据()
            end
            __存档.帮派写入(list)
            __存档.写仙玉()
            -- 世界:print('存档', os.date())
            local MYF = require('我的函数')
            MYF.写出txt('daily.txt',__活动限制)
            MYF.写出txt('Record.txt',__外置数据)
            print('每日数据已存档')
     end
end

function REG:全部存档(id)
    local 名称 = _角色[id].主角色.名称
    local 权限 = false
    for i=1,#__管理角色 do
        if __管理角色[i] == 名称 then
            权限 = true
        end
    end
    if not 权限 then
        _角色[id].主角色.rpc:提示窗口('你没有管理权限')
        return
    end
    
    -- 开始存档所有玩家的数据
    print('开始全部存档')
    for _, v in pairs(__玩家) do
        v:存档() -- 假设这是一个可以存档玩家数据的方法
    end
    
    -- 处理垃圾数据和帮派数据
    local list = {}
    for k, v in pairs(__垃圾) do
        if v.rid == -1 then
            list[k] = { 表名 = ggetype(v), nid = v.nid }
        end
    end
    __垃圾 = {}
    __存档.删除垃圾(list)

    list = {}
    for _, v in pairs(__帮派) do
        list[v.nid] = v:取存档数据()
    end
    __存档.帮派写入(list)
    __存档.写仙玉()
    -- 世界:print('存档', os.date())
    
    -- 保存每日数据
    local MYF = require('我的函数')
    MYF.写出txt('daily.txt', __活动限制)
    MYF.写出txt('Record.txt', __外置数据)
    print('全部每日数据已存档')
end


--====================================================================

--改服务器ip
local ip = __配置.外网.地址
local port = __配置.外网.端口
if gge.isdebug then
    repeat
        if SVR:启动(ip, port) then
            __世界:print('\x1b[32;1m服务监听成功\x1b[0m', ip, port)
            break
        else
            __世界:print('\x1b[31;1m服务监听失败\x1b[0m', ip, port)
        end
    until false
else
    if SVR:启动(ip, port) then
        __世界:print('\x1b[32;1m服务监听成功\x1b[0m', ip, port)
    else
        __世界:print('\x1b[31;1m服务监听失败\x1b[0m', ip, port)
    end
end
--无需返回
SVR.界面信息_时辰 = SVR.界面信息_时辰
SVR.界面信息_聊天 = SVR.界面信息_聊天
SVR.界面信息_队伍 = SVR.界面信息_队伍
SVR.界面信息_召唤 = SVR.界面信息_召唤
SVR.界面信息_人物 = SVR.界面信息_人物
SVR.界面信息_BUFF = SVR.界面信息_BUFF
SVR.界面信息_公告 = SVR.界面信息_公告
SVR.界面信息_传音 = SVR.界面信息_传音

SVR.界面消息_队伍 = SVR.界面消息_队伍
SVR.界面消息_好友 = SVR.界面消息_好友

SVR.置人物头像 = SVR.置人物头像
SVR.置人物气血 = SVR.置人物气血
SVR.置人物魔法 = SVR.置人物魔法
SVR.置人物经验 = SVR.置人物经验

SVR.刷新召唤兽内丹 = SVR.刷新召唤兽内丹
SVR.申请帮派窗口 = SVR.申请帮派窗口
SVR.作坊总管窗口 = SVR.作坊总管窗口
SVR.灌输灵气窗口 = SVR.灌输灵气窗口
SVR.仙器升级窗口 = SVR.仙器升级窗口
SVR.仙器炼化窗口 = SVR.仙器炼化窗口
SVR.神兵升级窗口 = SVR.神兵升级窗口
SVR.神兵精炼窗口 = SVR.神兵精炼窗口
SVR.神兵炼化窗口 = SVR.神兵炼化窗口
SVR.神兵强化窗口 = SVR.神兵强化窗口
SVR.装备打造窗口 = SVR.装备打造窗口
SVR.移动开始 = SVR.移动开始
SVR.移动更新 = SVR.移动更新
SVR.移动结束 = SVR.移动结束
SVR.切换方向 = SVR.切换方向
SVR.切换称谓 = SVR.切换称谓
SVR.切换外形 = SVR.切换外形
SVR.添加特效 = SVR.添加特效
SVR.添加喊话 = SVR.添加喊话
SVR.删除状态 = SVR.删除状态
SVR.添加状态 = SVR.添加状态

SVR.地图添加 = SVR.地图添加
SVR.地图删除 = SVR.地图删除
SVR.常规提示 = SVR.常规提示
SVR.刷新摆摊记录 = SVR.刷新摆摊记录
SVR.聊天框提示 = SVR.聊天框提示
SVR.提示窗口 = SVR.提示窗口
SVR.最后对话 = SVR.最后对话
SVR.刷新银子 = SVR.刷新银子
SVR.删除BUFF = SVR.删除BUFF
SVR.添加BUFF = SVR.添加BUFF
SVR.退出战斗 = SVR.退出战斗
SVR.战斗自动 = SVR.战斗自动
SVR.战斗操作 = SVR.战斗操作

SVR.自动任务_数据 = SVR.自动任务_数据

return SVR
