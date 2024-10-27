-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-10-26 18:56:38
local 任务 = {
    名称 = '称谓3_羊脂仙露',
    别名 = '羊脂仙露(三称)',
    类型 = '称谓剧情',
    是否可取消 = false,
	是否可追踪 = true
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    --self:删除()--
end

function 任务:任务更新(玩家, sec)
end

local _详情 = {
    '	前往#Y斧头帮#W找#u#G#m({斧头帮,58,76})三当家#m#u#W聊聊！',
	'   去#Y长寿村找#u#G#m({长寿村丹房,11,7})药店老板#m#u#W买个#Y羊脂仙露#W回来，交给#u#G#m({斧头帮,58,76})三当家#m#u'
}

local _追踪描述 = {
    '	前往#Y斧头帮#W找#u#G#m({斧头帮,58,76})三当家#m#u#W聊聊！',
	'   去#Y长寿村找#u#G#m({长寿村丹房,11,7})药店老板#m#u#W买个#Y羊脂仙露#W回来，交给#u#G#m({斧头帮,58,76})三当家#m#u'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end


function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '前些天，一个外号桃花杀手的女人路过我们帮，说是要找什么转世孙悟空，我们这里明明是斧头帮嘛，哪有什么转世孙悟空，可那个女人就是不明白这个道理，还硬要看我们的脚底板，我们这些帮众的脚底板看了也就看啦，我们尊贵的帮主的脚底板怎么能随便看呢?一言不合，两人就打起来啦，我们帮主因为恰好处在生理上的低潮期，所以功夫嘛，就比平时低了那么一点点，结果，就中了那个女人的八~~~伤~~~~~~~~~拳!',
    --1
    '(这个疯子~乱七糟说的一堆废话〉中了这个伤以后会怎么样?',
    --2
    '太好了，你居然可以把这个药找到了!看来帮主的伤一定有救了! !为了感谢和报答你，我决定把我昨天买酒剩下的钱给你。'
    --3
}

function 任务:任务NPC对话(玩家, NPC)
    NPC.头像 = NPC.外形
    if NPC.名称 == '三当家' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 1 then
                NPC.头像 = NPC.外形
                local a =  玩家:取物品是否存在("羊脂仙露")
                if a  then
                else
                    NPC.台词 = "我要的东西呢？"
                    return
                end
                local  b =    玩家:取物品是否存在("羊脂仙露")
                if  b then
                        b:减少(1)
                end
                NPC.台词 = _台词[3]
                NPC.结束 = nil
                 self:完成(玩家)
                 玩家:刷新追踪面板()
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '三当家' then
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
    玩家:添加声望(60)
    玩家:添加银子(200)
    玩家:提示窗口('#Y因为你的热心助人，你在这个世界的声望得到提升，获得60点声望，200两银子。')

    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:三称完成检测(玩家, '仙露')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    -- if NPC.名称 == '三当家' then
        if self.进度 == 1 then
            if items[1] then --
                if items[1].名称=='羊脂仙露' then
                    if items[1].数量 >= 1 then
                        items[1]:接受(1)
                        NPC.头像 = NPC.外形
                        NPC.台词 = _台词[3]
                        NPC.结束 = nil
                        self:完成(玩家)
                        玩家:刷新追踪面板()
                    end
                end
            end
        end
    -- end
end

function 任务:任务攻击事件(玩家, NPC)

end
local _怪物 = {
    { 名称 = "伶俐鬼", 外形 = 2059, 气血 = 8400, 魔法 = 1, 攻击 = 1300, 速度 = 21 },
}
function 任务:战斗初始化(玩家)
    self:加入敌方(1, 生成战斗怪物(_怪物[1]))
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
