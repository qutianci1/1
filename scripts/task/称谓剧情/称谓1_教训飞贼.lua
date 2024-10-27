-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-04-10 01:17:55
local 任务 = {
    名称 = '称谓1_教训飞贼',
    别名 = '教训飞贼(一称)',
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
	'	前往#Y长安(279,183)#W找#u#G#m({长安,279,183})杜老板#m#u#W聊聊！',
	'	前往#Y大唐境内(304,85)#W的山路上看看，教训那群抢药的#u#G#m({大唐境内,199,119})飞贼#m#u#W并杀了他。（ALT+A飞贼）',
    '	你成功的击杀了飞贼，快回去找#Y长安(279,199)#W找#u#G#m({长安,279,183})杜老板#m#u#W复命吧。'
}


local _追踪描述 = {
	'	前往#Y长安(279,183)#W找#u#G#m({长安,279,183})杜老板#m#u#W聊聊！',
	'	前往#Y大唐境内(304,85)#W的山路上看看，教训那群抢药的#u#G#m({大唐境内,199,119})飞贼#m#u#W并杀了他。（ALT+A飞贼）',
    '	你成功的击杀了飞贼，快回去找#Y长安(279,183)#W找#u#G#m({长安,279,183})杜老板#m#u#W复命吧。'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end

function 任务:任务取详情(玩家)
    return _详情[self.进度+1]
end

local _台词 = {
    '该死的强盗，每次来我这里拿药都不付钱。要是你能帮我去教训他一顿的话我一定会报答你的!那些强盗一般经常在#R长安西#w的山路上出现。',
    --1
    '太好了，这下可出了一口恶气!作为报答，我送你1000两银子!',
    --2
    '哈哈，这个老板还是挺慷慨的嘛!'
    --3
}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '杜老板' and NPC.台词 then
        if self.进度 == 0 then
            NPC.台词 = _台词[1]
            self.进度 = 1
			玩家:刷新追踪面板()
        elseif self.进度 == 2 then
            NPC.台词 = _台词[2]
            NPC.结束 = false
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '杜老板' then
        if self.进度 == 2 then
            NPC.头像 = 玩家.原形
            NPC.台词 = _台词[3]
            NPC.结束 = nil
            self:完成(玩家)
        end
    end
end

function 任务:完成(玩家)
    玩家:添加银子(3000)
    玩家:添加声望(15)
    玩家:提示窗口('#Y由于你的英勇你在这个世界的名望得到了提升，获得15点声望值和3000两银子。')
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:一称完成检测(玩家, '飞贼')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
    if self.进度 == 1 then
        if NPC.名称 == '抢药的飞贼' then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓1_教训飞贼.lua', self)
            if r then
                self.进度 = 2
				玩家:提示窗口('#R你成功的击杀了飞贼，快回去找#G杜老板#W复命吧。')
				玩家:刷新追踪面板()
            end
        end
    end
end

local _怪物 = {
    { 名称 = "飞贼", 外形 = 2044, 气血 = 600, 魔法 = 1, 攻击 = 59, 速度 = 1 }
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
