-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-04-05 19:22:38
-- @Last Modified time  : 2024-08-26 15:54:11

local 角色 = require('角色')

function 角色:战斗_初始化(v, ...)
    local r = self:任务_获取("变身卡")
    local 队伍数量 = 0
    local 亲和 = {}
    local 种族 = {}
    local 名称 = {}
    --变身卡修正
    if self.是否组队 then
        if self.是否队长 then
            for i, P in self:遍历队伍() do
                P.变身修正 = nil
                local rr = P:任务_获取("变身卡")
                if rr then
                    队伍数量 = 队伍数量 + 1
                    亲和[#亲和 + 1] = rr.变身属性.亲和
                    种族[#种族 + 1] = rr.变身属性.种族
                    名称[#名称 + 1] = rr.变身属性.名称
                end
            end
            local 总亲和 = 0
            for n = 1, #亲和 do
                总亲和 = 总亲和 + 亲和[n]
            end
            for i, P in self:遍历队伍() do
                local rr = P:任务_获取("变身卡")
                if rr then
                    local 异类卡, 同名卡 = -1, -1
                    for n = 1, #种族 do
                        if 种族[n] ~= rr.变身属性.种类 then
                            异类卡 = 异类卡 + 1
                        end
                    end
                    for n = 1, #名称 do
                        if 名称[n] == rr.变身属性.名称 then
                            同名卡 = 同名卡 + 1
                        end
                    end
                    local 修正 = 1.04 + 队伍数量 * 0.28 - (队伍数量 + 1) * 0.01 -
                    math.abs(rr.变身属性.亲和 - 总亲和 / 队伍数量) * 0.1 - 同名卡 * 0.18 - 异类卡 *
                    0.05
                    if 队伍数量 == 1 then
                        P.变身修正 = 1
                    else
                        P.变身修正 = 修正
                    end
                end
            end
        end
    else
        if r then
            self.变身修正 = 1
        else
            self.变身修正 = nil
        end
    end


    if ggetype(v) == 'string' then --PVE
        local arg = { self.接口, ... }
        local co = coroutine.running()
        coroutine.xpcall(
            function()
                local 战场 = require('战斗/战场')(v, arg)
                if self.是否组队 then
                    if not self.是否队长 then
                        return
                    end

                    for i, P in self:遍历队伍() do
                        战场:加入我方(i, P)
                        if P.参战召唤 then
                            local 参战 = P.参战召唤:取是否可参战()
                            if 参战 then
                                战场:加入我方(i + 5, P.参战召唤)
                            end
                        end
                        if P.孩子参战 then
                            local 外形 = 400
                            if P.孩子参战.性别 == '女' then
                                外形 = 420
                            end
                            战场:加入我方(i + 20,
                                { 名称 = P.孩子参战.名称, 外形 = 外形, 天资 = P.孩子参战.天资,
                                    速度 = 99999, 评价 = P.孩子参战.评价, 亲密 = P.孩子参战.亲密,
                                    孝心 = P.孩子参战.孝心 })
                        end
                    end
                else
                    self.切磋 = nil
                    self.PK = nil
                    self.PK发起方 = nil
                    战场:加入我方(1, self)
                    if self.参战召唤 then
                        local 参战 = self.参战召唤:取是否可参战()
                        if 参战 then
                            战场:加入我方(1 + 5, self.参战召唤)
                        end
                    end
                    if self.孩子参战 then
                        local 外形 = 400
                        if self.孩子参战.性别 == '女' then
                            外形 = 420
                        end
                        战场:加入我方(21,
                            { 名称 = self.孩子参战.名称, 外形 = 外形, 天资 = self.孩子参战.天资,
                                速度 = 99999, 评价 = self.孩子参战.评价, 亲密 = self.孩子参战.亲密,
                                孝心 = self.孩子参战.孝心 })
                    end
                end
                coroutine.xpcall(co, 战场:战斗开始())
            end
        )
        return coroutine.yield()
    elseif ggetype(v) == '角色' then --PVP
        local 类型 = ...
        if not v.是否战斗 and not v.是否观战 then
            coroutine.xpcall(
                function()
                    local 战场 = require('战斗/战场')()
                    --设置我方
                    if self.是否组队 then
                        for m, n in self:遍历队伍() do
                            n[类型] = true
                            if 类型 == 'PK' then
                                n.PK发起方 = true
                            else
                                n.PK发起方 = nil
                            end
                            local r = n:任务_获取("夺命香")
                            if r then
                                r:删除()
                            end
                            战场:加入我方(m, n)
                            if n.参战召唤 then
                                if n.参战召唤:取是否可参战() then
                                    战场:加入我方(m + 5, n.参战召唤)
                                end
                            end
                            if n.孩子参战 then
                                local 外形 = 400
                                if n.孩子参战.性别 == '女' then
                                    外形 = 420
                                end
                                战场:加入我方(m + 20,
                                    { 名称 = n.孩子参战.名称, 外形 = 外形, 天资 = n.孩子参战.天资,
                                        速度 = 99999, 评价 = n.孩子参战.评价, 亲密 = n.孩子参战.亲密,
                                        孝心 = n.孩子参战.孝心 })
                            end
                        end
                    else
                        self[类型] = true
                        if 类型 == 'PK' then
                            self.PK发起方 = true
                        else
                            self.PK发起方 = nil
                        end
                        local r = self:任务_获取("夺命香")
                        if r then
                            r:删除()
                        end
                        战场:加入我方(1, self)
                        if self.参战召唤 then
                            if self.参战召唤:取是否可参战() then
                                战场:加入我方(1 + 5, self.参战召唤)
                            end
                        end
                        if self.孩子参战 then
                            local 外形 = 400
                            if self.孩子参战.性别 == '女' then
                                外形 = 420
                            end
                            战场:加入我方(21,
                                { 名称 = self.孩子参战.名称, 外形 = 外形, 天资 = self.孩子参战.天资,
                                    速度 = 99999, 评价 = self.孩子参战.评价, 亲密 = self.孩子参战.亲密,
                                    孝心 = self.孩子参战.孝心 })
                        end
                    end
                    --设置敌方
                    local 玩家 = v
                    if 玩家.是否组队 then
                        for j, k in 玩家:遍历队伍() do
                            if 类型 == 'PK' then
                                k.rpc:提示窗口("#R请注意,你已进入强制PK战斗！")
                            end
                            k[类型] = true
                            战场:加入敌方(j, k)
                            if k.参战召唤 then
                                if k.参战召唤:取是否可参战() then
                                    战场:加入敌方(j + 5, k.参战召唤)
                                end
                            end
                            if k.孩子参战 then
                                local 外形 = 400
                                if k.孩子参战.性别 == '女' then
                                    外形 = 420
                                end
                                战场:加入敌方(j + 20,
                                    { 名称 = k.孩子参战.名称, 外形 = 外形, 天资 = k.孩子参战.天资,
                                        速度 = 99999, 评价 = k.孩子参战.评价, 亲密 = k.孩子参战.亲密,
                                        孝心 = k.孩子参战.孝心 })
                            end
                        end
                    else
                        战场:加入敌方(1, 玩家)
                        玩家[类型] = true
                        if 类型 == 'PK' then
                            玩家.rpc:提示窗口("#R请注意,你已进入强制PK战斗！")
                        end
                        if 玩家.参战召唤 then
                            if 玩家.参战召唤:取是否可参战() then
                                战场:加入敌方(1 + 5, 玩家.参战召唤)
                            end
                        end
                        if 玩家.孩子参战 then
                            local 外形 = 400
                            if 玩家.孩子参战.性别 == '女' then
                                外形 = 420
                            end
                            战场:加入敌方(21,
                                { 名称 = 玩家.孩子参战.名称, 外形 = 外形, 天资 = 玩家.孩子参战.天资,
                                    速度 = 99999, 评价 = 玩家.孩子参战.评价, 亲密 = 玩家.孩子参战.亲密,
                                    孝心 = 玩家.孩子参战.孝心 })
                        end
                    end
                    战场:战斗开始()
                end
            )
        elseif not v.是否观战 then
            coroutine.xpcall(
                function()
                    local 玩家 = v
                    table.insert(玩家.战斗.战场._观战表, self)
                    local data = 玩家.战斗.战场:取数据(玩家.战斗.位置)
                    self.是否观战 = true
                    self.战斗 = 玩家.战斗
                    self.rpn:添加状态(self.nid, 'vs') --周围
                    self.rpc:进入战斗(data, 玩家.战斗.位置, 玩家.战斗.战场.回合数, self.是否观战)
                end
            )
        elseif v.是否观战 then
            coroutine.xpcall(
                function()
                    self.rpc:提示窗口("#Y玩家正在观战！")
                end
            )
        end
    end
end

function 角色:战斗_开始(对象)
    self.战斗前召唤 = self.参战召唤
    self.是否战斗 = true
    self.rpn:添加状态(self.nid, 'vs') --周围
    self.战斗 = 对象
    self.战斗.自动 = self.战斗自动
    self.战斗.菜单指令 = self.战斗指令 or '物理'
    self.战斗.菜单目标 = self.战斗目标 or 11
    self.战斗.选择 = self.选择

    if self.上一场位置 and self.战斗.位置 then
        if self.上一场位置 < 6 and self.战斗.位置 > 5 or self.上一场位置 > 5 and self.战斗.位置 < 6 then
            if self.战斗.菜单目标 > 10 then
                self.战斗.菜单目标 = self.战斗.菜单目标 - 10
            elseif self.战斗.菜单目标 < 10 then
                self.战斗.菜单目标 = self.战斗.菜单目标 + 10
            end
        end
    end

    if self.是否机器人 then
        self.活跃时间 = os.time()
    end
end

function 角色:战斗_结束(助战)
    if self.是否战斗 then
        self.是否战斗 = false

        self.上一场位置 = self.战斗.位置

        self.战斗自动 = self.战斗.自动
        self.战斗指令 = self.战斗.菜单指令
        self.战斗目标 = self.战斗.菜单目标
        self.选择 = self.战斗.选择

        self.战斗召唤指令 = self.战斗.战斗召唤指令
        self.战斗召唤目标 = self.战斗.战斗召唤目标
        self.战斗召唤选择 = self.战斗.战斗召唤选择

        self.rpn:删除状态(self.nid, 'vs') --周围
        if not self.是否助战 then
            self.气血 = self.战斗.气血
            self.魔法 = self.战斗.魔法
        end
        if self.水陆 then
            if self.战斗.是否死亡 then
                __世界:水陆奖励(self.nid, true)
            else
                __世界:水陆奖励(self.nid, false)
            end
        end

        if not self.水陆 or not self.帮战 then
            if self.战斗.是否死亡 or self.战斗.是否逃跑 or self.是否掉线 then
                -- self:角色_离开队伍()
                if self.是否掉线 then
                    self:下线()
                end
            end
        end

        --战斗
        -- if __副本地图[self.当前地图.接口.id] and self.当前地图.接口.名称 == '比武场' then
        --     local map = __地图[1001]
        --     if map then
        --         local x = math.floor(350 * 20)
        --         local y = math.floor((map.高度 - 48) * 20)
        --         self:移动_切换地图(map, x, y)
        --     end

        --     if (self.战斗.是否死亡 or self.战斗.是否逃跑 or self.是否掉线) and self.当前地图.接口.名称 == '比武场' then
        --         local map = __地图[1001]
        --         if map then
        --             local x = math.floor(350 * 20)
        --             local y = math.floor((map.高度 - 48) * 20)
        --             self:移动_切换地图(map, x, y)
        --         end
        --     end
            -- if self.是否组队 then
            --     if self.是否队长 then
            --         if self.帮派 and __帮派[self.帮派] and __帮派[self.帮派].帮战体力 then
            --             __帮派[self.帮派].帮战体力 = __帮派[self.帮派].帮战体力 - 10
            --             if __帮派[self.帮派].帮战体力 <= 0 then
            --                 __帮派[self.帮派].帮战结束 = true
            --                 __帮派[self.帮派].帮战次数 = __帮派[self.帮派].帮战次数 + 1
            --                 __帮派[self.帮派].帮战失败 = __帮派[self.帮派].帮战失败 + 1
            --                 local 敌方 = 0
            --                 for i = 1, #__帮战 do
            --                     if __帮战[i][1] == self.帮派 then
            --                         敌方 = __帮战[i][2]
            --                     end
            --                     if __帮战[i][2] == self.帮派 then
            --                         敌方 = __帮战[i][1]
            --                     end
            --                 end
            --                 if __帮派[敌方] then
            --                     __帮派[敌方].胜负 = true
            --                     __帮派[self.帮派].胜负 = false
            --                     self:帮战结束处理(__帮派[self.帮派], __帮派[敌方])
            --                 end
            --             end
            --         end
            --     end
            -- end
        if self.帮战 then
            if self.战斗.是否死亡 then--只处理失败方
                --普通处理,掉体力
                __帮派[self.帮派].帮战体力 = __帮派[self.帮派].帮战体力 - 10
                --体力清零计算胜负
                if __帮派[self.帮派].帮战体力 <= 0 then
                    __帮派[self.帮派].帮战结束 = true
                    __帮派[self.帮派].帮战次数 = __帮派[self.帮派].帮战次数 + 1
                    __帮派[self.帮派].帮战失败 = __帮派[self.帮派].帮战失败 + 1
                    local 敌方 = 0
                    for i = 1, #__帮战 do
                        if __帮战[i][1] == self.帮派 then
                            敌方 = __帮战[i][2]
                        end
                        if __帮战[i][2] == self.帮派 then
                            敌方 = __帮战[i][1]
                        end
                    end
                    if __帮派[敌方] then
                        __帮派[敌方].帮战结束 = true
                        __帮派[敌方].帮战次数 = __帮派[敌方].帮战次数 + 1
                        __帮派[敌方].胜负 = true
                        __帮派[self.帮派].胜负 = false
                        self:帮战结束处理(__帮派[self.帮派], __帮派[敌方])
                    end
                end
            end
        else
            if self.战斗.是否死亡 then
                if self.水陆 then
                    self.气血 = self.最大气血
                    self.魔法 = self.最大魔法
                else
                    self.气血 = math.floor(self.最大气血 * 0.1)
                    self.魔法 = math.floor(self.最大魔法 * 0.1)
                    if self.战斗.战场.是否惩罚 or self.PK then
                        local map = __地图[1125]
                        self:移动_切换地图(map, 800, 800)
                        self.经验 = self.经验 - math.floor(self.经验 * 0.2)
                    end
                end
            end
        end
        self.水陆 = nil
        self.帮战 = nil
        self.PK = nil
        self.切磋 = nil
        self.PK发起方 = nil

        self.task:玩家战斗结束(self.接口, self.战斗.战场.脚本)

        local 战场召唤 = self.参战召唤
        self.参战召唤 = self.战斗前召唤

        if self.锁召唤 then
            self.战斗前召唤:召唤_参战(true)
        elseif 战场召唤 and 战场召唤 ~= self.战斗前召唤 then
            战场召唤:召唤_参战(true)
        end

        if self.是否机器人 then
            self.气血 = self.最大气血
            self.魔法 = self.最大魔法
            self.活跃时间 = os.time()
        end
        self:刷新属性()
        if self.参战召唤 ~= nil then
            if not self.是否助战 then
                self.rpc:置召唤气血(self.参战召唤.气血, self.参战召唤.最大气血)
                self.rpc:置召唤魔法(self.参战召唤.魔法, self.参战召唤.最大魔法)
                self.rpc:置召唤经验(self.参战召唤.经验, self.参战召唤.最大经验)
                self.rpc:置召唤忠诚(self.参战召唤.忠诚, 100)
            end
        end
        self.战斗 = nil
    end
end
-- end

-- function 角色:帮战结束处理(败, 胜)
--     if 败 then
--         for k, v in pairs(败.成员列表) do
--             local 经验奖励 = 1
--             local 帮派贡献 = 1
--             if __玩家[k] and __玩家[k].称谓 == 败.名称 .. '成员' then
--                 __玩家[k].接口:添加任务经验(经验奖励)
--                 __玩家[k].接口:添加成就(帮派贡献)
--                 __玩家[k].接口:常规提示('#Y帮战已结束,你们输了')
--             end
--             if __玩家[k] then
--                 if __副本地图[__玩家[k].当前地图.接口.id] and __玩家[k].当前地图.接口.名称 == '比武场' then
--                     local map = __地图[1001]
--                     if map then
--                         local x = math.floor(350 * 20)
--                         local y = math.floor((map.高度 - 48) * 20)
--                         __玩家[k]:移动_切换地图(map, x, y)
--                     end
--                 end
--             end
--         end
--     end
--     if 胜 then
--         for k, v in pairs(胜.成员列表) do
--             local 经验奖励 = 1
--             local 帮派贡献 = 1
--             local 物品奖励 = {
--                 sun = 0,
--                 广播 = '',
--                 物品配置 = {
--                     { 道具 = '补天神石', 几率 = 0.2, 数量 = 1, 是否广播 = 1, 等级限制 = 10 },
--                     { 道具 = '补天神石', 几率 = 0.2, 数量 = 1, 是否广播 = 1, 等级限制 = 10 },
--                     { 道具 = '补天神石', 几率 = 0.2, 数量 = 1, 是否广播 = 1, 等级限制 = 10 },
--                     { 道具 = '补天神石', 几率 = 0.2, 数量 = 1, 是否广播 = 1, 等级限制 = 10 },
--                     { 道具 = '补天神石', 几率 = 0.2, 数量 = 1, 是否广播 = 1, 等级限制 = 10 },
--                 }
--             } --这里抄一个奖励池的表
--             if __玩家[k] and __玩家[k].称谓 == 胜.名称 .. '成员' then
--                 __玩家[k].接口:添加任务经验(经验奖励)
--                 __玩家[k].接口:添加成就(帮派贡献)
--                 __玩家[k].接口:常规提示('#Y帮战已结束,你们赢了')
--                 local 奖励表 = 物品奖励
--                 local 总概率 = 奖励表.sun --总概率
--                 local 随机数 = math.random() --是否可以获得道具随机数
--                 local 奖励配置 = {}
--                 if 总概率 >= 随机数 then --如果总概率大于获得的随机数必定获得道具
--                     local 目标权重 = math.random(0, math.floor(总概率 * 10000)) / 10000 --获取一个随机小数
--                     local 当前权重 = 0 --初始化获得道具概率
--                     for i = 1, #奖励表.物品配置 do
--                         for k, v in pairs(奖励表.物品配置[i]) do --遍历掉落表
--                             if k == '几率' then
--                                 当前权重 = 当前权重 + v --概率重新赋值,概率=概率+随机一项概率的值
--                                 if 当前权重 >= 目标权重 then --如果道具概率大于等于随机数则返回对应掉落信息
--                                     local 道具 = 奖励表.物品配置[i]
--                                     奖励配置 = { 道具信息 = 道具, 广播 = 奖励表.广播 }
--                                 end
--                             end
--                         end
--                     end
--                 end
--                 if 奖励配置.道具信息 then
--                     local r = __沙盒.生成物品 { 名称 = 奖励配置.道具信息.道具, 数量 = 奖励配置.道具信息
--                     .数量, 参数 = 奖励配置.道具信息.参数 }
--                     if r then
--                         __玩家[k].接口:添加物品({ r })
--                         if 奖励配置.道具信息.是否广播 == 1 and 奖励配置.广播 ~= nil then
--                             __玩家[k].接口:发送系统(奖励配置.广播, __玩家[k].名称, r.ind, r.名称)
--                         end
--                     end
--                 end
--             end
--             if __玩家[k] then
--                 if __副本地图[__玩家[k].当前地图.接口.id] and __玩家[k].当前地图.接口.名称 == '比武场' then
--                     local map = __地图[1001]
--                     if map then
--                         local x = math.floor(350 * 20)
--                         local y = math.floor((map.高度 - 48) * 20)
--                         __玩家[k]:移动_切换地图(map, x, y)
--                     end
--                 end
--             end
--         end
--     end
--     __世界:发送系统('#R' .. 胜.名称 .. '战胜了' .. 败.名称 .. '')
--     胜.帮战地图 = nil
--     胜.帮战体力 = 0
--     败.帮战地图 = nil
--     败.帮战体力 = 0
-- end
function 角色:帮战结束处理(败, 胜)
    if 败 then
        for k, v in pairs(败.成员列表) do
            local 经验奖励 = 1500000
            local 帮派贡献 = 2500
            local 仙玉奖励 = 50
            if __玩家[k] and __玩家[k].称谓 == 败.名称 .. '成员' then
                __玩家[k].接口:添加任务经验(经验奖励)
                __玩家[k].接口:添加成就(帮派贡献)
                __玩家[k].接口:添加仙玉(仙玉奖励)
                __玩家[k].接口:常规提示('#Y帮战已结束,你们输了')
            end
            if __玩家[k] then
                if __副本地图[__玩家[k].当前地图.接口.id] and __玩家[k].当前地图.接口.名称 == '比武场' then
                    local map = __地图[1001]
                    if map then
                        local x = math.floor(350 * 20)
                        local y = math.floor((map.高度 - 48) * 20)
                        __玩家[k]:移动_切换地图(map, x, y)
                    end
                end
            end
        end
    end
    if 胜 then
        for k, v in pairs(胜.成员列表) do
            local 经验奖励 = 300000
            local 帮派贡献 = 5000
            local 仙玉奖励 = 1000
            local 物品奖励 = {
                sun = 0,
                广播 = '',
                物品配置 = {
                    { 道具 = '补天神石', 几率 = 0.2, 数量 = 1, 是否广播 = 1, 等级限制 = 10 },
                    { 道具 = '补天神石', 几率 = 0.2, 数量 = 1, 是否广播 = 1, 等级限制 = 10 },
                    { 道具 = '补天神石', 几率 = 0.2, 数量 = 1, 是否广播 = 1, 等级限制 = 10 },
                    { 道具 = '补天神石', 几率 = 0.2, 数量 = 1, 是否广播 = 1, 等级限制 = 10 },
                    { 道具 = '补天神石', 几率 = 0.2, 数量 = 1, 是否广播 = 1, 等级限制 = 10 },
                }
            } --这里抄一个奖励池的表
            if __玩家[k] and __玩家[k].称谓 == 胜.名称 .. '成员' then
                __玩家[k].接口:添加任务经验(经验奖励)
                __玩家[k].接口:添加成就(帮派贡献)
                __玩家[k].接口:添加仙玉(仙玉奖励)
                __玩家[k].接口:常规提示('#Y帮战已结束,你们赢了')
                local 奖励表 = 物品奖励
                local 总概率 = 奖励表.sun --总概率
                local 随机数 = math.random() --是否可以获得道具随机数
                local 奖励配置 = {}
                if 总概率 >= 随机数 then --如果总概率大于获得的随机数必定获得道具
                    local 目标权重 = math.random(0, math.floor(总概率 * 10000)) / 10000 --获取一个随机小数
                    local 当前权重 = 0 --初始化获得道具概率
                    for i = 1, #奖励表.物品配置 do
                        for k, v in pairs(奖励表.物品配置[i]) do --遍历掉落表
                            if k == '几率' then
                                当前权重 = 当前权重 + v --概率重新赋值,概率=概率+随机一项概率的值
                                if 当前权重 >= 目标权重 then --如果道具概率大于等于随机数则返回对应掉落信息
                                    local 道具 = 奖励表.物品配置[i]
                                    奖励配置 = { 道具信息 = 道具, 广播 = 奖励表.广播 }
                                end
                            end
                        end
                    end
                end
                if 奖励配置.道具信息 then
                    local r = __沙盒.生成物品 { 名称 = 奖励配置.道具信息.道具, 数量 = 奖励配置.道具信息
                    .数量, 参数 = 奖励配置.道具信息.参数 }
                    if r then
                        __玩家[k].接口:添加物品({ r })
                        if 奖励配置.道具信息.是否广播 == 1 and 奖励配置.广播 ~= nil then
                            __玩家[k].接口:发送系统(奖励配置.广播, __玩家[k].名称, r.ind, r.名称)
                        end
                    end
                end
            end
            if __玩家[k] then
                if __副本地图[__玩家[k].当前地图.接口.id] and __玩家[k].当前地图.接口.名称 == '比武场' then
                    local map = __地图[1001]
                    if map then
                        local x = math.floor(350 * 20)
                        local y = math.floor((map.高度 - 48) * 20)
                        __玩家[k]:移动_切换地图(map, x, y)
                    end
                end
            end
        end
    end
    __世界:发送系统('#R' .. 胜.名称 .. '战胜了' .. 败.名称 .. '')
    胜.帮战地图 = nil
    胜.帮战体力 = 0
    败.帮战地图 = nil
    败.帮战体力 = 0
end

function 角色:战斗_重连()
    if self.是否战斗 then
        local data = self.战斗.战场:取数据(self.战斗.位置)
        self.rpc:进入战斗(data, self.战斗.位置, self.战斗.战场.回合数)

        if self.战斗.掉线等待 then
            self.战斗:自动战斗(false)
            coroutine.xpcall(self.战斗.掉线等待)
        else
            self.战斗:自动战斗(true)
        end
    end
end

function 角色:角色_战斗自动(b)
    if self.是否战斗 then
        if self.是否组队 then
            for i,p in self:遍历队伍() do
                if p.nid ~= self.nid and p.离线角色 then
                    p.战斗:自动战斗(b)
                    p.自动=b
                end
            end
        end
        return self.战斗:自动战斗(b)
    elseif b then

    else
        if self.是否组队 then
            for i,p in self:遍历队伍() do
                if p.nid ~= self.nid and p.离线角色 then
                    p.战斗自动 = false
                    p.自动=false
                end
            end
        end
        self.战斗自动 = false
    end
end

function 角色:角色_退出观战(b)
    if self.是否观战 then
        self.rpc:退出战斗()
        self.是否观战 = false
        self.rpn:删除状态(self.nid, 'vs') --周围
        for i, v in pairs(self.战斗.战场._观战表) do
            if v.nid == self.nid then
                self.战斗.战场._观战表[i] = nil
            end
        end
        self.战斗 = nil
    end
end

function 角色:角色_卡战斗退出(b)
    if self.是否战斗 then
        self.战斗:脱离战斗()
    end
end

function 角色:角色_战斗技能列表(nid)
    if self.是否战斗 then
        if nid and self.是否组队 then
            for i,p in self:遍历队伍() do
                if p.nid == nid then
                    local list = {}
                    local 遗忘列表 = {}
                    if p.战斗.BUFF列表.遗忘 then
                        遗忘列表 = p.战斗.BUFF列表.遗忘.遗忘
                    end
                    local 计数 = 0
                    for _, v in pairs(p.战斗.法术列表) do
                        if v.是否主动 then --主动
                            计数 = 计数 + 1
                            table.insert(list, {
                                nid = v.nid,
                                名称 = v.名称,
                                熟练度 = v.熟练度,
                                消耗 = v:法术取消耗(),
                                遗忘 = false,
                                技能描述 = p:角色_战斗技能描述(nid)
                            })
                            if 遗忘列表[v.名称] then
                                list[计数].遗忘 = true
                            end
                        end
                    end
                    return list, p.战斗.魔法, p.战斗.气血, p.战斗.怨气
                end
            end
        else
            local list = {}
            local 遗忘列表 = {}
            if self.战斗.BUFF列表.遗忘 then
                遗忘列表 = self.战斗.BUFF列表.遗忘.遗忘
            end
            local 计数 = 0
            for _, v in pairs(self.战斗.法术列表) do
                if v.是否主动 then --主动
                    计数 = 计数 + 1
                    table.insert(list, {
                        nid = v.nid,
                        名称 = v.名称,
                        熟练度 = v.熟练度,
                        消耗 = v:法术取消耗(),
                        遗忘 = false,
                        技能描述 = self:角色_战斗技能描述(v.nid)
                    })
                    if 遗忘列表[v.名称] then
                        list[计数].遗忘 = true
                    end
                end
            end
            return list, self.战斗.魔法, self.战斗.气血, self.战斗.怨气
        end
    end
end

function 角色:角色_战斗技能描述(nid)
    if self.是否战斗 then
        local 法术 = self.战斗.法术列表[nid]
        if 法术 then
            return 法术:法术取描述(self.战斗.等级)
        end
    end
end

function 角色:角色_战斗召唤列表(nid)
    if nid then
        for i,p in self:遍历队伍() do
            if p.nid == nid then
                local r = {}
                for k, v in p:遍历召唤() do
                    table.insert(
                        r,
                        {
                            nid = v.nid,
                            名称 = v.名称,
                            外形 = v.外形,
                            原形 = v.原形,
                            已上场 = v.战斗已上场,
                            顺序 = v.顺序
                        }
                    )
                end
                return r
            end
        end
        local r = {}
        for k, v in self:遍历召唤() do
            table.insert(
                r,
                {
                    nid = v.nid,
                    名称 = v.名称,
                    外形 = v.外形,
                    原形 = v.原形,
                    已上场 = v.战斗已上场,
                    顺序 = v.顺序
                }
            )
        end
        return r
    else
        local r = {}
        for k, v in self:遍历召唤() do
            table.insert(
                r,
                {
                    nid = v.nid,
                    名称 = v.名称,
                    外形 = v.外形,
                    原形 = v.原形,
                    已上场 = v.战斗已上场,
                    顺序 = v.顺序
                }
            )
        end
        return r
    end
end
