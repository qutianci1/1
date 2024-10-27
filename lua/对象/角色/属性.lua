-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-04-20 01:24:27
-- @Last Modified time  : 2024-09-07 17:21:25
local MYF = require('我的函数')

local 角色 = require('角色')

function 角色:属性_初始化()
    self.刷新的属性 = {}
end

function 角色:属性_更新()
    if self.刷新的属性.最大气血 then
        self.rpc:置人物气血(self.气血, self.刷新的属性.最大气血)
    end
    if self.刷新的属性.最大魔法 then
        self.rpc:置人物魔法(self.魔法, self.刷新的属性.最大魔法)
    end
    if self.刷新的属性.最大经验 then
        self.rpc:置人物经验(self.经验, self.刷新的属性.最大经验)
    end
    if next(self.刷新的属性) then
        coroutine.xpcall(
            function()
                if self.刷新的属性.头像 then
                    self.rpc:置人物头像(self.刷新的属性.头像)
                end
                if self.刷新的属性.气血 then
                    if not self.是否助战 then
                        self.rpc:置人物气血(self.刷新的属性.气血, self.刷新的属性.最大气血)
                    end
                end
                if self.刷新的属性.魔法 then
                    if not self.是否助战 then
                        self.rpc:置人物魔法(self.刷新的属性.魔法, self.刷新的属性.最大魔法)
                    end
                end
                if self.刷新的属性.经验 then
                    if not self.是否助战 then
                        self.rpc:置人物经验(self.刷新的属性.经验, self.刷新的属性.最大经验)
                    end
                end
                if self.刷新的属性.外形 then
                    self.rpc:切换外形(self.nid, self.外形)
                    self.rpn:切换外形(self.nid, self.外形)
                end
                if self.刷新的属性.名称颜色 then
                    self.rpc:切换名称颜色(self.nid, self.名称颜色)
                    self.rpn:切换名称颜色(self.nid, self.名称颜色)
                end
                if self.刷新的属性.技能 then
                    self.rpc:请求刷新人物技能()
                end
                if self.刷新的属性.召唤列表 then
                    self.rpc:请求刷新召唤列表()
                end
                if self.刷新的属性.银子 then
                    self.rpc:刷新银子()
                end
                if self.刷新的属性.师贡 then
                    self.rpc:刷新师贡()
                end
                if self.刷新的属性.存银 then
                    self.rpc:刷新存银()
                end
                self.rpc:请求刷新人物()

                self.刷新的属性 = {}
            end
        )
    end
end

function 角色:角色_打开人物窗口()
    return self:角色_取窗口属性()
end

function 角色:角色_人物加点(t)
    if not self.是否战斗 and type(t) == 'table' then
        local n = 0
        for k, v in pairs(t) do
            if k ~= '潜力' and self[k] and type(v) == 'number' then
                n = n + v
            end
        end
        if n <= self.潜力 then
            self.潜力 = self.潜力 - n
            self.根骨 = self.根骨 + t.根骨
            self.灵性 = self.灵性 + t.灵性
            self.力量 = self.力量 + t.力量
            self.敏捷 = self.敏捷 + t.敏捷
            self:刷新属性()
            self.rpc:界面人物(self:角色_取窗口属性())
            return self:角色_取窗口属性()
        end
    end
end

function 角色:角色_取已分配属性()
    return (self.根骨 - self.等级) + (self.灵性 - self.等级) + (self.力量 - self.等级) + (self.敏捷 - self.等级)
end

function 角色:角色_人物洗点()
    if self.是否战斗 then
        return
    end
    self.根骨 = self.等级
    self.灵性 = self.等级
    self.力量 = self.等级
    self.敏捷 = self.等级
    self.潜力 = self.等级 * 4 + self.转生 * 60
    self:刷新属性()
end

function 角色:角色_取窗口属性()
    -- self = self.战斗 or self
    self = self
    local r = {}
    for _, v in pairs {
        'id',
        '名称',
        '外形',
        '原形',
        '头像',
        '种族',
        '称谓',
        '帮派',
        '声望',
        '最大声望',
        '战绩',
        '最大战绩',
        '等级',
        '转生',
        '经验',
        '最大经验',
        '气血',
        '最大气血',
        '魔法',
        '最大魔法',
        '攻击',
        '速度',
        '根骨',
        '灵性',
        '力量',
        '敏捷',
        '潜力'
    } do
        if type(self[v]) == 'number' then
            self[v] = math.floor(self[v])
        end
        r[v] = self[v]
    end
    r.根骨 = self.装备属性.根骨 + self.根骨
    r.灵性 = self.装备属性.灵性 + self.灵性
    r.力量 = self.装备属性.力量 + self.力量
    r.敏捷 = self.装备属性.敏捷 + self.敏捷
    return r
end

function 角色:角色_打开抗性窗口()
    if not self.是否战斗 then
        self:刷新属性()
    end
    local r = {}
    for _, k in pairs(require('数据库/抗性库')) do
        if self.抗性[k] ~= 0 then
            r[k] = self.抗性[k]
        end
    end
    return r
end

function 角色:角色_获取变身卡册信息()
    local 类型 = {'强法','抗性','物理'}
    for i=1,#类型 do
        if not self.变身卡册[类型[i]] then
            self.变身卡册[类型[i]] = {}
        end
        table.sort(self.变身卡册[类型[i]], function(a, b)
            return a.等级 < b.等级
        end)
    end
    return self.变身卡册
end

function 角色:角色_取出卡片(r)
    local 空位 = self:物品_查找空位()
    if 空位 < 1 then
        return '#Y你身上的空位不足,清理空间后再来吧'
    end
    if r then
        r.数量 = nil
        self:物品_添加({__沙盒.生成物品 {名称 = r.名称, 数量 = 1 , 参数 = r }})
        self.rpc:提示窗口('#Y已取出'..r.名称..'变身卡')
        local 序号 = 0
        for k,v in pairs(self.变身卡册[r.类型]) do
            if v.名称 == r.名称 then
                序号 = k
            end
        end
        self.变身卡册[r.类型][序号].数量 = self.变身卡册[r.类型][序号].数量 - 1
        if self.变身卡册[r.类型][序号].数量 <= 0 then
            table.remove(self.变身卡册[r.类型], 序号)
        end

        local 类型 = {'强法','抗性','物理'}
        for i=1,#类型 do
            table.sort(self.变身卡册[类型[i]], function(a, b)
                return a.等级 < b.等级
            end)
        end
        self.rpc:刷新七十二变(self.变身卡册)
    end
end

function 角色:角色_星梦石洗点(属性)
    if self[属性] then
        if self[属性] > self.等级 + 5 then
            self[属性] = self[属性] - 5
            self.潜力 = self.潜力 + 5000000
            self:刷新属性()
            return true
        end
    end
end