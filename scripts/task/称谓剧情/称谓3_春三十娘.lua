-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-10-26 18:14:31
local 任务 = {
    名称 = '称谓3_春三十娘',
    别名 = '春三十娘(三称)',
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
    '	前往#Y斧头帮#W找#u#G#m({帮主住房,18,12})至尊小宝#m#u#W聊聊！',
    '	去#Y盘丝洞#W刺杀#u#G#m({大唐边境,343,233})春三十娘#m#u#W。',
    '	知道了孙悟空的秘密快回去找#u#G#m({帮主住房,18,12})至尊小宝#m#u'
}


local _追踪描述 = {
    '	前往#Y斧头帮#W找#u#G#m({帮主住房,14,9})至尊小宝#m#u#W聊聊！',
    '	去#Y盘丝洞#W刺杀#u#G#m({大唐边境,343,233})春三十娘#m#u#W。',
    '	知道了孙悟空的秘密快回去找#u#G#m({帮主住房,18,12})至尊小宝#m#u'
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end

function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '该死该死该死，该死的春三十娘，还自称什么“桃花过处，寸草不生，金钱落地，人头不保”! !我就不吃这一 套... ..结果中了地的八伤拳.气死我了! !我好歹也是个斧头帮帮主，这么做我不是太~没面子了吗?',
    --1
    '你就是斧头帮帮主?难怪长了一付斗鸡眼。',
    --2
    '谁说我斗鸡眼?我只是把视线集中在一点，改变我对以往事物的看法而已~，这样吧，给我报仇的任务就交给你了....我这么信任你，感动吧?',
    --3
    '我kao~I服了U，强加个任务给我，还有理了！',
    --4
    '三十娘就在#R大唐边境的盘丝洞#W啦。 我相信你是能搞定地，你行地!',
    --5
    '你是来为斧头帮报仇的?我告诉你，别傻了,那是他在利用你。他其实是#R孙悟空转世',
    --6
    '没错的，孙悟空把白骨仙从十王降魔阵里救了出来，又利用月光宝盒的力量进到了500年前，但他们运气不好，在功力尚未恢复的时候就遇到了观音菩萨，本来孙悟空是该死的，但他的师傅唐三藏愿意跟他一命换一命，因此他就有了一次重生的机会。现在的斧头帮帮主就是孙悟空转世，而我的同门师妹，晶晶就是白骨仙的转世。他之所以还不知道自己是孙悟空的转世，那是因为他还没有遇到给他三颗痣的人，等他遇见以后，他就会明白自己真正的身份，而齐天大圣的真正力量也会恢复! !不过这个秘密既然你知道了，那么你就死定了!',
    --7
    '啊~~我好怕怕啊~~~',
    --8
    '什么?你说我是孙猴子转世?你认错人了吧?哈哈哈，开玩笑，我怎么可能是那只猴子呢!哦耶!',
    --9
    '看你嚣张的样子和斗鸡眼，真想海扁你! (看出来啦， 这家伙怎么可能是孙悟空转世呢?开玩笑嘛)',
    --10
    '英雄你放过我吧。我不是猴子，我要跟晶晶姑娘结婚!',
    --11
    '什么，孙悟空转生? (哇，真的假的啊? )'
	--12
}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '至尊小宝' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            self.对话进度 = 0
            NPC.台词 = _台词[9]
            NPC.结束 = false
        end
    elseif NPC.名称 == '春三十娘' and NPC.台词 then
        NPC.头像 = NPC.外形
        if self.进度 == 1 then
            self.对话进度 = 0
            NPC.台词 = _台词[6]
            NPC.结束 = false

        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '至尊小宝' then
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
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[5]
                NPC.结束 = nil
                self.进度 = 1
                玩家:刷新追踪面板()
            end
        elseif self.进度 == 2 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[10]
                NPC.结束 = false
            elseif  self.对话进度 == 1 then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[11]
                NPC.结束 = nil
                self:完成(玩家)
                玩家:刷新追踪面板()
            end
        end
    elseif NPC.名称 == '春三十娘' then
        if self.进度 == 1 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[12]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[7]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[8]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self:任务攻击事件(玩家, NPC)
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(300)
    玩家:提示窗口('#Y因为你打败了有名的魔头，你在这个世界的声得到了提升，获得300点声望。')

    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:三称完成检测(玩家, '春三十娘')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '春三十娘' then
        if self.进度 == 1 then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓3_春三十娘.lua', self)
            if r then
                self.进度 = 2
                玩家:添加银子(23987)
                玩家:添加经验(445458)
                玩家:常规提示('#R你获得445458经验和23987两银子！')
                玩家:刷新追踪面板()
            end
        end
    end
end

local _怪物 = {
    { 名称 = "春三十娘", 外形 = 2079, 气血 = 14000, 魔法 = 8000, 攻击 = 1300, 速度 = 260,抗性={物理吸收=50},技能 = { "乘风破浪","雷霆霹雳","地狱烈火" } }
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
