-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-10-26 18:13:51
local 任务 = {
    名称 = '称谓3_山贼之灵',
    别名 = '山贼之灵(三称)',
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
    '	前往#Y斧头帮#W找#u#G#m({斧头帮,63,82})二当家#m#u#W聊聊！',
    '	为了加入斧头帮，去#Y大雁塔六层#W打败#u#G#m({大雁塔六层,50,50})山贼之灵#m#u#W。#Y（ALT+A攻击山贼之灵）',
    '	打败山贼之灵了，回去#Y斧头帮#W找#u#G#m({斧头帮,69,84})二当家#m#u#W加入斧头帮吧。'
}

local _追踪描述 = {
    '	前往#Y斧头帮#W找#u#G#m({斧头帮,63,82})二当家#m#u#W聊聊！',
    '	为了加入斧头帮，去#Y大雁塔六层#W打败#u#G#m({大雁塔六层,50,50})山贼之灵#m#u#W。#Y（ALT+A攻击山贼之灵）',
    '	打败山贼之灵了，回去#Y斧头帮#W找#u#G#m({斧头帮,69,84})二当家#m#u#W加入斧头帮吧。'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '什么你说你想要加入斧头帮，想当一个好山贼?这可不是那么简单地，这可是要经历许多考验地! !你想当个山贼吗? ...哎，别推辞了，我知道你想当，当山贼是一份多么有前途的职业呀! !你想当你就说嘛，你不说我怎么知道呢。对不对?好，想当山贼首先就要接受入门级的考验，也就是去#R大雁塔六层#W干掉我们山贼的祖师爷一一#R山贼之灵#W。别害怕，我相信你，你行地！',
    --1
    '有没有搞错啊~不去行不行啊，又是这么老套的任务。',
    --2
    '哇，你真的能打败山贼之灵?厉害厉害，连我都打不过....好，从现在开始，你就是我斧头帮的一员了。做一个最好的山贼，继续努力吧！'
    --3
}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '二当家' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度==2 then
            NPC.台词 = _台词[3]
            NPC.结束 = nil
            self:完成(玩家)
            玩家:刷新追踪面板()
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '二当家' then
        if self.进度 == 0 then
            if self.对话进度 == 0 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[2]
                NPC.结束 = nil
                self.进度 = 1
                玩家:刷新追踪面板()
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(10)
    玩家:添加称谓('斧头帮小虾米')
    玩家:提示窗口('#Y因为你的勇气可嘉，你在这个世界的声望得到了提升，获得10点声望和和斧头帮小虾米的称号。')

    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:三称完成检测(玩家, '山贼')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if self.进度 == 1 then
        if NPC.名称 == '山贼之灵'  then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓2_水陆大会.lua', self)
            if r then
                self.进度 = 2
                玩家:添加银子(4268)
                玩家:添加经验(15847)
                玩家:常规提示('#R你打败了山贼之灵，获得了15847经验和4268两银子！')
                玩家:刷新追踪面板()
            end
        end
    end
end



function 任务:战斗初始化(玩家)
    -- print('进入战斗cnm')
    for i = 1, 1 do
        local r = 生成战斗怪物(_怪物[i])
        self:加入敌方(i, r)
    end
end


function 任务:战斗初始化(玩家)
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
