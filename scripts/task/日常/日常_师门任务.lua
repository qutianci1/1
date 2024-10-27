-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-08-13 15:20:21

local 任务 = {
    名称 = '日常_师门任务',
    别名 = '师门任务',
    类型 = '常规玩法'
}

function 任务:任务初始化()
    print('任务:初始化')
end

local _详情 = {
    '在#Y%s#W附近巡逻,铲除师门附近的#G密探#W。(当前第#R%s#W次，剩余#R%d#W分钟)',
    '去#Y%s#W附近和门派弟子切磋,没赢得话你也不用回来了#54。(当前第#R%s#W次，剩余#R%d#W分钟)',
    '师门仓库最近#G[%s]#W存量较少了很多,你去找来交给师傅。(当前第#R%s#W次，剩余#R%d#W分钟)',
    '师门仓库最近#G[%s]#W存量较少了很多,你去找一块龙来交给师傅。(当前第#R%s#W次，剩余#R%d#W分钟)'
}
function 任务:任务取详情(玩家)
    return string.format(_详情[self.分类], self.位置, 玩家.其它.师门次数, (self.时间 - os.time()) // 60)
end

function 任务:任务取消(玩家)
    玩家.其它.师门次数 = 0
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

local _密探外形 = {
    [1] = { 1, 2, 3, 4, 5, 6 },
    [2] = { 7, 8, 9, 10, 11, 12 },
    [3] = { 13, 14, 15, 16, 17, 18 },
    [4] = { 60, 61, 62, 63, 64, 65 },
    [1001] = { 4, 5, 6 },
    [1002] = { 1, 2, 3 },
    [2001] = { 10, 11, 12 },
    [2002] = { 7, 8, 9 },
    [3001] = { 16, 17, 18 },
    [3002] = { 13, 14, 15 },
    [4001] = { 63, 64, 65 },
    [4002] = { 60, 61, 62 }
}





local _寻物 = {
    {
        '天书残卷一',
        '天书残卷二',
        '天书残卷三',
        '天书残卷四',
        '天书残卷五'
    },
    {
        '六魂之玉',
        '补天神石',
        '盘古精铁',
        '天外飞石',
        '千年寒铁'
    }
}
function 任务:添加任务(玩家)
    玩家.其它.师门次数 = 玩家.其它.师门次数 + 1
    if 玩家.其它.师门次数 > 10 then
        玩家.其它.师门次数 = 1
    end
    玩家:添加任务(self)
    self.时间 = os.time() + 30 * 60

    if self.分类 == 1 or self.分类 == 2 then
        self:生成怪物(玩家)
    else
        self.位置 = _寻物[self.分类 - 2][math.random(#_寻物[self.分类 - 2])]
    end

    return true
end

local _地图 = {
    hs = 1002,
    nr = 1142,
    cf = 1001,
    fc = 1135,
    ps = 1173,
    df = 1122,
    mw = 1173,
    st = 1131,
    tg = 1111,
    pt = 1140,
    lg = 1116,
    wz = 1146,
    bg = 101300,
    yd = 1122,
    lr = 101395,
    ss = 1001
}

function 任务:生成怪物(玩家)
    local map = 玩家:取地图(_地图[self.门派])
    if not map then
        return
    end
    if self.分类 == 1 then
        self.怪名 = '密探'
    else
        self.怪名 = _随机名称(3)
    end

    local X, Y = map:取随机坐标()
    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    self.队伍 = {}
    self.NPC =
    map:添加NPC {
        队伍 = self.队伍,
        名称 = self.怪名,
        时长 = 1800,
        外形 = _密探外形[玩家.种族][math.random(6)],
        脚本 = 'scripts/task/日常/日常_师门任务.lua',
        时间 = self.时间,
        X = X,
        Y = Y,
        来源 = self
    }
    self.MAP = map.id
    return true
end

function 任务:完成(玩家)
    local r = 玩家:取任务('日常_师门任务')

    if r then
        if self.NPC then
            self:任务取消(玩家)
        end
        self:删除()
        self:掉落包(玩家)
    end
end

local _掉落 = {
    { 几率 = 10, 名称 = '悔梦石', 数量 = 1, 广播 = '#C水水谁%s获得了什么#G#m(%s)[%s]#m#n' },
    { 几率 = 10, 名称 = '亲密丹', 数量 = 1, 参数 = 1000, 广播 = '#C水水谁%s获得了什么#G#m(%s)[%s]#m#n' }
}
function 任务:掉落包(玩家)
    local 银子 = 0
    local 经验 = 5000
    --(1+玩家.其它.抓鬼次数*1.2)

    玩家:添加参战召唤兽经验(经验 * 1.5, "师门")
    玩家:添加银子(银子, "师门")
    玩家:添加经验(经验, "师门")

    if 玩家:取活动限制次数('天庭任务') > 200 then
        return
    end
    玩家:增加活动限制次数('天庭任务')

    -- for i, v in ipairs(_掉落) do
    --     if math.random(1000) <= v.几率 then
    --         local r = 生成物品 { 名称 = v.名称, 数量 = v.数量, 参数 = v.参数 }
    --         if r then
    --             玩家:添加物品({ r })
    --             if v.广播 then
    --                 玩家:发送系统(v.广播, 玩家.名称, r.ind, r.名称)
    --             end
    --             break
    --         end
    --     end
    -- end
end

--===============================================

local 对话 = [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧
2|我认错人了
]]

function 任务:NPC对话(玩家, i)
    local r = 玩家:取任务('日常_师门任务')
    if r and r.nid == self.来源.nid then
        return 对话
    end
    return '我认识你么？'
end

function 任务:NPC菜单(玩家, i)
    if i == '1' then
        if self.来源.NPC then
            local r = 玩家:进入战斗('scripts/task/日常/日常_师门任务.lua',self)
            if r then
                self.来源:完成(玩家)
            end
        end
    end
end

--===============================================

function 任务:战斗初始化(玩家, NPC)
    local r = 玩家:取任务('日常_师门任务')
    if r then
        local 怪物属性 = {
            外形 = NPC.外形,
            名称 = NPC.名称,
            等级 = 玩家.等级,
            气血 = 26542,
            魔法 = 18000,
            攻击 = 1,
            速度 = 1,
            抗性 = { 金 = 20, 木 = 20, 水 = 20, 火 = 20, 土 = 20 },
        }
        self:加入敌方(1, 生成战斗怪物(怪物属性))

        if NPC.名称 ~= "密探" then
            local n = 玩家.种族 * 1000 + 玩家.性别
            local sx = _密探外形[n]
            for i = 2, 3 do
                怪物属性 = {
                    外形 = sx[math.random(#sx)],
                    名称 = "手下",
                    等级 = 玩家.等级,
                    气血 = 26542,
                    魔法 = 18000,
                    攻击 = 1,
                    速度 = 1,
                    抗性 = { 金 = 20, 木 = 20, 水 = 20, 火 = 20, 土 = 20 },
                }
                self:加入敌方(i, 生成战斗怪物(怪物属性))
            end
        end
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(dt)
    if dt then
        local zg = self:取对象(11)
        if zg then
            for k, v in self:遍历我方() do
                if v.是否玩家 then
                    local z = v.对象.接口:取乘骑坐骑()
                    if z then
                        z:添加经验(5)
                        z:添加熟练(5)
                    end
                end
            end
        end
    end
end

return 任务
