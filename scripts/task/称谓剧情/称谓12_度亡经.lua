local 任务 = {
    名称 = '称谓12_度亡经',
    别名 = '度亡经(十二称)',
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
    '你可以完成第十二个称谓剧情任务了，任务领取人#Y四圣庄(194,104)#G刘伯钦',
    '去地府问问#G黑无常#W刘伯钦老父的事情。',
    '再去找#G秦广王#W问问。',
    '搞了半天原来是#G黑无常#W的缘故，找他算帐去。',
    '去找化生寺#G空慈方丈#W要《度亡经》超度刘伯钦老父亡魂。#R(对话后将直接进入战斗）',
    '把《度亡经》给#G刘伯钦#W。#Y(ALT+G将度亡经给予刘伯钦)'
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    {头像 = 3166, 结束 = false, 序号 = 1, 台词 = '这位兄弟请慢行，前山多虎，还是小心为上。'},
    {头像 = 0, 结束 = false, 序号 = 2, 台词 = '呵呵，你这人倒有趣，谢了.不过只有老虎怕我，我可不怕老虎。'},
    {头像 = 3166, 结束 = false, 序号 = 3, 台词 = '哦?听你这么说，莫非你就是去西天取经之人? ? '},
    {头像 = 0, 结束 = false, 序号 = 4, 台词 = '嗯，你是谁呀，怎么知道取经人的事情。'},
    {头像 = 3166, 结束 = false, 序号 = 5, 台词 = '在下是这里的猎户，叫刘伯钦，专司杀虎猎豹，远近也算小有名气。前几日梦中见到已故去的老父，说他不知何故，在地府轮回不得超生，唯有西行取经之人方能助他解脱，所以在下这几日都在此处等待取经之人。'},
    {头像 = 0, 结束 = false, 序号 = 6, 台词 = '哈哈，我不是取经人，不过超度你父亲亡魂，这是小事一桩，就让我帮你这个小忙吧。'},
    {头像 = 3166, 序号 = 7, 台词 = '太好了，如真能超度亡父，在下感恩不尽。'},
    --0

    {头像 = 0, 结束 = false, 序号 = 8, 台词 = '喂，小黑，我又来啦。那四圣庄有个猎户刘伯钦，他老父亡魂不得超生，在地狱轮回受苦，这是怎么回事? ?'},
    {头像 = 3073, 结束 = false, 序号 = 9, 台词 = '啊.. ..这....你... ..你怎么管得这么多啊。'},
    {头像 = 0, 结束 = false, 序号 = 10, 台词 = '嗯?你说什么? ?'},
    {头像 = 3073, 结束 = false, 序号 = 11, 台词 = '没，没，这事儿不归我管啊，亡魂超生这事儿，....应该是秦广王负责吧。'},
    {头像 = 0, 序号 = 12, 台词 = '哼！！...'},
    --1

    {头像 = 2274, 序号 = 13, 台词 = '啊，上..... 上仙明鉴，....小王都是管些杂事，这.这实在不管小王事啊。上仙不如... ...不如去问问卞城王，他或许知道。 '},
    --2
    {头像 = 0, 结束 = false, 序号 = 14, 台词 = '秦广王，你胆子不小啊，居然呼来喝去地消遣我! !'},
    {头像 = 2274, 结束 = false, 序号 = 15, 台词 = '上... ...上仙饶命，.小...小......怎敢放肆，只是... ..只是那刘伯钦老父在生时曾经咒骂地府阎罗，所以阎王下令罚他在地府苦修三百年才得超生，由黑无常监管。可.... 可不是小王故意刁难。只要大王点头，...小王立刻帮他办. ..... '},
    {头像 = 0, 序号 = 16, 台词 = '哼，算你识相，等我去问问小黑!'},
    --3

    {头像 = 0, 结束 = false, 序号 = 17, 台词 = '小黑! ! !你是不是觉着这地府清静得很，想闹点什么事儿出来才高兴啊??'},
    {头像 = 3073, 结束 = false, 序号 = 18, 台词 = '哎呀，俺可不敢，不敢啊。你何必为一个凡人动这么大气呢，咱们这么熟了犯不着吧。'},
    {头像 = 0, 结束 = false, 序号 = 19, 台词 = '哼，身为神仙，怎可随意刁难凡尘众生，你不觉得你很过分吗?'},
    {头像 = 3073, 结束 = false, 序号 = 20, 台词 = '哎呀，咱... .咱们好商量嘛。况且那是天庭的旨意，老阎我也不敢违背啊。不过....哩嘿，咱们这交情，当然要帮你想法子啦。'},
    {头像 = 0, 结束 = false, 序号 = 21, 台词 = '你有什么法子? ?'},
    {头像 = 3073, 结束 = false, 序号 = 22, 台词 = '其实也不难，听说化生寺有一卷#R《度亡经》#W是如来亲传，有超度鬼神的大法力，你只要把那卷  搞到#R《度亡经》#W就不需玉帝旨意也可以超度那个猎户的父亲啦。 '},
    {头像 = 0, 序号 = 23, 台词 = '嗯，听起来不错，去化生寺看看。'},
    --4
    {头像 = 3047, 结束 = false, 序号 = 24, 台词 = '阿密陀佛，施主要《度亡经》? ?'},
    {头像 = 0, 结束 = false, 序号 = 25, 台词 = '对，方丈，这可是救人的大事儿，一卷经文，度亡魂超生，想来方丈不会吝嗇吧。'},
    {头像 = 3047, 结束 = false, 序号 = 26, 台词 = '非也，不是老衲吝啬。施主有所不知，这《度亡经》乃我佛如来亲传真经，度人度鬼，法力无穷，也因此我佛如来在经文上手书了#R大明天王咒#W。'},
    {头像 = 0, 结束 = false, 序号 = 27, 台词 = '大明王天咒，难道.....? ?'},
    {头像 = 3047, 结束 = false, 序号 = 28, 台词 = '不错，此经由大明王天镇护，要得此经者，须得先经受大明王天的试炼，不知施主... ...'},
    {头像 = 0, 结束 = false, 序号 = 29, 台词 = '听说大明王天法力.....但为了救人，也顾不得那许多了，姑且试一试吧。'},
    {头像 = 3047, 序号 = 30, 台词 = '那....施主请千万小心，不可勉强。'},
    --5

    {头像 = 3047, 结束 = false, 序号 = 31, 台词 = '施主好本事，竟然可以战败大明王天... ....'},
    {头像 = 0, 序号 = 32, 台词 = '好难受，这大明王天果然不是好惹的。不管怎么说，《度亡经》也到手了，赶紧去拿给刘伯钦吧。'},
    --6

    {头像 = 3166, 结束 = false, 序号 = 33, 台词 = '只要念这《度亡经》....就可以超度亡父了? ? ......大恩大德，叫我怎么回报... ...'},
    {头像 = 0, 序号 = 34, 台词 = '不用啦，这是修行之人应该做的，做这些事，我心里也感到平安喜乐，有助于我的修行呢。'}
}
function 任务:取对话(玩家)
    local r = _台词[self.对话进度]
    local 台词, 头像, 结束 = r.台词, r.头像, r.结束
    if 头像 == 0 then
        头像 = 玩家.原形
    end

    return 台词, 头像, 结束
end

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '刘伯钦' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        end
    elseif NPC.名称 == '黑无常' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 8
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        elseif self.进度 == 4 then
            self.对话进度 = 17
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        end
    elseif NPC.名称 == '空慈方丈' and NPC.台词 then
        if self.进度 == 5 then
            self.对话进度 = 24
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        end
    elseif NPC.名称 == '秦广王' and NPC.台词 then
        if self.进度 == 2 then
            self.对话进度 = 13
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            self.进度 = 3
        elseif self.进度 == 3 then
            self.对话进度 = 14
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        end
    end
end

function 任务:任务NPC菜单(玩家, NPC, i)
    if NPC.名称 == '刘伯钦' then
        if self.进度 == 0 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 7 then
                self.进度 = 1
            end
        elseif self.进度 == 6 then
            self.对话进度 = 34
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            self:完成(玩家)
        end
    elseif NPC.名称 == '黑无常' then
        if self.进度 == 1 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 12 then
                self.进度 = 2
            end
        elseif self.进度 == 4 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 23 then
                self.进度 = 5
            end
        end
    elseif NPC.名称 == '秦广王' then
        if self.进度 == 3 then
            self.对话进度 = self.对话进度 + 1
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            if self.对话进度 == 16 then
                self.进度 = 4
            end
        end
    elseif NPC.名称 == '空慈方丈' then
        if self.进度 == 5 then
            if self.对话进度 < 30 then
                self.对话进度 = self.对话进度 + 1
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
            elseif self.对话进度 == 30 then
                self:任务攻击事件(玩家, NPC)
            end
        elseif self.进度 == 6 then
            self.对话进度 = 32
            NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
        end
    end
end

function 任务:完成(玩家)
    玩家:添加声望(50)
    玩家:常规提示('#Y你热心助人，得到了上天赐予的50点好心值，你的声望增加了50点。')
    local r = 玩家:取任务('引导_升级检测')
    if r then
        r:十二称完成检测(玩家, '度亡经')
    end
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    if NPC.名称 == '刘伯钦' then
        if self.进度 == 6 then
            if items[1] and items[1].名称 == '度亡经' then --
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                    self.对话进度 = 33
                    NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                end
            end
        end
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if NPC.名称 == '空慈方丈' then
        if self.进度 == 5 and self.对话进度 == 30 then
            local r = true
            --玩家:进入战斗('scripts/task/称谓1_教训飞贼.lua')
            if r then
                玩家:添加物品({生成物品 {名称 = '度亡经', 数量 = 1}})
                玩家:常规提示('#Y你得到3300000点经验，100000两银子和度亡经。')
                self.对话进度 = 31
                NPC.台词, NPC.头像, NPC.结束 = self:取对话(玩家)
                self.进度 = 6
            end
        end
    end
end

function 任务:战斗初始化(玩家)
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
