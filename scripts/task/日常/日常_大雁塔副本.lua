-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-06-04 19:44:01
-- @Last Modified time  : 2023-06-16 03:09:25

-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2023-06-16 02:46:53

local 任务 = {
    名称 = '日常_大雁塔副本',
    别名 = '大雁塔降魔',
    类型 = '副本任务'
}


function 任务:任务初始化()
    self.坐标记录 = {}
    for i=1,20 do
        self.坐标记录[i] = {x = 0 , y = 0}
    end
end



function 任务:任务取详情(玩家)
    local _任务详情 = {
    [1] = '#Y任务目的：#r#W除掉雁塔中的妖魔,#u#G#m({大雁塔一层,136,70})慈恩寺方丈#m#u#W会助你一臂之力。',
    [2] = '#Y任务目的：#r#W请速去,#u#G#m({大雁塔一层,'..self.坐标记录[2].x..','..self.坐标记录[2].y..'})（'..self.坐标记录[2].x..','..self.坐标记录[2].y..'）#m#u#W镇杀妖魔。'
}
    if self.进度 == 1 or self.进度 == 2 then
        任务.别名 = '雁塔一层任务'
    end
    return _任务详情[self.进度]
end

function 任务:任务取消(玩家)
    玩家:切换地图(1001, 2085, 1760)
    self:删除()
end

function 任务:任务更新(sec, 玩家)
    if os.time() > self.时间 then
        玩家:切换地图(1001, 2085, 1760)
        self:删除()
    end
end

function 任务:任务上线(玩家)


end

function 任务:任务下线(玩家)
    玩家:切换地图(1001, 103, 199)
    self.地图 = nil
    self:删除()
end

function 任务:添加任务(玩家)
    self.时间 = os.time() + 3600
    self.进度 = 1
    self.地图 = {
        生成地图(1004),
        生成地图(1005),
        生成地图(1006),
        生成地图(1007),
        生成地图(1008),
        生成地图(1090),
        生成地图(1009),
    }
    -- self.地图[1]:添加跳转({ X = 23, Y = 22, tid = self.地图[2].id, tX = 75, tY = 80 })
    local map = self.地图[1]
    玩家:切换地图2(map, 280, 1700)
    map:添加NPC {
        名称 = "慈恩寺方丈",
        外形 = 3031,
        脚本 = 'scripts/npc/副本/大雁塔/慈恩寺方丈.lua',
        X = 136,
        Y = 70}
    玩家:添加任务(self)
    return true
end

local _掉落 = {
    { 几率 = 800, 名称 = '仙器礼盒', 数量 = 1},
    { 几率 = 500, 名称 = '仙器礼盒', 数量 = 1 },
    { 几率 = 500, 名称 = '仙器礼盒', 数量 = 1, 参数 = 125 },
    { 几率 = 50, 名称 = '千年寒铁', 数量 = 1 },
    { 几率 = 30, 名称 = '天外飞石', 数量 = 1 },
    { 几率 = 300, 名称 = '人参果', 数量 = 1 },
    { 几率 = 300, 名称 = '神兽丹', 数量 = 1 },
    { 几率 = 300, 名称 = '凝精聚气丸', 数量 = 1 },
    { 几率 = 100, 名称 = '仙器礼盒', 数量 = 1, 参数 = 60 },
    { 几率 = 10, 名称 = '盘古精铁', 数量 = 1, 广播 = '#C%s#c00FFFF在大雁塔副本中获得了一个#G#m(%s)[%s]#m#n#c00FFFF#23!' }
}
function 任务:掉落包(玩家)
    for i, v in ipairs(_掉落) do
        if math.random(1000) <= v.几率 then
            local r = 生成物品 { 名称 = v.名称, 数量 = v.数量, 参数 = v.参数 }
            if r then
                玩家:添加物品({ r })
                if v.广播 then
                    玩家:发送系统(v.广播, 玩家.名称, r.ind, r.名称)
                end
                break
            end
        end
    end
end

--===============================================

function 任务:任务NPC对话(玩家, NPC)
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if i == '1' then
        self.进度 = 2
    end
end

--===============================================


function 任务:战斗初始化(玩家, NPC)

end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
