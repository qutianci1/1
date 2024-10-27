-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-30 20:13:59
-- @Last Modified time  : 2024-08-19 12:16:44

local 取信息表 = function(list, keys)
    local t = {}
    for i, v in ipairs(list) do
        t[i] = {}
        for _, k in ipairs(keys) do
            t[i][k] = v[k]
        end
    end
    return t
end

local _刷新界面信息 = function(self)
    local t = 取信息表(self.队伍, {'nid', '头像', '转生', '名称', '等级', '种族', '性别'})
    for k, v in self:遍历队伍() do
        v.rpc:界面信息_队伍(t)
    end
end

local _取队友nid = function(self)
    local r = {}
    for i, v in self:遍历队友() do
        table.insert(r, v.nid)
    end
    return r
end

local _遍历队伍周围玩家 = function(self)
    local list = {}
    for _, v in ipairs(self.队伍) do
        for _, P in v:遍历周围玩家() do
            list[P.nid] = P
        end
    end
    return next, list
end

local _清空变量 = function(self)
    self.队长 = nil
    self.队伍 = nil
    self.是否组队 = nil
    self.是否队长 = nil
    self.队伍申请 = nil
    self.队伍位置 = nil
end

local 角色 = require('角色')

function 角色:队伍_初始化()
end

function 角色:是否队友(P)
    if self.是否组队 then
        for _, v in ipairs(self.队伍) do
            if v == P then
                return true
            end
        end
    end
end

function 角色:遍历队伍()
    if self.是否组队 then
        return next, self.队伍
    end
    return next, {}
end

function 角色:遍历队友()
    if self.是否组队 then
        local k, v
        return function(list)
            k, v = next(list, k)
            if v == self then
                k, v = next(list, k)
            end
            return k, v
        end, self.队伍
    end
    return next, {}
end

function 角色:队伍_取队伍人数()
    return #self.队伍
end

function 角色:角色_打开队伍窗口()
    if self.是否组队 then
        return 取信息表(self.队伍, {'nid', '外形', '转生', '名称', '等级', '种族', '性别'})
    end
end

function 角色:刷新队伍信息()
    _刷新界面信息(self)
end

function 角色:角色_创建队伍()
    if not self.是否战斗 and not self.是否组队 then
        self.是否组队 = true
        self.是否队长 = true
        self.队伍 = {self}
        self.队伍申请 = setmetatable({}, {__mode = 'v'})

        _刷新界面信息(self)
        for _, v in _遍历队伍周围玩家(self) do
            v.rpc:添加状态(self.nid, 'leader')
        end

        return true
    end
end

function 角色:角色_离开队伍()
    if not self.是否战斗 and self.是否组队 then
        if self.是否队长 then
            self.rpc:提示窗口('队伍解散了。')
            self.rpt:提示窗口('队伍解散了。')
            self.rpc:删除状态(self.nid, 'leader') --自己
            self.rpt:界面信息_队伍 {}
            for _, v in _遍历队伍周围玩家(self) do
                v.rpc:删除状态(self.nid, 'leader')
            end
            for i, v in ipairs(self.队伍) do
                _清空变量(v)
            end
            if _角色[self.cid] and _角色[self.cid].子角色 then
                for i,v in pairs(_角色[self.cid].子角色) do
                    if v.nid ~= self.nid then
                        v.队长 = nil
                        v.队伍 = nil
                        v.是否组队 = nil
                        v.是否队长 = nil
                        v.队伍申请 = nil
                        v.队伍位置 = nil
                        v:下线(1)
                        _角色[self.cid].子角色[v.nid] = nil
                    end
                end
            end
            self.rpc:界面信息_队伍 {}
        else
            self.rpc:提示窗口('你离开了队伍。')
            local _, 周围 = _遍历队伍周围玩家(self) --取得所有队友的周围玩家
            for i, v in ipairs(self.队伍) do
                if v == self then
                    table.remove(self.队伍, i)
                    break
                end
            end
            self.rpt:提示窗口('#Y请注意，#R%s#Y离开了队伍。', self.名称) --队友
            _刷新界面信息(self)
            local nids = _取队友nid(self.队伍[1])
            for _, v in pairs(周围) do
                if __玩家[v.nid] then
                    v.rpc:置队友(self.队伍[1].nid, nids)
                end
            end
            self.队长 = nil
            self.队伍 = nil
            self.是否组队 = nil
            self.是否队长 = nil
            self.队伍申请 = nil
            self.队伍位置 = nil
            self.rpc:界面信息_队伍 {}
            if self.离线角色 then
                self:下线(1)
                if _角色[self.cid] then
                    for i,v in pairs(_角色[self.cid].子角色) do
                        if v.nid ~= self.nid then
                            _角色[self.cid].子角色[i] = nil
                            break
                        end
                    end
                end
            end
        end
        return true
    end
end

function 角色:角色_踢出队伍(i)
    if self.是否组队 and not self.是否战斗 and self.是否队长 and i ~= 1 and self.队伍[i] then
        local P = self.队伍[i]
        _清空变量(P)
        local _, 周围 = _遍历队伍周围玩家(self) --取得所有队友的周围玩家
        table.remove(self.队伍, i)
        P.rpc:提示窗口('你被请离了队伍。')
        P.rpc:界面信息_队伍 {}
        _刷新界面信息(self)
        local nids = _取队友nid(self)
        for _, v in pairs(周围) do
            v.rpc:置队友(self.队伍[1].nid, nids)
        end
        if P.离线角色 then
            P:下线(1)
            for i,v in pairs(_角色[self.cid].子角色) do
                if v.nid ~= self.nid then
                    _角色[self.cid].子角色[i] = nil
                    break
                end
            end
        end
        return true
    end
end

function 角色:角色_踢出队伍NID(NID)
    if self.是否组队 and not self.是否战斗 and self.是否队长 and NID ~= self.nid then
        for i,v in pairs(self.队伍) do
            if v.nid == NID then
                local P = self.队伍[i]
                _清空变量(P)
                local _, 周围 = _遍历队伍周围玩家(self) --取得所有队友的周围玩家
                table.remove(self.队伍, i)
                P.rpc:提示窗口('你被请离了队伍。')
                P.rpc:界面信息_队伍 {}
                _刷新界面信息(self)
                local nids = _取队友nid(self)
                for _, v in pairs(周围) do
                    v.rpc:置队友(self.队伍[1].nid, nids)
                end
                if P.离线角色 then
                    P:下线(1)
                    for i,v in pairs(_角色[self.cid].子角色) do
                        if v.nid ~= self.nid then
                            _角色[self.cid].子角色[i] = nil
                            break
                        end
                    end
                end
                return true
            end
        end
        if __玩家[NID] and __玩家[NID].离线角色 then
            local P = __玩家[NID]
            _清空变量(P)
            local _, 周围 = _遍历队伍周围玩家(self) --取得所有队友的周围玩家
            _刷新界面信息(self)
            P:下线(1)
            return true
        end
    elseif NID ~= self.nid and __玩家[NID] then
        if __玩家[NID].离线角色 then
            __玩家[NID]:下线()
            return true
        end
    end
end

function 角色:角色_移交队长(i)
    if self.是否组队 and not self.是否战斗 and self.是否队长 and i ~= 1 and self.队伍[i] then
        local P = self.队伍[i]
        P.是否队长, self.是否队长 = true, nil
        P.队伍申请, self.队伍申请 = self.队伍申请, nil
        self.rpc:删除状态(self.nid, 'leader') --周围
        self.rpn:删除状态(self.nid, 'leader') --周围
        P.rpn:添加状态(P.nid, 'leader') --周围
        P.rpc:添加状态(P.nid, 'leader')
        P.rpc:提示窗口('你成为了新的队长。')
        self.队伍[1], self.队伍[i] = self.队伍[i], self.队伍[1]
        _刷新界面信息(self)
        if _角色[self.cid].子角色[P.nid] then
            _角色[self.cid].子角色[P.nid].离线角色 = nil
            _角色[self.cid].子角色[P.nid].是否助战 = false
            self.离线角色=true
            self.是否助战=true
            _角色[self.cid].主角色 = _角色[self.cid].子角色[P.nid]
            _角色[self.cid].主角色.cid = self.cid
            if _角色[self.cid].主角色.rpc:重新进入游戏(_角色[self.cid].主角色:取登录数据(), _角色[self.cid].主角色.设置) then
                if _角色[self.cid].主角色.是否队长 then
                    for i, v in _角色[self.cid].主角色:遍历队友() do
                        v.队长 = _角色[self.cid].主角色.nid
                        v.队伍位置 = i
                    end
                end
                -- _角色[self.cid].主角色.rpn:添加状态(_角色[self.cid].主角色.nid, 'leader') --周围
                -- _角色[self.cid].主角色.rpc:添加状态(_角色[self.cid].主角色.nid, 'leader')            
                _角色[self.cid].主角色:地图_初始化()
                _刷新界面信息(_角色[self.cid].主角色)
                _角色[self.cid].主角色.task:任务上线(_角色[self.cid].主角色.接口)
                if _角色[self.cid].主角色.是否交易 and _角色[self.cid].主角色.交易对象 == self and not _角色[self.cid].主角色.是否战斗 then
                    local 等级转换=self.转生..'转'..self.等级..' 级'
                    self.rpc:交易窗口(self.名称, _角色[self.cid].主角色.银子, _角色[self.cid].主角色:交易_取召唤(),self.等级)
                end
            end
        end
        local nids = _取队友nid(P)
        for _, v in _遍历队伍周围玩家(self) do
            v.rpc:置队友(self.队伍[1].nid, nids)
        end
        return true
    end
end

function 角色:角色_移交队长NID(NID)
    if self.是否组队 and not self.是否战斗 and self.是否队长 and NID ~= self.nid then
        for i,v in pairs(self.队伍) do
            if v.nid == NID then
                local P = self.队伍[i]
                if v.是否机器人 then
                    return
                end
                P.是否队长, self.是否队长 = true, nil
                P.队伍申请, self.队伍申请 = self.队伍申请, nil
                self.rpc:删除状态(self.nid, 'leader') --周围
                self.rpn:删除状态(self.nid, 'leader') --周围
                P.rpn:添加状态(P.nid, 'leader') --周围
                P.rpc:添加状态(P.nid, 'leader')
                P.rpc:提示窗口('你成为了新的队长。')
                self.队伍[1], self.队伍[i] = self.队伍[i], self.队伍[1]
                _刷新界面信息(self)
                if _角色[self.cid].子角色[P.nid] then
                    _角色[self.cid].子角色[P.nid].离线角色 = nil
                    _角色[self.cid].子角色[P.nid].是否助战 = false
                    self.离线角色=true
                    self.是否助战=true
                    _角色[self.cid].主角色 = _角色[self.cid].子角色[P.nid]
                    _角色[self.cid].主角色.cid = self.cid
                    if _角色[self.cid].主角色.rpc:重新进入游戏(_角色[self.cid].主角色:取登录数据(), _角色[self.cid].主角色.设置) then
                        if _角色[self.cid].主角色.是否队长 then
                            for i, v in _角色[self.cid].主角色:遍历队友() do
                                v.队长 = _角色[self.cid].主角色.nid
                                v.队伍位置 = i
                            end
                        end
                        -- _角色[self.cid].主角色.rpn:添加状态(_角色[self.cid].主角色.nid, 'leader') --周围
                        -- _角色[self.cid].主角色.rpc:添加状态(_角色[self.cid].主角色.nid, 'leader')            
                        _角色[self.cid].主角色:地图_初始化()
                        _刷新界面信息(_角色[self.cid].主角色)
                        _角色[self.cid].主角色.task:任务上线(_角色[self.cid].主角色.接口)
                        if _角色[self.cid].主角色.是否交易 and _角色[self.cid].主角色.交易对象 == self and not _角色[self.cid].主角色.是否战斗 then
                            local 等级转换=self.转生..'转'..self.等级..' 级'
                            self.rpc:交易窗口(self.名称, _角色[self.cid].主角色.银子, _角色[self.cid].主角色:交易_取召唤(),self.等级)
                        end
                    end
                end
                local nids = _取队友nid(P)
                for _, v in _遍历队伍周围玩家(self) do
                    v.rpc:置队友(self.队伍[1].nid, nids)
                end
                return true
            end
        end
    end
end

function 角色:机器人添加队伍(P)
    P.是否组队 = true
    P.队伍 = self.队伍
    table.insert(self.队伍, P)
    _刷新界面信息(self)
    local nids = _取队友nid(self)
    for _, v in _遍历队伍周围玩家(self) do
        v.rpc:置队友(self.队伍[1].nid, nids)
    end
end

function 角色:机器人踢出队伍(种族, 性别, 外形)
    if self.是否组队 and not self.是否战斗 and self.是否队长 then
        local i = nil
        for k, v in self:遍历队伍() do
            if v.种族 == 种族 and v.性别 == 性别 and v.外形 == 外形 and v.是否机器人 then
                i = k
            end
        end

        if i then
            table.remove(self.队伍, i)
            _刷新界面信息(self)
            local nids = _取队友nid(self)
            for _, v in _遍历队伍周围玩家(self) do
                v.rpc:置队友(self.队伍[1].nid, nids)
            end
        end

        return true
    end
end


function 角色:角色_打开队伍申请窗口()
    if self.是否组队 then
        return 取信息表(self.队伍申请, {'名称', '转生', '等级', '种族', '性别'})
    end
end

function 角色:角色_申请加入队伍(nid)
    local P = self.周围玩家[nid]
    if __副本地图[self.当前地图.接口.id] and self.当前地图.接口.名称 == '比武场' then
        if P and P.是否组队 and P.是否队长 and __玩家[P.nid] then
            if self.帮派 ~= __玩家[P.nid].帮派 then
                return '#Y帮战场景内,禁止加入敌方队伍!!'
            end
        end
    end

    if P and P.是否组队 and P.是否队长 then
        local name = self.名称
        if P.队伍申请[name] then
            return '#Y你已在对方的申请列表中，别着急...'
        elseif #P.队伍 == 5 then
            -- elseif 取表数量(P.队伍申请) == 5 then
            --     return "#R申请队例已满。"
            return '#R该队伍已经满员。'
        end

        P.队伍申请[name] = self
        table.insert(P.队伍申请, self)

        P.rpc:界面消息_队伍() --按钮动画
        return '#Y已经向队长申请加入，请稍等...'
    end
end

function 角色:角色_允许加入队伍(name)
    if self.是否组队 and self.是否队长 and name and self.队伍申请[name] then
        local P = self.队伍申请[name]
        if #self.队伍 == 5 then
            return '#R队伍已经满员了。'
        elseif P.是否组队 then
            return '#R对方已经有队伍了'
        elseif P.是否摆摊 then
            return '#R对方正在摆摊'
        elseif not self.周围玩家[P.nid] then
            return '#R距离过远'
        end

        for i, v in ipairs(self.队伍申请) do
            if v == P then
                table.remove(self.队伍申请, i)
                break
            end
        end
        self.队伍申请[name] = nil --删除申请

        if __玩家[P.nid] then
            P.是否组队 = true
            P.队伍 = self.队伍
            table.insert(self.队伍, P)
            _刷新界面信息(self)
            local nids = _取队友nid(self)
            for _, v in _遍历队伍周围玩家(self) do
                v.rpc:置队友(self.队伍[1].nid, nids)
            end
            return true
        end
        return '#R无法加入'
    end
end

function 角色:角色_拒绝加入队伍(name)
    if self.是否组队 and self.是否队长 and name and self.队伍申请[name] then
        local P = self.队伍申请[name]
        P.rpc:提示窗口('#Y%s#W已拒绝你的组队请求！', self.名称)

        for i, v in ipairs(self.队伍申请) do
            if v == P then
                table.remove(self.队伍申请, i)
                break
            end
        end
        self.队伍申请[name] = nil --删除申请
        return true
    end
end

function 角色:角色_清空申请队伍()
    if self.是否组队 and self.是否队长 then
        self.队伍申请 = {}

        return true
    end
end


function 角色:角色_快速加入队伍(nid)
    if __副本地图[self.当前地图.接口.id] and self.当前地图.接口.名称 == '比武场' then
        return '#Y帮战场景内,禁止加入敌方队伍!!'
    elseif not self.是否组队 or not self.是否队长 then
        return '#R只有队长才可进行此操作'
    elseif #self.队伍 == 5 then
        return '#R队伍已经满员了。'
    end
    if self.nid == nid then
        return '#R你无法这样操作自己'
    end
    if __玩家[nid].地图 ~= self.地图 then
        local map = __地图[self.地图]
        if map then
            local x = math.floor(self.x )
            local y = math.floor(self.y )
            coroutine.xpcall(
                function()
                    __玩家[nid]:移动_切换地图(map, x, y)
                end
            )
        end
    end
    __玩家[nid].是否组队 = true
    __玩家[nid].队伍 = self.队伍
    table.insert(self.队伍, __玩家[nid])
    _刷新界面信息(self)
    local nids = _取队友nid(self)
    for _, v in _遍历队伍周围玩家(self) do
        v.rpc:置队友(self.队伍[1].nid, nids)
    end
    return true
end
