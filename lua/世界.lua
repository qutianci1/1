-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-08 11:52:28
-- @Last Modified time  : 2024-08-20 20:35:53

__时辰 = 1
local 世界 = require('GOL')("GAME")
引擎 = 世界
--'逻辑服务'
function 世界:初始化()
    self.rpc =
    setmetatable(
        {},
        {
            __index = function(_, k)
                return function(_, ...)
                    local arg = { ... }
                    local list = {}
                    for k, v in self:遍历玩家() do
                        list[k] = v
                    end
                    coroutine.xpcall(
                        function()
                            local n = 0
                            for _, v in pairs(list) do
                                if v.离线角色 == nil then
                                    v.rpc[k](nil, table.unpack(arg))
                                end
                                n = n + 1
                                 -- if n % 10 == 0 then --发送50个玩家，停一下
                                 --     self:定时(100)
                                 -- end
                            end
                        end
                    )
                end
            end
        }
    )
    self._定时按秒 = self:定时(--按秒
        500, --各种事件的更新时间
        function(ms)
            if not __rpc then
                return
            end
            self:更新按秒(os.time())
            return ms
        end
    )

    self._定时时辰 = self:定时(--时辰
        100000,
        function(ms)
            if not __rpc then
                return
            end
            __时辰 = __时辰 + 1
            if __时辰 > 12 then
                __时辰 = 1
            end
            -- if __时辰 == 5 then
            --     self:发送系统('现在开始天亮了')
            -- elseif __时辰 == 11 then
            --     self:发送系统('现在开始天黑了')
            -- end

            for id, v in self:遍历玩家() do
                v:时辰刷新(__时辰)
            end
            self.rpc:界面信息_时辰(__时辰)
            return ms
        end
    )

     self._定时五分 = self:定时(--60分钟
          30 * 60 * 1000, --60*60*1000
          function(ms)
             self:全局存档()
             return ms
          end
      )
     self.玩家 = getmetatable(__玩家).__index --名称索引
end   ---纯手动存档就注释这块

function 世界:全局存档()
    coroutine.xpcall(
        function()
            print('开始存档',os.clock()*1000)
            local ks = 0
            for _, v in pairs(__玩家) do
                v:存档()
                self:定时(
                    0.09  * 6 * 1000,
                    v:存档()
                )
                if next(__玩家,_) == nil then
                    print("玩家存档定时结束")
                    self:定时(
                        0.9  * 60 * 1000,
                        function ()
                           local list = {}
                            for k, v in pairs(__垃圾) do
                                if v.rid == -1 then
                                    list[k] = { 表名 = ggetype(v), nid = v.nid }
                                end
                            end
                            __垃圾 = {}
                            __存档.删除垃圾(list)
                            print("垃圾删除结束")
                        end
                    )
                end
            end
            list = {}
            for _, v in pairs(__帮派) do
                list[v.nid] = v:取存档数据()
            end
            __存档.帮派写入(list)
            __存档.写仙玉()
            世界:print('存档', os.date())
            local MYF = require('我的函数')
            MYF.写出txt('daily.txt',__活动限制)
            MYF.写出txt('Record.txt',__外置数据)
            print('每日数据已存档',os.clock()*1000)
        end
    )
end

local call_count = 0

function 世界:更新按秒(sec)
    call_count = call_count + 1
    for i, v in pairs(__玩家) do
        v:更新(sec)
    end

    for _, v in pairs(__地图) do
        v:更新(sec)
    end
    for k, v in pairs(__战场) do
        v:更新(sec)
    end
    if call_count % 2 == 1 then
        local weekday = tonumber(os.date('%w', os.time()))--星期
        local hour = tonumber(os.date('%H', os.time()))--小时
        local minute = tonumber(os.date('%M', os.time()))--分
        local second = tonumber(os.date('%S', os.time()))--秒
        for k, v in pairs(__事件) do
            if k == '任务NPC_王五' then
                if v.是否打开 and not v._是否开始 then
                    v._是否开始 = true
                    ggexpcall(v.更新, v)
                end
            end
            if second == 0 then
                if k == '地煞星' or k == '师门弟子' then
                    if minute % 15 == 0 then
                        if v.是否打开 then
                            ggexpcall(v.更新, v)
                        end
                    end
                elseif  k == '高级地煞星'then
                    if minute == 0 then
                        if v.是否打开 then
                            ggexpcall(v.更新, v)
                        end
                    end
                end
                if k == "世界答题" then
                    if v.是否打开 then
                        ggexpcall(v.更新, v)
                    end
                end
                if minute == 0 then
                    if weekday == 1 and k == '夺镖任务' then
                        if v.是否打开 then
                            ggexpcall(v.更新, v)
                        end
                    elseif weekday == 2 and k == '天元盛典_万仙方阵' then
                        if v.是否打开 then
                            ggexpcall(v.更新, v)
                        end
                    elseif weekday == 3 then
                        if k == '花灯报吉_灯灵' or k == '花灯报吉_天官' then
                            if v.是否打开 then
                                ggexpcall(v.更新, v)
                            end
                        end
                    elseif weekday == 4 then
                        if k == '城东保卫战' then
                            if v.是否打开 then
                                ggexpcall(v.更新, v)
                            end
                        end
                        if hour / 2 == math.floor(hour / 2) then
                            if k == '城东BOSS' then
                                if v.是否打开 then
                                    ggexpcall(v.更新, v)
                                end
                            end
                        end
                    elseif weekday == 5 and k == '梨园庙会' then
                        if v.是否打开 then
                            ggexpcall(v.更新, v)
                        end
                    -- elseif weekday == 6 and k == '东海龙王' then
                    --     if v.是否打开 then
                    --         ggexpcall(v.更新, v)
                    --     end
                    end
                end
            end
        end
        --凌晨刷新次数
        local currentTimestamp = os.time()
        local currentTime = os.date("*t", currentTimestamp)
        if currentTime.hour == 0 and currentTime.min == 0 and currentTime.sec == 0 then
            __活动限制 = {}
            _宠物蛋奖励 = require('数据库/宠物蛋奖励库')
            _地图在线奖励 = require('数据库/地图在线奖励') --重启
            -- for k,v in pairs(__外置数据) do
            --     if __配置.递增规则[k] then
            --         v = v - __配置.递增规则[k][3]--每日凌晨回落价格
            --         if v < __配置.递增规则[k][4] then
            --             v = __配置.递增规则[k][4]
            --         end
            --     end
            -- end
        end
        --水陆相关操作
            --将所有入场的玩家,加入__水陆大会全局变量中,并设置状态为false,玩家点击准备后修改为true,在匹配对手时只会在状态为true的玩家中筛选,状态为false的玩家直接判负
        -- if weekday == 1 or weekday == 2 or weekday == 3 or weekday == 4 or  weekday == 0 then
        --     if hour <= 19 and minute == 0 and second == 0 then
        --         __世界:发送系统('#Y唐王有令,今日晚将举办水陆大会,还没有报名的玩家,可以去皇宫魏征处报名参赛,无论胜负皆有丰厚奖励!!!')
        --     end
        --     if hour == 19 and minute == 45 and second == 0 then
        --         __世界:发送系统('#Y水陆大会已开启入场,所有报名的玩家,请务必在7点59分之前入场!')
        --     end
        --     if hour == 20 and minute == 0 and second == 0 then
        --         for k,v in pairs(__水陆数据) do
        --             if __玩家[k] then
        --                 if __玩家[k] then
        --                     if __玩家[k].当前地图.接口.id == 1197 then
        --                         __水陆大会[k] = {状态 = false, 战斗 = 0}
        --                     end
        --                 end
        --             end
        --         end
        --     elseif hour == 20 and minute == 05 and second == 00 then--8:05:00开启第一轮匹配
        --         self:筛选选手组()
        --     end
        --     if hour >= 20 and hour < 23 then
        --         if __水陆匹配.状态 == '匹配' then
        --             self:水陆匹配战斗()
        --         elseif __水陆匹配.状态 == '战斗中' then
        --             self:水陆刷新战斗状态()
        --         elseif __水陆匹配.状态 == '等待中' then
        --             if os.time() - __水陆匹配.计时 >= 0 then
        --                 __水陆匹配.状态 = '筛选'
        --             end
        --         elseif __水陆匹配.状态 == '筛选' then
        --             self:筛选选手组()
        --         end
        --     end
        -- end

        if weekday == 1 or weekday == 2 or weekday == 3 or weekday == 4 or weekday == 5 or weekday == 6 or  weekday == 0 then--星期5 6 日 关闭帮战
            local 取消帮战 = false
            if hour == 19 and minute == 30 and second == 0 then--19:30:00
                --统计帮派
                local list = {}
                for k,v in pairs(__帮派) do
                    table.insert(list, {名称 = k , 威望 = v.威望值})
                end
                if #list == 1 then
                    取消帮战 = true
                end
                if 取消帮战 then
                    __世界:发送系统('#Y由于帮派数量不足2,本日帮战活动取消')
                else
                    __世界:发送系统('#Y帮战进场时间,没进的速度#32')
                    table.sort(list, function(a, b) return a.威望 > b.威望 end)
                    local 对战组 = {}
                    local 对战双方 = {}
                    for i, v in ipairs(list) do
                        table.insert(对战双方, v.名称)
                        if i % 2 == 0 then
                            table.insert(对战组, 对战双方)
                            对战双方 = {}
                        end
                    end
                    __帮战 = 对战组
                    __世界:发送系统('#Y本日对战帮派如下:')
                    for i=1,#__帮战 do
                        __世界:发送系统('#Y'..__帮战[i][1]..'VS'..__帮战[i][2]..'')
                    end
                    for i=1,#__帮战 do
                        local 帮战地图 = __沙盒.生成地图(1197)
                        帮战地图:添加NPC {
                            名称 = "离场传送人",
                            外形 = 3011,
                            脚本 = 'scripts/npc/帮战/离场传送人.lua',
                            X = 143,
                            Y = 16}

                        帮战地图:添加NPC {
                            名称 = __帮战[i][1].."守护神",
                            外形 = 3011,
                            脚本 = 'scripts/npc/帮战/NPC1.lua',
                            X = 72,
                            Y = 60,
                            帮派 = __帮派[__帮战[i][1]]}
                        帮战地图:添加NPC {
                            名称 = __帮战[i][2].."守护神",
                            外形 = 3011,
                            脚本 = 'scripts/npc/帮战/NPC2.lua',
                            X = 63,
                            Y = 56,
                            帮派 = __帮派[__帮战[i][2]]}
                        for n=1,#__帮战[i] do
                            __帮派[__帮战[i][n]].帮战地图 = 帮战地图
                            __帮派[__帮战[i][n]].帮战体力 = 2000
                            __帮派[__帮战[i][n]].帮战结束 = false
                        end
                    end
                end
            end
            if hour == 21 and minute == 0 and second == 0 then
                -- table.print(__帮战)
                for i=1,#__帮战 do
                    local 帮派1,帮派2 = __帮战[i][1] , __帮战[i][2]

                    if not __帮派[帮派1].帮战结束 then--没有结束则按照体力判断
                        __帮派[帮派1].帮战结束 = true
                        __帮派[帮派2].帮战结束 = true
                        if __帮派[帮派1].帮战体力 > __帮派[帮派2].帮战体力 then
                            __帮派[帮派1].胜负 = true
                            __帮派[帮派2].胜负 = false
                            self:帮战结束处理(__帮派[帮派1],__帮派[帮派2])
                        elseif __帮派[帮派1].帮战体力 < __帮派[帮派2].帮战体力 then
                            __帮派[帮派2].胜负 = true
                            __帮派[帮派1].胜负 = false
                            self:帮战结束处理(__帮派[帮派2],__帮派[帮派1])
                        else
                            self:帮战平局处理(__帮派[帮派2],__帮派[帮派1])
                        end
                    end
                end
            end
        end
    end
end

-- function 世界:帮战结束处理(a,b)
--     print('帮战结束处理')
-- end
function 世界:帮战结束处理(败, 胜)
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

function 世界:帮战平局处理(败, 胜)--这里是平局,你自己看着奖励,胜 败都一样处理就完了
    if 败 then
        for k, v in pairs(败.成员列表) do
            local 经验奖励 = 200000
            local 帮派贡献 = 3000
            if __玩家[k] and __玩家[k].称谓 == 败.名称 .. '成员' then
                __玩家[k].接口:添加任务经验(经验奖励)
                __玩家[k].接口:添加成就(帮派贡献)
                __玩家[k].接口:常规提示('#Y帮战已结束,平局')
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
            local 经验奖励 = 200000
            local 帮派贡献 = 3000
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
                __玩家[k].接口:常规提示('#Y帮战已结束,平局')
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
    __世界:发送系统('#R' .. 胜.名称 .. '和' .. 败.名称 .. '的战斗结果以平局收场')
    胜.帮战地图 = nil
    胜.帮战体力 = 0
    败.帮战地图 = nil
    败.帮战体力 = 0
end

function 世界:水陆奖励(nid, 胜负)
    local 积分奖励 = 10
    local 经验奖励 = 1000000
    if not 胜负 then--失败时获得的积分和经验奖励
        积分奖励 = 5
        经验奖励 = 500000
    end
    local 玩家 = __玩家[nid]
    if 玩家 then
        if not 玩家.积分.水陆积分 then
            玩家.积分.水陆积分 = 0
        end
        玩家.积分.水陆积分 = 玩家.积分.水陆积分 + 积分奖励

        玩家.接口.添加经验(玩家, 经验奖励)
        local r = 玩家.接口.取参战召唤兽(玩家)
        if r then
            r:添加经验(经验奖励 * 1.5)
            r:添加内丹经验(经验奖励 * 1.5)
        end
        玩家:法宝_添加经验(经验奖励)
    end
end

function 世界:水陆刷新战斗状态()
    local 无战斗 = true
    for i=1,#__水陆匹配.选手组 do
        if __玩家[__水陆匹配.选手组[i][1]] then
            if __玩家[__水陆匹配.选手组[i][1]].是否战斗 then
                无战斗 = false
            end
        end
    end
    if 无战斗 then
        __水陆匹配.状态 = '等待中'
        __水陆匹配.计时 = os.time() + 300
        __世界:发送系统('#Y水陆督军:#W各位水陆大会参赛选手请注意,将于5分钟后开启下一轮匹配战斗,请注意挑战补给状态!')
    end
end

function 世界:水陆匹配战斗()
    for i=1,#__水陆匹配.选手组 do
        if __水陆匹配.选手组[i][1] ~= __水陆匹配.选手组[i][2] then
            --恢复默认状态
            __水陆大会[__水陆匹配.选手组[i][1]].状态 = false
            __水陆大会[__水陆匹配.选手组[i][2]].状态 = false
            --异常处理
            __水陆大会[__水陆匹配.选手组[i][1]].战斗 = __水陆大会[__水陆匹配.选手组[i][1]].战斗 + 1
            __水陆大会[__水陆匹配.选手组[i][2]].战斗 = __水陆大会[__水陆匹配.选手组[i][2]].战斗 + 1
            if not __玩家[__水陆匹配.选手组[i][1]] then--如果选手一不在线
                if __玩家[__水陆匹配.选手组[i][2]] then
                    __玩家[__水陆匹配.选手组[i][2]].rpc:提示窗口('由于你的对手不在线,你自动获得胜利!')
                    self:水陆奖励(__水陆匹配.选手组[i][2], true)
                    return
                else
                    return
                end
                return
            elseif not __玩家[__水陆匹配.选手组[i][2]] then
                if __玩家[__水陆匹配.选手组[i][1]] then
                    __玩家[__水陆匹配.选手组[i][1]].rpc:提示窗口('由于你的对手不在线,你自动获得胜利!')
                    self:水陆奖励(__水陆匹配.选手组[i][1], true)
                    return
                else
                    return
                end
                return
            end
            __玩家[__水陆匹配.选手组[i][1]]:水陆进入战斗(__水陆匹配.选手组[i][2])
        else
            __玩家[__水陆匹配.选手组[i][1]].rpc:提示窗口('你本轮轮空,自动获得胜利!')
            self:水陆奖励(__水陆匹配.选手组[i][1], true)
            __水陆大会[__水陆匹配.选手组[i][1]].战斗 = __水陆大会[__水陆匹配.选手组[i][1]].战斗 + 1
        end
    end
    __水陆匹配.状态 = '战斗中'
end

function 世界:筛选选手组()
    local 选手组 = {}
    --把所有符合条件的玩家加入选手组
    for k,v in pairs(__水陆大会) do--k=nid
        if v.状态 and v.战斗 < 3 then
            table.insert(选手组, k)
        end
    end
    if #选手组 == 0 then
        __水陆匹配.状态 = '结束'
        return
    end
    __水陆匹配.选手组 = {}
    --如果选手组人数大于2则开启随机匹配,将两名随机玩家 加入水陆匹配队列中
    while #选手组 >= 2 do
        local 随机 = math.random(1, #选手组)
        __水陆匹配.选手组[#__水陆匹配.选手组 + 1] = {}
        __水陆匹配.选手组[#__水陆匹配.选手组][1] = 选手组[随机]
        table.remove(选手组, 随机)
        随机 = math.random(1, #选手组)
        __水陆匹配.选手组[#__水陆匹配.选手组][2] = 选手组[随机]
        table.remove(选手组, 随机)
    end
    --如果剩余单个选手,则设置对手为自己,在开启战斗时直接胜出
    if #选手组 == 1 then
        __水陆匹配.选手组[#__水陆匹配.选手组 + 1] = {}
        __水陆匹配.选手组[#__水陆匹配.选手组][1] = 选手组[1]
        __水陆匹配.选手组[#__水陆匹配.选手组][2] = 选手组[1]
    end
    __水陆匹配.状态 = '匹配'
end

function 世界:添加玩家(P) --从数据新建玩家，但并没有链接
    if not __玩家[P.nid] then
        self.玩家[P.名称] = P
        self.玩家[P.id] = P
        __玩家[P.nid] = P
        if not P.是否机器人 then
            self:INFO('世界添加玩家:%s(%s)', P.名称, P.nid)
        else
            __机器人[P.nid] = P
        end
    end
    return P
end

function 世界:删除玩家(P)
    -- if self.是否摆摊 then
    --     return
    -- end
    if __玩家[P.nid] then
        self.玩家[P.名称] = nil
        self.玩家[P.id] = nil
        __玩家[P.nid] = nil
        if P.是否机器人 then
            __机器人[P.nid] = nil
        else
            self:INFO('世界删除玩家:%s(%s)', P.名称, P.nid)
        end
    end
end

function 世界:遍历玩家()
    return next, __玩家
end


function 世界:遍历帮派()
    return next, __帮派
end

function 世界:取玩家总数()
    local n = 0
    for _ in self:遍历玩家() do
        n = n + 1
    end
    return n
end

function 世界:是否白天()
    return __时辰 >= 5 and __时辰 <= 10
end

function 世界:发送世界(str, ...)
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    self.rpc:界面信息_聊天('#69 ' .. str)
end

function 世界:发送系统(str, ...)
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    self.rpc:界面信息_聊天('#71 ' .. str)
end

function 世界:发送信息(str, ...)
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    self.rpc:界面信息_聊天('#114 ' .. str)
end

世界:初始化()
return 世界
