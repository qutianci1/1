-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-20 06:15:13
-- @Last Modified time  : 2024-10-16 16:19:13

local 召唤 = require('召唤')
local _召唤库 = require('数据库/召唤库')
local 技能描述 = {}
function 召唤:召唤_技能描述(技能数据)
    local 法术 = 技能数据
    local 定位
    for i , v in ipairs(self.主人.参战召唤.技能) do
        -- v.nid
        定位 = self.主人.参战召唤.技能[i].nid
    end
    -- local 法术 = self.战斗.法术列表[nid]
    if 定位 then
        return self:法术取描述()
    end

end

function 召唤:法术取描述(v)
    return '恢复目标70%最大气血'
end

function 召唤:召唤_改名(v)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 or type(v) ~= 'string' then
        return '#Y当前状态下无法进行此操作'
    end
    self.名称 = v
    if self.是否观看 then
        mast.rpc:切换名称(self.nid, v)
        mast.rpn:切换名称(self.nid, v)
    end
    mast.rpc:界面信息_召唤(self:召唤_取窗口属性()) --刷新右上宠物状态
    table.print(self:召唤_取窗口属性())
    return true
end

function 召唤:召唤_参战(v)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    if mast.转生 == 0 and self.等级 > mast.等级 + 50 then
        return '#Y参战召唤兽等级不能高于人物50级！'
    end
    if mast.转生 < self.转生要求 then
        return '#Y你还无法驾驭这个等级的召唤兽！'
    end
    if mast.等级 < self.参战等级 and mast.转生 < self.转生要求 then
        return '#Y你还无法驾驭这个等级的召唤兽！'
    end
    --参战条件判断
    if mast.参战召唤 then
        mast.参战召唤.是否参战 = false
    end
    self.是否参战 = v == true
    if self.是否参战 then
        mast.参战召唤 = self
        mast.rpc:界面信息_召唤(self:取界面数据())
    else
        mast.rpc:界面信息_召唤()
        mast.参战召唤 = nil
    end
    return self.是否参战
end

function 召唤:召唤_参战刷新(v)
    local mast = self.主人
    --参战条件判断
    if mast.参战召唤 then
        mast.参战召唤.是否参战 = false
    end
    self.是否参战 = v == true
    if self.是否参战 then
        mast.参战召唤 = self
        mast.rpc:界面信息_召唤(self:取界面数据())
    else
        mast.rpc:界面信息_召唤()
        mast.参战召唤 = nil
    end
    return self.主人.nid
end

function 召唤:召唤_加点(t)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    local 加点总和 = 0
    for k, v in pairs(t) do
        加点总和 = 加点总和 + v
    end
    if 加点总和 <= self.潜力 then
        self.潜力 = self.潜力 - 加点总和
        self.根骨 = self.根骨 + t[1]
        self.灵性 = self.灵性 + t[2]
        self.力量 = self.力量 + t[3]
        self.敏捷 = self.敏捷 + t[4]
        self:刷新属性()
    end
    self.主人.rpc:界面信息_召唤(self:召唤_取窗口属性())
    return true
end

function 召唤:召唤_加点返回(t)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    local 加点总和 = 0
    for k, v in pairs(t) do
        加点总和 = 加点总和 + v
    end
    if 加点总和 <= self.潜力 then
        self.潜力 = self.潜力 - 加点总和
        self.根骨 = self.根骨 + t[1]
        self.灵性 = self.灵性 + t[2]
        self.力量 = self.力量 + t[3]
        self.敏捷 = self.敏捷 + t[4]
        self:刷新属性()
    end
    self.主人.rpc:界面信息_召唤(self:召唤_取窗口属性()) --刷新右上宠物状态
    return self:召唤_取窗口属性()
end

function 召唤:召唤_放生()
    local mast = self.主人
    -- if mast.是否战斗 or mast.是否摆摊 or mast.加锁状态 then
    if mast.是否战斗 or mast.是否摆摊  then
        return '#Y高级操作请先解除安全码!请不要将安全码透露给他人'
    end
    for k,v in self:遍历内丹() do
        return '#Y拥有内丹的召唤兽无法放生'
    end
    if mast.参战召唤 == self then
        return '#Y当前召唤兽参战中无法进行此操作'
    end
    if self.被管制 then
        return '#Y当前召唤兽处于管制状态,无法放生'
    end
    if mast.观看召唤 == self then
        mast.当前地图:删除召唤(self)
    end

    self:删除()
    return true
end

function 召唤:召唤_观看(v)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    if mast.观看召唤 then
        mast.当前地图:删除召唤(mast.观看召唤)
        mast.观看召唤=nil
    end
    self.是否观看 = v == true

    if self.是否观看 then
        self.x, self.y = mast.x, mast.y
        mast.当前地图:添加召唤(self)
        mast.观看召唤 = self
    end

    return self.是否观看
end

function 召唤:召唤_驯养()
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    if self.忠诚 >= 100 then
        return '#Y召唤兽忠诚已满！'
    end
    local v = self.主人:物品_获取('宠物口粮')
    local gv = self.主人:物品_获取('高级宠物口粮')
    local n = 1
    if gv then
        gv:减少(1)
        n = 99
    elseif v then
        v:减少(1)
        n = 5
    else
        return '#Y你的包裹里没有宠物口粮'
    end
    self.忠诚 = self.忠诚 + n
    if self.忠诚 > 100 then
        self.忠诚 = 100
    end
    mast.rpc:界面信息_召唤(self:召唤_取窗口属性()) --刷新右上宠物状态
    return true,self.忠诚
end

function 召唤:召唤_取窗口抗性()
    self:刷新属性()
    local r = {}
    for _, k in pairs(require('数据库/抗性库')) do
        if self.抗性[k] ~= 0 then
            r[k] = self.抗性[k]
        end
    end

    for _, k in pairs { "成长", "亲密", "初血", "初法", "初攻", "初敏","金","木","水","火","土" } do
        r[k] = self[k]
    end
    return r
end

function 召唤:召唤_取窗口技能()
    self:刷新属性()
    local r = self.技能
    -- for _, k in pairs(require('数据库/技能库')) do
    --     if self.抗性[k] ~= 0 then
    --         r[k] = self.抗性[k]
    --     end
    -- end

    -- for _, k in pairs { "成长", "亲密", "初血", "初法", "初攻", "初敏","金","木","水","火","土" } do
    --     r[k] = self[k]
    -- end
    return r
end

function 召唤:召唤_取窗口属性()
    -- self = self.战斗 or self
    self = self
    local r = {}
    for _, v in pairs {
        'nid',
        '等级',
        '转生',
        '飞升',
        '亲密',
        '外形',
        '染色',
        '名称',
        '忠诚',
        '气血',
        '最大气血',
        '魔法',
        '最大魔法',
        '攻击',
        '速度',
        '经验',
        '最大经验',
        '根骨',
        '灵性',
        '力量',
        '敏捷',
        '潜力',
        '是否参战',
        '是否观看',
        '炼妖',
        '天生技能',
        '领悟技能',
        '技能格子',
        '技能'

    } do
        r[v] = self[v]
        if v == '速度' then
            r[v] = self.数据.速度
        elseif v == '攻击' then
            r[v] = self.数据.攻击
        end
    end
    local list = {}

    for _, v in ipairs(self.内丹) do
        table.insert(list, {
            名称 = v.技能,
            等级 = v.等级,
            转生 = v.转生,
            点化 = v.点化
        })
    end
    r.内丹 = list
    if not self.战斗 then
        self.主人.当前查看召唤 = self
    end
    return r
end

function 召唤:召唤_取内丹列表()
    local list = {}
    for _, v in ipairs(self.内丹) do
        table.insert(list, {
            名称 = v.技能,
            等级 = v.等级,
            转生 = v.转生,
            点化 = v.点化,
            经验 = v.经验,
            最大经验 = v.最大经验,
            元气 = v.元气,
            最大元气 = v.最大元气,
            描述 = v:取描述(self)
        })
    end
    return list
end

function 召唤:召唤_打开抗性窗口()
    return self:召唤_取窗口抗性()
end

function 召唤:召唤_打开技能窗口()
    return self:召唤_取窗口技能()
end

function 召唤:召唤_物品使用(i)
    -- print(i,m)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    return self.主人:角色_召唤物品使用(i, self)
end

function 召唤:召唤_炼妖(q)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end

    local 物品 = self.主人:角色_取物品信息(q)
    if not 物品 then
        return '#Y无此道具'
    end
    if not 物品.参数 and 物品.名称 ~= '金柳露' and 物品.名称 ~= '高级金柳露' and 物品.名称 ~= '超级金柳露' and 物品.名称 ~= '卧龙丹' then
        return '#Y这件物品不能用来炼妖'
    end
    if 物品.名称 == '卧龙丹' then
        self.数据.炼妖 = {}
        self:刷新属性()
        物品:减少(1)
        self.主人.rpc:提示窗口('#Y炼妖已清除')
        return 2
    end
      local 上限 = 5 + self.转生 * 3
    if self.转生 == 3 then
        上限 = 11
    end
    if #self.炼妖 >= 上限 then
        return '#Y你的召唤兽炼妖次数已达上限'
    end
    if not self.数据.炼妖 then
        self.数据.炼妖 = {}
    end
    local 法抗表={"抗混乱","抗封印","抗昏睡","抗中毒","抗水","抗雷","抗火","抗风","抗遗忘","抗鬼火","物理吸收"}
    local 炼妖表={"灵犀角","云罗帐","五溪散","雪蟾蜍","沧海珠","蓝田玉","烈焰砂","霄汉鼎","忆梦符","辟邪珠","武帝袍"}
    for i=1,#炼妖表 do
        if 物品.名称 == 炼妖表[i] then
            self.数据.炼妖[#self.数据.炼妖 + 1] = { }
            self.数据.炼妖[#self.数据.炼妖][法抗表[i]] = 物品.参数
            self:刷新属性()
            物品:减少(1)
            self.主人.rpc:提示窗口('#Y炼妖成功')
            return 2
        end
    end

    if 物品.名称 == '盘古石' then
        if type(物品.参数) ~= 'table' then
            return '#Y这件物品不能用来炼妖'
        end
        self.数据.炼妖[#self.数据.炼妖 + 1] = { }
        self.数据.炼妖[#self.数据.炼妖].抗风 = 物品.参数[1]
        self.数据.炼妖[#self.数据.炼妖].抗水 = 物品.参数[2]
        self.数据.炼妖[#self.数据.炼妖].抗雷 = 物品.参数[3]
        self.数据.炼妖[#self.数据.炼妖].抗火 = 物品.参数[4]
        self:刷新属性()
        物品:减少(1)
        self.主人.rpc:提示窗口('#Y炼妖成功')
        return 2
    end
    if 物品.名称 == '金柳露' or 物品.名称 == '高级金柳露' or 物品.名称 == '超级金柳露' then
        local 极品率 = { 全满 = 0.1, 满成长 = 0.2, 满初值 = 0.15, 暴成长 = 0}
        local 召唤兽数据 = _召唤库[self.名称]
        if not 召唤兽数据 then
            return '#Y获取召唤兽数据失败'
        end
        if 召唤兽数据.类型 ~= 1 then
            return '#Y这类召唤兽无法服用金柳露'
        end
        if 物品.名称 == '高级金柳露' then
            极品率 = { 全满 = 0.15, 满成长 = 0.3, 满初值 = 0.2, 暴成长 = 0.03}
        elseif 物品.名称 == '超级金柳露' then
            极品率 = { 全满 = 0.4, 满成长 = 0.2, 满初值 = 0.2, 暴成长 = 0.12}
        end
        local 总概率 = 极品率.全满 + 极品率.满成长 + 极品率.满初值 + 极品率.暴成长
        local 随机 = math.random()
        self.等级 = 0
        self.经验 = 0
        self.最大经验 = self:取升级经验()
        if 总概率 >= 随机 then
            if 极品率.暴成长 >= 随机 then
                self.成长 = 召唤兽数据.成长 + 召唤兽数据.成长*随机
                self.初血 = 召唤兽数据.初血
                self.初法 = 召唤兽数据.初法
                self.初攻 = 召唤兽数据.初攻
                self.初敏 = 召唤兽数据.初敏
                self.主人.rpc:提示窗口('#Y你的召唤兽灵光一闪,似乎已突破瓶颈,可喜可贺#89')
            elseif 极品率.全满 >= 随机 then
                self.成长 = 召唤兽数据.成长
                self.初血 = 召唤兽数据.初血
                self.初法 = 召唤兽数据.初法
                self.初攻 = 召唤兽数据.初攻
                self.初敏 = 召唤兽数据.初敏
                self.主人.rpc:提示窗口('#Y你的召唤兽天资聪慧,似乎达到最佳状态,可喜可贺#89')
            elseif 极品率.满初值 >= 随机 then
                self.成长 = math.random(math.floor(召唤兽数据.成长 * 0.8 * 1000) ,召唤兽数据.成长 * 1000) / 1000
                self.初血 = 召唤兽数据.初血
                self.初法 = 召唤兽数据.初法
                self.初攻 = 召唤兽数据.初攻
                self.初敏 = 召唤兽数据.初敏
                self.主人.rpc:提示窗口('#Y你的召唤兽后来居上,状态已达到巅峰#17')
            else
                self.成长 = 召唤兽数据.成长
                self.初血 = math.random(math.floor(召唤兽数据.初血 * 0.8) ,召唤兽数据.初血)
                self.初法 = math.random(math.floor(召唤兽数据.初法 * 0.8) ,召唤兽数据.初法)
                self.初攻 = math.random(math.floor(召唤兽数据.初攻 * 0.8) ,召唤兽数据.初攻)
                local 随机 = math.random(800,1000) / 1000
                self.初敏 = math.floor(召唤兽数据.初敏 * 随机)
                self.主人.rpc:提示窗口('#Y你的召唤兽福至心灵,似乎有返祖的迹象#35')
            end
        else
            self.成长 = math.random(math.floor(召唤兽数据.成长 * 0.8 * 1000) ,召唤兽数据.成长 * 1000) / 1000
            self.初血 = math.random(math.floor(召唤兽数据.初血 * 0.8) ,召唤兽数据.初血)
            self.初法 = math.random(math.floor(召唤兽数据.初法 * 0.8) ,召唤兽数据.初法)
            self.初攻 = math.random(math.floor(召唤兽数据.初攻 * 0.8) ,召唤兽数据.初攻)
            local 随机 = math.random(800,1000) / 1000
            self.初敏 = math.floor(召唤兽数据.初敏 * 随机)
        end
        self:洗点处理()
        物品:减少(1)
        return '#Y合成成功'
    end
    return '#Y这件物品不能用来炼妖'
end

function 召唤:召唤_取内丹(name)
    for _, v in ipairs(self.内丹) do
        if v.技能 == name then
            return v
        end
    end
end

function 召唤:召唤_删除内丹(name)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    for i, v in ipairs(self.内丹) do
        if v.技能 == name then
            table.remove(self.内丹, i)
            return
        end
    end
end

function 召唤:召唤_吐出内丹(name)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    local 内丹 = self:召唤_取内丹(name)
    if 内丹 then
        local r = 内丹:吐出(self)
        if r and self.主人:物品_检查添加 { r } then
            self:召唤_删除内丹(name)
            self.主人:物品_添加 { r }
            self:刷新属性()
            self.主人.rpc:常规提示('#Y这只召唤兽吐出了一颗内丹。')
            return true
        end
    else
        return '#R内丹不存在'
    end
end

function 召唤:召唤_内丹经验转换(name)
    local mast = self.主人
    if mast.是否战斗 or mast.是否摆摊 then
        return '#Y当前状态下无法进行此操作'
    end
    local 内丹 = self:召唤_取内丹(name)
    if 内丹 then
        if 内丹.等级 >= 内丹.等级上限 then
            if 内丹.转生 + 1 > self.转生 then
                return '内丹的转生次数,不可高于召唤兽！'
            else
                if 内丹:转生处理(self) then
                    self.刷新的属性.内丹 = true
                    return string.format("#Y%s#W内丹转生成功！", 内丹.技能)
                end
            end
        else
            if self.经验 < 500 then
                return "#Y一次最少要转换500点经验，你的召唤兽经验不够了。"
            end
            local n = math.floor(self.经验 * 0.2)
            local lv, ts = 内丹.等级, nil
            if 内丹:添加经验(n, self) then
                self.经验   = self.经验 - n
                self.刷新的属性.内丹= true
                if 内丹.等级 > lv then
                    ts = string.format("#Y%s内丹升到%s级", 内丹.技能, 内丹.等级)
                end
                return 内丹.经验, 内丹.等级,
                    string.format("#Y%s的%s内丹获得#R%s#Y点经验",
                        召唤.名称, 内丹.技能, n), ts
            end
        end
    end
end
-- function 召唤:召唤_取染色方案(self.外形)
-- -- self:取召唤染色方案(self.外形)
-- end