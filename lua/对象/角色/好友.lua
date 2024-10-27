-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-04-12 16:32:34
-- @Last Modified time  : 2024-08-26 13:10:59

local GGF = require('GGE.函数')
local 角色 = require('角色')
local 临时记录 = {}

function 角色:角色_获取好友数据(v)
    self:角色_刷新好友列表()
    table.sort(self.好友列表, function(a, b)
        if a.在线 ~= b.在线 then -- 如果在线状态不同，以在线状态为第一权重
            return a.在线 == '在线'
        elseif a.转生 ~= b.转生 then -- 如果在线状态相同，以转生为第二权重，从高到低排序
            return a.转生 > b.转生
        elseif a.等级 ~= b.等级 then -- 如果转生相同，以等级为第三权重，从高到低排序
            return a.等级 > b.等级
        else
            return false
        end
    end)
    return self.好友列表
end

function 角色:角色_刷新好友列表()
    for i=1,#self.好友列表 do
        local 玩家数据 = {}
        if __玩家[self.好友列表[i].nid] then
            玩家数据 = __玩家[self.好友列表[i].nid]
            self.好友列表[i].在线 = '在线'
        else
            玩家数据 =__存档.角色读档(self.好友列表[i].nid)
            self.好友列表[i].在线 = '离线'
        end
        local 数据 = {'名称','种族','等级','转生','飞升','帮派','称谓','外形','头像','性别','原形'}
        for n=1,#数据 do
            if 玩家数据.数据[数据[n]] then
                self.好友列表[i][数据[n]] = 玩家数据.数据[数据[n]]
            end
        end
    end
end

function 角色:角色_获取指定好友(nid)
    local r = self:角色_获取好友编号(nid)
    if r then
        return self.好友列表[r]
    end
end

function 角色:角色_获取好友编号(nid)
    local 编号
    for i=1,#self.好友列表 do
        if self.好友列表[i].nid == nid then
            编号 = i
        end
    end
    return 编号
end

function 角色:角色_发送消息(nid,v)
    local timestamp = os.time()
    local date_str = os.date("%Y-%m-%d %H:%M:%S", timestamp)
    local 信息 = '#R'..self.名称..'  '..date_str..'#r#W'..v
    local 发送信息 = 信息
    local r = self:角色_获取好友编号(nid)
    if r then
        self.好友列表[r].历史信息[#self.好友列表[r].历史信息 + 1] = 发送信息
        self.rpc:刷新聊天记录(self.好友列表[r].历史信息)
    else
        if not 临时记录[self.nid] then 临时记录[self.nid] = {} end
        if not 临时记录[self.nid][nid] then 临时记录[self.nid][nid] = {} end
        临时记录[self.nid][nid][#临时记录[self.nid][nid] + 1] = 发送信息
        self.rpc:刷新聊天记录(临时记录[self.nid][nid])
    end
    -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>处理对方信息
    if __玩家[nid] then
        local r = __玩家[nid]:角色_获取好友编号(self.nid)
        local _记录 = {}
        if r then
            -- print('????')
            __玩家[nid].好友列表[r].历史信息[#__玩家[nid].好友列表[r].历史信息 + 1] = 发送信息
            _记录 = __玩家[nid].好友列表[r].历史信息
        else
            -- print('啥是啥')
            if not 临时记录[nid] then 临时记录[nid] = {} end
            if not 临时记录[nid][self.nid] then 临时记录[nid][self.nid] = {} end
            临时记录[nid][self.nid][#临时记录[nid][self.nid] + 1] = 发送信息
            _记录 = 临时记录[nid][self.nid]
            -- table.print(_记录)
        end
        local msg = {
            id = self.id,
            nid = self.nid,
            名称 = self.名称,
            转生 = self.转生,
            等级 = self.等级,
            种族 = self.种族,
            称谓 = self.称谓,
            帮派 = self.帮派,
            头像 = self.头像,
            性别 = self.性别,
            外形 = self.外形,
            原形 = self.原形,
            好友度 = 0,
            关系 = '我的朋友',
            历史信息 = _记录
        }
        __玩家[nid].rpc:界面消息_好友(msg)
    else
        self.rpc:提示窗口('#Y暂不支持离线留言')
    end
end

function 角色:角色_申请添加好友(nid)
    if nid == self.nid then
        return self.rpc:提示窗口('#Y不能添加自己为好友!')
    end
    local P = self.周围玩家[nid]
    if P then
        local isfriend = self:是否为好友(nid)
        if isfriend then
            self.rpc:提示窗口('#G%s#Y已经是你的好友',__玩家[nid].名称)
            return
        else
            self:角色_添加好友(P)
            P.rpc:提示窗口('#Y玩家#G%s#Y已经将您添加为他的好友',self.名称)
            self.rpc:提示窗口('#Y已添加好友')
        end
    end
end

function 角色:角色_查找添加好友(nid)
    local isfriend = self:是否为好友(nid)
    local 玩家数据 = {}
    if __玩家[nid] then
        玩家数据 = __玩家[nid]
    else
        玩家数据 =__存档.角色读档(nid)
    end
    if isfriend then
        self.rpc:提示窗口('#G%s#Y已经是你的好友',玩家数据.数据.名称)
        return
    else
        self:角色_添加好友(玩家数据.数据)
        self.rpc:提示窗口('#Y恭喜你多了一位好友#G%s',玩家数据.数据.名称)
        if __玩家[nid] then
            __玩家[nid].rpc:提示窗口('#Y玩家#G%s#Y已经将您添加为他的好友',self.名称)
        end
    end
end

function 角色:角色_ID查找好友(ID)
    local 结果
    local 种族 = { "人", "魔", "仙", "鬼" }
    local 性别 = {'男','女'}
    for k,v in pairs(__玩家) do
        if v.id == ID then
            结果 = {}
            结果.nid = v.nid
            结果.名称 = v.名称
            结果.等级 = v.等级
            结果.转生 = v.转生
            结果.种族 = 种族[v.种族]
            结果.性别 = 性别[v.性别]
        end
    end
    self.rpc:查找结果(结果)
end

function 角色:角色_名称查找好友(名称)
    local 结果
    local 种族 = { "人", "魔", "仙", "鬼" }
    local 性别 = {'男','女'}
    for k,v in pairs(__玩家) do
        if v.名称 == 名称 then
            结果 = {}
            结果.nid = v.nid
            结果.名称 = v.名称
            结果.等级 = v.等级
            结果.转生 = v.转生
            结果.种族 = 种族[v.种族]
            结果.性别 = 性别[v.性别]
        end
    end
    self.rpc:查找结果(结果)
end

function 角色:角色_添加好友(P)
    local 好友信息  ={
            id = P.id,
            nid = P.nid,
            名称 = P.名称,
            种族 = P.种族,
            等级 = P.等级,
            转生 = P.转生,
            飞升 = P.飞升,
            帮派 = P.帮派,
            称谓 = P.称谓,
            外形 = P.外形,
            原形 = P.原形,
            头像 = P.头像,
            性别 = P.性别,
            关系 = '我的朋友',
            好友度 = 0,
            历史信息 = {},
            在线 = self:取玩家是否在线(P.nid)
        }
    table.insert(self.好友列表,好友信息)
    self:刷新好友列表()
end



function 角色:角色_更新好友信息1()
    for i=1,#self.好友列表 do
        local 玩家数据 = {}
        if __玩家[self.好友列表[i].nid] then
            玩家数据 = __玩家[self.好友列表[i].nid]
            self.好友列表[i].在线 = '在线'
        else
            玩家数据 =__存档.角色读档(self.好友列表[i].nid)
            self.好友列表[i].在线 = '离线'
        end
        self.好友列表[i].名称 = 玩家数据.数据.名称
        self.好友列表[i].种族 = 玩家数据.数据.种族
        self.好友列表[i].等级 = 玩家数据.数据.等级
        self.好友列表[i].转生 = 玩家数据.数据.转生
        self.好友列表[i].飞升 = 玩家数据.数据.飞升
        self.好友列表[i].帮派 = 玩家数据.数据.帮派
        self.好友列表[i].称谓 = 玩家数据.数据.称谓
        self.好友列表[i].外形 = 玩家数据.数据.外形
        self.好友列表[i].原形 = 玩家数据.数据.原形
        self.好友列表[i].头像 = 玩家数据.数据.头像
        self.好友列表[i].性别 = 玩家数据.数据.性别
        self.好友列表[i].关系 = '我的朋友'
        self.好友列表[i].好友度 = 0
    end
end

function 角色:角色_更新好友信息(nid)
    if self:是否为好友(nid) then
        if __玩家[nid] then
            local 玩家数据 = __玩家[nid]
            local k,v = self:取好友列表信息(nid)
            self.好友列表[k].名称 = 玩家数据.数据.名称
            self.好友列表[k].种族 = 玩家数据.数据.种族
            self.好友列表[k].等级 = 玩家数据.数据.等级
            self.好友列表[k].转生 = 玩家数据.数据.转生
            self.好友列表[k].飞升 = 玩家数据.数据.飞升
            self.好友列表[k].帮派 = 玩家数据.数据.帮派
            self.好友列表[k].称谓 = 玩家数据.数据.称谓
            self.好友列表[k].外形 = 玩家数据.数据.外形
            self.好友列表[k].原形 = 玩家数据.数据.原形
            self.好友列表[k].头像 = 玩家数据.数据.头像
            self.好友列表[k].性别 = 玩家数据.数据.性别
            self.好友列表[k].关系 = '我的朋友'
            self.好友列表[k].好友度 = 0
            v.在线 = '在线'
            return self.好友列表[k]
        else
            local 玩家数据 =__存档.角色读档(nid)
            local k,v = self:取好友列表信息(nid)
            self.好友列表[k].名称 = 玩家数据.数据.名称
            self.好友列表[k].种族 = 玩家数据.数据.种族
            self.好友列表[k].等级 = 玩家数据.数据.等级
            self.好友列表[k].转生 = 玩家数据.数据.转生
            self.好友列表[k].飞升 = 玩家数据.数据.飞升
            self.好友列表[k].帮派 = 玩家数据.数据.帮派
            self.好友列表[k].称谓 = 玩家数据.数据.称谓
            self.好友列表[k].外形 = 玩家数据.数据.外形
            self.好友列表[k].原形 = 玩家数据.数据.原形
            self.好友列表[k].头像 = 玩家数据.数据.头像
            self.好友列表[k].性别 = 玩家数据.数据.性别
            self.好友列表[k].关系 = '我的朋友'
            self.好友列表[k].好友度 = 0
            v.在线 = '离线'
            return self.好友列表[k]
        end
    else
        -- self.rpc:提示窗口('您和玩家[#Y%s#W]还不是好友#17',self.名称)
        self.rpc:提示窗口('你们还不是好友#17',self.名称)
    end
end

function 角色:角色_删除好友(nid)
    local isfriend = self:是否为好友(nid)
    if isfriend then
        local 编号 = 0
        for i=1,#self.好友列表 do
            if self.好友列表[i].nid == nid then
                编号 = i
            end
        end
        if 编号 ~= 0 then
            table.remove(self.好友列表, 编号)
            self.rpc:提示窗口('#Y已删除好友')
        end
        self:刷新好友列表()
    else
        self.rpc:提示窗口('#Y不是好友关系,无法断交')
    end
end

function 角色:刷新好友列表()
    self.rpc:刷新好友列表(self.好友列表)
end

function 角色:取好友列表信息(nid)
    for k,v in pairs(self.好友列表) do
        if v.nid == nid then
            return k,v
        end
    end
end

function 角色:是否为好友(nid)
    for _, v in pairs(self.好友列表) do
        if v.nid == nid then
            return true
        end
    end
    return false
end
