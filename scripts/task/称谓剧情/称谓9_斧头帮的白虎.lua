-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:56
-- @Last Modified time  : 2024-10-26 21:31:53

local 任务 = {
    名称 = '称谓9_斧头帮的白虎',
    别名 = '斧头帮的白虎(九称)',
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
	'  前往#Y斧头帮#W找#u#G#m({帮主住房,14,7})至尊小宝#m#u#W谈谈！',
	'  消灭那些#u#G#m({斧头帮,17,121})白虎#m#u#W（ALT+A攻击白虎）',
	'  回去#Y斧头帮#W找#u#G#m({帮主住房,14,7})至尊小宝#m#u#W聊聊！',
	'  把照妖镜交给#u#G#m({五指山,116,138})晶晶姑娘#m#u#R（请将照妖镜ALT+G给予晶晶后交谈）',
	'  前往#Y斧头帮#W找#u#G#m({帮主住房,14,7})至尊小宝#m#u#W谈谈！',
}
local _追踪描述 = {
	'  前往#Y斧头帮#W找#u#G#m({帮主住房,14,7})至尊小宝#m#u#W谈谈！',
	'  消灭那些#u#G#m({斧头帮,17,121})白虎#m#u#W（ALT+A攻击白虎）',
	'  回去#Y斧头帮#W找#u#G#m({帮主住房,14,7})至尊小宝#m#u#W聊聊！',
	'  把照妖镜交给#u#G#m({五指山,116,138})晶晶姑娘#m#u#R（请将照妖镜ALT+G给予晶晶后交谈）',
	'  前往#Y斧头帮#W找#u#G#m({帮主住房,14,7})至尊小宝#m#u#W谈谈！',
}

function 任务:任务取追踪(玩家)
    return _追踪描述[self.进度+1]
end
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '我真是流年不利，先前被碧桃娘子偷走了镜子。如今又有一个姑娘赖我偷了他的照妖镜。',
    --1
    '这是怎么回事?',
    --2
    '那姑娘那天一个人鬼鬼祟祟地逃到斧头帮，说是有一个牛妖在追她。叫我把她藏起来。过了几日，她见没什么事，就打算拍拍屁股走人了。没想到却发现她的照妖镜不见了，便一咬定是我趁人之危偷了去。',
    --3
    '那照妖镜到底去哪儿了呢?',
    --4
    '斧头帮后山有成精的白虎，经常出来偷盗东西，可能是叫他们偷走了',
    --5
    '多谢你。还请你帮我把这照妖镜交还个晶晶姑娘，顺便替我作证，偷走镜子的是后山的白虎。',
    --6
    '又是你！',
    --7
    '晶晶，你不是嫁给牛魔王了吗，怎么又跑了?',
    --8
    '谁真要嫁给那老牛妖。我答应嫁给他，不过是为了从他口中知道更多祖师爷的故事。还有嘛，他答应照妖镜给我作为定情信物，那可是个宝贝呢，得到照妖镜以后我就开溜了。为了躲避他，我就只好躲进了一个叫做斧头帮的贼窝里。谁曾想我拼了命得来的照妖镜竟然叫一个叫至尊小宝的偷走了，还死不承认!',
    --9
    '姑娘说的照妖镜可是这个',
    --10
    '咦，怎么在你手里',
    --11
    '至尊小宝没有偷你的照妖镜，这照妖镜是我从后山的白虎那里得到的',
    --12
    '这么说，我冤枉了他。你，你替我跟他陪个不是吧',
    --13
    '这还差不多，我就不跟她一般见识了。'
    --14
}

function 任务:任务NPC对话(玩家, NPC)
    NPC.头像 = NPC.外形
    if NPC.名称 == '至尊小宝' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        elseif self.进度 == 2 then
            self.对话进度 = 0
            NPC.台词 = _台词[6]
            self.进度 = 3
            玩家:刷新追踪面板()
        elseif self.进度 == 4 then
            self.对话进度 = 0
            NPC.台词 = _台词[14]
            self:完成(玩家)
            玩家:刷新追踪面板()
        end
    elseif NPC.名称 == '晶晶姑娘' and NPC.台词 then
        if self.进度 == 3 then
                local a =  玩家:取物品是否存在("照妖镜")
                if a  then
                else
                    NPC.台词 = "我要的东西呢？"
                    return
                end
                local  b =    玩家:取物品是否存在("照妖镜")
                if  b then
                        b:减少(1)
                end
                    self.对话进度 = 0
                    NPC.头像 = NPC.外形
                    NPC.台词 = _台词[7]
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
        end
    elseif NPC.名称 == '晶晶姑娘' then
        if self.进度 == 3 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[8]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[9]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[10]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self.对话进度 = 4
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[11]
                NPC.结束 = false
            elseif self.对话进度 == 4 then
                self.对话进度 = 5
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[12]
                NPC.结束 = false
            elseif self.对话进度 == 5 then
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[13]
                NPC.结束 = nil
                玩家:添加物品({生成物品 {名称 = '金箍', 数量 = 1}})
                self.进度 = 4
                玩家:刷新追踪面板()
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(5000)
    玩家:常规提示('#Y你帮助斧头帮帮主洗清了冤屈，你在这个世界的声望提高了，你获得了5000点声望。')
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:九称完成检测(玩家, '白虎')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    -- if NPC.名称 == '晶晶姑娘' then
        if self.进度 == 3 then
            if items[1] and items[1].名称 == '照妖镜' then --
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    self.对话进度 = 0
                    NPC.头像 = NPC.外形
                    玩家:常规提示('#Y给予了'..NPC.名称..items[1].名称)
					玩家:常规提示('与晶晶姑娘交谈')
                    NPC.结束 = false
                end
            end
        end
    -- end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '白虎' then
        if self.进度 == 1 then
            local r = 玩家:进入战斗('scripts/task/称谓剧情/称谓9_斧头帮的白虎.lua')
            if r then
                玩家:添加经验(2000000)
                玩家:常规提示('#R你打败了白虎，获得2000000经验。')
                玩家:添加物品({生成物品 {名称 = '照妖镜', 数量 = 1}})
                self.进度 = 2
                玩家:刷新追踪面板()
            end
        end
    end
end

local _怪物 = {
    { 名称 = "白虎", 外形 = 2038, 气血 = 222222, 魔法 = 1, 攻击 = 6888, 速度 = 299,抗性 = { 连击率 = 30, 忽视防御几率 = 20, 忽视防御程度 = 50, 连击次数 = 3,狂暴几率 = 10, 致命几率 = 10, 抗昏睡 = 30, 抗混乱 = 30, 抗封印 = 30 } },
    { 名称 = "白虎", 外形 = 2038, 气血 = 222222, 魔法 = 1, 攻击 = 6888, 速度 = 299,抗性 = { 连击率 = 30, 忽视防御几率 = 20, 忽视防御程度 = 50, 连击次数 = 3,狂暴几率 = 10, 致命几率 = 10, 抗昏睡 = 30, 抗混乱 = 30, 抗封印 = 30 } },
    { 名称 = "白虎", 外形 = 2038, 气血 = 222222, 魔法 = 1, 攻击 = 6888, 速度 = 299,抗性 = { 连击率 = 30, 忽视防御几率 = 20, 忽视防御程度 = 50, 连击次数 = 3,狂暴几率 = 10, 致命几率 = 10, 抗昏睡 = 30, 抗混乱 = 30, 抗封印 = 30 } },
    { 名称 = "白虎", 外形 = 2038, 气血 = 222222, 魔法 = 1, 攻击 = 6888, 速度 = 299,抗性 = { 连击率 = 30, 忽视防御几率 = 20, 忽视防御程度 = 50, 连击次数 = 3,狂暴几率 = 10, 致命几率 = 10, 抗昏睡 = 30, 抗混乱 = 30, 抗封印 = 30 } },
    { 名称 = "白虎", 外形 = 2038, 气血 = 222222, 魔法 = 1, 攻击 = 6888, 速度 = 299,抗性 = { 连击率 = 30, 忽视防御几率 = 20, 忽视防御程度 = 50, 连击次数 = 3,狂暴几率 = 10, 致命几率 = 10, 抗昏睡 = 30, 抗混乱 = 30, 抗封印 = 30 } }
}


function 任务:战斗初始化(玩家)
    for i = 1, 5 do
        local r = 生成战斗怪物(_怪物[i])
        self:加入敌方(i, r)
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
