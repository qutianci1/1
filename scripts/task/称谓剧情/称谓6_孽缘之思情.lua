-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-10-26 20:37:56


local 任务 = {
    名称 = '称谓6_孽缘之思情',
    别名 = '孽缘之思情(六称)',
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
	'  前往#Y方寸后山#W找#u#G#m({方寸后山,50,21})陈百万#m#u#W谈谈！',
	'  到#Y长安#W闹市区找#u#G#m({长安,89,68})陈夫人#m#u#W了解生意情况。',
	'  回去#Y方寸后山#W告诉#u#G#m({方寸后山,20,21})陈百万#m#u#W他家的情况。'
}

local _追踪描述 = {
	'  前往#Y方寸后山#W找#u#G#m({方寸后山,50,21})陈百万#m#u#W谈谈！',
	'  到#Y长安#W闹市区找#u#G#m({长安,89,68})陈夫人#m#u#W了解生意情况。',
	'  回去#Y方寸后山#W告诉#u#G#m({方寸后山,50,21})陈百万#m#u#W他家的情况。'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '我是想来山上修道的，不过，我在长安还有好大的产业，让人放心不下...我家有万贯家财，还有年轻美貌的妻子，如果我来山上修道，那我这一片家业交给谁呢?我想找个人去问问我在长安的夫人，看看我的生意现在怎么样了。',
    --1
    '陈百万那个死鬼，说什么要去山上修道，一去就是几年不回来，真是鬼迷心窍了.我已经另嫁人啦，他的那几个店铺现在也归了别人，如果他修成了正果，叫他别忘了下山来看看我们呀，哈哈哈! !',
    --2
    '看来我还是太天真了，什么美貌妻子，万贯家财，既然想要修道就应该把这一切都置之脑后，我终于懂了,谢谢你，行路人!我身上还有最后5万两银子，我现在了无牵挂，用不看了，你拿去吧!'
}

function 任务:任务NPC对话(玩家, NPC)
    NPC.头像 = NPC.外形
    if NPC.名称 == '陈百万' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            self.进度 = 1
            玩家:刷新追踪面板()
        elseif self.进度 == 2 then
            NPC.台词 = _台词[3]
            self:完成(玩家)
            玩家:刷新追踪面板()
        end
    elseif NPC.名称 == '陈夫人' and NPC.台词 then
        if self.进度 == 1 then
            self.对话进度 = 0
            NPC.台词 = _台词[2]
            self.进度 = 2
            玩家:刷新追踪面板()
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
end

function 任务:完成(玩家)
    玩家:添加银子(50000)
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:六称完成检测(玩家, '思情')
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
