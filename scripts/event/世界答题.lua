-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-27 13:51:21
-- @Last Modified time  : 2024-05-09 16:49:17
--{year =2022, month = 7, day =27, hour =0, min =0, sec = 00}
--年月日 时分秒
local 事件 = {
    名称 = '世界答题',
    是否打开 = true,
    开始时间 = os.time {year = 2022, month = 7, day = 25, hour = 0, min = 0, sec = 00},
    结束时间 = os.time {year = 2025, month = 7, day = 30, hour = 0, min = 0, sec = 00}
}

function 事件:事件初始化()
    self.题库 = {
        {问题="我国的首都是？",答案="北京"},
        {问题="我国的四个直辖市除了北京、上海、重庆外还有一个是？",答案="天津"},
        {问题="世界上第一个发明导弹的国家是？",答案="德国"},
        {问题="被誉为“诗仙”的是哪一位人物？",答案="李白"},
        {问题="史家之绝唱，无韵之离骚”是指哪部文学作品？",答案="史记"},
        {问题="我国哪一个传统节日是为纪念投江而死的屈原？",答案="端午节"},
        {问题="有一部动画片描述的是七个神通广大的兄弟拯救一个老爷爷的故事，这部动画片的名字叫？",答案="葫芦兄弟"},
        {问题="出淤泥而不染”形容的是哪种花？",答案="莲花"},
        {问题="一个人有两性特征，我们通常将这种人形容为？",答案="人妖"},
        {问题="计算机中有一个核心部件叫作中央处理器，我们一般将它简称为？",答案="cpu"},
        {问题="出师未捷身先死，长使英雄泪满襟”形容的是哪一位人物？",答案="诸葛亮"},
        {问题="南村群童欺我老无力”形容的是哪一位诗人晚年时的悲惨境况？",答案="杜甫"},
        {问题="回眸一笑百媚生，六宫粉黛无颜色”形容的是哪一位女性人物？",答案="杨玉环"},
        {问题="孟夏 在古代时令中是指农历几月？",答案="四月"},
        {问题="宫城的正门被称为？",答案="午门"},
        {问题="玄武门之变的主角是？",答案="李世民"},
        {问题="我国历史上第一位女性皇帝是？",答案="武则天"},
        {问题="战国七雄是指秦、齐、韩、燕、魏、赵以及？",答案="楚"},
        {问题="项羽率领3万精兵击败刘邦50万联军是哪一场战役？",答案="彭城之战"},
        {问题="湖南湖北是用哪条湖作为分界线的？",答案="洞庭湖"},
        {问题="在《儒林外史》中，哪位人物因为中了举人而疯掉？",答案="范进"},
        {问题="中华人民的母亲河是哪条河流？",答案="黄河"},
        {问题="我国最大的江南皮革厂厂长是？",答案="黄鹤"},
        {问题="生当作人杰，死亦为鬼雄”的作者是？",答案="李清照"},
        {问题="在天愿作比翼鸟，在地愿为连理枝”出自哪首诗？",答案="长恨歌"},
        {问题="每年的10月1日是我国的什么节日？",答案="国庆节"},
        {问题="月饼是来源于我国哪一个传统节日？",答案="中秋节"},
        {问题="论语记载了哪一位人物的言论？",答案="孔子"},
        {问题="勤有功，戏无益。戒之哉，宜勉力”出自？",答案="三字经"},
        {问题="我国历史上的第一位皇帝是？",答案="秦始皇"},
        {问题="秦孝公任命的哪一位人物主持的变法让秦国逐步强大起来？",答案="商鞅"},
        {问题="每年的农历正月十五日为元宵节，在古时又将元宵节称为？",答案="上元节"},
        {问题="3转召唤兽能服用几个内丹？",答案="3个"},
        {问题="人物达到多少等级后可以1转？",答案="102"},
        {问题="法术熟练度跟转生修正有关系吗？",答案="有"},
        {问题="召唤兽可以服用几个龙之骨？",答案="3个"},
        {问题="鬼王任务找谁领取？",答案="钟馗"},
        {问题="天庭任务找谁领取？",答案="李靖"},
        {问题="修罗任务找谁领取？",答案="灵兽村使者"},
        {问题="那个地方可以摆摊？",答案="洛阳集市"},
        {问题="召唤兽内丹中具备反震效果的内丹是？",答案="万佛朝宗"},
        {问题="神兽可以飞升几次？",答案="3次"},
        {问题="五常神兽中攻击初值最高的召唤兽是那个？",答案="浪淘沙"},
        {问题="猴精在哪个场景出现？",答案="御马监"},
        {问题="召唤兽内丹在哪里购买？",答案="长安饰品店"},
        {问题="领取双倍时间找谁领取？",答案="一品侍卫"},
        {问题="在哪可以提高坐骑经验？",答案="帮派驯养师"},
        {问题="找那位NPC可以换角色？",答案="黄大仙"},
        {问题="四级神兵升五级需要用什么矿石？",答案="补天神石"},
        {问题="人物转生除了准备二十一味清目丸和冥钞还需要准备？",答案="千年血参"},
        {问题="旧版神兽中，第三次飞升造型为剑精灵的神兽是？",答案="超级蝙蝠"},
        {问题="召唤兽二转需要扣除多少亲密？",答案="20万"},
    }
    self.阶段 = 0 --0未开始 1已开始
    self.起始时间 = os.time() + 600
    self.持续时间 = 600
    -- self.结束间隔 = 120
end


function 事件:更新()
    if os.time() >= self.起始时间 and self.阶段 == 0 then
        self.起始时间 = os.time() + 1
        self.阶段 = 1
        local sj = math.random(1,#self.题库)
        self.当前答题 = sj
        self:发送系统('#Y【世界答题】#G世界答题开始啦，请注意本次题目为：#W“%s”#55', self.题库[self.当前答题].问题)
    elseif self.阶段==1 and os.time() >= self.起始时间 then
        self.阶段 = 0
        self.起始时间 = os.time() + 600
        self:发送系统('#Y【世界答题】#G很遗憾本次没有小伙伴答对题目！#83', self.题库[self.当前答题].问题)
    end
end

function 事件:答案验证(str,data)
    if self.当前答题 and self.阶段 == 1 then
        if str == self.题库[self.当前答题].答案 then
            self:发送系统('#Y【世界答题】#G恭喜#W%s#G在本次世界答题中答对正确答案！#51', data.名称)
           -- data.接口:添加仙玉(100)
            data.接口:添加银子(1206)
            data.接口:添加经验(1920)
            local 奖励 = 是否奖励(2014,data.等级,data.转生)
            if 奖励 ~= nil and type(奖励) == 'table' then
                local r = 生成物品 { 名称 = 奖励.道具信息.道具, 数量 = 奖励.道具信息.数量, 参数 = 奖励.道具信息.参数 }
                if r then
                    data.接口:添加物品({ r })
                    if 奖励.道具信息.是否广播 == 1 and 奖励.广播 ~= nil then
                        data.接口:发送系统(奖励.广播, data.名称, r.ind, r.名称)
                    end
                end
            end
            self.当前答题 = nil
            self.阶段 = 0
            self.起始时间 = os.time() + 600
        end
    end
end

return 事件
