-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2023-09-12 15:08:26

local 任务 = {
    名称 = '日常_打图任务',
    别名 = '打图任务',
    类型 = '常规玩法',
    是否可取消 = true,
    是否可追踪 = false
}

function 任务:任务初始化()
end

function 任务:任务取详情(玩家)
    if self.NPC and self.MAP then
        local map = 玩家:取地图(self.MAP)
        if map then
            return string.format('#Y任务目的:#r#W前往#Y%s#W场景，捉拿#u#G#m({%s,%s,%s})%s#m#u#W#r(剩余#R%d#W分钟)'
                , self.位置, map.名称,self.坐标.x,self.坐标.y,self.怪名, (self.时间 - os.time()) // 60)
        end
    end
    return string.format('由于行动迟缓，#Y%s#W已经逃之夭夭了。\n', self.怪名)
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
    end
end

function 任务:任务取消(玩家)
    local map = 玩家:取地图(self.MAP)
    if map then
        local NPC = map:取NPC(self.NPC)
        if NPC then
            map:删除NPC(self.NPC)
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

local _地图 = {1208,1213,1193,1110}
function 任务:生成怪物(玩家)
    local map = 玩家:取随机地图(_地图)
    if not map then
        return
    end
    self.怪名 = 取随机名称()
    local X, Y = map:取随机坐标()
    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    玩家:添加任务(self)
    self.时间 = os.time() + 30 * 60
    self.NPC =
    map:添加NPC {
        名称 = self.怪名,
        时长 = 1800,
        外形 = 2044,
        脚本 = 'scripts/task/日常/日常_打图任务.lua',
        时间 = self.时间,
        X = X,
        Y = Y,
        来源 = self
    }
    self.坐标 = {}
    self.坐标.x, self.坐标.y = X, Y
    self.MAP = map.id
    玩家:刷新追踪面板()
    return true
end

function 任务:完成(玩家)
    local r = 玩家:取任务('日常_打图任务')
    if r then
        local map = 玩家:取地图(self.MAP)
        if map then
            map:删除NPC(self.NPC)
        end
        self:删除()
        self:掉落包(玩家, 玩家.其它.抓鬼次数)
    end
    玩家:刷新追踪面板()
end

function 任务:掉落包(玩家, 次数)
    local 银子 = math.random(800, 1600)
    local 经验 = 50000

    玩家:添加任务经验(经验, "打图")
    玩家:添加银子(银子, "打图")
    if math.random(100) >= 50 then
        local r = 生成物品 { 名称 = '藏宝图' }
        if r then
            玩家:添加物品({ r })
        end
    end
end

--===============================================
local 对话 = [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|交出你的财宝
2|我路过的
]]
function 任务:任务攻击事件(玩家, NPC)
    local r = 玩家:取任务("日常_打图任务")
    if r and r.NPC == NPC.来源.NPC then
        local rr = 玩家:进入战斗('scripts/task/日常/日常_打图任务.lua', NPC)
        if rr then
            r:完成(玩家)
        end
        return
    end
    return "我认识你么？"
end

function 任务:NPC对话(玩家, i)
    local r = 玩家:取任务("日常_打图任务")
    if r and r.NPC == self.来源.NPC then
        return 对话
    end
    return "我认识你么？"
end

function 任务:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:进入战斗('scripts/task/日常/日常_打图任务.lua', self)
        if r then
            self.来源:完成(玩家)
        end
    end
end

--===============================================

function 任务:战斗初始化(玩家, NPC)
    local 任务 = 玩家:取任务('日常_打图任务')
    local 等级 = 玩家.等级
    local _怪物 = {
        { 名称 = NPC.名称, 外形 = NPC.外形, 等级=等级, 血初值 = 200, 法初值 = 50, 攻初值 = 50, 敏初值 = 50,施法几率 = 50,是否消失 = true},
        { 名称 = '帮凶', 外形 = 2045, 等级=等级, 血初值 = 150, 法初值 = 50, 攻初值 = 20, 敏初值 = 20,施法几率 = 50,是否消失 = true},
        { 名称 = '帮凶', 外形 = 2045, 等级=等级, 血初值 = 150, 法初值 = 50, 攻初值 = 20, 敏初值 = 20,施法几率 = 50,是否消失 = true}
    }

    if 任务 then
        for i=1,3 do
            local r = 生成战斗怪物(生成怪物属性(_怪物[i],'中等',nil,'低级法术'))
            self:加入敌方(i, r)
        end
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(v)
end

return 任务
