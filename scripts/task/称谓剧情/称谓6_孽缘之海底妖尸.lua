-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-10-26 20:39:15


local 任务 = {
    名称 = '称谓6_孽缘之海底妖尸',
    别名 = '孽缘之海底妖尸(六称)',
    类型 = '称谓剧情',
    是否可取消 = false,
	是否可追踪 = true
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务更新(玩家, sec)
end

local _详情 = {
	'  前往#Y方寸山#W找#u#G#m({方寸山,25,32})游方术士#m#u#W聊聊！',
	'  前往#Y海底迷宫三层#W解决掉#u#G#m({海底迷宫三层,57,30})千年妖尸#m#u#W,拿回剃刀。#Y（对千年妖尸进行ALT+A攻击）',
	'  已击败千年妖尸,回去向#u#G#m({方寸山,25,32})游方术士#m#u#W汇报！'
}
local _追踪描述 = {
	'  前往#Y方寸山#W找#u#G#m({方寸山,25,32})游方术士#m#u#W聊聊！',
	'  前往#Y海底迷宫三层#W解决掉#u#G#m({海底迷宫三层,57,30})千年妖尸#m#u#W,拿回剃刀。#Y（对千年妖尸进行ALT+A攻击）',
	'  已击败千年妖尸,回去向#u#G#m({方寸山,25,32})游方术士#m#u#W汇报！'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '唉。。。。唉。。。唉。。。。',
    --1
    '这位老兄，你干嘛唉声叹气?',
    --2
    '我不知道该不该告诉你这桩事，但这个麻烦如果不解决的话，我的修行将无法继续下去。',
    --3
    '那你就告诉我吧，也许我就是上天安排来帮助你解决问题的。',
    --4
    '看你是热心人，我就告诉你吧。每个术士在修炼的过程中身上都会带着那把剃度的剃刀，这把刀凝结了术士的功力，就像他的生命一样和术士共同成长.而我的刀被来自#R海底迷宫三层#W的一只修炼千年以上的#R妖尸#W夺走了，假以时日，妖尸会吸去刀上的全部功力，那时候我多年的修行就全完了。',
    --5
    '看你这么可怜，我是要去帮你拿回来了',
    --6
    '啊，这正是我的剃刀!这下我多年的修行可保住了..多谢你!这是我平时炼制的一些丹药，也许你在战斗中会用的着。日后你有什么需要我帮忙的话我也会尽力而为!',
    --7
    '呵呵，好说好说啦。'
    --8
}

function 任务:任务NPC对话(玩家, NPC)
    NPC.头像 = NPC.外形
    if NPC.名称 == '游方术士' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            self.对话进度 = 0
            NPC.台词 = _台词[7]
            NPC.结束 = false
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '游方术士' then
        if self.进度 == 0 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[2]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[3]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[4]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self.对话进度 = 4
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[5]
                NPC.结束 = false
            elseif self.对话进度 == 4 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[6]
                NPC.结束 = nil
                self.进度 = 1
                玩家:刷新追踪面板()
            end
        elseif self.进度 == 2 then
            if self.对话进度 == 0 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[8]
                NPC.结束 = nil
                self:完成(玩家)
                玩家:刷新追踪面板()
            end
        end
    end
end


function 任务:完成(玩家)
    玩家:添加声望(1600)
    玩家:常规提示('#Y你打败了海底妖尸，保一方平安获得了1600声望。')
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:六称完成检测(玩家, '妖尸')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '千年妖尸' then
        if self.进度 == 1 then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓6_孽缘之海底妖尸.lua', self)
            if r then
                玩家:添加经验(820000)
                玩家:常规提示('#Y你打败了海底妖尸,剃刀已追回。')
                -- 玩家:添加物品({生成物品 {名称 = '剃刀', 数量 = 1}})
                self.进度 = 2
                玩家:刷新追踪面板()
            end
        end
    end
end

local _怪物 = {
    { 名称 = "海底妖尸", 外形 = 2017, 气血 = 152000, 魔法 = 9101, 攻击 = 10200, 速度 = 233 }
}

function 任务:战斗初始化(玩家)
    for i = 1, 1 do
        local r = 生成战斗怪物(_怪物[i])
        self:加入敌方(i, r)
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
