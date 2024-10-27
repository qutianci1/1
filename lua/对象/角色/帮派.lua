-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-11 21:06:23
-- @Last Modified time  : 2024-07-29 12:15:06
local 角色 = require('角色')
local _munpack = require('cmsgpack.safe').unpack

function 角色:角色_取消帮派()
    self.帮派 = nil
    -- if self.帮派 == nil or self.帮派 == '' then
    --     self.rpc:提示窗口("#Y你还没有帮派！")
    -- else
    --     local 职务 = __帮派[self.帮派]:取成员(self.nid).职务
    --     if 职务 == '帮众' then
    --         self:角色_删除称谓(self.帮派..'的帮众')
    --         self:角色_帮派退出(self.nid)
    --         self.帮派=nil
    --         self.rpc:提示窗口("#Y你已经恢复无帮派人士#204")
    --     else
    --         self.rpc:提示窗口("#Y暂时不能解散帮派,请转移到其他成员!")
    --     end
    -- end
end

function 角色:角色_退出帮派(v)
    if not __帮派[v] then
        return
    end
    local 帮派 = __帮派[v]
    local 职位=帮派:取成员(self.nid).职务
    if 职位=='帮主' then
        local 副帮主=0
        for k,v in pairs(帮派.成员列表) do
            if v.职务=='副帮主' then
                副帮主=k
            end
        end
        if 副帮主 == 0 then
            self.rpc:提示窗口("#Y由于你是帮主,帮派内没有可以继任的副帮主,无法退出！#R如需解散帮派,请联系管理处理。")
            return
        else
            if __玩家[副帮主] then
                self:角色_清除帮派称谓(v,__玩家[副帮主])
                __玩家[副帮主].rpc:提示窗口("#Y由于帮主离开帮派,你自动继任为新帮主。")
            else
                local 玩家数据 =__存档.角色读档(副帮主)
                self:角色_清除帮派称谓(v,玩家数据.数据)
                __存档.角色存档(玩家数据)
            end
            帮派.成员列表[副帮主].职务 = '帮主'
        end
    end
    self:角色_离帮处理(v)
end

function 角色:角色_离帮处理(v)
    local 帮派 = __帮派[v]
    self:角色_清除帮派称谓(v,__玩家[self.nid])
    if self.帮派数据.帮派贡献 then
        self.帮派数据.帮派贡献=math.floor(self.帮派数据.帮派贡献*0.7)
    end
    if self.帮派数据.守护神 then
        self.帮派数据.守护神 = {主守护='',副守护=''}
    end
    帮派:成员删除(self)
    self.帮派=nil
    self.rpc:提示窗口("#Y你已成功脱离帮派")
    -- self.rpc:打开帮派现状()
    -- self.rpc:打开帮派管理()
end

function 角色:角色_帮派创建(v, z)
    if self.帮派 and self.帮派 ~= '' then
        self.rpc:提示窗口("#Y你已经有帮派了！")
        return
    end
    if __帮派[v] then
        self.rpc:提示窗口("#Y这个帮派名称已被占用,重新取个名字吧！")
        return
    end
    local 帮派 = require('对象/帮派/帮派')({名称=v,宗旨=z,响应=10,帮主=self.名称,创始人=self.名称,创建时间=os.time()})
    帮派.守护 = {'大力战神','混乱战神'}
    帮派:成员添加(self, '帮主',v)
    -- self:角色_添加称谓(v..'的帮派创始人')
    self:角色_添加称谓(v..'帮主')

    帮派:成员上线(self)
    return true
end

function 角色:角色_进入帮派()
    if self.帮派==nil then
        self.rpc:提示窗口("#Y你并没有帮派！")
        return
    end
    if not __帮派[self.帮派] then
        self.rpc:提示窗口("#Y并没有找到你的帮派哦！")
        return
    end
    -- print(__帮派[self.帮派].响应,'__帮派[self.帮派].响应')
    if __帮派[self.帮派].响应 ~= 10 then
        self.rpc:提示窗口("#Y你的帮派还没有建成,快去找人响应吧！")
        return
    end
    local 帮派 = __帮派[self.帮派]
    return 帮派:进入地图(self)
end

function 角色:角色_清除帮派称谓(v,玩家)
    local 职位={'帮主','副帮主','左护法','右护法','长老','堂主','精英','帮众'}
    for i=1,#玩家.称谓列表 do
        for o=1,#职位 do
            if 玩家.称谓列表[i]==v..职位[o] then
                table.remove(玩家.称谓列表, i)
            end
        end
    end
end

function 角色:角色_踢出帮派处理(v,nid)
    if not __帮派[v] then
        self.rpc:提示窗口("#Y该帮派已经解散！#24")
        return
    end
    if self.nid==nid then
        return
    end
    local 帮派 = __帮派[v]
    if 帮派:取成员(nid)==nil then
        return
    end
    local 管理级别=帮派:取成员(self.nid).管理级别
    local 目标级别=帮派:取成员(nid).管理级别
    local 目标职位=帮派:取成员(nid).职务
    if 目标级别~=6 then
        self.rpc:提示窗口("#Y这位成员在帮里拥有职位,请免除职位后踢出。")
        return
    end
    if 管理级别==1 then
        --删除称谓
        if __玩家[nid]~=nil then
            self:角色_清除帮派称谓(v,__玩家[nid])
            -- __玩家[nid]:角色_删除称谓(v..目标职位)
            -- if __玩家[nid].帮派数据.守护点数 then--暂时搁置重置帮派守护
            -- end
            if __玩家[nid].帮派数据.帮派贡献 then
                __玩家[nid].帮派数据.帮派贡献=math.floor(__玩家[nid].帮派数据.帮派贡献*0.7)
            end
            if __玩家[nid].帮派数据.帮派贡献.守护神 then
                __玩家[nid].帮派数据.帮派贡献.守护神 = {主守护='',副守护=''}
            end
            __玩家[nid].rpc:提示窗口('#Y你被踢出了'..v..'帮派')
            __玩家[nid].帮派=nil
        else
            local 玩家数据 =__存档.角色读档(nid)
            玩家数据.数据['帮派']= nil
            if 玩家数据.数据.称谓==v..目标职位 then
                玩家数据.数据.称谓=''
            end
            if 玩家数据.数据.帮派数据.帮派贡献 then
                玩家数据.数据.帮派数据.帮派贡献=math.floor(玩家数据.数据.帮派数据.帮派贡献*0.7)
            end
            if 玩家数据.数据.帮派数据.帮派贡献.守护神 then
                玩家数据.数据.帮派数据.帮派贡献.守护神 = {主守护='',副守护=''}
            end
            self:角色_清除帮派称谓(v,玩家数据.数据)
            __存档.角色存档(玩家数据)
        end
        if 帮派.成员列表[nid] then
            帮派.成员列表[nid] = nil
        end
        帮派.成员数量=帮派:取成员人数()
        帮派:更新成员信息()
        self.rpc:刷新帮派成员(帮派.成员列表)
        self.rpc:提示窗口("#Y已踢出玩家!")
    else
        self.rpc:提示窗口("#Y只有帮主才有踢人的权利")
    end
end

function 角色:角色_同意帮派申请加入(v,nid)
    if not __帮派[v] then
        return
    end
    local 帮派 = __帮派[v]
    if 帮派:取成员(nid)~=nil then
        return
    end
    local 人数=帮派:取成员人数()
    if 人数>=帮派.最大成员数量 then
        self.rpc:提示窗口("#Y帮派人数已满,无法继续添加玩家")
        return
    end
    local 编号=0
    for i=1,#帮派.申请列表 do
        if 帮派.申请列表[i].nid==nid then
            编号=i
        end
    end
    if 编号==0 then
        self.rpc:提示窗口("#Y列表中不存在此玩家")
        self.rpc:刷新申请成员(帮派.申请列表)
        return
    end
    if __玩家[nid]~=nil then
        if __玩家[nid].帮派~=nil and __玩家[nid].帮派 ~= "" then
            self.rpc:提示窗口("#Y目标已加入其他帮派")
            table.remove(帮派.申请列表, 编号)
            self.rpc:刷新申请成员(帮派.申请列表)
            return
        end
    else
        local 玩家数据 =__存档.角色读档(nid)
        if 玩家数据.数据['帮派']~= nil and __玩家[nid].帮派 ~= "" then
            self.rpc:提示窗口("#Y目标已加入其他帮派")
            table.remove(帮派.申请列表, 编号)
            self.rpc:刷新申请成员(帮派.申请列表)
            return
        end
    end
    local 管理级别 = 帮派:取成员(self.nid).管理级别
    if 管理级别<7 then
        if __玩家[nid]~=nil then
            __玩家[nid].帮派=v
            __玩家[nid]:角色_添加称谓(v..'帮众')
            if __玩家[nid].帮派数据.帮派成就==nil then
                __玩家[nid].帮派数据.帮派成就=0
            end
            if __玩家[nid].帮派数据.帮派贡献==nil then
                __玩家[nid].帮派数据.帮派贡献=0
            end
            if __玩家[nid].帮派数据.守护点数==nil then
                __玩家[nid].帮派数据.守护点数={总数=0,已用=0,剩余=0}
            end
            帮派:成员添加(__玩家[nid], '帮众')
            __玩家[nid].rpc:提示窗口('#Y'..v..'已通过你的入帮申请!')
        else
            local 玩家数据 =__存档.角色读档(nid)
            玩家数据.数据['帮派']= v
            玩家数据.数据.称谓列表[#玩家数据.数据.称谓列表+1]=v..'帮众'
            if 玩家数据.数据.帮派数据.帮派成就==nil then
                玩家数据.数据.帮派数据.帮派成就=0
            end
            if 玩家数据.数据.帮派数据.帮派贡献==nil then
                玩家数据.数据.帮派数据.帮派贡献=0
            end
            if 玩家数据.数据.帮派数据.守护点数==nil then
                玩家数据.数据.帮派数据.守护点数={总数=0,已用=0,剩余=0}
            end
            __存档.角色存档(玩家数据)
            帮派:成员添加(玩家数据.数据, '帮众')
        end
        self.rpc:提示窗口("#Y已批准玩家的入帮申请!")
        table.remove(帮派.申请列表, 编号)
        self.rpc:刷新申请成员(帮派.申请列表)
    else
        self.rpc:提示窗口("#Y没有管理权限")
    end
end

function 角色:角色_拒绝帮派申请加入(v,nid)
    if not __帮派[v] then
        return
    end
    local 帮派 = __帮派[v]
    if 帮派:取成员(nid)~=nil then
        return
    end
    local 编号=0
    for i=1,#帮派.申请列表 do
        if 帮派.申请列表[i].nid==nid then
            编号=i
        end
    end
    local 管理级别 = 帮派:取成员(self.nid).管理级别
    if 管理级别<7 then
        table.remove(帮派.申请列表, 编号)
        if __玩家[nid]~=nil then
            __玩家[nid].rpc:提示窗口('#Y'..v..'拒绝了你的入帮申请!')
        end
        self.rpc:刷新申请成员(帮派.申请列表)
        self.rpc:提示窗口("#Y已拒绝入帮申请")
    else
        self.rpc:提示窗口("#Y没有管理权限")
    end
end

function 角色:角色_清空申请加入(v)
    if not __帮派[v] then
        return
    end
    local 帮派 = __帮派[v]
    local 管理级别 = 帮派:取成员(self.nid).管理级别
    if 管理级别<7 then
        帮派.申请列表={}
        self.rpc:刷新申请成员(帮派.申请列表)
        self.rpc:提示窗口("#Y已清空入帮申请")
    else
        self.rpc:提示窗口("#Y没有管理权限")
    end
end

function 角色:角色_任命官职(v,职位,nid)
    if not __帮派[v] then
        return
    end
    local 帮派 = __帮派[v]
    local 管理级别 = 帮派:取成员(self.nid).管理级别
    if 管理级别 == 1 then
        local 结果 = 帮派:任命官职(职位,nid)
        if type(结果)=='string' then
            self.rpc:提示窗口("#Y"..结果)
        else
            if __玩家[nid]~=nil then
                self:角色_清除帮派称谓(v,__玩家[nid])
                __玩家[nid]:角色_添加称谓(v..职位)
            else
                local 玩家数据 =__存档.角色读档(nid)
                self:角色_清除帮派称谓(v,玩家数据.数据)
                玩家数据.数据.称谓列表[#玩家数据.数据.称谓列表+1]=v..职位
                __存档.角色存档(玩家数据)
            end
            self.rpc:提示窗口("#Y成功任命官职")
        end
    elseif 管理级别 == 2 then
        if 职位 == '副帮主' then
            return self.rpc:提示窗口("#Y副帮主职位只能由帮主任命！")
        end
        local 结果 = 帮派:任命官职(职位,nid)
        if type(结果)=='string' then
            self.rpc:提示窗口("#Y"..结果)
        else
            if __玩家[nid]~=nil then
                self:角色_清除帮派称谓(v,__玩家[nid])
                __玩家[nid]:角色_添加称谓(v..职位)
            else
                local 玩家数据 =__存档.角色读档(nid)
                self:角色_清除帮派称谓(v,玩家数据.数据)
                玩家数据.数据.称谓列表[#玩家数据.数据.称谓列表+1]=v..职位
                __存档.角色存档(玩家数据)
            end
            self.rpc:提示窗口("#Y成功任命官职")
        end
    else
        self.rpc:提示窗口("#Y没有管理权限")
    end
end

function 角色:角色_帮派申请加入(v) --客户端请求
    if not __帮派[v] then
        return self.rpc:提示窗口("#Y该帮派已经解散！#24")
    end
    if self.帮派~=nil and self.帮派 ~= '' then
        return self.rpc:提示窗口("#Y你已经加入了帮派，请先退出现在的帮派！#24")
    end
    local 帮派 = __帮派[v]
    local 结果 = 帮派:申请加入(self)
    if type(结果) == 'string' then
        self.rpc:提示窗口("#Y"..结果)
    else
        self.rpc:提示窗口("#Y你已经申请加入,请耐心等待管理审核")
    end
    return
end


function 角色:角色_响应帮派(v)
    if not __帮派[v] then
        self.rpc:提示窗口("#Y你相应的这个帮派不存在！")
        return
    end
    if self.帮派 and self.帮派 ~= '' then
        if self.帮派~=v then
            self.rpc:提示窗口("#Y你已经有帮派了！")
        else
            self.rpc:提示窗口("#Y创建者或已经响应过的无法再次相应！")
        end
        return
    end
    -- self:角色_添加称谓(v..'的大长老')
    local 帮派 = __帮派[v]
    return 帮派:响应帮派(self)
end

function 角色:角色_帮派退出(nid)
    if self.帮派 and __帮派[self.帮派] then
        local 帮派 = __帮派[self.帮派]
        if 帮派:取成员(nid).职务 == '帮主' then
        else
            帮派:成员删除(self)
        end
    end
end

function 角色:角色_帮派进入地图()
    if self.帮派 and __帮派[self.帮派] then
        local 帮派 = __帮派[self.帮派]
        帮派:进入地图(self)
    end
end

function 角色:角色_取帮派信息()
    if self.帮派==nil or self.帮派 == '' then
        return "#Y你还没有加入任何帮派"
    end
    if __帮派[self.帮派] then
        local 帮派 = __帮派[self.帮派]
        local 数据=帮派:获取帮派数据(self)
        return 数据
    end
end