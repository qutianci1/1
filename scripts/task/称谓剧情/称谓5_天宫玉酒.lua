-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-10 23:34:35
-- @Last Modified time  : 2024-10-26 20:37:14
local 任务 = {
    名称 = '称谓5_天宫玉酒',
    别名 = '天宫玉酒(五称)',
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
    '	前往#Y大唐边境#W找#u#G#m({大唐边境,436,155})牛妖#m#u#W聊聊！',
    '	去#Y凌霄宝殿#W找#u#G#m({凌霄宝殿,57,97})王母娘娘#m#u#W要瓶玉酒过来。#R（对话结束后进入战斗）',
    '	将天宫的玉酒交给#u#G#m({魔王寨,19,12})牛魔王#m#u'
}
local _追踪描述 = {
    '	前往#Y大唐边境#W找#u#G#m({大唐边境,436,155})牛妖#m#u#W聊聊！',
    '	去#Y凌霄宝殿#W找#u#G#m({凌霄宝殿,57,97})王母娘娘#m#u#W要瓶玉酒过来。#R（对话结束后进入战斗）',
    '	将天宫的玉酒交给#u#G#m({魔王寨,19,12})牛魔王#m#u'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '伤脑筋，真伤脑筋---大王马上就要和青青成婚了，可到现在还没拿的出手的喜酒，要是到了婚礼上还这样的话，我们一定会被大王用三昧真火烧死的',
    --1
    '想要玉酒可没那么容易，最少，得看看我的宠物同不同意，哦呵呵呵! !',
    --2
    '什么？还要打仗？',
    --3
    '玉酒，玉酒，时隔五百年我又喝上了这玉酒。上一回，喝这玉酒是和孙猴子那时候孙猴子跑到天庭去做了弼马温，背叛了小白，我喝了这酒与他断绝了兄弟情义'
    --4
}

function 任务:任务NPC对话(玩家, NPC)
NPC.头像 = NPC.外形
    if NPC.名称 == '牛妖' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            self.进度 = 1
            玩家:刷新追踪面板()
        end
    elseif NPC.名称 == '王母娘娘' and NPC.台词 then
        if self.进度 == 1 then
            self.对话进度 = 0
            NPC.台词 = _台词[2]
            NPC.结束 = false
        end
    elseif NPC.名称 == '牛魔王' and NPC.台词 then
        if self.进度 == 2 then
                local a =  玩家:取物品是否存在("天宫玉酒")
                if a  then
                else
                    NPC.台词 = "我要的东西呢？"
                    return
                end
                local  b =    玩家:取物品是否存在("天宫玉酒")
                if  b then
                        b:减少(1)
                end
            NPC.头像 = NPC.外形
             NPC.台词 = _台词[4]
            self:完成(玩家)
            玩家:刷新追踪面板()
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '王母娘娘' then
        if self.进度 == 1 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[3]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                self:任务攻击事件(玩家, NPC)
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(400)
    玩家:添加银子(8000)
    玩家:提示窗口('#Y你完成了牛妖的托付，你在这个世界的声望得到了提升，获得400点声望。')
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:五称完成检测(玩家, '玉酒')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    -- if NPC.名称 == '牛魔王' then
        if self.进度 == 2 then
            if items[1] and items[1].名称 == '天宫玉酒' then --
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
					玩家:常规提示('#Y给予了'..NPC.名称..items[1].名称)
                    NPC.头像 = NPC.外形
                    NPC.台词 = _台词[4]
                    self:完成(玩家)
                    玩家:刷新追踪面板()
                end
            end
        end
    -- end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '王母娘娘' then
        if self.进度 == 1 and self.对话进度 == 2 then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓5_天宫玉酒.lua', self)
            if r then
                self.进度 = 2
                玩家:添加物品({生成物品 {名称 = '天宫玉酒', 数量 = 1}})
                玩家:刷新追踪面板()
            end
        end
    end
end

local _怪物 = {
    { 名称 = "凤凰", 外形 = 2071, 气血 = 60060, 魔法 = 19000, 攻击 = 5200, 速度 = 260,技能={'地狱烈火','天雷怒火','三味真火'} }
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
