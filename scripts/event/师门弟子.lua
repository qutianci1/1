-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-27 13:51:21
-- @Last Modified time  : 2024-08-23 22:42:09
--{year =2022, month = 7, day =27, hour =0, min =0, sec = 00}
--年月日 时分秒
local 事件 = {
    名称 = '师门弟子',
    是否打开 = false,
    开始时间 = os.time {year = 2022, month = 7, day = 25, hour = 0, min = 0, sec = 00},
    结束时间 = os.time {year = 2022, month = 7, day = 30, hour = 0, min = 0, sec = 00}
}

function 事件:事件初始化()
    self.NPC = {}
end

local _模型 = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,60,61,62,63,64,65,40,41,42,43,44,45,50,51,52,53,54,55}
local _种族 = {1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,1,1,2,2,3,3,1,1,2,2,3,3}
local _性别 = {1,1,1,2,2,2,1,1,1,2,2,2,1,1,1,2,2,2,1,1,1,2,2,2,1,2,1,2,1,2,1,2,1,2,1,2}
function 事件:更新()
    local _门派 = {'化生寺','方寸山','将军府','女儿村','方寸山','将军府','狮驼岭','魔王寨','地府','盘丝洞','魔王寨','地府','五庄观','天宫','龙宫','普陀山','天宫','龙宫','三尸派','阴都','白骨洞','兰若寺','阴都','白骨洞','化生寺','女儿村','狮驼岭','盘丝洞','五庄观','普陀山','将军府','方寸山','魔王寨','地府','天宫','龙宫'}
    local _技能 = {
        化生寺 = {'反间之计', '情真意切', '谗言相加', '借刀杀人', '失心狂乱'},
        方寸山 = {'催眠咒', '瞌睡咒', '离魂咒', '迷魂醉', '百日眠'},
        将军府 = {'作茧自缚', '金蛇缠丝', '天罗地网', '作壁上观', '四面楚歌'},
        女儿村 = {'蛇蝎美人', '追魂迷香', '断肠烈散', '鹤顶红粉', '万毒攻心'},
        狮驼岭 = {'魔之飞步', '急速之魔', '魔神飞舞', '天外飞魔', '乾坤借速'},
        魔王寨 = {'妖之魔力', '力神复苏', '狮王之怒', '兽王神力', '魔神附身'},
        地府 = {'夺命勾魂', '追神摄魄', '魔音摄心', '销魂蚀骨', '阎罗追命'},
        盘丝洞 = {'红袖添香', '莲步轻舞', '楚楚可怜', '魔神护体', '含情脉脉'},
        五庄观 = {'飞砂走石', '乘风破浪', '太乙生风', '风雷涌动', '袖里乾坤'},
        天宫 = {'雷霆霹雳', '日照光华', '雷神怒击', '电闪雷鸣', '天诛地灭'},
        龙宫 = {'龙卷雨击', '龙腾水溅', '龙啸九天', '蛟龙出海', '九龙冰封'},
        普陀山 = {'地狱烈火', '天雷怒火', '三味真火', '烈火骄阳', '九阴纯火'},
        三尸派 = {'吸血水蛭', '六翅毒蝉', '啮骨抽髓', '血煞之蛊', '吸星大法'},
        阴都 = {'麻沸散', '鬼失惊', '乱魂钉', '失心疯', '孟婆汤'},
        白骨洞 = {'幽冥鬼火', '火影迷踪', '冥烟销骨', '落日熔金', '血海深仇'},
        兰若寺 = {'幽怜魅影', '醉生梦死', '一曲销魂', '秦丝冰雾', '倩女幽魂'}
    }
    local _地图 = {1173,1110,1193,1174,1194,1213,1091,1092}
    for k,v in pairs(_地图) do
        local map = self:取地图(v)
        if map then
            for i=1,50 do
                local X, Y = map:取随机坐标()
                local 随机 = math.random(1, #_模型)
                local NPC =
                    map:添加NPC {
                    名称 = 取随机名称(),
                    称谓 = _门派[随机]..'弟子',
                    外形 = _模型[随机],
                    种族 = _种族[随机],
                    性别 = _性别[随机],
                    门派 = _门派[随机],
                    技能 = _技能[_门派[随机]],
                    脚本 = 'scripts/event/师门弟子.lua',
                    时间 = 1800,
                    X = X,
                    Y = Y,
                    事件 = self
                }
            end
        else
            print('未读取地图',v)
        end
    end
    return not self.是否结束 and 900
end

function 事件:事件开始()
    self:更新('我被更新了')
end

function 事件:事件结束()
    self.是否结束 = true
end
--=======================================================

local _qjxh = { 150000, 200000, 340000, 600000, 900000 }
function 事件:NPC对话(玩家, i)
    local 对话
    if 玩家.种族 == self.种族 then
        local r = self:技能选项(玩家)
        对话 = string.format([[哦！是自己人啊#93那么可以用师门贡献代替银子！要练习哪个法术呢#55
menu
%s
]], table.concat(r, "\n"))
    else
        对话 = [[在下才疏学浅,指导不了你呢#17]]
    end
    return 对话
end

function 事件:技能选项(玩家)
    local 列表 = {}
    if self.技能 then
        for i=1,#self.技能 do
            if not 玩家:取技能是否满熟练(self.技能[i]) and 玩家:取技能是否存在(self.技能[i]) then
                列表[#列表 + 1] = #列表+1 .. '|' .. self.技能[i] .. '(需师门贡献'.._qjxh[i]..')'
            end
        end
    end
    return 列表
end

function 事件:NPC菜单(玩家, i)
    if 玩家.种族 == self.种族 then
        local 消耗 = _qjxh[i + 0]
        if 玩家:扣除师贡(_qjxh[i + 0]) then
            local r = 玩家:进入战斗('scripts/event/师门弟子.lua',self)--60
        end
    end
end

--===============================================


function 事件:战斗初始化(玩家,s)
    local 外形列表 = {}
    for i, v in ipairs(_模型) do
        if _性别[i] == s.性别 and _种族[i] == s.种族 then
            table.insert(外形列表, v)
        end
    end

    local _怪物 = {
        { 名称 = s.名称, 外形 = s.外形, 等级 = 玩家.等级 , 血初值 = 600, 法初值 = 1800, 攻初值 = 200, 敏初值 = 60  , 技能 = s.技能 , 施法几率 = 100 },
        { 名称 = "手下", 外形 = 外形列表[math.random(#外形列表)], 等级 = 玩家.等级 , 血初值 = 600, 法初值 = 1800, 攻初值 = 200, 敏初值 = 60  , 技能 = s.技能 , 施法几率 = 100 },
        { 名称 = "手下", 外形 = 外形列表[math.random(#外形列表)], 等级 = 玩家.等级 , 血初值 = 600, 法初值 = 1800, 攻初值 = 200, 敏初值 = 60  , 技能 = s.技能 , 施法几率 = 100 }
    }
    for i = 1, 3 do
        local r = 生成战斗怪物(生成怪物属性(_怪物[i] , '简单'))
        self:加入敌方(i, r)
    end
end

function 事件:战斗回合开始(dt)
end

function 事件:战斗结束(x, y)
end
--===============================================
function 事件:完成(玩家)
    if 玩家.是否组队 then
        for _, v in 玩家:遍历队伍() do
            self:掉落包(v)
        end
    else
        self:掉落包(玩家)
    end
end
local _掉落 = {
    {几率 = 10, 名称 = '悔梦石', 数量 = 1, 广播 = '#C水水谁%s获得了什么#G#m(%s)[%s]#m#n'},
    {几率 = 10, 名称 = '亲密丹', 数量 = 1, 参数 = 1000}
}
function 事件:掉落包(玩家)
    local 银子 = 0
    local 经验 = 30000 * (玩家.等级 * 0.15)
    玩家:添加参战召唤兽经验(经验 * 1.5)
    玩家:添加银子(银子)
    玩家:添加经验(经验)

    if 玩家:取活动限制次数('小金鲤') >= 200 then
        return
    end
    玩家:增加活动限制次数('小金鲤')
    for i, v in ipairs(_掉落) do
        if math.random(1000) <= v.几率 then
            local r = 生成物品 {名称 = v.名称, 数量 = v.数量, 参数 = v.参数}
            if r then
                玩家:添加物品({r})
                if v.广播 then
                    玩家:发送系统(v.广播, 玩家.名称, r.ind, r.名称)
                end
                break
            end
        end
    end
end
return 事件
