-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-10-26 18:13:35
local 任务 = {
    名称 = '称谓3_夜光珠',
    别名 = '夜光珠(三称)',
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
    '	前往#Y五指山#W找#u#G#m({五指山,114,145})晶晶姑娘#m#u#W聊聊！',
    '	去江洲城#Y大唐境内#W找#u#G#m({大唐境内,432,218})伶俐鬼#m#u#W。#Y（ALT+A攻击伶俐鬼）',
    '	找回夜光珠， 跟#u#G#m({五指山,114,145})晶晶姑娘#m#u#W聊聊！',
    '	把晶晶姑娘的夜光珠交给，#u#G#m({帮主住房,18,12})至尊小宝#m#u'
}

local _追踪描述 = {
    '	前往#Y五指山#W找#u#G#m({五指山,114,145})晶晶姑娘#m#u#W聊聊！',
    '	去江洲城#Y大唐境内#W找#u#G#m({大唐境内,432,218})伶俐鬼#m#u#W。#Y（ALT+A攻击伶俐鬼）',
    '	找回夜光珠， 跟#u#G#m({五指山,114,145})晶晶姑娘#m#u#W聊聊！',
    '	把晶晶姑娘的夜光珠交给，#u#G#m({帮主住房,18,12})至尊小宝#m#u'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end



function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '长夜漫漫，无心睡眠，我睡不着，难道你也睡不着? ..哎，难道你也是因为心中有着想念的人儿无法入睡?如果只你也有喜欢的人，你会怎么向他表白心意呢?哎，说这些也许你会笑我...对了，这里有一个专偷人宝物的妖怪小偷，名字叫做伶俐鬼，很嚣张，我的夜光珠也被她盗走了。这件宝物对我来说至关重要你能帮我夺回来吗?',
    --1
    '晶晶姑娘如此美丽，还有人..哦是鬼，敢偷你的东西呀?',
    --2
    '她偷了我的夜光珠以后就逃走了，现在似乎藏匿在江州一带。',
    --3
    '啊，真的是夜光珠。本来我没抱太多希望了呢，没想到你真的做到了!太谢谢你！',
    --4
    '小意思， 不就是一个小鬼嘛， 举手之劳啦~',
    --5
    '这颗夜光珠，我本来是准备送给斧头帮帮主的，作为，作为表白心意的礼物没错，我喜欢的人就是他，从第一眼见到就觉得我们前世是认识的，有一种非常熟悉的感觉，这就是人们所说的缘分吗? ...可是，我实在没胆子亲手把这夜光珠交给他，我害怕...如果可以，你能帮我把这夜光珠交给帮主吗?',
    --6
    '哇~这么肉麻的话你还是留着和帮主说吧。我闪先~',
    --7
    '什么?这是晶晶姑娘送给我的?没想到晶晶姑娘竟会喜欢身为山贼，粗犷一面的我，我真是太太太太太太意外了. ..我不会辜负晶晶姑娘的心意地，我决定- ........和她结婚! ! !这些钱给你买酒喝。',
    --8
    '(汗) .-.这家伙真是太傻瓜了，简.....人类之耻....'
    --9
}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '晶晶姑娘' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            self.对话进度 = 0
            NPC.台词 = _台词[4]
            NPC.结束 = false
        end
    elseif NPC.名称 == '至尊小宝' and NPC.台词 then
        if self.进度 == 3 then
            self.对话进度 = 1
                NPC.头像 = NPC.外形
                local a =  玩家:取物品是否存在("夜光珠")
                if a  then
                else
                    NPC.台词 = "我要的东西呢？"
                    return
                end
                local  b =    玩家:取物品是否存在("夜光珠")
                if  b then
                        b:减少(1)
                end
                NPC.台词 = _台词[8]
                NPC.结束 = false
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '晶晶姑娘' then
        if self.进度 == 0 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[2]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[3]
                NPC.结束 = nil
                self.进度 = 1
                玩家:刷新追踪面板()
            end
        elseif self.进度 == 2 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[5]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[6]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[7]
                NPC.结束 = nil
                self.进度=3
                玩家:刷新追踪面板()
            end
        end
    elseif  NPC.名称 == '至尊小宝' then
        if self.进度==3 then
			if self.对话进度 == 1 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[9]
                NPC.结束 = nil
                self:完成(玩家)
                玩家:刷新追踪面板()
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(90)
    玩家:提示窗口('#Y因为你的热心助人，你在这个世界的声望得到提升，获得90点声望，900两银子。')

    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:三称完成检测(玩家, '夜光珠')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    -- if NPC.名称 == '至尊小宝' then
        if self.进度 == 3 then
                if items[1].名称=='夜光珠' then
                    if items[1].数量 >= 1 then
                        items[1]:接受(1)
                        NPC.头像 = NPC.外形
						玩家:常规提示('#Y给予了'..NPC.名称..items[1].名称)					
						玩家:常规提示( '什么?这是晶晶姑娘送给我的?没想到晶晶姑娘竟会喜欢身为山贼，粗犷一面的我，我真是太太太太太太意外了. ..我不会辜负晶晶姑娘的心意地，我决定- ........和她结婚! ! !这些钱给你买酒喝。')
                        NPC.结束 = nil
                        self:完成(玩家)
                    end
            end
        end
    -- end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '伶俐鬼' then
        if self.进度 == 1 then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓3_羊脂仙露.lua', self)
            if r then
                self.进度 = 2
                玩家:添加银子(4587)
                玩家:添加经验(324541)
                玩家:添加物品 { 生成物品 { 名称 = '夜光珠', 数量 = 1 }}
                玩家:常规提示('#R你打败了伶俐鬼，获得324541经验和4587银两和夜光洙！')
                玩家:刷新追踪面板()
            end
        end
    end
end

local _怪物 = {
    { 名称 = "伶俐鬼", 外形 = 2059, 气血 = 8400, 魔法 = 1, 攻击 = 1300, 速度 = 21 },
}

function 任务:战斗初始化(玩家)
    self:加入敌方(1, 生成战斗怪物(_怪物[1]))
end

function 任务:战斗初始化(玩家)
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
