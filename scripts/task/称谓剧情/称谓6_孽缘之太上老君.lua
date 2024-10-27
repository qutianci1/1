-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-10-26 20:38:00

local 任务 = {
    名称 = '称谓6_孽缘之太上老君',
    别名 = '孽缘之太上老君(六称)',
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
	'  前往#Y方寸山#W找#u#G#m({方寸山,31,13})道士#m#u#W聊聊！',
	'  前往#Y天宫#W找#u#G#m({老君丹房,11,5})太上老君#m#u#W聊聊！',
	'  回去#Y方寸山#W告诉#u#G#m({方寸山,31,13})道士#m#u#W老君的情况.',
}
local _追踪描述 = {
	'  前往#Y方寸山#W找#u#G#m({方寸山,31,13})道士#m#u#W聊聊！',
	'  前往#Y天宫#W找#u#G#m({老君丹房,11,5})太上老君#m#u#W聊聊！',
	'  回去#Y方寸山#W告诉#u#G#m({方寸山,31,13})道士#m#u#W老君的情况.',
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '我们道家子弟的最高梦想就是见一见道门始祖#R太上老君#W，以我的功力是没有可能去#R天宫#W了，你能帮我去实现这个理想吗?',
    --1
    '恩，反正这事也不算太难，就帮你吧。',
    --2
    '快走吧快走吧，我忙着呢，别烦我!',
    --3
    '老道~我只是受人之托来拜访你，否则我才不理你呢!',
    --4
    '啊，太上老君跟你说话了呢，5555....真羡慕。谢谢你帮我实现了梦想!',
    --5
    '哎，这算什么梦想啊....'
    --6
}

function 任务:任务NPC对话(玩家, NPC)
    NPC.头像 = NPC.外形
    if NPC.名称 == '道士' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            self.对话进度 = 0
            NPC.台词 = _台词[5]
            NPC.结束 = false
        end
    elseif NPC.名称 == '太上老君' and NPC.台词 then
        if self.进度 == 1 then
            self.对话进度 = 0
            NPC.台词 = _台词[3]
            NPC.结束 = false
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '道士' then
        if self.进度 == 0 then
            if self.对话进度 == 0 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[2]
                NPC.结束 = nil
                self.进度 = 1
                玩家:刷新追踪面板()
            end
        elseif self.进度 == 2 then
            if self.对话进度 == 0 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[2]
                NPC.结束 = nil
                self:完成(玩家)
                玩家:刷新追踪面板()
            end
        end
    elseif NPC.名称 == '太上老君' then
        if self.进度 == 1 then
            if self.对话进度 == 0 then
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[4]
                NPC.结束 = nil
                self.进度 = 2
                玩家:刷新追踪面板()
            end
        end
    end
end

function 任务:完成(玩家)
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:六称完成检测(玩家, '老君')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
end

function 任务:任务攻击事件(玩家, NPC)
end

function 任务:战斗初始化(玩家)
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
