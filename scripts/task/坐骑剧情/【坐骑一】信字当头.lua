-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-05-23 11:41:08
local 任务 = {
    名称 = '【坐骑一】信字当头',
    别名 = '信字当头',
    类型 = '坐骑任务',
    是否可取消 = false,
    是否可追踪 = false,
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务更新(玩家, sec)
end

local _详情 = {
    '斧头帮帮主好像有事情找你帮忙，先去找#G至尊小宝#W问问有什么事情吧!',
    '帮小宝找#G白衣文士#W理论。（提示：对话后进入战斗）',
    '那白衣文士被你打败后懊丧地低垂着头,忽然又仰起头来高吼一声。',
    '找到灵兽村,将白衣文士的书信亲手交给麒麟村长。#Y（提示：进入灵兽村时要与#G冰熊守卫#Y战斗）',
    '把书信交给#G冰熊守卫#W并说清楚前因后果',
    '找到#G麒麟村长#W并亲手将书信交给他',
    '将书信交给#G麒麟村长#W（提示：使用ALT+G给与。）',
    '信已送到，在这随便逛逛吧！噫？#G赵大#W、#G钱二#W，去找他们聊聊吧！',
    '找#G东海龙王#W要一颗避水珠送给赵大。',
    '使用#G夜明珠#W，在龙宫内寻找避水珠（提示：使用夜明珠后会进入战斗,胜利后有几率获得避水珠。）',
    '将#G避水珠#W给予#G赵大#W（提示：使用ALT+G给与。）',
    '见识见识洛阳富商#G贾有钱#W的“神兵”。（提示：对话后进入战斗。）',
    '听听这贾有钱还想说些什么'
}
function 任务:任务取详情(玩家)
    return _详情[self.进度 + 1]
end

local _台词 = {
    '英雄,你终于来啦',
    --1
    '发生什么事了？',
    --2
    '桥头有个穿白衣服的人好生厉害!我们已经几天不敢出门，快弹尽粮绝了',
    --3
    '我去帮你讨个说法。',
    --4
    --进度1  帮小宝找#G白衣文士#W理论。（提示：对话后进入战斗）
    '喂，你就是那个欺负小宝的家伙吧?(看样子似乎不像是坏人。)',
    --5
    '终于来了个稍微像样一些，你是他们的首领吧?',
    --6
    '我只是打抱不平的路人,看你浑身伤痕累累的，不如先坐下来吃个包子喝杯茶?',
    --7
    '哼!废话不用多说，动手吧!',
    --8
    '看来话不投机……既然如此，就等打完再说吧!',
    --9
    --进度2  那白衣文士被你打败后懊丧地低垂着头,忽然又仰起头来高吼一声。
    '吼……',
    --10
    '胜败乃兵家常事，输给我也不是什么丢脸的事，叫两声发泄一下纵然是好，但也不要叫得那么大声嘛。吓坏我不要紧，但是吓坏小朋友们就不好了。',
    --11
    '哼!为何要与异类勾结谋害于我?',
    --12
    '我的族人深受妖孽残害，我怎会帮助它们加害于你？况且你身受重伤，我真要杀你易如反掌。',
    --13
    '唉，看来是误会你了。我本是灵兽村中的白虎护卫，为了追捕叛进的族人,阻止他们为祸地方我才来到这里，却不料遭到妖魔暗算，不能铲除那些祸害，实在心有不甘啊……',
    --14
    '我曾在此处除去一群作乱的白虎，不知道是否是你说的叛徒?',
    --15
    '啊?那些白虎虽说没有通天本领，但真要收服他们也相当棘手，我追了他们三天三夜才跟到这里来。',
    --16
    '举手之劳罢了,哈哈……',
    --17
    '既然祸害已除……看你不像是坏人。在下有一不情之请，是否能劳烦尊驾……',
    --18
    '男子汉大丈夫，说话不要婆婆妈妈的。只要不是杀人越货、谋财害命、夺人所爱、伤天害理……而且，还要是我力所能及的事情，我一定会尽力而为的。',
    --19
    '我现在身负重伤，无力回去禀报族长事情经过。待我写一封亲笔书信予你，劳烦帮我送到我居住的灵兽村，亲手将书信交给麒麟村长。灵兽村位于冰天雪地的北俱芦洲冰窟内，门口有一只巨大的冰熊看守着，只要拿着我的书信表明来意即可通行无阻。',
    --20
    '还以为是什么事情，仅仅是送信罢了。',
    --21
    '此事就有劳你了,不甚感激',--生成书信
    --22
    '小事一桩，就借送信前往灵兽村一游吧。',
    --23
    --进度3  找到灵兽村,将白衣文士的书信亲手交给麒麟村长。#Y（提示：进入灵兽村时要与#G冰熊守卫#Y战斗）
    '哪里来的狂徒，竟敢擅闯灵兽圣地，还不素手就擒！',--战斗
    --24
    --进度4 找到#G麒麟村长#W并亲手将书信交给他
    '原来有白虎守卫的书信，为什么不早点拿出来！',
    --25
    '这可是你先动的手。',
    --26
    '哼，既如此你们就进去吧，别打扰我睡觉。',
    --27
    '村子里似乎越来越不平静……少侠不知此番前来有何贵干？',
    --28
    --进度5 将书信交给#G麒麟村长#W（提示：使用ALT+G给与。）
    '阁下看老夫这灵兽村风光如何？',
    --29
    '灵兽村冰雪筑成，巧夺天工，实在是美不胜收啊！！',
    --30
    '阁下可以如此以为最好，老夫有意邀请阁下在灵兽村住个十年八年，相比也不会反对吧？？',
    --31
    '十年八年……村长这是要软禁在下吗？？',
    --32
    '话不能这么说，老夫也是迫于无亲,灵兽村的秘密是无论如何不可让外人得知的。',
    --33
    '保守秘密的心情在下能够理解，但是也不能限制他人的自由。作为一名长者，您怎可这般对我?',
    --34
    '这个……也罢……只要阁下答应保守灵兽村的秘密不向任问人提起，老夫马上亲自送你出去。',
    --35
    '这个自是当然，请村长放心！',
    --36
    --进度6 信已送到，在这随便逛逛吧！噫？#G赵大#W、#G钱二#W，去找他们聊聊吧！
    '哈，那件神兵，了得!!享在手中一闪一闪的，俺活了大半辈子，可也没见过这么神奇的宝物。',--赵大
    --37
    '要是拿到那件神兵,我这一华子可就不用干活啦!',--钱二
    --38
    '你个没出息的钱二，有了那件宝物，也许我就可以变得法力无边，上天入地，无所不能了，到时候要钱有钱，要田有田，哈哈哈……',
    --39
    '打扰了，在下刚才不慎听到了两位大哥的谈话，听说以后神奇的宝物……',
    --40
    '想要知道宝物的下落，你得帮我们一个忙',
    --41
    '你想要我帮什么忙，杀人越货、谋财害命、夺人所爱、伤天害理……力不能及的事情我可不做。',
    --42
    '哈哈,不要害怕，我一把年纪了，缺德的事情也是不做的。你要是能从东海龙王那要来一颗避水珠，我就告诉你宝物的秘密。',
    --43
    '这有何难，你们稍等片刻我去去就来。',
    --44
    --进度7 找#G东海龙王#Y要一颗避水珠送给赵大。
    '如此圣地，岂容你等踏入！还不滚开！',
    --45
    '龙王，每次见面都说这句话烦不烦啊?也不换点新鲜的。',
    --46
    '啊,原来是你啊,不知今日到来有何贵干?',
    --47
    '听说龙宫内有一宝物避水珠,凡人用了可在水中畅游不致窒息,可否赠予我一颗?',
    --48
    '避水珠……龙宫内确实有这么一件宝贝……但本王公务繁忙，不便与你同去。不过须找到夜明珠，才可在龙宫内找到避水珠。',
    --49
    '待我自去即可,不必劳烦龙王大驾了。',
    --50
    '不过宝贝都有鱼怪守护,你前去毫的时候须多加小心。',
    --51
    --进度8 使用夜明珠，在龙宫内寻找避水珠
    --进度9 将#G避水珠#W给予#G赵大#W（提示：使用ALT+G给与。）
    '既然这位小兄弟帮忙找到了避水珠,我就告诉你吧,这神兵乃是洛阳城的贾有钱所有,他放出话来,谁回答出他的问题,那件盖世神兵就归谁。',
    --52
    '（想我走南闯北，上天入地，什么没见过，回答个问题难不倒我。）',
    --53
    --进度10 见识见识洛阳富商#G贾有钱#W的“神兵”。（提示：对话后进入战斗。）
    '这位小哥，你也是为了神兵而来的吧？？？',
    --54
    '不敢不敢，在下只是好奇而已。',
    --55
    '哈哈，不用客套,神兵就在此处，只要你回答上我的问题，它就是你的!',
    --56
    '（好一把神兵，果真是件罕见的宝物，也算没有白来一趟)那就请赐教……',
    --57
    '哈哈，这个世间有一群修行得道的灵兽，不知道你听没听说过?只要你说出它们居住的场所，这件神兵就归你啦!!',
    --58
    '(答应麒麟村长的事不可食言，看来这神兵我是没份了。）东西虽好，可惜在下走南闯北，也算见过不少世面，可这灵兽却连听也未曾听说过，更不要说知道它们在哪了。可惜这神兵与我无缘,唉…',
    --59
    '小子，你想蒙谁。其实我已经知道你去过灵兽村，现在告诉爷爷灵兽村在哪，神兵还是你的。要不……哩哩，爷爷请你吃板刀面!',
    --60
    '(我去过灵兽村的事情怎么会被外人得知?先套套他的话!）在下是真的不知啊，不知你是从哪听说我去过灵兽村的消息!',
    --61
    '你还给我水仙不开花―一装蒜!再给你一次机会:说还是不说?',
    --62
    '唉，看到这神兵我本来想说，但是我又答应过朋友不能说。人生苦短，如若连诚信都守不住,那就白活一世了。',
    --63
    '哼，看来不教训教训你是不会说的了!',
    --64
    --进度11 听听这贾有钱还想说些什么
    '英雄请住手,容小的慢慢说来。',
    --65
    '打不过才叫停手,以为大爷是好欺负的吗?你们从哪得知灵兽村的,快快说来还可以饶你不死!',
    --66
    '英雄息怒，我本是灵兽村的村民，因为不相信您能帮我们保守秘密，才特意变身来试探于您。没想到英雄如此言而有信，实在惭愧啊!请英雄饶恕我的冒犯之罪。',
    --67
    '罢了，诚信那是最基本的本质，遵守诺言亦是份内之事，你们也太小看我了。',
    --68
    '说来容易做来难，英雄实在令人佩服。这神兵乃是我灵兽村的秘宝,可借灵气幻化为形。此番试探令我等心悦诚服，为表歉意这件神兵就送给英雄吧!',
    --69
    '咦?这神兵怎么是个鸡蛋?',
    --70
    '这蛋不是普通的蛋，而是可孵化灵兽幼子的兽丹，英雄可找到灵兽村守护神帮忙孵化。',
    --71
    '喔,真要能孵化灵兽我就先谢谢了，若是孵不出来我可要再来找你们麻烦,就此别过。',
    --72
}

function 任务:任务NPC对话(玩家, NPC)
    if NPC.名称 == '至尊小宝' and NPC.台词 then
        if self.进度 == 0 then
            self.对话进度 = 0
            NPC.台词 = _台词[1]
            NPC.结束 = false
        end
    elseif NPC.名称 == '白衣文士' and NPC.台词 then
        if self.进度 == 1 then
            self.对话进度 = 0
            NPC.头像 = 玩家.原形
            NPC.台词 = _台词[5]
            NPC.结束 = false
        elseif self.进度 == 2 then
            self.对话进度 = 0
            NPC.头像 = NPC.外形
            NPC.台词 = _台词[10]
            NPC.结束 = false
        end
    elseif NPC.名称 == '冰熊守卫' and NPC.台词 then
        if self.进度 == 3 then
            self.对话进度 = 0
            NPC.头像 = NPC.外形
            NPC.台词 = _台词[24]
            self:任务攻击事件(玩家, NPC)
        elseif self.进度 == 4 then
            self.对话进度 = 0
            NPC.头像 = NPC.外形
            NPC.台词 = _台词[25]
            NPC.结束 = false
        end
    elseif NPC.名称 == '麒麟村长' and NPC.台词 then
        if self.进度 == 5 then
            self.对话进度 = 0
            NPC.头像 = NPC.外形
            NPC.台词 = _台词[28]
            NPC.结束 = nil
            self.进度 = 6
        end
    elseif NPC.名称 == '赵大' and NPC.台词 then
        if self.进度 == 7 then
            self.对话进度 = 0
            NPC.头像 = NPC.外形
            NPC.台词 = _台词[37]
            NPC.结束 = false
        end
    elseif NPC.名称 == '东海龙王' and NPC.台词 then
        if self.进度 == 8 then
            self.对话进度 = 0
            NPC.头像 = NPC.外形
            NPC.台词 = _台词[45]
            NPC.结束 = false
        end
    elseif NPC.名称 == '贾有钱' and NPC.台词 then
        if self.进度 == 11 then
            self.对话进度 = 0
            NPC.头像 = NPC.外形
            NPC.台词 = _台词[54]
            NPC.结束 = false
        elseif self.进度 == 12 then
            self.对话进度 = 0
            NPC.头像 = NPC.外形
            NPC.台词 = _台词[65]
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
                NPC.结束 = nil
                self.进度 = 1
            end
        end
    elseif NPC.名称 == '白衣文士' then
        if self.进度 == 1 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[6]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[7]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[8]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self.对话进度 = 4
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[9]
                NPC.结束 = nil
                self:任务攻击事件(玩家, NPC)
            end
        elseif self.进度 == 2 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[11]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[12]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[13]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self.对话进度 = 4
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[14]
                NPC.结束 = false
            elseif self.对话进度 == 4 then
                self.对话进度 = 5
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[15]
                NPC.结束 = false
            elseif self.对话进度 == 5 then
                self.对话进度 = 6
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[16]
                NPC.结束 = false
            elseif self.对话进度 == 6 then
                self.对话进度 = 7
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[17]
                NPC.结束 = false
            elseif self.对话进度 == 7 then
                self.对话进度 = 8
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[18]
                NPC.结束 = false
            elseif self.对话进度 == 8 then
                self.对话进度 = 9
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[19]
                NPC.结束 = false
            elseif self.对话进度 == 9 then
                self.对话进度 = 10
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[20]
                NPC.结束 = false
            elseif self.对话进度 == 10 then
                self.对话进度 = 11
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[21]
                NPC.结束 = false
                玩家:添加物品({生成物品 {名称 = '白虎的亲笔书信', 数量 = 1}})
            elseif self.对话进度 == 11 then
                self.对话进度 = 12
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[22]
                NPC.结束 = false
            elseif self.对话进度 == 12 then
                self.对话进度 = 13
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[23]
                NPC.结束 = nil
                self.进度 = 3
            end
        end
    elseif NPC.名称 == '冰熊守卫' then
        if self.进度 == 4 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[26]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[27]
                NPC.结束 = nil
                self.进度 = 5
            end
        end
    elseif NPC.名称 == '麒麟村长' then
        if self.进度 == 6 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[30]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[31]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[32]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self.对话进度 = 4
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[33]
                NPC.结束 = false
            elseif self.对话进度 == 4 then
                self.对话进度 = 5
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[34]
                NPC.结束 = false
            elseif self.对话进度 == 5 then
                self.对话进度 = 6
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[35]
                NPC.结束 = false
            elseif self.对话进度 == 6 then
                self.对话进度 = 7
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[36]
                NPC.结束 = nil
                玩家:切换地图(1174, 45, 147)
                self.进度 = 7
            end
        end
    elseif NPC.名称 == '赵大' then
        if self.进度 == 7 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[38]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[39]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[40]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self.对话进度 = 4
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[41]
                NPC.结束 = false
            elseif self.对话进度 == 4 then
                self.对话进度 = 5
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[42]
                NPC.结束 = false
            elseif self.对话进度 == 5 then
                self.对话进度 = 6
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[43]
                NPC.结束 = false
            elseif self.对话进度 == 6 then
                self.对话进度 = 7
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[44]
                NPC.结束 = nil
                self.进度 = 8
            end
        elseif self.进度 == 10 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[53]
                NPC.结束 = nil
                self.进度 = 11
            end
        end
    elseif NPC.名称 == '东海龙王' then
        if self.进度 == 8 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[46]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[47]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[48]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self.对话进度 = 4
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[49]
                NPC.结束 = false
            elseif self.对话进度 == 4 then
                self.对话进度 = 5
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[50]
                NPC.结束 = false
            elseif self.对话进度 == 5 then
                self.对话进度 = 6
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[51]
                NPC.结束 = nil
                self.进度 = 9
            end
        end
    elseif NPC.名称 == '贾有钱' then
        if self.进度 == 11 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[55]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[56]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[57]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self.对话进度 = 4
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[58]
                NPC.结束 = false
            elseif self.对话进度 == 4 then
                self.对话进度 = 5
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[59]
                NPC.结束 = false
            elseif self.对话进度 == 5 then
                self.对话进度 = 6
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[60]
                NPC.结束 = false
            elseif self.对话进度 == 6 then
                self.对话进度 = 7
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[61]
                NPC.结束 = false
            elseif self.对话进度 == 7 then
                self.对话进度 = 8
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[62]
                NPC.结束 = false
            elseif self.对话进度 == 8 then
                self.对话进度 = 9
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[63]
                NPC.结束 = false
            elseif self.对话进度 == 9 then
                self.对话进度 = 10
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[64]
                NPC.结束 = nil
                self:任务攻击事件(玩家, NPC)
            end
        elseif self.进度 == 12 then
            if self.对话进度 == 0 then
                self.对话进度 = 1
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[66]
                NPC.结束 = false
            elseif self.对话进度 == 1 then
                self.对话进度 = 2
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[67]
                NPC.结束 = false
            elseif self.对话进度 == 2 then
                self.对话进度 = 3
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[68]
                NPC.结束 = false
            elseif self.对话进度 == 3 then
                self.对话进度 = 4
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[69]
                NPC.结束 = false
                玩家:添加物品({生成物品 {名称 = '灵兽蛋', 数量 = 1}})
            elseif self.对话进度 == 4 then
                self.对话进度 = 5
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[70]
                NPC.结束 = false
            elseif self.对话进度 == 5 then
                self.对话进度 = 6
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[71]
                NPC.结束 = false
            elseif self.对话进度 == 6 then
                self.对话进度 = 7
                NPC.头像 = 玩家.原形
                NPC.台词 = _台词[72]
                NPC.结束 = nil
                self:完成(玩家)
            end
        end
    end
end

function 任务:完成(玩家)
    -- 玩家:添加声望(10)
    -- 玩家:提示窗口('#Y由于你的英勇你在这个世界的名望得到了提升，获得10点声望值。')
    -- 玩家:添加物品({生成物品 {名称 = '千年寒铁', 数量 = 1}})
    -- local r = 玩家:取任务('引导_升级检测')
    -- if r then
    --     r:一称完成检测(玩家, '小孩')
    -- end
    玩家:添加任务('灵兽降世')
    self:删除()
end

function 任务:任务NPC给予(玩家, NPC, cash, items)
    -- 玩家:添加物品({生成物品 {名称 = '白虎的亲笔书信', 数量 = 1}})
    if self.进度 == 6 then
        if items[1] and items[1].名称 == '白虎的亲笔书信' then
            if items[1].数量 >= 1 then
                items[1]:接受(1)
                self.对话进度 = 0
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[29]
                NPC.结束 = false
            end
        end
    elseif self.进度 == 10 then
        if items[1] and items[1].名称 == '避水珠' then
            if items[1].数量 >= 1 then
                items[1]:接受(1)
                self.对话进度 = 0
                NPC.头像 = NPC.外形
                NPC.台词 = _台词[52]
                NPC.结束 = false
            end
        end
    end
end

function 任务:任务攻击事件(玩家, NPC)
    if self.进度 == 1 then
        if NPC.名称 == '白衣文士' then
            local r = 玩家:进入战斗('scripts/task/坐骑剧情/【坐骑一】信字当头.lua',self)
            if r then
                玩家:添加经验(500000)
                self.进度 = 2
            end
        end
    elseif self.进度 == 3 then
        if NPC.名称 == '冰熊守卫' then
            local r = 玩家:进入战斗('scripts/task/坐骑剧情/【坐骑一】信字当头.lua',self)
            if r then
                玩家:添加经验(500000)
                self.进度 = 4
            end
        end
    elseif self.进度 == 11 then
        if NPC.名称 == '贾有钱' then
            local r = 玩家:进入战斗('scripts/task/坐骑剧情/【坐骑一】信字当头.lua',self)
            if r then
                玩家:添加经验(800000)
                self.进度 = 12
            end
        end
    end
end

local _怪物 = {
    { 名称 = "白衣文士", 外形 = 1, 气血 = 500000, 魔法 = 100000, 攻击 = 6000, 速度 = 300, 技能 = {{名称='失心狂乱',熟练度=8000},{名称='借刀杀人',熟练度=8000},{名称='天诛地灭',熟练度=8000}},施法几率 = 30 },
    { 名称 = "白虎", 外形 = 2038, 气血 = 350000, 魔法 = 100000, 攻击 = 8000, 速度 = 180 },
    { 名称 = "白虎", 外形 = 2038, 气血 = 350000, 魔法 = 100000, 攻击 = 8000, 速度 = 180 }
}

local _怪物1 = {
    { 名称 = "冰熊守卫", 外形 = 2040, 气血 = 650000, 魔法 = 100000, 攻击 = 8000, 速度 = 280 },
    { 名称 = "两角怪", 外形 = 2013, 气血 = 380000, 魔法 = 100000, 攻击 = 6000, 速度 = 130 },
    { 名称 = "两角怪", 外形 = 2013, 气血 = 380000, 魔法 = 100000, 攻击 = 6000, 速度 = 130 }
}

local _怪物2 = {
    { 名称 = "鱼怪", 外形 = 2094, 气血 = 580000, 魔法 = 100000, 攻击 = 3900, 速度 = 300, 技能 = {'龙卷雨击','龙啸九天','九龙冰封'},施法几率 = 50 }
}

local _怪物3 = {
    { 名称 = "贾有钱", 外形 = 2087, 气血 = 1800000, 魔法 = 100000, 攻击 = 5900, 速度 = 320 }
}

function 任务:战斗初始化(玩家,r)
    if r.进度 == 1 then
        for i = 1, 3 do
            local r = 生成战斗怪物(_怪物[i])
            self:加入敌方(i, r)
        end
    elseif r.进度 == 3 then
        for i = 1, 3 do
            local r = 生成战斗怪物(_怪物1[i])
            self:加入敌方(i, r)
        end
    elseif r.进度 == 9 then
        local 随机 = math.random(2, 5)
        for i = 1, 随机 do
            local r = 生成战斗怪物(_怪物2[1])
            self:加入敌方(i, r)
        end
    elseif r.进度 == 11 then
        self:加入敌方(1, 生成战斗怪物(_怪物3[1]))
    end
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)
end

return 任务
