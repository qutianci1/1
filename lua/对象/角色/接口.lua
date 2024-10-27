-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:55
-- @Last Modified time  : 2024-10-18 20:41:53

-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-05 19:22:38
-- @Last Modified time  : 2023-09-14 17:16:29


--可以访问的属性
local 接口 = {
    名称 = true,
    等级 = true,
    转生 = true,
    飞升 = true,
    nid = true,
    外形 = true,
    原形 = true,
    称谓 = true,
    帮派 = true,
    性别 = true,
    种族 = true,
    气血 = true,
    地图 = true,
    银子 = true,
    仙玉 = true,
    存银 = true,
    师贡 = true,
    体力 = true,
    活力 = true,
    最大气血 = true,
    魔法 = true,
    最大魔法 = true,
    作坊 = true,
    X = true,
    Y = true,
    x = true,
    y = true,
    是否组队 = true,
    是否队长 = true,
    是否战斗 = true,
    其它 = true,
    充值 = true,
    礼包 = true,
    变身卡册 = true,
    法宝列表 = true,
    帮派数据 = true,
    积分 = true
}
--可以访问的方法
function 接口:领养孩子()
    if not self.孩子 then
        self.孩子 = {}
    end
    if #self.孩子 > 8 then
        return '最多可以领养8个孩子'
    end
    local 初始化 = self:角色_初始化孩子()
    table.insert(self.孩子, #self.孩子 + 1, 初始化)
    return '你领养了一个'..初始化.性别..'孩'
end
function 接口:星梦石洗点(属性)
    return self:角色_星梦石洗点(属性)
end

function 接口:宠物蛋奖励()
    return _宠物蛋奖励
end

function 接口:地图在线奖励()
    return _地图在线奖励
end

function 接口:取是否递增()
    if __配置.兑换递增 then
        return __配置.递增规则,__外置数据
    end
    return
end

function 接口:添加兑换记录(类型)
    if __配置.兑换递增 and __配置.递增规则[类型] then
        __外置数据[类型] = __外置数据[类型] + __配置.递增规则[类型][1]
        if __外置数据[类型] > __配置.递增规则[类型][2] then
            __外置数据[类型] = __配置.递增规则[类型][2]
        end
    end
end

function 接口:存款操作(数额)
    self.银子 = self.银子 - 数额
    self.存银 = self.存银 + 数额
    return true
end

function 接口:水陆大会添加队伍(id)
    local 队伍数据 = {}
    __水陆数据[id] = {}
    for _, v in self:遍历队伍() do
        队伍数据[#队伍数据 + 1] = {nid = v.nid , 名称 = v.名称}
    end
    table.insert(__水陆数据[id], 队伍数据)
end

function 接口:查询水陆报名队伍(id)
    if __水陆数据[id] then
        return '你已在报名队伍中,无法重复报名'
    end
    local t = {}
    for _, v in self:遍历队伍() do
        for q,w in pairs(__水陆数据) do
            for i=1,#w do
                if w[i].nid == v.nid then
                    table.insert(t, v.名称)
                end
            end
        end
    end
    if #t > 0 then
        return '#Y' .. table.concat(t, '、 ') .. '#W已在报名列表中无法重复报名'
    end
    return true
end

function 接口:获取水陆报名开关()
    local weekday = os.date("*t").wday
    local hour = os.date("*t").hour
    if weekday == 2 and hour >= 19 and hour <= 24 then
        return false
    else
        return true
    end
end

function 接口:获取水陆入场开关()
    local weekday = tonumber(os.date('%w', os.time()))
    local hour = os.date("*t").hour
    local minute = os.date("*t").min
    if weekday == 2 and hour == 19 then
        if minute >= 45 and minute <= 59 then
            return true
        end
    end
    return false
end

function 接口:检查水陆开关()
    local weekday = os.date("*t").wday
    local hour = os.date("*t").hour
    local minute = os.date("*t").min
    if weekday == 2 then
        if hour >= 20 and hour < 23 then
            return true
        end
    end
    return false
end

function 接口:检查水陆队伍()
    local 记录 = __水陆数据[self.nid]
    if 记录 then
        local 符合人数 = 0
        for _, v in self:遍历队伍() do
            for q,w in pairs(记录) do
                for i=1,#w do
                    if w[i].nid == v.nid then
                        符合人数 = 符合人数 + 1
                    end
                end
            end
        end
        if 符合人数 == #记录 then
            return true
        end
    else
        return '未找到你的报名信息！'
    end
end

function 接口:水陆大会准备()
    if __水陆大会[self.nid] and __水陆数据[self.nid] then
        if __水陆大会[self.nid].战斗 < 3 then
            __水陆大会[self.nid].状态 = true
            return '你们队伍已经#G准备好比赛，#W比赛很快开始。#r#R温馨提示：比赛开始前记得别进行顶号、更换队长等影响系统判断的操作哦。'
        else
            return '你们已完成三场战斗,还请自行离场!'
        end
    else
        return '未找到你的水陆报名信息,请尝试以报名时的队长来准备。'
    end
end

function 接口:寻找卡册变身卡(名称,类型)
    if not self.变身卡册[类型] then
        if 类型 == '强法' or 类型 == '抗性' or 类型 == '物理' then
            self.变身卡册[类型] = {}
        else
            return
        end
    end
    for k,v in pairs(self.变身卡册[类型]) do
        if v.名称 == 名称 then
            return k
        end
    end
    return '无此卡'
end

function 接口:变身卡排序(类型)
    if not self.变身卡册[类型] then
        return
    end
    table.sort(self.变身卡册[类型], function(a, b)
        return a.等级 < b.等级
    end)
end

function 接口:取帮派成员(id)
    if not self.帮派 then
        self.rpc:提示窗口('#Y你还没有帮派')
        return
    end
    if __帮派[self.帮派] then
        local P = __帮派[self.帮派]:ID取成员(id + 0)
        return P
    end
end

function 接口:发送帮派公告(文本)
    if __帮派[self.帮派] then
        for k, v in __帮派[self.帮派]:遍历成员() do --遍历成员
            if __玩家[k] then --判断一下玩家是否在线
                __玩家[k].rpc:聊天框提示(文本)
            end
        end
    end
end

function 接口:提示窗口(...)
    self.rpc:提示窗口(...)
end

function 接口:请求召唤染色方案(...)
    return self.rpc:请求召唤染色方案(...)
end

function 接口:常规提示(...)
    self.rpc:常规提示(...)
end

function 接口:聊天框提示(...)
    self.rpc:聊天框提示(...)
end

function 接口:最后对话(...)
    self.rpc:最后对话(...)
end

-- function 接口:最后对话2(内容,外形)
--     self.rpc:最后对话2(内容,外形)
-- end
function 接口:选择窗口(...)
    return self.rpc:选择窗口(...)
end

function 接口:神兵窗口(...)
    return self.rpc:神兵自选(...)
end

function 接口:创建帮派窗口(...)
    return self.rpc:创建帮派窗口(...)
end

function 接口:响应帮派窗口(...)
    return self.rpc:响应帮派窗口(...)
end

function 接口:申请帮派窗口(t)
    return self.rpc:申请帮派窗口(t)
end

function 接口:帮派创建(名称, 宗旨)
    return self:角色_帮派创建(名称, 宗旨)
end

function 接口:响应帮派(名称)
    return self:角色_响应帮派(名称)
end
function 接口:取消帮派()
    return self:角色_取消帮派()
end

function 接口:创建帮战()
    __帮战[1] = {'凌烟阁','只手遮天'}

    local 帮战地图 = __沙盒.生成地图(1197)
    帮战地图:添加NPC {
        名称 = "帮派总管",
        外形 = 3011,
        脚本 = 'scripts/npc/帮派/帮派总管.lua',
        X = 143,
        Y = 16}
    for i=1,#__帮战[1] do
        __帮派[__帮战[1][i]].帮战地图 = 帮战地图
    end
    return '创建成功'
    -- return self:创建帮战()
end

function 接口:帮战入场()
    if not self.帮派 then
        return '没有帮派不要在这里胡闹!'
    end
    if not __帮派[self.帮派] then
        return '未找到你的帮派,可能已解散请联系管理处理'
    end
    if not __帮派[self.帮派].帮战地图 then
        return '未找到你帮派的对战场景,请联系帮主确认'
    end
    if __帮派[self.帮派].帮战地图 then
        self:移动_切换地图(__帮派[self.帮派].帮战地图, 1840, 1300)
        self.称谓 = self.帮派..'成员'
        self.rpc:切换称谓(self.nid, self.称谓)
        self.rpn:切换称谓(self.nid, self.称谓)
    end
end


function 接口:进入帮派()
    return self:角色_进入帮派()
end
function 接口:打开对话(...)
    return self.rpc:打开对话(...)
end

function 接口:确认窗口(...)
    return self.rpc:确认窗口(...)
end

function 接口:输入窗口(...)
    return self.rpc:输入窗口(...)
end

function 接口:整数输入窗口(...)
    return self.rpc:整数输入窗口(...)
end

function 接口:金钱输入窗口(...)
    return self.rpc:金钱输入窗口(...)
end

function 接口:打开给予窗口(nid)
    return self.rpc:打开给予(nid)
end

function 接口:打开作坊窗口(数据)
    return self.rpc:打开作坊窗口(数据)
end

function 接口:物品_获取数量(名称)
    return self:物品_获取数量(名称)
end

function 接口:兑换藏宝图窗口()
    local s = self:物品_获取数量('见闻录')
    local r = self:物品_获取数量('指南录')
    self.rpc:藏宝图兑换窗口(self.银子, s, r)
end

function 接口:兑换卡密()
    self.rpc:卡密兑换()
end

function 接口:取款()
    self.rpc:打开取款()
end

function 接口:购买窗口(spt)
    local GGF = require('GGE.函数')
    if __脚本[spt] and __脚本[spt].取商品 and __脚本[spt].购买 then
        coroutine.xpcall(function()
            local list = __脚本[spt]:取商品()
            if type(list) == 'table' then
                local 校验 = {}
                for i, v in ipairs(list) do
                    校验[i] = tostring(v)
                end
                local i, n
                if not self.积分.除妖奖章 then
                    self.积分.除妖奖章 = 0
                end
                if not self.积分.功绩 then
                    self.积分.功绩 = 0
                end
                if spt == 'scripts/shop/大雁塔兑换.lua' then
                    i, n = self.rpc:购买窗口(self.积分.除妖奖章, list)
                elseif spt == 'scripts/shop/水陆积分.lua' then
                    i, n = self.rpc:购买窗口(self.积分.水陆积分, list)
                elseif spt == 'scripts/shop/地宫兑换.lua' then
                    local 商品 = {}
                    if __配置.兑换递增 then
                        for k,v in pairs(list) do
                            商品[k] = v
                            if __外置数据[v.名称] then
                                商品[k].价格 = __外置数据[v.名称]
                            end
                        end
                    else
                        商品 = GGF.复制表(list)
                    end
                    i, n = self.rpc:购买窗口(self.积分.功绩, 商品)
                else
                    i, n = self.rpc:购买窗口(self.银子, list)
                end
                local list = __脚本[spt]:取商品()
                if 校验[i] == tostring(list[i]) then
                    local r = __脚本[spt]:购买(self.接口, i, n)
                    if type(r) == 'string' then
                        self.rpc:提示窗口(r)
                    end
                else
                    self.rpc:提示窗口('#Y购买失败，商品已经刷新')
                end
            end
        end)
    end
end

function 接口:当铺窗口()
    self.rpc:当铺窗口()
end

function 接口:增加当铺()
    if self.当铺栏<3 then
        if self.银子>=1000000 then
            self:角色_扣除银子(1000000)
            self.当铺栏=self.当铺栏+1
        else
            self.rpc:提示窗口('#Y你的金钱不足100W,无法增加新的当铺栏')
        end
    else
        self.rpc:提示窗口('#Y你最多可以增加3页当铺栏')
    end
end

function 接口:换角色窗口()
    local 外形, 种族, 性别 = self.rpc:换角色窗口()
    return 种族, 性别, 外形
end

function 接口:转生窗口()
    local 种族, 性别, 外形 = self.rpc:转生窗口()
    return 种族, 性别, 外形
end

function 接口:作坊总管窗口()
    self.rpc:作坊总管窗口()
end

function 接口:出售变身卡窗口()
    self.rpc:出售变身卡窗口(self.银子)
end



-- function 接口:作坊窗口()
--     self.rpc:作坊窗口()
-- end
function 接口:灌输灵气窗口()
    self.rpc:灌输灵气窗口(self.银子)
end

function 接口:仙器升级窗口()
    self.rpc:仙器升级窗口(self.银子)
end

function 接口:仙器炼化窗口()
    self.rpc:仙器炼化窗口(self.银子)
end

function 接口:仙器重铸窗口()
    self.rpc:仙器重铸窗口(self.银子)
end

function 接口:神兵升级窗口()
    self.rpc:神兵升级窗口(self.银子)
end

function 接口:神兵强化窗口()
    self.rpc:神兵强化窗口(self.银子)
end

function 接口:神兵精炼窗口()
    self.rpc:神兵精炼窗口(self.银子)
end

function 接口:神兵炼化窗口()
    self.rpc:神兵炼化窗口(self.银子)
end

function 接口:装备打造窗口()
    self.rpc:装备打造窗口(self.银子)
end

function 接口:发送系统(...) --71
    __世界:发送系统(...)
end

function 接口:遍历队友()
    local k, v
    return function(list)
        k, v = next(list, k)
        if v == self then
            k, v = next(list, k)
        end
        if v then
            return k, v.接口
        end
    end, self.队伍 or {}
end

function 接口:刷新外形()
    return self:角色_刷新外形()
end

function 接口:召唤兽驯养()
    local zh = self:角色_打开召唤兽驯养窗口()
    self.rpc:召唤兽驯养(zh,self.帮派数据.帮派成就)
end

function 接口:遍历队伍()
    local k, v
    return function(list)
        k, v = next(list, k)
        if v then
            return k, v.接口
        end
    end, self.队伍 or {}
end

function 接口:获取时间宠等级()
    local r = self:角色_取宠物信息()
    if r and r.等级 then
        return r.等级
    end
    return 0
end

function 接口:取任务(名称)
    local r = self:任务_获取(名称)
    return r and r.接口
end
function 接口:刷新追踪面板()
    if self.是否组队 then
        for _, v in self:遍历队伍() do
            v.rpc:刷新界面任务()
        end
    else
        self.rpc:刷新界面任务()
    end
end
function 接口:取剧情任务(名称)
    local r = self:任务_获取(名称)
    return r
end

function 接口:判断等级是否低于(等级, 转生, 飞升)
    if type(等级) == 'number' and self.等级 > 等级 then
        return false
    end
    if type(转生) == 'number' and self.转生 > 转生 then
        return false
    end
    if type(飞升) == 'number' and self.飞升 > 飞升 then
        return false
    end

    return true
end

function 接口:判断等级是否高于(等级, 转生, 飞升)
    if type(等级) == 'number' and self.等级 < 等级 then
        return false
    end
    if type(转生) == 'number' and self.转生 < 转生 then
        return false
    end
    if type(飞升) == 'number' and self.飞升 < 飞升 then
        return false
    end

    return true
end

function 接口:取双倍时间数据()
    return __双倍时间[self.nid]
end

function 接口:领取双倍时间(n)
    __双倍时间[self.nid] = __双倍时间[self.nid] + n
    return __双倍时间[self.nid]
end

function 接口:取五倍时间数据()
    return __五倍时间[self.nid]
end

function 接口:领取五倍时间(n)
    __五倍时间[self.nid] = __五倍时间[self.nid] + n
    return __五倍时间[self.nid]
end

function 接口:取队伍任务(名称) --
    local mz = '#R'
    if self.是否组队 then
        for _, v in self:遍历队伍() do
            if v:取任务(名称) then
                return true
            end
        end
    else
        return 接口.取任务(self, 名称)
    end
    return false
end

function 接口:取队伍人数()
    if self.是否组队 then
        return #self.队伍
    end
    return 1
end

function 接口:取队伍平均等级()
    if self.是否组队 then
        local 等级 = 0
        for _, v in self:遍历队伍() do
            等级 = 等级 + v.等级
        end
        等级 = 等级 / #self.队伍
        return math.floor(等级)
    end

    return self.等级
end

function 接口:取队伍最高等级()
    if self.是否组队 then
        local 等级 = self.等级
        for _, v in self:遍历队伍() do
            if v.等级 > 等级 then
                等级 = v.等级
            end
        end
        return 等级
    end
    return self.等级
end

function 接口:取队伍最高转生()
    if self.是否组队 then
        local 转生 = self.转生
        for _, v in self:遍历队伍() do
            if v.转生 > 转生 then
                转生 = v.转生
            end
        end
        return 转生
    end
    return self.转生
end

function 接口:添加任务(t, ...)
    if type(t) == 'string' then
        if t == '灵兽降世' then
            t = __沙盒.生成任务({ 名称 = t , 进度 = 0}, ...)
        else
            t = __沙盒.生成任务({ 名称 = t }, ...)
        end
    end
    return self:任务_添加(t) and true
end

function 接口:遍历任务()
    -- local k, v
    -- return function(list)
    --     k, v = next(list, k)
    --     if v then
    --         return k, v.接口
    --     end
    -- end, self._任务

    return self:遍历任务()
end

function 接口:遍历召唤()
    
end

function 接口:住店()
    self.气血 = self.最大气血
    self.魔法 = self.最大魔法
end

function 接口:全队超级巫医()
    for _, v in self:遍历队伍() do
        for k, n in v:遍历召唤() do
            n:超级巫医()
        end
    end

end

function 接口:超级巫医()
    for k, v in self:遍历召唤() do
        v:超级巫医()
    end
end

function 接口:全队取巫医消耗()
    local yzxh = 0
    for _, v in self:遍历队伍() do
        for k, n in v:遍历召唤() do
            yzxh = yzxh + n:取巫医消耗()
        end
    end
    return yzxh
end

function 接口:取巫医消耗()
    local yzxh = 0
    for k, v in self:遍历召唤() do
        yzxh = yzxh + v:取巫医消耗()
    end
    return yzxh
end

function 接口:取玩家(nid)
    return __玩家[nid]
end

function 接口:取宠物信息()
    return self:角色_取宠物信息()
end

function 接口:打开宠物领养窗口()
    return self.rpc:打开宠物领养()
end

function 接口:领养时间宠(n)
    local r = require('数据库/宠物库')[n]
    local _名称颜色 = {
        0xFF8C00FF, -- 橙色0转
        0xEE82EEFF, -- 粉色1转
        0x7B68EEFF, -- 紫色2转
        0x0000CDFF, -- 深蓝3转
        0x4B0082FF, -- 深紫4转
    }
    if not next(self.宠物) then
        self:宠物_添加(require('对象/宠物') { 名称 = r.name, 外形 = r.外形 , 名称颜色 = _名称颜色[self.转生+1]})
        return 1
    else

        if self.rpc:确认窗口('是否确定替换当前时间宠？') then
            local _, p = next(self.宠物)
            p.名称 = r.name
            p.名称颜色 = _名称颜色[self.转生+1]
            p.外形 = r.外形
            return 2
        end
    end
    return false
end

function 接口:改名(v)
    if self.是否战斗 or self.是否摆摊 or type(v) ~= 'string' then
        return
    end
    self.名称 = v
    self.rpc:切换名称(self.nid, v)
    self.rpn:切换名称(self.nid, v)
    return true
end

function 接口:判断是否满血(v)
    if self.是否战斗 then
        return false
    end
    if v then
        if self.气血 == self.最大气血 then
            return true
        end
    end
end

function 接口:判断是否满蓝(v)
    if self.是否战斗 then
        return false
    end
    if v then
        if self.魔法 == self.最大魔法 then
            return true
        end
    end
end

function 接口:增减气血(v)
    if type(v) == 'number' then
        if self.气血 >= self.最大气血 then
            return
        end
        self.气血 = self.气血 + math.floor(v)
        self.rpc:添加特效(self.nid, 'add_hp')
        self.rpn:添加特效(self.nid, 'add_hp')
        if self.气血 > self.最大气血 then
            self.气血 = self.最大气血
        end
        return self.气血
    end
    return
end

function 接口:增减魔法(v)
    if type(v) == 'number' then
        if self.魔法 >= self.最大魔法 then
            return
        end
        self.魔法 = self.魔法 + math.floor(v)
        self.rpc:添加特效(self.nid, 'add_mp')
        self.rpn:添加特效(self.nid, 'add_mp')
        if self.魔法 > self.最大魔法 then
            self.魔法 = self.最大魔法
        end
        return self.魔法
    end
    return
end

function 接口:双加(a, b)
    if type(a) == 'number' and type(b) == 'number' then
        self.气血 = self.气血 + math.floor(a)
        self.魔法 = self.魔法 + math.floor(b)
        if self.魔法 > self.最大魔法 then
            self.魔法 = self.最大魔法
        end

        if self.气血 > self.最大气血 then
            self.气血 = self.最大气血
        end


        return self.魔法
    end
end

function 接口:添加法术熟练(熟练)
    if type(熟练) == 'number' then
        local kts = {}
        for k, v in self:遍历技能() do
            if v.名称 ~= '银索金铃' and v.名称 ~= '将军令' and v.名称 ~= '大势锤' and v.名称 ~= '七宝玲珑塔' and v.名称 ~= '黑龙珠' and v.名称 ~= '幽冥鬼手' and v.名称 ~= '大手印' and v.名称 ~= '绝情鞭' and v.名称 ~= '情网' and v.名称 ~= '宝莲灯' and v.名称 ~= '金箍儿' and v.名称 ~= '锦襕袈裟' and v.名称 ~= '白骨爪' and v.名称 ~= '化蝶' then
                if v.熟练度 < v.熟练度上限 then
                    table.insert(kts, k)
                end
            end
        end
        if #kts > 0 then
            local k = kts[math.random(#kts)]
            self.技能[k]:添加熟练度(熟练)
            self.刷新的属性.技能 = true
            return self.技能[k].名称
        else
            self.rpc:提示窗口('#Y 你所有法术熟练度已经达到上限，无法食用！')
        end
    end
    return false
end

function 接口:添加体力(n)
    self.体力 = self.体力 + math.floor(n)
    if self.体力 > self.体力上限 then
        self.体力 = self.体力上限
    end
    return self.体力
end

function 接口:取技能是否存在(s)
    for _, v in self:遍历技能() do
        if v.名称 == s then
            return true
        end
    end
    return false
end

function 接口:取技能是否满熟练(s)
    for _, v in self:遍历技能() do
        if v.名称 == s then
            if v.熟练度 >= 5000 + (self.转生 + 1) * 5000 then
                return true
            end
        end
    end
    return false
end

function 接口:添加技能熟练度(技能,数量)
    for _, v in self:遍历技能() do
        if v.名称 == 技能 then
            v.熟练度 = v.熟练度 + 数量
            if v.熟练度 > 5000 + (self.转生 + 1) * 5000 then
                v.熟练度 = 5000 + (self.转生 + 1) * 5000
            end
            self.rpc:提示窗口('#Y 你的技能'..v.名称..'熟练度提升了'..数量..'点！')
        end
    end
    return false
end

function 接口:添加技能(name, m)
    return self:添加技能(name, m)
end

function 接口:指定阶数技能添加熟练(jn, n)
    for k, v in self:遍历技能() do
        if v.阶段 == jn then
            v:添加熟练度(math.floor(n))
        end
    end
end

function 接口:取地图(id)
    return __地图[id] and __地图[id].接口
end

function 接口:取当前地图()
    return self.当前地图.接口
end

function 接口:取随机地图(t)
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

function 接口:切换地图(mid, x, y)
    local map = __地图[mid]
    if map then
        x = math.floor(x * 20)
        y = math.floor((map.高度 - y) * 20)
        coroutine.xpcall(
            function()
                self:移动_切换地图(map, x, y)
            end
        )
    end
end

function 接口:切换地图2(map, x, y)
    if map then
        coroutine.xpcall(
            function()
                self:移动_切换地图(map, x, y)
            end
        )
    end
end

local _可双倍 = {
    抓鬼 = true,
    鬼王 = true,
    天庭 = true,
    修罗 = true,
    野外 = true
}
local _不可加成 = {
    人参果 = true,
    人参果王 = true,
    超级人参果王 = true,
    测试人参果王 = true
}
function 接口:添加声望(n, 来源)
    self.声望 = math.floor(self.声望 + n)
    self.最大声望 = math.floor(self.最大声望 + n)
end

function 接口:添加等级()
    self.等级 = self.等级 + 1
    self.根骨 = self.根骨 + 1
    self.灵性 = self.灵性 + 1
    self.力量 = self.力量 + 1
    self.敏捷 = self.敏捷 + 1
    self.潜力 = self.潜力 + 4
    self.最大经验 = self:取升级经验()
    if self.等级 <= 30 then
        self.体力上限 = 90
    else
        self.体力上限 = 10 * ( 60 + self.等级 + 50 * self.转生 )
    end

    self:刷新属性(1)
    self.rpc:添加特效(self.nid, 'level_up')
    self.rpn:添加特效(self.nid, 'level_up')
end

function 接口:取经验加成(来源)
    local 倍率 = 1
    if 来源 then
        if _可双倍[来源] then
            local r = self:任务_获取('双倍时间')
            if r then
                倍率 = 倍率 + 1
            end
        elseif 来源 == '降魔' then
            local r = self:任务_获取('五倍时间')
            if r then
                倍率 = 倍率 + 5
            end
        end
    end
    return 倍率
end

function 接口:扣除积分(类型,数额)
    self:扣除积分(类型,数额)
end

function 接口:添加除妖奖章(n)
    if not self.积分 then
        self.积分 = {除妖奖章 = 0}
    end
    if not self.积分.除妖奖章 then
        self.积分.除妖奖章 = 0
    end
    self.积分.除妖奖章 = self.积分.除妖奖章 + n
    self.rpc:提示窗口('#Y你得到了除妖奖章')
end

function 接口:添加功绩(n)
    if not self.积分 then
        self.积分 = {功绩 = 0}
    end
    if not self.积分.功绩 then
        self.积分.功绩 = 0
    end
    self.积分.功绩 = self.积分.功绩 + n
    self.rpc:提示窗口('#Y你得到了'..n..'功绩')
end

function 接口:添加任务经验(n, 来源)
    local yk = self:任务_获取('VIP月卡')
    if yk then
        n = math.floor(n * 1.3)
    end
    n = n * 接口.取经验加成(self, 来源)
    接口.添加经验(self, n)
    local r = 接口.取参战召唤兽(self)
    if r then
        r:添加经验(n * 1.5)
        r:添加内丹经验(n * 1.5)
    end
    self:法宝_添加经验(n)
end

function 接口:添加亲密(nid,亲密)
    self:召唤_添加亲密(nid,亲密)
    return true
end

function 接口:添加经验(n)
    local yk = self:任务_获取('VIP月卡')
    if yk then
        n = math.floor(n * 1.3)
    end

    self.经验 = math.floor(self.经验 + n)
    if self:取等级上限() then
        return false
    end

    while self.经验 >= self.最大经验 and not self:取等级上限() do
        self.经验 = self.经验 - self.最大经验
        接口.添加等级(self)
        self:召唤_添加升级亲密(self.等级)
        self.task:任务升级事件(self.接口)
    end
    if not self.离线角色 then
        self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y点经验')
    end
    return true
end

function 接口:添加参战召唤兽经验(n,来源)
    n = n * 接口.取经验加成(self, 来源)
    local yk = self:任务_获取('VIP月卡')
    if yk then
        n = math.floor(n * 1.3)
    end
    -- 接口.添加经验(self, n)
    local r = 接口.取参战召唤兽(self)
    if r then
        r:添加经验(n * 1.5)
        r:添加内丹经验(n * 1.5)
    end
    -- self:法宝_添加经验(n)
end

function 接口:取参战召唤兽()
    if self.参战召唤 then
        return self.参战召唤.接口
    end
end

function 接口:取是否拥有法宝(名称)
    return self:法宝_是否拥有(名称)
end
function 接口:获取法宝()
    return self:角色_获取法宝数据()
end

function 接口:添加法宝(名称)
    local r = require('数据库/法宝库')[名称]
    self:法宝_添加(require('对象/法宝/法宝') { 名称 = r.名称, 主人 = r.主人, 阴阳 = r.阴阳, 道行 = r.道行, 等级 = 1 })
    return 1
end

function 接口:检测坐骑(r)
    for k,v in pairs(self.坐骑) do
        if v.接口.几座 == r then
            return true
        end
    end
end


function 接口:添加坐骑(r)
    self:坐骑_添加(__沙盒.生成坐骑 { 种族 = self.种族, 几座 = r })
end

function 接口:删除当前坐骑()
    for k,v in pairs(self.坐骑) do
        if v == self.当前坐骑 then
            self.坐骑[k] = nil
        end
    end
end

function 接口:取乘骑坐骑()
    if self.当前坐骑 then
        return self.当前坐骑.接口
    end
end

function 接口:是否佩戴装备()
    for k, v in pairs(self.装备) do
        return true
    end
end

local _称谓需求 = {
    { '三界贤君' },
    { '齐天妖王' },
    { '九天圣佛' },
    { '阴都大帝' },
}
local _转生等级需求 = { 102, 122, 142, 180 }
function 接口:转生条件检测(性别)
    if self.转生 >= 3 then
        return "最高3转！"
    end
    if self.等级 < _转生等级需求[self.转生 + 1] then
        return "等级未达到转生要求！"
    end

    if 接口.是否佩戴装备(self) then
        return "请先卸下人物装备！"
    end
    for k, v in self:遍历任务() do
        if v.禁止转生 then
            return "请先完成任务栏任务！"
        end
    end
    if self.是否组队 then
        return "请先离队！"
    end
    if 性别 and self.配偶 and 性别 ~= self.性别 then
        return "已结婚的玩家在转生的时候不能改变性别！"
    end

    -- if not self:取称谓是否存在(_称谓需求[self.种族][1]) then
    --     return "请先获得10级别剧情称谓"
    -- end
    -- if self.转生>=1 then
    --     if not self:取称谓是否存在('火眼金睛' ) then
    --         return "请先获得14级别剧情称谓"
    --     end
    -- end
    if not self:转生技能检测() then
        return "至少有一种技能学习到第五阶并且满熟练度"
    end

    if self.经验 < 0 then
        return "必须把经验补为正数或通过降级弥补经验值"
    end
end

function 接口:换角色检测(性别)
    if 接口.是否佩戴装备(self) then
        return "请先卸下人物装备！"
    end
    if self.是否组队 then
        return "请先离队！"
    end
    if 性别 and self.配偶 and 性别 ~= self.性别 then
        return "已结婚的玩家不能改变性别！"
    end
end

function 接口:重选修正(xz)
    if type(xz) == 'table' then
        self.转生记录 = xz
        self:刷新属性()
        self.rpc:提示窗口('#Y新的修正已生效')
    end
end

local 转生dj = { 15, 15, 60 }
function 接口:转生处理(种族, 性别, 外形)
    -- if 接口.转生条件检测(self) then
    --     return
    -- end
    local 旧门派 = require('数据库/角色').基本信息[self.原形].门派
    local t = require('数据库/角色').基本信息[外形]

    if not t then
        return
    end
    table.insert(self.转生记录, self.种族 * 1000 + self.性别)

    self.转生 = self.转生 + 1
    self.等级 = 转生dj[self.转生]
    self.经验 = 0
    self.外形 = 外形
    self.头像 = 外形
    self.原形 = 外形
    self.武器 = nil
    self.种族 = t.种族
    self.性别 = t.性别

    local 新门派 = t.门派
    local _门派技能 = require('数据库/角色').门派技能
    local 旧技能 = {}
    for _, jn in self:遍历技能() do
        if jn.阶段 then
            旧技能[jn.名称] = jn
        end
    end

    for ji, jmp in ipairs(旧门派) do
        for i, mc in ipairs(_门派技能[jmp]) do
            if 旧技能[mc] then
                local xmp = 新门派[ji]
                --旧技能[mc].名称 = _门派技能[xmp][i]
                旧技能[mc]:转换(_门派技能[xmp][i])
                旧技能[mc]:刷新熟练度上限(self)
            end
        end
    end

    self:角色_人物洗点()
    self:角色_取名称颜色()
end

function 接口:人物洗点()
    if 接口.是否佩戴装备(self) then
        return "#Y请先卸下人物装备！"
    end

    self:角色_人物洗点()
    return true
end

function 接口:取已分配属性()
    local r = self:角色_取已分配属性()
    if not r or r < 0 then
        r = 0
    end
    return r
end

function 接口:删除指定物品(名称)
    self:角色_删除物品(名称)
    return true
end

function 接口:寻找召唤兽(名称)
    return self:寻找召唤兽(名称)
end

function 接口:删除召唤兽(名称)
    return self:删除召唤兽(名称)
end

function 接口:换角色处理(种族, 性别, 外形)
    if self.银子 < 500000 then
        self.rpc:常规提示("你身上的银两不足50W两！")
        return
    end

    self.银子 = self.银子 - 500000

    local 旧门派 = require('数据库/角色').基本信息[self.原形].门派
    local t = require('数据库/角色').基本信息[外形]
    self.外形 = 外形
    self.头像 = 外形
    self.原形 = 外形
    self.种族 = t.种族
    self.性别 = t.性别
    self.门派 = t.门派
    self.武器 = nil
    local 新门派 = t.门派
    local _门派技能 = require('数据库/角色').门派技能
    local 旧技能 = {}
    for _, jn in self:遍历技能() do
        if jn.阶段 then
            旧技能[jn.名称] = jn
        end
    end

    for ji, jmp in ipairs(旧门派) do
        for i, mc in ipairs(_门派技能[jmp]) do
            if 旧技能[mc] then
                local xmp = 新门派[ji]
                --旧技能[mc].名称 = _门派技能[xmp][i]
                旧技能[mc]:转换(_门派技能[xmp][i])
                旧技能[mc]:刷新熟练度上限(self)
            end
        end
    end


    self:角色_人物洗点()
    self:刷新属性()
end

function 接口:添加称谓(s)
    return self:角色_添加称谓(s)
end

function 接口:检查空位()
    return self:物品_检查空间()
end

function 接口:添加物品(t)
    local r = self:物品_添加(t)
    if r then
        for k, v in pairs(t) do
            if v.数据.数量 and v.数据.数量 > 1 then
                self.rpc:提示窗口('#Y你获得了#G' .. v.数据.名称 .. '*' .. v.数据.数量)
            else
                self.rpc:提示窗口('#Y你获得了#G' .. (v.数据.原名 or v.数据.名称))
            end
        end
    end

    return r
end

function 接口:添加物品_无提示(t)
    local r = self:物品_添加(t)
    return r
end

function 接口:添加召唤(t)
    local r = self:召唤_添加(t)
    if r then
        self.rpc:提示窗口('#Y你获得了#G' .. t.名称)
    else
        self.rpc:提示窗口('#Y已达到携带上限')
    end
    return r
end

function 接口:删除物品(name, n)
    return true
end

function 接口:取物品是否存在(name)
    return self:物品_获取(name)
end

function 接口:兑换神兽()
    if self:取召唤兽数量() >= self.召唤兽携带上限 then
        return '你可携带的召唤兽数量已满'
    end
    local s = self:物品_获取数量('神兽碎片')
    if s then
        if s < 90 then
            self.rpc:提示窗口('#Y你拥有的神兽碎片似乎不够')
            return
        end
    else
        self.rpc:提示窗口('#Y你没有神兽碎片')
        return
    end
    local _神兽列表 = {'超级飞鱼','超级蜘蛛','超级海龟','超级蝙蝠','超级蟾蜍','超级毒蛇','超级飞鱼','超级毒蛇','超级蜘蛛','范式之魂','垂云叟','浪淘沙','垂云叟','超级蟾蜍','五叶','颜如玉','浪淘沙','垂云叟'}
    local 神兽 = _神兽列表[math.random(#_神兽列表)]
    local k = self:物品_扣除数量('神兽碎片',90)
    if k then
        local r = self:召唤_添加(__沙盒.生成召唤 { 名称 = 神兽 })
        self.rpc:提示窗口('#Y你获得了神兽#G'..神兽)
        __世界:发送系统('#R%s#C使用90个神兽碎片向神兽大将兑换了一只#G#m(%s)[%s]#m#n',self.名称, r.ind, r.名称)
    end
end


function 接口:取活动限制次数(name)
    if __活动限制[self.nid] == nil then
        __活动限制[self.nid] = {}
    end
    if __活动限制[self.nid][name] == nil then
        __活动限制[self.nid][name] = 0
    end
    return __活动限制[self.nid][name]
end

function 接口:增加活动限制次数(name)
    if __活动限制[self.nid] == nil then
        __活动限制[self.nid] = {}
    end
    if __活动限制[self.nid][name] == nil then
        __活动限制[self.nid][name] = 0
    end
    __活动限制[self.nid][name] = __活动限制[self.nid][name] + 1
end

function 接口:添加银子(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    self.刷新的属性.银子 = true
    self.银子 = self.银子 + n
    if not self.离线角色 then
        self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y两银子')
    end
end

function 接口:添加仙玉(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    self:角色_添加仙玉(n)
    self.刷新的属性.仙玉 = true
    --self.仙玉 = self.仙玉 + n
    if not self.离线角色 then
        self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y仙玉')
    end
end


function 接口:添加师贡(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    self.刷新的属性.师贡 = true
    self.师贡 = self.师贡 + n
    self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y师贡')
end

function 接口:添加活力(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    self.活力 = self.活力 + n
    if self.活力 > self.活力上限 then
        self.活力 = self.活力上限
    end
end

function 接口:扣除成就(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    if not self.帮派数据.帮派成就 then
        self.帮派数据.帮派成就 = 0
    end
    self.帮派数据.帮派成就 = self.帮派数据.帮派成就 - n
end

function 接口:添加成就(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    if not self.帮派数据.帮派成就 then
        self.帮派数据.帮派成就 = 0
    end
    self.帮派数据.帮派成就 = self.帮派数据.帮派成就 + n
    self.rpc:提示窗口('#Y你获得了#R' .. n .. '#Y点帮派成就')
    return true
end

function 接口:添加帮派建设(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n or n <= 0 then
        return
    end
    if not self.帮派 then
        return
    end
    if not __帮派[self.帮派] then
        return
    end
    __帮派[self.帮派].建设度 = __帮派[self.帮派].建设度 + n
    self.rpc:提示窗口('#Y在你的努力下,帮派建设度提高了#R' .. n .. '#Y点')
    if __帮派[self.帮派]:是否可升级() then
        self.rpc:提示窗口('#Y你的帮派可以升级了,快联系帮主升级帮派吧')
    end
end

function 接口:刷新属性()
    return self:刷新属性()
end

function 接口:扣除银子(n)
    return self:角色_扣除银子(n)
end

function 接口:扣除体力(n)
    return self:角色_扣除体力(n)
end

function 接口:扣除师贡(n)
    return self:角色_扣除师贡(n)
end

function 接口:更换称谓(s)
    for k, v in pairs(self.称谓列表) do
        if v == s then
            self:角色_更换称谓(k)
            return true
        end
    end

    return false
end

function 接口:取当前地图等级()
    return self.当前地图.地图等级 or 0
end

function 接口:进入战斗(v, ...)
    if not self.是否战斗 then
        local 脚本 = __脚本[v]
        if type(脚本) == 'table' and type(脚本.战斗初始化) == 'function' then
            return self:战斗_初始化(v, ...)
        else
            warn('战斗脚本错误')
        end
    end
end

function 接口:自动任务(...)
    self.rpc:自动任务_数据(...)
end

function 接口:自动任务_战斗结束(...)
    self.rpc:自动任务_战斗结束(...)
end

--===============================================================================
if not package.loaded.角色接口_private then
    package.loaded.角色接口_private = setmetatable({}, { __mode = 'k' })
end
local _pri = require('角色接口_private')

local 角色接口 = class('角色接口')

function 角色接口:初始化(P)
    _pri[self] = P
    self.是否玩家 = true
end

function 角色接口:__index(k)
    local r = 接口[k]
    local P = _pri[self]
    if r == true then
        return P[k]
    elseif r then
        return function(_, ...)
            return r(P, ...)
        end
    end
end

function 角色接口:__pairs(k)
    return 接口
end

return 角色接口
