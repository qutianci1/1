-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-08 15:08:54
-- @Last Modified time  : 2024-08-27 15:23:52

local 角色 = require('角色')

function 角色:任务_初始化()
    local 存档任务 = self.任务
    local _任务表 = {}

    self.任务 =
    setmetatable(
        {},
        {
            __newindex = function(t, k, v)
                if v then
                    v.rid = self.id
                    v:更新来源(self.任务)
                    if v.获得时间 == 0 then
                        v.获得时间 = os.time()
                    end
                else
                    local T = _任务表[k]
                    if T then
                        __垃圾[k] = T
                        __垃圾[k].rid = -1
                        if T.是否BUFF then
                            self.rpc:删除BUFF(k)
                        end
                    end
                end
                _任务表[k] = v
                self.刷新的任务 = true
            end,
            __index = function(t, k)
                return _任务表[k]
            end,
            __pairs = function(...)
                return next, _任务表
            end
        }
    )

    if type(存档任务) == 'table' then
        for nid, v in pairs(存档任务) do
            if not __任务[nid] or __任务[nid].rid == v.rid then
                self.任务[nid] = require('对象/任务/任务')(v)
            end
        end
    end

    do -- task
        local kname
        local function task(_, ...)
            for i, v in pairs(self.任务) do
                local fun = v[kname]
                if type(fun) == 'function' then
                    local r = { coroutine.xpcall(fun, v.接口, ...) }
                    if r[1] ~= coroutine.FALSE and r[1] ~= nil then
                        return table.unpack(r)
                    end
                end
            end
        end

        self.task =
        setmetatable(
            {},
            {
                __index = function(_, k)
                    kname = k
                    return task
                end
            }
        )
    end
end

function 角色:任务_更新(sec)
    self.task:任务更新(sec,self.接口)
    if self.刷新的任务 then
        self.刷新的任务 = nil
        coroutine.xpcall(
            function()
                self.rpc:请求刷新任务列表()
            end
        )
    end
    for i, v in self:遍历任务() do
        if v.up and v.nid == self.窗口.任务 then
            v.up = nil
            coroutine.xpcall(
                function()
                    self.rpc:刷新任务详情(v:取详情(self.接口))
                end
            )
            break
        end
    end
end

function 角色:遍历任务()
    return pairs(self.任务)
end

function 角色:任务_添加(T)
    if ggetype(T) == '任务接口' then
        T = T[0x4253]
    end
    if ggetype(T) == '任务' and not self:任务_获取(T.名称) then
        if T.来源 then
            T = T:镜像()
        end

        self.任务[T.nid] = T
        if T.是否BUFF then
            self.rpc:添加BUFF({ nid = T.nid, 名称 = T.名称, 图标 = T.图标 })
        end
        return T
    end
end

function 角色:任务_获取(名称)
    for _, v in self:遍历任务() do
        if v.名称 == 名称 then
            return v
        end
    end
end

function 角色:任务_取BUFF列表()
    local list = {}
    for _, v in self:遍历任务() do
        if v.是否BUFF then
            table.insert(
                list,
                {
                    nid = v.nid,
                    名称 = v.名称,
                    图标 = v.图标,
                    获得时间 = v.获得时间
                }
            )
        end
    end
    return list
end

function 角色:角色_刷新任务追踪()
    local list = {}
    for k, v in self:遍历任务() do
        if not v.是否BUFF and not v.是否隐藏 and v.是否可追踪 then
            table.insert(
                list,
                {
                    nid = v.nid,
                    类型 = v.类型,
                    名称 = v.别名 or v.名称,
                    获得时间 = v.获得时间,
                    是否可取消 = v.是否可取消
                }
            )
        end
    end
    return list
end

function 角色:角色_刷新追踪详情(nid)
    local r = self.任务[nid]
    if r then
        self.窗口.任务 = nid
        return r:取追踪详情(self.接口)
    end
    return '任务不存在'
end

function 角色:角色_打开任务窗口()
    local list = {}
    for k, v in self:遍历任务() do
        if not v.是否BUFF and not v.是否隐藏 then
            table.insert(
                list,
                {
                    nid = v.nid,
                    类型 = v.类型,
                    名称 = v.别名 or v.名称,
                    获得时间 = v.获得时间,
                    是否可取消 = v.是否可取消
                }
            )
        end
    end
    return list
end

function 角色:角色_获取任务详情(nid)
    local r = self.任务[nid]
    if r then
        self.窗口.任务 = nid
        return r:取详情(self.接口)
    end
    return '任务不存在'
end

function 角色:角色_取消任务(nid)
    local T = self.任务[nid]
    if T and T.是否可取消 ~= false then
        if T.任务取消 then
            T:任务取消(self.接口)
        end
        self.任务[nid] = nil
        return true
    end
end

function 角色:角色_获取可接任务()
end
