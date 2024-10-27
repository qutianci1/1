-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-04-14 20:33:38
-- @Last Modified time  : 2024-08-23 22:43:40

local 任务 = {
    名称 = '日常_帮派任务',
    别名 = '帮派任务',
    类型 = '常规玩法'
}

function 任务:任务初始化()
end

local _详情 = {
    '帮中药材储量告急,去帮总管找#G%s#W来#46(当前第#R%s#W次，剩余#R%d#W分钟)',
    '在帮派内完成#G%s#W次清理杂草(当前第#R%s#W次，剩余#R%d#W分钟)',
    '帮里需要一批看门的召唤兽,你去给我抓一只#G%s#W来!(当前第#R%s#W次，剩余#R%d#W分钟)',--做的不错这是你的奖励

    '去长安,洛阳,傲来,长寿的#G%s#W打听一下酒价,看谁愿意接收订单(当前第#R%s#W次，剩余#R%d#W分钟)',--最近生意好差#8,酒价都降了几次了都卖不出去,如果你们帮要可以优惠些给你#56   给他订单    找错人了
    '去找#G%s#W拿回他欠我们帮的银子。(当前第#R%s#W次，剩余#R%d#W分钟)',--这么痛快就把银票给了,看来不能过手瘾了#77
    '帮里的人员名单被叛徒放到锦盒里准备送给斧头帮,被#G%s#W截获了,去把锦盒拿回来#51(当前第#R%s#W次，剩余#R%d#W分钟)',--既然你这个锦盒对你这么重要#23,那我会马上把锦盒送到你们帮里,你放心好了!

    '去#G%s#W解决骚扰路人的妖怪#54(当前第#R%s#W次，剩余#R%d#W分钟)',
    -- '听说今日有一武官#G%s#W时常欺压民众#78,你去找千里眼问问他所在何处,然后把他解决了吧(当前第#R%s#W次，剩余#R%d#W分钟)',
    '前往天宫寻找#G%s#W看他能不能找到武官确切的位置(当前第#R%s#W次，剩余#R%d#W分钟)',
    '近日帮内种植的灵植大规模枯萎,务必要找到#G%s#W,才可以救活灵植(当前第#R%s#W次，剩余#R%d#W分钟)',

    '由于你长期对帮派做出贡献，意外的收到了一条神秘任务#89(当前第#R%s#W次，剩余#R%d#W分钟)',

    '已查明武官位置,前往#G%s#W(当前第#R%s#W次，剩余#R%d#W分钟)',
    '已经把订单提交了,回去找#G%s#W交付任务吧(当前第#R%s#W次，剩余#R%d#W分钟)',
    '已收回了欠银,回去找#G%s#W交付任务吧(当前第#R%s#W次，剩余#R%d#W分钟)',
}

function 任务:任务取详情(玩家)
    -- if self.分类 == 6 then
    --     self.时间 = os.time() + 600
    -- end
    if self.分类 == 8 then
        if self.位置 ~= '千里眼' then
            return string.format(_详情[11], self.位置, 玩家.其它.帮派次数, (self.时间 - os.time()) // 60)
        end
    elseif self.分类 == 4 then
        if self.指定NPC == '帮派总管' then
            return string.format(_详情[12], self.位置, 玩家.其它.帮派次数, (self.时间 - os.time()) // 60)
        end
    elseif self.分类 == 5 then
        if self.位置 == '帮派总管' then
            return string.format(_详情[13], self.位置, 玩家.其它.帮派次数, (self.时间 - os.time()) // 60)
        end
    end
    return string.format(_详情[self.分类], self.位置, 玩家.其它.帮派次数, (self.时间 - os.time()) // 60)
end

function 任务:任务更新(sec)
    if self.时间 <=sec then
        self:删除()
    end
end

function 任务:任务取消(玩家)
    -- 玩家.其它.帮派次数 = 0
    玩家:删除指定物品('锄头')
    玩家:删除指定物品('订单')
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if NPC then
            map:删除NPC(self.NPC)
        end
    end
end

function 任务:任务上线(玩家)
    if self.时间 - os.time() <= 0 then
        self:删除()
        if self.NPC then
            self:任务取消(玩家)
        end
    end
end

local _寻物 = {'青灵草','血色茶花','千年寒冰'}
local _寻药 = {'灵芝','佛手','香叶','九转龙涎香','天龙水','鬼切草','羊脂仙露','旋复花','曼佗罗花','仙狐涎','白药','和合散','大还丹','黑玉断续膏','金创药','丹桂丸','归神散','风水混元丹','羚羊角','紫石英','百兽灵丸','定神香'}
local _寻宠 = {'夜叉','猪怪','小妖','牛妖'}
local _寻人 = {'药店老板','龙天兵','酒店老板'}
local _订单 = {'广源酒馆','三才酒馆','长寿酒馆','傲来国酒馆'}
local _暗雷 = {'龙窟三层','龙窟四层','凤巢三层','凤巢四层'}

function 任务:添加任务(玩家)
    玩家.其它.帮派次数 = 玩家.其它.帮派次数 + 1
    if 玩家.其它.帮派次数 > 10 then
        玩家.其它.帮派次数 = 1
    end
    玩家:添加任务(self)
    self.时间 = os.time() + 30 * 60
    if self.分类 == 1 then
        self.位置 = _寻药[math.random(#_寻药)]
    elseif self.分类 == 2 then
        self.位置 = 3
        玩家:添加物品({生成物品 {名称 = '锄头', 数量 = 1}})
    elseif self.分类 == 3 then
        self.位置 = _寻宠[math.random(#_寻宠)]
    elseif self.分类 == 4 then
        玩家:添加物品({生成物品 {名称 = '订单', 数量 = 1}})
        self.位置 = '酒店老板'
        self.指定NPC = _订单[math.random(#_订单)]
    elseif self.分类 == 5 then
        self.位置 = _寻人[math.random(#_寻人)]
    elseif self.分类 == 6 then
        self.位置 = '无名侠女'
    elseif self.分类 == 7 then
        self.位置 = _暗雷[math.random(#_暗雷)]
    elseif self.分类 == 8 then
        self.位置 = '千里眼'
    elseif self.分类 == 9 then
        self.位置 = _寻物[math.random(#_寻物)]
    end
    玩家:刷新追踪面板()
    return true
end

local _地图 = {1179,1180,1188,1189,1217,1473}
function 任务:生成怪物(玩家)
    local map = 玩家:取地图(_地图[math.random(#_地图)])
    if not map then
        return
    end
    self.怪名 = 取随机名称()
    local X, Y = map:取随机坐标()
    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)击杀武官%s', map.名称, X, Y, self.怪名)
    self.队伍 = {}
    self.NPC =
    map:添加NPC {
        队伍 = self.队伍,
        名称 = self.怪名,
        时长 = 1800,
        外形 = 2082,
        脚本 = 'scripts/task/日常/日常_帮派任务.lua',
        时间 = self.时间,
        X = X,
        Y = Y,
        来源 = self
    }
    self.MAP = map.id
    return {名称 = self.怪名, 地图 = map, 坐标={x=X,y=Y}}
end

function 任务:完成(玩家)
    local r = 玩家:取任务('日常_帮派任务')
    if r then
        if self.NPC then
            self:任务取消(玩家)
        end
        玩家:删除指定物品('帮派欠银')
        self:删除()
        玩家:刷新追踪面板()
        self:掉落包(玩家)
    end
end

function 任务:掉落包(玩家)
    local 银子 = math.floor(玩家.等级 * 120 + 玩家.其它.帮派次数 * 2000)
    local 经验 = math.floor((玩家.等级 * 1000 + 10000) * (1 + 玩家.其它.帮派次数 / 10) * 2)
    --100级为例,在不取消任务的情况下,1轮经验为620W   金钱23万
    local 掉落奖励 = true
    if 玩家:取活动限制次数('帮派任务') > 30 then
        经验 = 经验/2 银子 = 0
        掉落奖励 = false
    end

    if self.分类 == 10 then
        经验 = 经验 * 10
        银子 = 银子 * 10
        掉落奖励 = true
    end
    --锄草 20;寻药 25;召唤兽 30;订单 25;收债 30;无名 35;暗雷 35;武官 35;寻物 30
    -- 1-3次平均成就25点,4-5次平均成就27.5,6-10次平均成就26.5
    --26
    --30-70 一轮成就500-700点    24  44
    --70-100 一轮成就700-1000点  44  74
    --100-140 一轮成就1000-1400点 74  114
    --140 ↑ 一轮成就1400-1800点  114  154
    local 成就奖励 = self:计算成就(玩家.等级,self.分类)
    玩家:添加银子(银子, "帮派")
    玩家:添加经验(经验, "帮派")
    玩家:添加成就(成就奖励)
    玩家:添加帮派建设(50)

    if not 掉落奖励 then
        return 银子,经验
    end
    local 奖励 = 是否奖励(1002,玩家.等级,玩家.转生)
    if 玩家.其它.帮派次数 == 10 then
        奖励 = 是否奖励(1001,玩家.等级,玩家.转生)
    end

    if 奖励 ~= nil and type(奖励) == 'table' then
        local r = 生成物品 { 名称 = 奖励.道具信息.道具, 数量 = 奖励.道具信息.数量, 参数 = 奖励.道具信息.参数 }
        if r then
            玩家:添加物品({ r })
            if 奖励.道具信息.是否广播 == 1 and 奖励.广播 ~= nil then
                玩家:发送系统(奖励.广播, 玩家.名称, r.ind, r.名称)
            end
        end
    end
    return 银子,经验
end

function 任务:计算成就(等级,分类)
    local 基础值 = {20, 25, 30, 25, 30, 35, 35, 35, 30, 100}
    local 等级段 = {
        {min = 30, max = 70, Reward = 0.5},
        {min = 71, max = 100, Reward = 1},
        {min = 101, max = 140, Reward = 1},
        {min = 141, max = 180, Reward = 1}
    }
    local 等级加成 = 0
    for i, v in ipairs(等级段) do
        if 等级 >= v.min and 等级 <= v.max then
            等级加成 = v.Reward
            break
        end
    end
    return 基础值[分类] + math.floor(等级加成 * 等级)
end

local 对话 = [[你是何方宵小,竟敢挡住本官去路!
menu
1|贪官，受死
2|我认错人了
]]

function 任务:NPC对话(玩家)
    if self.来源 then
        if self.来源.分类 == 8 then
            local r = 玩家:取任务('日常_帮派任务')
            if r and r.nid == self.来源.nid then
                return 对话
            end
            return '我认识你么？'
        end
    end
end

function 任务:NPC菜单(玩家, i)
    if i == '1' then
        if self.来源.NPC then
            local r = 玩家:进入战斗('scripts/task/日常/日常_帮派任务.lua',self)
            if r then
                self.来源:完成(玩家)
            end
        end
    end
end

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '千里眼' and self.分类 == 8 and self.位置 == '千里眼' then
        NPC.头像 = NPC.外形
        NPC.台词 = '我可以帮找到你想找的人,但是嘛...这手续费是少不了的,看你也是做好事,就收你1000两吧!'
    elseif self.分类 == 4 then
        local map = 玩家:取当前地图().名称
        if map == self.指定NPC then
            if NPC.名称 == '酒店老板' or NPC.名称 == '郭三才' then
                NPC.头像 = NPC.外形
                NPC.台词 = '你的订单我收下了,马上给你们送过去#32'
                玩家:删除指定物品('订单')
                self.指定NPC = '帮派总管'
            end
        end
    elseif self.分类 == 5 then
        local map = 玩家:取当前地图().名称
        if self.位置 == NPC.名称 then
            if (NPC.名称 == '药店老板' and map == '长寿村丹房') or (NPC.名称 == '龙天兵' and map == '长寿村打铁铺') or (NPC.名称 == '酒店老板' and map == '长寿酒馆') then
                if math.random(100) <= 99 then
                    NPC.头像 = NPC.外形
                    NPC.台词 = '好大的胆子,敢来我这里收账,给我上！'
                    local r = 玩家:进入战斗('scripts/task/日常/日常_帮派任务.lua',self)
                    if r then
                        NPC.头像 = NPC.外形
                        NPC.台词 = '哎呦,真是有眼不识泰山,这是您的银票,快收好'
                        玩家:添加物品({生成物品 {名称 = '帮派欠银', 数量 = 1}})
                        self.位置 = '帮派总管'
                    end
                else
                    NPC.头像 = NPC.外形
                    NPC.台词 = '来的太巧了,银票我都准备好了,您收好#56'
                    玩家:添加物品({生成物品 {名称 = '帮派欠银', 数量 = 1}})
                    self.位置 = '帮派总管'
                end
            end
        end
    elseif self.分类 == 6 then
        if NPC.名称 == '无名侠女' then
            local r = 玩家:进入战斗('scripts/task/日常/日常_帮派任务.lua',self)
            if r then
                local 银两 , 经验 = self:完成(玩家)
                if 玩家.是否组队 or 玩家.是否队长 then
                    for k, v in 玩家:遍历队伍() do
                        if v.nid ~= 玩家.nid then
                            local 随机 = math.random(20,30)
                            v.好心值 = v.好心值 + 随机
                            v:提示窗口('#Y恭喜你获得#G'..随机..'#Y点好心值,再接再厉吧。')
                            if 银两 ~= nil and 经验 ~= nil then
                                玩家:添加参战召唤兽经验(math.floor(经验 / 2 * 1.5), "帮杀")
                                玩家:添加银子(3000, "帮杀")
                                玩家:添加经验(math.floor(经验 / 2), "帮杀")
                            end
                        end
                    end
                end
            end
        end
    elseif self.分类 == 8 then
        local r = 玩家:取任务('日常_帮派任务')
        if r and self.来源 and r.nid == self.来源.nid then
            return 对话
        end
        return '我认识你么？'
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if self.分类 == 8 then
        if i == '1' then
            if self.来源.NPC then
                local r = 玩家:进入战斗('scripts/task/日常/日常_帮派任务.lua',self)
                if r then
                    local 银两 , 经验 = self.来源:完成(玩家)
                    if 玩家.是否组队 or 玩家.是否队长 then
                        for k, v in 玩家:遍历队伍() do
                            if v.nid ~= 玩家.nid then
                                local 随机 = math.random(20,30)
                                v.好心值 = v.好心值 + 随机
                                v:提示窗口('#Y恭喜你获得#G'..随机..'#Y点好心值,再接再厉吧。')
                                if 银两 ~= nil and 经验 ~= nil then
                                    玩家:添加参战召唤兽经验(math.floor(经验 / 2 * 1.5), "帮杀")
                                    玩家:添加银子(3000, "帮杀")
                                    玩家:添加经验(math.floor(经验 / 2), "帮杀")
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    if cash >= 1000 and self.位置 == '千里眼' then
        玩家:扣除银子(1000)
        local 数据 = self:生成怪物(玩家)
        if 数据 then
            NPC.头像 = 2061
            NPC.台词 = string.format('我看到武官%s此刻正在%s(%d,%d)附近闲逛,赶快过去吧', 数据.名称, 数据.地图.名称, 数据.坐标.x, 数据.坐标.y)
        end
    end
end

function 任务:任务特殊暗雷(玩家,地图)
    local r = 玩家:取任务('日常_帮派任务')
    if r and math.random(100) <= 25 then
        if self.位置 == 地图 then
            if self.分类 == 7 then
                local r = 玩家:进入战斗('scripts/task/日常/日常_帮派任务.lua',self)
                if r then
                    local 银两 , 经验 = self:完成(玩家)
                    if 玩家.是否组队 or 玩家.是否队长 then
                        for k, v in 玩家:遍历队伍() do
                            if v.nid ~= 玩家.nid then
                                local 随机 = math.random(20,30)
                                v.好心值 = v.好心值 + 随机
                                v:提示窗口('#Y恭喜你获得#G'..随机..'#Y点好心值,再接再厉吧。')
                                if 银两 ~= nil and 经验 ~= nil then
                                    玩家:添加参战召唤兽经验(math.floor(经验 / 2 * 1.5), "帮杀")
                                    玩家:添加银子(3000, "帮杀")
                                    玩家:添加经验(math.floor(经验 / 2), "帮杀")
                                end
                            end
                        end
                    end
                end
                return false
            end
        end
    end
    return true
end

function 任务:战斗初始化(玩家, NPC)
    local _怪物 = {
        { 名称 = "三界妖王", 外形 = 2018, 等级=玩家.等级, 血初值 = 7300, 法初值 = 1500, 攻初值 = 1600, 敏初值 = 350,技能={'天诛地灭','电闪雷鸣'}},
        { 名称 = "三界妖王", 外形 = 2018, 等级=玩家.等级, 血初值 = 400, 法初值 = 500, 攻初值 = 400, 敏初值 = 180,技能={'借刀杀人'}},
        { 名称 = "三界妖王", 外形 = 2018, 等级=玩家.等级, 血初值 = 400, 法初值 = 500, 攻初值 = 400, 敏初值 = 180,技能={'借刀杀人'}},
        { 名称 = "千年黑熊精", 外形 = 2006, 等级=玩家.等级, 血初值 = 400, 法初值 = 500, 攻初值 = 400, 敏初值 = 180,技能={'电闪雷鸣'}},
        { 名称 = "千年黑熊精", 外形 = 2006, 等级=玩家.等级, 血初值 = 400, 法初值 = 500, 攻初值 = 400, 敏初值 = 180,技能={'借刀杀人'}},
        { 名称 = "黑山老妖", 外形 = 2073, 等级=玩家.等级, 血初值 = 400, 法初值 = 500, 攻初值 = 400, 敏初值 = 180,技能={'电闪雷鸣'}},
        { 名称 = "六臂魔王", 外形 = 2074, 等级=玩家.等级, 血初值 = 400, 法初值 = 500, 攻初值 = 400, 敏初值 = 180,技能={'借刀杀人'}},
        { 名称 = "黑山老妖", 外形 = 2073, 等级=玩家.等级, 血初值 = 400, 法初值 = 500, 攻初值 = 400, 敏初值 = 180,技能={'电闪雷鸣'}}
    }
    local r = 玩家:取任务('日常_帮派任务')
    if r then
        if r.分类 == 8 then
            local 怪物属性 = {
                外形 = NPC.外形,
                名称 = NPC.名称,
                等级 = 玩家.等级,
                气血 = 36542,
                魔法 = 18000,
                攻击 = 5000,
                速度 = 220,
                抗性 = { 金 = 20, 木 = 20, 水 = 20, 火 = 20, 土 = 20 },
            }
            self:加入敌方(1, 生成战斗怪物(怪物属性))
            for i = 2, 3 do
                怪物属性 = {
                    外形 = 2038,
                    名称 = "帮凶",
                    等级 = 玩家.等级,
                    气血 = 23542,
                    魔法 = 8000,
                    攻击 = 12000,
                    速度 = 150,
                    抗性 = { 金 = 20, 木 = 20, 水 = 20, 火 = 20, 土 = 20 },
                }
                self:加入敌方(i, 生成战斗怪物(怪物属性))
            end
        elseif r.分类 == 5 then
            for i = 1, 3 do
                怪物属性 = {
                    外形 = 2087,
                    名称 = "打手",
                    等级 = 玩家.等级,
                    气血 = 12542,
                    魔法 = 8000,
                    攻击 = 6800,
                    速度 = 150,
                    抗性 = { 金 = 20, 木 = 20, 水 = 20, 火 = 20, 土 = 20 },
                }
                self:加入敌方(i, 生成战斗怪物(怪物属性))
            end
        elseif r.分类 == 6 then
            local 怪物属性 = {
                外形 = 2015,
                名称 = '无名侠女',
                等级 = 玩家.等级,
                气血 = 89542,
                魔法 = 18000,
                攻击 = 8000,
                速度 = 320,
                抗性 = { 金 = 20, 木 = 20, 水 = 20, 火 = 20, 土 = 20 },
                技能={'离魂咒'},
            }
            self:加入敌方(1, 生成战斗怪物(怪物属性))
            for i = 2, 3 do
                怪物属性 = {
                    外形 = 2039,
                    名称 = "银狐",
                    等级 = 玩家.等级,
                    气血 = 28042,
                    魔法 = 8000,
                    攻击 = 9000,
                    速度 = 220,
                    抗性 = { 金 = 20, 木 = 20, 水 = 20, 火 = 20, 土 = 20 },
                }
                self:加入敌方(i, 生成战斗怪物(怪物属性))
            end
        elseif r.分类 == 7 then
            local 怪物属性 = {
                外形 = 2070,
                名称 = '骚扰路人的妖怪',
                等级 = 玩家.等级,
                气血 = 66542,
                魔法 = 18000,
                攻击 = 1300,
                速度 = 290,
                抗性 = { 金 = 20, 木 = 20, 水 = 20, 火 = 20, 土 = 20 },
                技能={'蛟龙出海'},
            }
            self:加入敌方(1, 生成战斗怪物(怪物属性))
            for i = 2, 3 do
                怪物属性 = {
                    外形 = 2070,
                    名称 = "帮凶",
                    等级 = 玩家.等级,
                    气血 = 36542,
                    魔法 = 8000,
                    攻击 = 1200,
                    速度 = 190,
                    抗性 = { 金 = 20, 木 = 20, 水 = 20, 火 = 20, 土 = 20 },
                }
                self:加入敌方(i, 生成战斗怪物(怪物属性))
            end
        end
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)

end


return 任务