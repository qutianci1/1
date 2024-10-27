-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-09-13 12:58:53
-- @Last Modified time  : 2024-08-13 15:20:17

local NPC表 = {
    [1174] = {
        {名称 = '彩翼仙子', x = 203, y = 25},
        {名称 = '北俱芦洲土地', x = 114, y = 93},
        {名称 = '幽冥地鬼', x = 47, y = 134},
    },
    [1070] = {
        {名称 = '惠静师太', x = 19, y = 31},
        {名称 = '陈老财', x = 71, y = 127},
        {名称 = '天寿老人', x = 29, y = 25},
        {名称 = '南极仙翁', x = 33, y = 47},
    },
    [1091] = {
        {名称 = '小花仙', x = 56, y = 38},
        {名称 = '长寿老人', x = 96, y = 90},
    },
    [1123] = {
        {名称 = '黑无常', x = 10, y = 20},
        {名称 = '阎罗王', x = 35, y = 20},
    },
    [1031] = {
        {名称 = '青楼老板', x = 18, y = 25},
    },
    [1141] = {
        {名称 = '仙女姐姐', x = 22, y = 15},
    },
    [1092] = {
        {名称 = '蝴蝶妹妹', x = 107, y = 79},
        {名称 = '龟学士', x = 360, y = 147},
        {名称 = '九头精怪', x = 154, y = 121},
    },
    [1127] = {
        {名称 = '牛头', x = 37, y = 21},
    },
    [1128] = {
        {名称 = '马面', x = 4, y = 20},
    },
    [1005] = {
        {名称 = '大力精', x = 49, y = 59},
    },
    [1004] = {
        {名称 = '索命鬼', x = 114, y = 68},
    },
    [1131] = {
        {名称 = '蛤蟆精', x = 37, y = 29},
        {名称 = '山神', x = 5, y = 31},
        {名称 = '雷鸟精', x = 9, y = 8},
    },
    [1132] = {
        {名称 = '二大王', x = 33, y = 16},
    },
    [1133] = {
        {名称 = '三大王', x = 26, y = 13},
    },
    [1007] = {
        {名称 = '鬼魁', x = 48, y = 53},
    },
    [1011] = {
        {名称 = '王秀才', x = 16, y = 14},
    },
    [1198] = {
        {名称 = '蟠桃园土地', x = 47, y = 49},
        {名称 = '小灵猴', x = 50, y = 29},
        {名称 = '神兵', x = 37, y = 36},
    },
    [1199] = {
        {名称 = '司马小仙', x = 29, y = 153},
        {名称 = '小马仙', x = 90, y = 55},
        {名称 = '采星仙女', x = 50, y = 131},
    },
    [1200] = {
        {名称 = '弼马温', x = 17, y = 8},
    },
    [1108] = {
        {名称 = '流沙河船夫', x = 18, y = 7},
    },
    [1140] = {
        {名称 = '黄夫人', x = 40, y = 53},
        {名称 = '小仙女', x = 96, y = 71},
    },
    [1110] = {
        {名称 = '长安西土地', x = 384, y = 145},
        {名称 = '老李', x = 239, y = 140},
    },
    [1173] = {
        {名称 = '武者', x = 245, y = 266},
        {名称 = '逍遥仙', x = 454, y = 157},
    },
    [1236] = {
        {名称 = '胡大力', x = 362, y = 205},
        {名称 = '何小姐', x = 97, y = 30},
        {名称 = '黄火牛', x = 402, y = 218},
        {名称 = '满堂春', x = 335, y = 62},
        {名称 = '顶天柱', x = 309, y = 125},
        {名称 = '胡巧儿', x = 237, y = 89},
    },
    [1122] = {
        {名称 = '孤魂野鬼', x = 89, y = 11},
    },
    [1217] = {
        {名称 = '采桃仙女', x = 69, y = 70},
        {名称 = '桃花仙', x = 87, y = 136},
    },
    [1194] = {
        {名称 = '莽汉', x = 88, y = 30},
        {名称 = '老猴精', x = 27, y = 29},
        {名称 = '苦行者', x = 162, y = 3},
        {名称 = '五指山土地', x = 253, y = 48},
        {名称 = '山妖', x = 320, y = 34},
    },
    [1193] = {
        {名称 = '老贾', x = 46, y = 215},
        {名称 = '梅花仙', x = 106, y = 226},
    }
}

local 战斗NPC = {
    {名称 = '蟠桃凤凰' , x = 25 , y = 36},
    {名称 = '蟠桃神灵' , x = 41 , y = 79},
    {名称 = '蟠桃神灵' , x = 68 , y = 95}
}

local 地图ID表 = {1174, 1070, 1091, 1123, 1031, 1141, 1092, 1127, 1128, 1005, 1004, 1131, 1132, 1133,1007, 1011, 1198, 1199, 1200, 1108, 1140, 1110, 1173, 1236, 1122, 1217, 1194, 1193}

local 任务 = {
    名称 = '日常_任务链',
    别名 = '任务链',
    类型 = '常规玩法',
    是否可取消 = true,
    是否可追踪 = true
}

function 任务:任务初始化()
end

local __详情 = {
    '#Y任务目的:#r#W击杀#Y#u%s#W#u中的#u#G#m({%s,%s,%s})%s#m#u#W后前往#Y#u%s#W#u找#u#G#m({%s,%s,%s})%s#m#u#W复命。#r任务进度:%s/200#r剩余时间:%s',
    '#Y任务目的:#r#W找到#Y#u%s#W#u中的#u#G#m({%s,%s,%s})%s#m#u#W。#r任务进度:%s/200#r剩余时间:%s',
    '#Y任务目的:#r#W将#G%s#W交给#Y#u%s#W#u中的#u#G#m({%s,%s,%s})%s#m#u#W。#r任务进度:%s/200#r剩余时间:%s'
}
function 任务:任务取详情(玩家)
    if self.NPC and self.MAP then
        local map = 玩家:取地图(self.MAP)
        if self.分类 == 1 then
            return string.format( __详情[self.分类] , '蟠桃园后' , map.名称, self.战斗NPC.x , self.战斗NPC.y , self.战斗NPC.名称 , map.名称 , self.NPC.x , self.NPC.y , map.名称, self.NPC.名称 , self.环数 , 获取剩余时间(self.时间 - os.time()))
        elseif self.分类 == 2 then
            return string.format( __详情[self.分类] , map.名称 , map.名称 , self.NPC.x , self.NPC.y , self.NPC.名称 , self.环数 , 获取剩余时间(self.时间 - os.time()))
        elseif self.分类 == 3 then
            return string.format( __详情[self.分类] , self.物品 , map.名称, map.名称 , self.NPC.x , self.NPC.y , self.NPC.名称 , self.环数 , 获取剩余时间(self.时间 - os.time()))
        end
    end
    return ''
end

function 任务:任务更新(sec,玩家)
    if self.时间 <=sec then
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
end

function 任务:添加任务(玩家)
    self.时间 = os.time() + 获取当日剩余时间()
    self.环数 = 1
    玩家:刷新追踪面板()
    return self:置任务(玩家)
end

function 任务:置任务(玩家)
    self.NPC = {}
    self.战斗NPC = {}
    self.物品 = ''
    self.分类 = math.random(1, 3)--1=杀怪,2=寻人,3=送物品
    self.MAP = 地图ID表[math.random(1, #地图ID表)]
    local 随机 = NPC表[self.MAP][math.random(1, #NPC表[self.MAP])]
    self.NPC = {
        名称 = 随机.名称,
        X = 随机.x,
        Y = 随机.y
    }
    if self.分类 == 1 then
        随机 = 战斗NPC[math.random(1, #战斗NPC)]
        self.战斗NPC = {
            名称 = 随机.名称,
            X = 随机.x,
            Y = 随机.y
        }
    elseif self.分类 == 3 then
        self.物品 = 取任务链随机装备()
        玩家:添加物品({ 生成物品 { 名称 = self.物品 } })
    end
    local 对话 = {
        [1] = {
            string.format('#R%s#W的钱被一个叫做#R%s#W的怪物抢了，最近在#R蟠桃园后#W看见过，你去把他杀了，然后去告诉%s吧！',self.NPC.名称,self.战斗NPC.名称,self.NPC.名称)
        },
        [2] = {
            string.format('#R%s#W四处错乱，害了不少无辜生灵了，却不知藏身何处了，劳请将之找出来~',self.NPC.名称),
            string.format('见到#R%s#W的时候帮我带句话,说我最近很忙,一直没时间,改天一定去拜访。',self.NPC.名称),
            string.format('上次被#R%s#W欺负了，你帮我找找他在哪，我好叫人报仇去~',self.NPC.名称),
            string.format('原来#R%s#W是神仙啊，真是闯祸了，昨天来的时候还被我家的狗咬了一口，你能帮我去给赔个不是吗？我是不敢去了。',self.NPC.名称),
            string.format('#R%s#W是仙就了不起了，我就是看他不爽，帮我找找在哪我去给他点颜色看看？',self.NPC.名称),
            string.format('#R%s#W这妖孽，好在还没有形成祸害，还速请探知方位，好去收服。',self.NPC.名称)
        },
        [3] = {
            string.format('上次#R%s#W托我带一件#G%s#W，现在找到了，你能帮我送过去吗？',self.NPC.名称 , self.物品),
            string.format('不就是#G%s#W吗？我这里多的是，#R%s#W要我就给他一个了，你帮忙送过去吧。',self.物品 , self.NPC.名称),
            string.format('本来懒得理#R%s#W，看他找#G%s#W快找疯了，就帮他实现下他的愿望吧。',self.NPC.名称 , self.物品),
            string.format('我当#G%s#W是什么宝贝，这破烂东西好像#R%s#W正着急找呢，遇到他就帮我带回去吧。',self.物品 , self.NPC.名称),
            string.format('上次经过#R%s#W家见#G%s#W，一时兴起就拿了回来，我看也该还回去了。',self.NPC.名称 , self.物品),
            string.format('#R%s#W好像正在找#G%s#W，看你也是一个好心人，能不能劳驾给帮忙带过去~',self.NPC.名称 , self.物品)
        },
    }
    local 临时对话 = 对话[self.分类][math.random(1, #对话[self.分类])]
    return 临时对话
end

function 任务:完成(玩家)
    local 金钱 = math.floor(5000 + ( 5000 * (玩家.等级 / 15) ) + self.环数 * 100)
    if math.random(100) <= 10 then
        金钱 = 金钱 * 5
        玩家:发送系统('天降福星！#Y'..玩家.名称..'#W做普通任务竟然得到了#R'..金钱..'两银子惊喜奖励！')
    end
    玩家:添加银子(金钱, "任务链")
    if self.环数 == 5 then
        玩家:添加物品({ 生成物品 { 名称 = '乌金', 数量 = 1 } })
    elseif self.环数 == 10 then
        玩家:添加物品({ 生成物品 { 名称 = '金刚石', 数量 = 1 } })
    elseif self.环数 == 20 then
        玩家:添加物品({ 生成物品 { 名称 = '寒铁', 数量 = 1 } })
    elseif self.环数 == 40 then
        玩家:添加物品({ 生成物品 { 名称 = '百炼精铁', 数量 = 1 } })
    elseif self.环数 == 60 then
        玩家:添加物品({ 生成物品 { 名称 = '龙之鳞', 数量 = 1 } })
    elseif self.环数 == 80 then
        玩家:添加物品({ 生成物品 { 名称 = '千年寒铁', 数量 = 1 } })
    elseif self.环数 == 120 then
        玩家:添加物品({ 生成物品 { 名称 = '天外飞石', 数量 = 1 } })
    elseif self.环数 == 160 then
        玩家:添加物品({ 生成物品 { 名称 = '盘古精铁', 数量 = 1 } })
    elseif self.环数 == 200 then
        if math.random(100) <= 30 then
            local r = 生成物品 { 名称 = '补天神石', 数量 = 2 }
            玩家:添加物品({r})
            玩家:发送系统('出手不凡！#Y'..玩家.名称..'#W普通任务得到了#Y两块#m('..r.nid..')['..r.名称..']#m#n')
        else
            玩家:添加物品({ 生成物品 { 名称 = '补天神石', 数量 = 1 } })
        end
        self:任务取消(玩家)
        self:删除()
        return false
    end
    self.环数 = self.环数 + 1
    return true
end

function 任务:掉落包(玩家, 次数)

end

--===============================================

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == self.战斗NPC.名称 and self.分类 == 1 then
        local r = 玩家:进入战斗('scripts/task/日常/日常_任务链.lua',self)
        if r then
            r = self:完成(玩家)
            if r then
                local a = self:置任务(玩家)
                玩家:最后对话(a,NPC.外形)
            end
        end
    end
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    if NPC.名称 == self.NPC.名称 and self.分类 == 3 then
        if items[1] and items[1].名称 == self.物品 then
            local r = self:完成(玩家)
            if r then
                items[1]:接受(1)
                local a = self:置任务(玩家)
                玩家:最后对话(a,NPC.外形)
            end
        else
            NPC.台词 = '你给我东西干嘛'
        end
    end
end

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == self.NPC.名称 and self.分类 == 2 then
        local r = self:完成(玩家)
        if r then
            local a = self:置任务(玩家)
            NPC.台词 = a
        end
    end
end

--===============================================

function 任务:战斗初始化(玩家, 任务)
    local _怪物 = {
        蟠桃凤凰 = {
            {名称 = '蟠桃凤凰' , 外形 = 2071 , 等级 = 玩家.等级 , 血初值 = 200 , 法初值 = 100 , 攻初值 = 100 , 敏初值 = 50},
            {名称 = '孤魂野鬼' , 外形 = 2049 , 等级 = 玩家.等级 , 血初值 = 150 , 法初值 = 100 , 攻初值 = 100 , 敏初值 = 20}
        },
        蟠桃神灵 = {
            {名称 = '蟠桃神灵' , 外形 = 2068 , 等级 = 玩家.等级 , 血初值 = 200 , 法初值 = 100 , 攻初值 = 100 , 敏初值 = 50},
            {名称 = '孤魂野鬼' , 外形 = 2049 , 等级 = 玩家.等级 , 血初值 = 150 , 法初值 = 100 , 攻初值 = 100 , 敏初值 = 20}
        },
        蟠桃女娲 = {
            {名称 = '蟠桃女娲' , 外形 = 2290 , 等级 = 玩家.等级 , 血初值 = 200 , 法初值 = 100 , 攻初值 = 100 , 敏初值 = 50},
            {名称 = '孤魂野鬼' , 外形 = 2049 , 等级 = 玩家.等级 , 血初值 = 150 , 法初值 = 100 , 攻初值 = 100 , 敏初值 = 20}
        }
    }
    if _怪物[任务.战斗NPC.名称] then
        if 任务.环数 < 120 then
            for i=1,math.random(4, 6) do
                local r = {}
                if i == 1 then
                    r = 生成战斗怪物(生成怪物属性(_怪物[任务.战斗NPC.名称][i] , '中等'))
                else
                    r = 生成战斗怪物(生成怪物属性(_怪物[任务.战斗NPC.名称][2] , '简单'))
                end
                self:加入敌方(i, r)
            end
        elseif 任务.环数 < 160 then
            for i=1,math.random(5, 8) do
                local r = {}
                if i == 1 then
                    _怪物[任务.战斗NPC.名称][i].血初值 = _怪物[任务.战斗NPC.名称][i].血初值 * 2
                    r = 生成战斗怪物(生成怪物属性(_怪物[任务.战斗NPC.名称][i] , '困难' , nil , '中级法术' ))
                else
                    _怪物[任务.战斗NPC.名称][2].血初值 = _怪物[任务.战斗NPC.名称][2].血初值 * 2
                    r = 生成战斗怪物(生成怪物属性(_怪物[任务.战斗NPC.名称][2] , '中等' , nil , '低级法术'))
                end
                self:加入敌方(i, r)
            end
        elseif 任务.环数 < 200 then
            for i=1,math.random(6, 10) do
                local r = {}
                if i == 1 then
                    _怪物[任务.战斗NPC.名称][i].血初值 = _怪物[任务.战斗NPC.名称][i].血初值 * 4
                    r = 生成战斗怪物(生成怪物属性(_怪物[任务.战斗NPC.名称][i] , '困难' , nil , '高级法术' ))
                else
                    _怪物[任务.战斗NPC.名称][2].血初值 = _怪物[任务.战斗NPC.名称][2].血初值 * 4
                    r = 生成战斗怪物(生成怪物属性(_怪物[任务.战斗NPC.名称][2] , '中等' , nil , '中级法术'))
                end
                self:加入敌方(i, r)
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
























