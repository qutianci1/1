-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-04-05 19:22:38
-- @Last Modified time  : 2024-09-13 18:34:31


local GGF = require('GGE.函数')
local MYF = require('我的函数')
local _MD5 = require('md5')
local _NID = require('nanoid').generate
local _mpack = require('cmsgpack').pack
local _munpack = require('cmsgpack.safe').unpack

local _ENV = setmetatable({}, { __index = _G })
仙玉 = {}
--================================================================================
--================================================================================
--================================================================================
--================================================================================
local _USQL = require('LIB.SQLITE3')('data/user.db')

if _USQL:取值("select count(*) from sqlite_master where name='账户'; ") == 0 then
    if not _USQL:执行(GGF.读入文件('./data/sql/账户.sql')) then
        warn(_USQL:取错误())
    end

end

do
    function 注册账号(账号, 密码, 安全, 体验, QQ, IP)
        if not gge.isdebug then
            local 找到 = false
            for k, v in pairs(__体验码) do
                if 体验 == v then
                    找到 = true
                end
            end
            if not 找到 then
                return '#R请输入正确的体验码！'
            end
        end

        if _USQL:取值("select count(*) from  账户 where 账号='%s' limit 1", 账号) ~= 0 then
            return '#R账号已存在'
        end
        _USQL:开始事务()
        _USQL:执行('insert into 账户(时间) values(%d)', os.time())
        local id = _USQL:取递增ID()
        local r = _USQL:修改('update 账户 set 账号=? where id=%d', id, 账号)
        -- _USQL:修改('update 账户 set 密码=? where id=%d', id, _MD5(密码 .. QQ))
        _USQL:修改('update 账户 set 密码=? where id=%d', id, 密码)
        _USQL:修改('update 账户 set 安全=? where id=%d', id, 安全)
        _USQL:修改('update 账户 set 体验=? where id=%d', id, 体验)
        _USQL:修改('update 账户 set QQ=? where id=%d', id, QQ)
        _USQL:修改('update 账户 set IP=? where id=%d', id, IP or '')

        _USQL:提交事务()
        return r == 1
    end

    function 修改密码(账号, 安全, 密码)
        local t = _USQL:查询一行("select * from 账户 where 账号='%s' and 安全='%s'", 账号, 安全)
        if type(t) == 'table' then
            -- local r = _USQL:修改("update 账户 set 密码=? where 账号='%s'", 账号, _MD5(密码 .. t.QQ))
            local r = _USQL:修改("update 账户 set 密码=? where 账号='%s'", 账号, 密码)
            return r == 1
        end
    end

    function 验证账号(账号, 密码)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
            -- table.print(t)
            -- if t.密码 == _MD5(密码 .. t.QQ) then
            print(t.密码,密码)
            if t.密码 == 密码 then
                if not 仙玉[t.id] then
                    仙玉[t.id] = t.仙玉
                end
                return t
            end
        end
        return false
    end

    function 写仙玉()
        _USQL:开始事务()
        for k, v in pairs(仙玉) do
            _USQL:修改('update 账户 set 仙玉=? where id=%d', k, v)
        end
        _USQL:提交事务()
    end
end
--================================================================================
--================================================================================
--================================================================================
--================================================================================
local _DSQL = require('LIB.SQLITE3')('data/save.db')
if _DSQL:取值("select count(*) from sqlite_master where name='角色'; ") == 0 then
    for _, k in ipairs { '宠物', '好友', '技能', '角色', '任务', '物品', '召唤', '坐骑' , '帮派' , '法宝' } do
        _DSQL:执行(GGF.读入文件(string.format('./data/sql/%s.sql', k)))
    end
end

do
    function 角色列表(uid,data)
        return _DSQL:查询("select id,nid,外形,头像,名称,等级,转生,性别,种族,登录时间,删除时间 from 角色 where uid='%d' order by id"
            , uid),data
    end


    function 检测名称(名称)
        if _DSQL:取值("select count(*) from  角色 where 名称 = '%s' limit 1", 名称) ~= 0 then
            return true
        end
    end



    function 角色创建(uid, 名称, 外形)
        if 检测名称(名称) then
            return '名称已存在'
        end
        if _DSQL:取值("select count(*) from  角色 where uid = '%d' ", uid) >= 6 then
            return '无法创建更多的角色'
        end
        local r = require('数据库/角色').基本信息[外形]
        if r then
            if _DSQL:执行("insert into 角色(uid,nid,创建时间,名称,外形,性别,种族,头像) values('%d','%s','%d','%s','%d','%d','%d','%d')"
                , uid, _NID(), os.time(), 名称, 外形, r.性别, r.种族, 外形) == 1 then
                return 角色列表(uid)
            end
        else
            return '数据库错误'
        end

        return '数据库错误'
    end

    function 角色读档(nid)
        local tb = _DSQL:查询一行("select * from 角色 where nid='%s'", nid)
        if tb then
            tb.数据 = _munpack(tb.数据) or {}
            local rid = tb.id
            for _, k in ipairs { '宠物', '好友', '技能', '任务', '物品', '召唤', '坐骑' , '法宝'} do
                local t = {}
                for l in _DSQL:遍历('select * from %s where rid=%d', k, rid) do
                    l.数据 = _munpack(l.数据) or {}
                    t[l.nid] = l
                end
                tb[k] = t
            end
        end

        return tb
    end

    local function _update(表名, list)
        for _, v in pairs(list) do
            local nid = v.nid
            if v == false then
                _DSQL:执行("delete from %s where nid='%s'", 表名, nid)
            else
                nid = v.nid
                if not _DSQL:查询一行("select * from %s where nid='%s'", 表名, nid) then
                    _DSQL:执行("insert into %s(nid) values('%s')", 表名, nid)
                end
                v.nid = nil
                local r
                for k, v in pairs(v) do
                    if k == '数据' then
                        r = _DSQL:blob("update %s set %s=? where nid='%s'", 表名, k, nid, _mpack(v))
                    else
                        r = _DSQL:修改("update %s set %s=? where nid='%s'", 表名, k, nid, v)
                    end
                    if r ~= 1 then
                        print(r, k, v, _DSQL:取错误())
                    end
                end
            end
        end
    end

    function 角色存档(tb)
        local rid = tb.id
        tb.id = nil
        if _DSQL:开始事务() then
            for _, k in ipairs { '宠物', '好友', '技能', '任务', '物品', '召唤', '坐骑' , '法宝' } do
                if type(tb[k]) == 'table' then
                    _update(k, tb[k])
                    tb[k] = nil
                end
            end

            local r
            for k, v in pairs(tb) do
                if k == '数据' then
                    r = _DSQL:blob("update 角色 set %s=? where id='%d'", k, rid, _mpack(v))
                else
                    r = _DSQL:修改("update 角色 set %s=? where id='%d'", k, rid, v)
                end
                if r ~= 1 then
                    print(r, rid, k, v, _DSQL:取错误())
                end
            end
            _DSQL:提交事务()
        end

    end

    function 删除垃圾(list)
        _DSQL:开始事务()
        for _, v in pairs(list) do
            _DSQL:执行("delete from %s where nid='%s'", v.表名, v.nid)
        end
        _DSQL:提交事务()
    end

    function 帮派读取()
        return  _DSQL:查询("select * from 帮派")
    end

    function 帮派写入(list)
        if _DSQL:开始事务() then
            _update('帮派', list)
            _DSQL:提交事务()
        end
    end
end
 function 验证安全码(账号, 安全码)
        local t = _USQL:查询一行("select * from 账户 where 账号 = '%s'", 账号)
        if type(t) == 'table' then
        local 安全码字符串 = tostring(安全码)
        print(t.安全, 安全码字符串)
        if t.安全 == 安全码字符串 then
             return true
           end
        end
    end

-- for l in _USQL:遍历('select * from 召唤 ') do
--     local t = {}
--     for k,v in pairs(l) do
--         t[k] = v
--     end
--     l.数据 = t
--     角色存档({召唤={l}})
-- end


return _ENV
