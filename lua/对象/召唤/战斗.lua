-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-30 11:37:01
-- @Last Modified time  : 2024-08-27 11:18:19

local 召唤 = require('召唤')

function 召唤:战斗_开始(对象)
    self.战斗已上场 = true
    --元气
    for k, v in self:遍历内丹() do
        v:增减元气(-1)
    end
    self.战斗 = 对象
    self.战斗.菜单指令 = self.主人.战斗召唤指令 or '物理'
    self.战斗.菜单目标 = self.主人.战斗召唤目标 or 11
    self.战斗.选择 = self.主人.战斗召唤选择
    self.主人.战斗召唤 = 对象

    if self.主人.上一场位置 and self.战斗.位置 then
        if self.主人.上一场位置 + 5 < 11 and self.战斗.位置 > 10 or self.主人.上一场位置 + 5 > 10 and self.战斗.位置 < 11 then
            if self.战斗.菜单目标 > 10 then

                self.战斗.菜单目标 = self.战斗.菜单目标 - 10
            elseif self.战斗.菜单目标 < 10 then

                self.战斗.菜单目标 = self.战斗.菜单目标 + 10
            end
        end
        self.主人.战斗召唤目标 = self.战斗.菜单目标
    end
end

function 召唤:取是否可参战()
    if self.主人.转生 == 0 then
        if self.等级 - self.主人.等级 >= 50 then
            self.主人.rpc:提示窗口('#Y当前参战召唤兽等级过高,无法加入战斗！')
            return
        end
    end
    if self.忠诚 < 70 then
        if math.random(100) >= 50 then
            self.主人.rpc:提示窗口('#Y你的召唤兽忠诚过低,不愿意加入战斗！')
            return
        end
    end
    return true
end

function 召唤:战斗_结束(召还)
    self.气血 = self.战斗.气血
    self.魔法 = self.战斗.魔法
    if self.战斗.是否死亡 then
        self.气血 = math.floor(self.最大气血 * 0.1)
        self.魔法 = math.floor(self.最大魔法 * 0.1)
    end
    self.主人.task:召唤战斗结束(self.主人.接口)

    if self.主人.是否机器人 then
        self.忠诚 = 100
        self.气血 = self.最大气血
        self.魔法 = self.最大魔法
    end
    self:刷新属性()
end

function 召唤:死亡处理()
    self.忠诚 = self.忠诚 - 15
    self.亲密 = self.亲密 - 50
    if self.忠诚 <= 0 then
        self.忠诚 = 0
    end
    if self.亲密 <= 0 then
        self.亲密 = 0
    end
end

function 召唤:召唤_战斗属性() --战斗召唤窗口
    local r = {}
    for _, v in pairs {
        'nid',
        '名称',
        '等级',
        '染色',
        '忠诚',
        '亲密',
        '转生',
        '飞升',
        '外形',
        '气血',
        '最大气血',
        '魔法',
        '最大魔法',
        '攻击',
        '速度',
        '经验',
        --法术
    } do
        r[v] = self[v]
    end

    local list = {}
    for _, v in ipairs(self.内丹) do
        table.insert(list, {
            名称 = v.技能,
            等级 = v.等级,
            转生 = v.转生,
            点化 = v.点化,
        })
    end
    r.内丹 = list
    return r
end

function 召唤:召唤_战斗技能列表(name)
    local list = {}
    for _, v in pairs(self.战斗.法术列表) do
        if v.是否主动 then --主动
            table.insert(list, {
                nid = v.nid,
                名称 = v.名称,
                熟练度 = 1,
                是否内丹 = ggetype(v) == '内丹',
                消耗 = v:法术取消耗(self.战斗),
                技能描述 = self:召唤_战斗技能描述(v.nid)
            })
        end
    end
    return list, self.战斗.魔法, self.战斗.气血
end

function 召唤:召唤_战斗技能描述(nid)
    local 法术 = self.战斗.法术列表[nid]
    if 法术 then
        return 法术:法术取描述(self.战斗)
    end

end
