-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2024-08-26 13:36:35

local 任务 = {
    名称 = '日常_降魔任务',
    别名 = '降魔任务',
    类型 = '常规玩法'
}
local _别名组 = {
    '三藏逢魔',
    '殿前献艺',
    '宝象迷情',
    '群猴聚义',
    '智斗黄袍',
    '奎星归位'
}
local _详情组 = {
    {name = '三藏逢魔', 详情 = '#Y任务目的:#r#W三藏黑松林迷路，误入黄袍怪老巢，性命危急。义士速赶至#Y%s#W处消灭#G#u%s#W#u，为营救三藏而战。(当前第#R%s#W次，剩余#R%d#W分钟)'},
    {name = '殿前献艺', 详情 = '#Y任务目的:#r#W唐僧师徒宝象国中倒换文牒，八戒却大夸本领，殿前放言要前往捉妖去也，义士请火速前往#Y%s#W处消灭#G#u%s#W#u，助八戒一臂之力。(当前第#R%s#W次，剩余#R%d#W分钟)'},
    {name = '宝象迷情', 详情 = '#Y任务目的:#r#W宝象国迷情重重，委实蹊跷，还望义士前往#Y%s#W击败#G#u%s#W#u探听究竟。(当前第#R%s#W次，剩余#R%d#W分钟)'},
    {name = '群猴聚义', 详情 = '#Y任务目的:#r#W义士速去#Y%s#W告知#G#u%s#W#u详情，邀其前来宝象，除妖伏魔。(当前第#R%s#W次，剩余#R%d#W分钟)'},
    {name = '智斗黄袍', 详情 = '#Y任务目的:#r#W那黄袍怪神通广大，万不可轻敌。义士速去#Y%s#W击败#G#u%s#W#u。(当前第#R%s#W次，剩余#R%d#W分钟)'},
    {name = '奎星归位', 详情 = '#Y任务目的:#r#W决战在睫，义士速去#Y%s#W打败#G#u%s#W#u！(当前第#R%s#W次，剩余#R%d#W分钟)'}
}
function 任务:任务初始化()
    print('任务:初始化')
end

function 任务:任务取详情(玩家)
    if self.NPC then
        return string.format(_详情组[self.分类].详情, self.位置, self.怪名, 玩家.其它.降魔次数, (self.时间 - os.time()) // 60)
    end
    return string.format('由于行动迟缓，#Y%s#W已经逃之夭夭了。\n', self.怪名)
end

function 任务:任务取消(玩家)
    玩家.其它.降魔次数 = 0
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

local _怪信息 = {
    [1] = {
        [1] = {名称 = '天眼魔尊', 模型 = 2018},
        [2] = {名称 = '多闻魔尊', 模型 = 2127},
        [3] = {名称 = '神通魔尊', 模型 = 2126},
        [4] = {名称 = '智慧魔尊', 模型 = 2150}
    },
    --三藏逢魔
    [2] = {
        [1] = {名称 = '西域响马', 模型 = 6552},
        [2] = {名称 = '呆头小虫', 模型 = 6553},
        [3] = {名称 = '粗放大鬼', 模型 = 6554}
    },
    --殿前献艺
    [3] = {
        [1] = {名称 = '白龙马', 模型 = 2453}
    },
    --宝象迷情
    [4] = {
        [1] = {名称 = '齐天大圣', 模型 = 2123}
    },
    --群猴聚义
    [5] = {
        [1] = {名称 = '认真的黄袍怪', 模型 = 2127},
        [2] = {名称 = '愤怒的黄袍怪', 模型 = 2127},
        [3] = {名称 = '疯狂的黄袍怪', 模型 = 2127},
        [4] = {名称 = '变态的黄袍怪', 模型 = 2127}
    },
    --智斗黄袍
    [6] = {
        [1] = {名称 = '奎木狼', 模型 = 2130}
    }
    --奎星归位
}

local _刷新地点 = {
    [1] = {101299, 101295, 101538, 101537, 1173, 1131, 101300},
    --三藏逢魔
    [2] = {101537, 101538},
    --殿前献艺
    [3] = {101537, 101538},
    --宝象迷情
    [4] = {101537, 101538},
    --群猴聚义
    [5] = {101537, 101538},
    --智斗黄袍
    [6] = {101537, 101538}
    --奎星归位
}

function 任务:生成怪物(玩家)
    local map = 玩家:取随机地图(_刷新地点[self.分类])
    if not map then
        return
    end
    local xz = math.random(#_怪信息[self.分类])
    if self.分类 == 5 then
        xz = 1
    end
    self.怪名 = _怪信息[self.分类][xz].名称
    self.怪模型 = _怪信息[self.分类][xz].模型

    local X, Y = map:取随机坐标() --真坐标

    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    self.队伍 = {}

    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
        v.其它.降魔次数 = v.其它.降魔次数 + 1
        if v.其它.降魔次数 > 10 then
            v.其它.降魔次数 = 1
        end
        v:添加任务(self)
    end
    self.时间 = os.time() + 30 * 60
    self.NPC =
        map:添加NPC {
        队伍 = self.队伍,
        人数 = #self.队伍,
        时长 = 3600,
        分类 = self.分类,
        进度 = 1,
        名称 = self.怪名,
        外形 = self.怪模型,
        脚本 = 'scripts/task/日常/日常_降魔任务.lua',
        时间 = self.时间,
        X = X,
        Y = Y,
        来源 = self
    }
    self.MAP = map.id
    return true
end
function 任务:重新生成怪物(玩家)
    if self.进度 >= 4 then
        self:完成(玩家)
        return
    end
    local map = 玩家:取地图(self.MAP)
    if map then
        map:删除NPC(self.NPC)
    end

    map = 玩家:取随机地图(_刷新地点[self.分类])
    if not map then
        return
    end
    self.进度 = self.进度 + 1
    self.怪名 = _怪信息[self.分类][self.进度].名称
    self.怪模型 = _怪信息[self.分类][self.进度].模型

    local X, Y = map:取随机坐标() --真坐标
    if not X then
        return
    end
    self.位置 = string.format('%s(%d,%d)', map.名称, X, Y)
    self.队伍 = {}

    for k, v in 玩家:遍历队伍() do
        table.insert(self.队伍, v.nid)
    end
    self.时间 = os.time() + 30 * 60
    self.NPC =
        map:添加NPC {
        队伍 = self.队伍,
        人数 = #self.队伍,
        时长 = 3600,
        分类 = self.分类,
        进度 = 1,
        名称 = self.怪名,
        外形 = self.怪模型,
        脚本 = 'scripts/task/日常/日常_降魔任务.lua',
        时间 = self.时间,
        X = X,
        Y = Y,
        来源 = self
    }
    self.MAP = map.id
    return true
end
function 任务:完成(玩家)
    local r = 玩家:取任务('日常_降魔任务')
    if 玩家.是否组队 then
        if r then
            for _, v in 玩家:遍历队伍() do
                local rr = v:取任务('日常_降魔任务')
                if rr and r.nid == rr.nid then
                    rr:删除()
                    self:掉落包(v,v.其它.降魔次数)
                end
            end
        end
        for _, nid in ipairs(self.队伍) do
            local r = 玩家:取玩家(nid)
            if r then
                local w = 玩家:取任务('日常_降魔任务')
                if w then
                    w:删除()
                end
            end
        end
    elseif r then
        self:删除()
        self:掉落包(玩家,玩家.其它.降魔次数)
    end

    local map = 玩家:取地图(self.MAP)
    if map then
        map:删除NPC(self.NPC)
    end
end
local _掉落 = {
    {几率 = 800, 名称 = '九彩云龙珠', 数量 = 1, 参数 = 130},
	{几率 = 500, 名称 = '内丹精华', 数量 = 1},
    {几率 = 500, 名称 = '血玲珑', 数量 = 1, 参数 = 125},
    {几率 = 80, 名称 = '千年寒铁', 数量 = 1},
    {几率 = 50, 名称 = '天外飞石', 数量 = 1},
    {几率 = 300, 名称 = '人参果', 数量 = 1},
    {几率 = 300, 名称 = '神兽丹', 数量 = 1},
    {几率 = 300, 名称 = '凝精聚气丸', 数量 = 1},
    {几率 = 100, 名称 = '蟠桃', 数量 = 1, 参数 = 60},
    {几率 = 30, 名称 = '盘古精铁', 数量 = 1},
    {几率 = 30, 名称 = '补天神石', 数量 = 1,广播=true},
    {几率 = 100, 名称 = '随机双加药品', 数量 = 1},
    {几率 = 50, 名称 = '天机密令', 数量 = 1},
    {几率 = 30, 名称 = '见闻录', 数量 = 1},
    {几率 = 1, 名称 = '随机神兵', 数量 = 1, 参数 = 1,广播=true},
    {几率 = 50, 名称 = '随机炼妖', 数量 = 1, 参数 = 9},
    {几率 = 50, 名称 = '随机宝石', 数量 = 1, 参数 = 5},
    {几率 = 20, 名称 = '人参果王', 数量 = 1,广播=true},
    {几率 = 10, 名称 = '六魂之玉', 数量 = 1,广播=true},
}

local _广播组 = {
    '#c00FFFF【三藏逢魔】#C%s#c00FFFF一行勇闯黑松岭，见到那小妖怪正是要抬着这唐僧下锅时，使出一招降龙十八掌后#78#c00FFFF便让#G#m(%s)[%s]#m#n#c00FFFF和唐玄奘一同脱离魔掌#24！',
    '#c00FFFF【殿前献艺】#C%s#c00FFFF大显神通，捉妖本领更是无人能及，国王嘉奖了个#G#m(%s)[%s]#m#n#c00FFFF#86！',
    '#c00FFFF【宝象迷情】#C%s#c00FFFF聪明绝顶#101#c00FFFF一番打听后便知这宝象国之事诸多蹊跷，众人好奇，只好拿出#G#m(%s)[%s]#m#n#c00FFFF换得一听究竟。#35',
    '#c00FFFF【群猴聚义】#C%s#c00FFFF使出浑身解数才说服孙大圣给了自己一个#G#m(%s)[%s]#m#n#c00FFFF与其一同前去宝象国，降妖除魔#89！',
    '#c00FFFF【智斗黄袍】虽是那黄袍怪神通广大，可遇到#R/%s#c00FFFF后，仍被打了个落荒而逃，丢下了个#G#m(%s)[%s]#m#n#c00FFFF#44！',
    '#c00FFFF【奎星归位】那黄袍怪穷途现形，原是天庭奎木狼思凡下界，不想被#R/%s#c00FFFF围追堵截，看到此间种种只好扔出#G#m(%s)[%s]#m#n#c00FFFF才躲过一劫。#101#c00FFFF！',

}



function 任务:掉落包(玩家,次数)
    local 银子 = 1500*(1+次数*0.12)
    local 经验 = math.floor((25000 + 玩家.等级 * 1000)*(1+次数*0.072))
    local 法宝经验 = 360+次数*12

    if 玩家:判断等级是否高于(142) and 玩家:判断等级是否低于(90) then --90-142
        玩家:添加参战召唤兽经验(经验, "日常_降魔任务")
        -- 玩家:常规提示("#Y适合任务90-142级玩家参与！")
        return
    end
    玩家:添加参战召唤兽经验(经验 * 1.5,"降魔")
    玩家:添加银子(银子,"降魔")
    玩家:添加经验(经验,"降魔")
    玩家:添加法宝经验(法宝经验,"降魔")
    if 玩家:取活动限制次数('降魔任务') > 200 then
        return
    end
    玩家:增加活动限制次数('降魔任务')

    玩家:添加物品({生成物品 {名称 = '宝象遁行符', 数量 = 1}})
    for i, v in ipairs(_掉落) do
        if math.random(1000) <= v.几率 then
            local r = 生成物品 {名称 = v.名称, 数量 = v.数量, 参数 = v.参数}
            if r then
                玩家:添加物品({r})
                if v.广播 then
                    玩家:发送系统(_广播组[self.分类], 玩家.名称, r.ind, r.名称)
                end
                break
            end
        end
    end
end

--===============================================
local 对话 = [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧
2|我认错人了
]]

function 任务:NPC对话(玩家, i)
    local r = 玩家:取任务('日常_降魔任务')
    if r and r.nid == self.来源.nid then
        return 对话
    end
    return '我认识你么？#24'
end

function 任务:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:进入战斗('scripts/task/日常/日常_降魔任务.lua')
        if r then
            if self.来源.分类 == 5 then
                self.来源:重新生成怪物(玩家)
            else
                self.来源:完成(玩家)
            end
        end
    end
end
--===============================================

function 任务:战斗初始化(玩家)








    
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
