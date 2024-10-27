-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2024-08-26 13:36:26
local _时辰 = { '子时', '丑时', '寅时', '卵时', '辰时', '巳时', '午时', '未时', '申时', '酉时',
    '戌时', '亥时' }
local _时刻 = { '一刻', '二刻', '三刻', '四刻', '五刻', '六刻', '七刻', '八刻' }
local _小怪 = { '诌鬼', '假鬼', '奸鬼', '捣蛋鬼', '冒失鬼', '烟沙鬼', '挖渣鬼',
    '仔细鬼', '讨吃鬼', '醉死鬼', '抠掏鬼', '伶俐鬼', '急突鬼', '丢谎鬼',
    '乜斜鬼', '撩桥鬼', '饿鬼', '色鬼', '穷鬼', '刻山鬼', '吸血鬼', '惊鸿鬼',
    '清明鬼' }

local _外形 = { 2089, 2056, 2055, 2049, 2050, 2051, 2115, 2109 }
--"九头魔",无头鬼, 野鬼, 冤魂, 修罗, 幽灵, 范式之魂, 剑精灵
local _地图 = { 1001 }
--龙窟一层, 龙窟二层, 龙窟三层, 龙窟四层, 凤巢一层, 凤巢二层, 凤巢三层, 凤巢四层, 御马监, 瑶池, 蟠桃园, 蟠桃园后

local 任务 = {
    名称 = '日常_鬼王任务',
    别名 = '鬼王任务',
    类型 = '常规玩法',
    是否可取消 = true,
    是否可追踪 = true
}

function 任务:任务初始化()
end

function 任务:任务取详情(玩家)
    if self.NPC and self.MAP then
        local map = 玩家:取地图(self.MAP)
        if map then
            return string.format('#Y任务目的:#r#W刚收到鬼差信报，在#Y%s#W处发现#u#G#m({%s,%s,%s})%s#m#u#W为免其危害人间，我已下令招募三界有志之士前往捉拿，成功者重重有赏！这事情就有劳阁下了！(当前第#R%s#W次，剩余#R%d#W分钟)'
            , self.位置,map.名称,self.坐标.x,self.坐标.y,self.怪名 , 玩家.其它.鬼王次数, (self.时间 - os.time()) // 60)
        end
    end
    return string.format('由于行动迟缓，#Y%s#W已经逃之夭夭了。\n', self.怪名)
end

local _追踪描述 = '去#G%s(%s,%s)#W寻找#u#G#m({%s,%s,%s})%s#m#u#W[#G%s/10#W]#r#W剩余时间:%s'

function 任务:任务取追踪(玩家)
    if self.MAP then
        local map = 玩家:取地图(self.MAP)
        if map then
            return string.format(_追踪描述,map.名称,self.坐标.x,self.坐标.y,map.名称,self.坐标.x,self.坐标.y,self.怪名,玩家.其它.鬼王次数,os.date("!%H:%M:%S", (self.时间 - os.time() )))--任务.别名,任务.类别,
        end
    end
end

function 任务:任务更新(sec,玩家)
    if self.时间 <=sec then
        local map = 玩家:取地图(self.MAP)
        if map then
            local NPC = map:取NPC(self.NPC)
            if NPC then
                map:删除NPC(self.NPC)
            end
        end
        self:任务取消(玩家)
        self:删除()
        玩家:提示窗口('#Y你的鬼王任务已超时。')
    end
end

function 任务:任务取消(玩家)
    玩家.其它.鬼王次数 = 0
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if NPC then
            NPC.人数 = NPC.人数 - 1
            if NPC.人数 <= 0 then
                map:删除NPC(self.NPC)
            end
        end
    end
end

function 任务:任务上线(玩家)
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if not NPC then
            self:删除()
        end
    end
end

function 任务:生成怪物(玩家)
    local map = 玩家:取随机地图(_地图)
    if not map then
        return
    end
    self.怪名 = _时辰[math.random(#_时辰)] .. _时刻[math.random(#_时刻)] .. _小怪[math.random(#_小怪)]
    local X, Y = map:取随机坐标() --真坐标
    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    self.队伍 = {}
    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
        v.其它.鬼王次数 = v.其它.鬼王次数 + 1
        if v.其它.鬼王次数 > 7 then
            v.其它.鬼王次数 = 1
        end
        v:添加任务(self)
    end
    self.时间 = os.time() + 30 * 60
    self.NPC =
    map:添加NPC {
        队伍 = self.队伍,
        人数 = #self.队伍,
        时长 = 1800,
        名称 = self.怪名,
        外形 = _外形[math.random(#_外形)],
        脚本 = 'scripts/task/日常/日常_鬼王任务.lua',
        时间 = self.时间,
        X = X,
        Y = Y,
        来源 = self
    }
    self.坐标 = {}
    self.坐标.x, self.坐标.y = X, Y
    self.次数 = 玩家.其它.抓鬼次数
    self.MAP = map.id

    玩家:自动任务({
        类型 = "日常_鬼王任务",
        nid = self.NPC,
        外形 = self.外形,
        id = self.MAP,
        x = X,
        y = Y
    })
    玩家:刷新追踪面板()
    return true
end

function 任务:完成(玩家)
    local r = 玩家:取任务('日常_鬼王任务')
    if 玩家.是否组队 then
        if r then
            for _, v in 玩家:遍历队伍() do
                local rr = v:取任务('日常_鬼王任务')
                if rr then
                    rr:删除()
                    self:掉落包(v, v.其它.鬼王次数)
                end
            end
        end
        -- for _, nid in ipairs(self.队伍) do
        --     local r = 玩家:取玩家(nid)
        --     if r then
        --         local w = 玩家:取任务('日常_鬼王任务')
        --         if w then
        --             w:删除()
        --         end
        --     end
        -- end
    elseif r then
        self:删除()
        self:掉落包(玩家, 玩家.其它.鬼王次数)
    end

    local map = 玩家:取地图(self.MAP)
    if map then
        map:删除NPC(self.NPC)
    end
    玩家:刷新追踪面板()
end


function 任务:掉落包(玩家, 次数)
    local 银子 = 1000 * (1 + 次数 * 0.12)
    --local 师贡 = 30000
    local 经验 = math.floor((16000 + 玩家.等级 * 700) * (1 + 次数 * 0.14))
    local r = 玩家:取任务("引导_鬼王任务")
    if r then
        r:添加进度(玩家)
    end
    if 玩家:判断等级是否高于(142) or 玩家:判断等级是否低于(90) then --90-142
        玩家:添加参战召唤兽经验(经验, "日常_鬼王任务")
        return
    end
    玩家:添加银子(银子, "鬼王")
    玩家:添加任务经验(经验, "鬼王")
    玩家:添加活力(10)
    if 玩家.是否队长 then
        local t = 玩家:取物品是否存在('鬼狱灵反符')
        if not t then
            玩家:添加物品({ 生成物品 { 名称 = '鬼狱灵反符', 数量 = 1 } })
        end
    end

    local 奖励 = 是否奖励(1008,玩家.等级,玩家.转生)
    if 次数 == 10 then
        奖励 = 是否奖励(1007,玩家.等级,玩家.转生)
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
end

--=====================对话==========================
local 对话 = [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧
2|我认错人了
]]

function 任务:NPC对话(玩家, i)
    local r = 玩家:取任务('日常_鬼王任务')
    if r and r.NPC == self.来源.NPC then
        return 对话
    end
    return '我认识你么？#24'
end

function 任务:任务攻击事件(玩家, NPC)
    local r = 玩家:取任务("日常_鬼王任务")
    if r and r.NPC == NPC.来源.NPC then
        local rr = 玩家:进入战斗('scripts/task/日常/日常_鬼王任务.lua', NPC)
        if rr then
            r:完成(玩家)
        end
        玩家:自动任务_战斗结束(rr)
        return
    end
    return "我认识你么？"
end

function 任务:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:进入战斗('scripts/task/日常/日常_鬼王任务.lua',self)
        if r then
            self.来源:完成(玩家)
        end
        玩家:自动任务_战斗结束(r)
    end
end

function 任务:战斗初始化(玩家,NPC)
    local 任务 = 玩家:取任务('日常_鬼王任务')
    local 等级 = 玩家:取队伍最高等级()
    local _怪物 = {
        { 名称 = NPC.名称, 外形 = NPC.外形, 等级=等级, 血初值 = 300, 法初值 = 100, 攻初值 = 50, 敏初值 = 80,施法几率 = 50,是否消失 = false},
        { 名称 = "地狱战神", 外形 = 2074, 等级=等级, 血初值 = 3000, 法初值 = 100, 攻初值 = 50, 敏初值 = 60,施法几率 = 50,是否消失 = false}
    }
    if 任务 then
        for i=1,7 + math.floor(任务.次数 * 0.2) do
            local r = {}
            if i == 1 then
                r = 生成战斗怪物(生成怪物属性(_怪物[i],'困难',nil,'高级法术'))
            else
                _怪物[2].名称 = _时辰[math.random(#_时辰)] .. _时刻[math.random(#_时刻)] .. _小怪[math.random(#_小怪)]
                _怪物[2].外形 = _外形[math.random(#_外形)]

                r = 生成战斗怪物(生成怪物属性(_怪物[2],'困难',nil,'中级法术'))
            end
            self:加入敌方(i, r)
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
