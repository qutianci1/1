-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-25 17:16:26
-- @Last Modified time  : 2024-08-25 08:32:42
local MYF = require('我的函数')
local _召唤库 = require('数据库/召唤库')
local 战斗对象 = class('战斗对象')
gge.require('战斗/对象/事件')

function 战斗对象:初始化(位置, 对象, 战场)
    self.战场 = 战场
    self.位置 = 位置
    self.对象 = 对象
    self.怨气 = 149
    self.回合数 = 0
    self.已行动 = false
    self.辅助冷却 = {}
    self.转生 = 对象.转生

    local tp = ggetype(对象)
    self.是否玩家 = tp == '角色'
    self.是否召唤 = tp == '召唤'
    self.是否怪物 = tp == '怪物'
    self.孩子增益 = {}
    if 位置 >= 21 then
        self.是否怪物 = false
        self.是否召唤 = false
        self.是否玩家 = false

        self.是否孩子 = true
        self.是否施法 = false

        if 位置 <= 25 then
            self.主人 = 位置 - 20
        else
            self.主人 = 位置 - 15
        end
    end

    self.指令 = '物理'

    self:事件_初始化()
    self.回合数据 = {} --发给客户端的
    self.BUFF列表 = {}
    self.法术列表 = {}
    self.召唤列表 = {}
    self.内丹列表 = {}
    self.主动技能 = {} --怪物随机用

    self.气血 = 对象.气血
    self.魔法 = 对象.魔法

    self.对象数据 = {
        攻击 = 对象.攻击,
        速度 = 对象.速度,
        忽视躲闪率 = 0, --废弃
        抗致命几率 = 0, --废弃
        抗连击率 = 0, --废弃
        忽视反击率 = 0, --废弃
    }

    if self.是否玩家 then
        for _, v in 对象:遍历召唤() do
            v.战斗已上场 = false
            table.insert(self.召唤列表, v)
        end
        table.sort(
            self.召唤列表,
            function(a, b)
                return a.顺序 < b.顺序
            end
        )

        for _, v in 对象:遍历技能() do
            if v.战斗可用 then --战斗
                self.法术列表[v.nid] = v
            end
        end
        --变身卡修正
        local r = self:任务_获取("变身卡")
        if self.变身修正 and r then
            local 属性1 = {'最大气血','最大魔法','攻击','速度'}
            local 属性2 = {'气血','魔法','攻击','速度'}
            local 简称 = {'HP','MP','AP','SP'}
            for i=1,#属性1 do
                if r.变身属性[简称[i]] then
                    local 修正 = string.format("%.2f" , r.变身属性[简称[i]] * self.变身修正)
                    local 提升数值 = 0
                    if 对象[属性1[i]] then
                        提升数值 = math.floor(对象[属性1[i]] * (修正 / 100))
                        对象[属性1[i]] = 对象[属性1[i]] + 提升数值
                        self.rpc:聊天框提示('#115 %s','#R你的'..属性1[i]..'增加了'..修正..'%')
                    end
                    if 对象[属性2[i]] then
                        对象[属性2[i]] = 对象[属性2[i]] + 提升数值
                    end
                end
            end
            local 类型 = r.变身属性.类型
            if 类型 then
                local 强法属性={"加强混乱","加强封印","加强昏睡","加强毒伤害","加强火","加强风","加强雷","加强水","加强鬼火","加强遗忘","加强三尸虫回血程度"}
                local 物理属性={"连击次数","连击率","反震程度","反震率","反击率","反击","躲闪率","狂暴几率","致命几率","忽视防御程度","忽视防御几率"}
                local 抗性属性={"物理吸收","抗火","抗水","抗雷","抗风","抗混乱","抗昏睡","抗封印","抗中毒","抗震慑","抗鬼火","抗遗忘","抗三尸虫"}
                local 五行属性={"金","木","水","火","土"}
                local 抗性文本 = ''
                local 五行文本 = ''
                local 调用属性 = 强法属性
                if r.变身属性.类型 == '抗性' then
                    调用属性 = 抗性属性
                elseif r.变身属性.类型 == '物理' then
                    调用属性 = 物理属性
                end
                for i=1,#调用属性 do
                    if r.变身属性[调用属性[i]] and r.变身属性[调用属性[i]] ~= 0 then
                        local 修正 = string.format("%.2f" , r.变身属性[调用属性[i]] * self.变身修正)
                        if 对象.抗性[调用属性[i]] then
                            对象.抗性[调用属性[i]] = 对象.抗性[调用属性[i]] + 修正
                            self.rpc:聊天框提示('#115 %s','#R你的'..调用属性[i]..'增加了'..修正..'%')
                        end
                    end
                end
                for i=1,#五行属性 do
                    if r.变身属性[五行属性[i]] and r.变身属性[五行属性[i]] ~= 0 then
                        对象.抗性[五行属性[i]] = r.变身属性[五行属性[i]]
                    end
                end
            end
        end
    elseif self.是否召唤 or self.是否怪物 then
        self.是否消失 = self.是否消失 == nil
        self.装备属性 = MYF.容错表()

        for k, v in 对象:遍历内丹() do
            if v.元气 > 0 then
                if v.战斗可用 then
                    v.数据 = {名称 = v.技能}
                    self.法术列表[v.nid] = v
                end
                table.insert(self.内丹列表, v)
            end
        end
        for _, v in 对象:遍历技能() do
            if v.战斗可用 then --战斗
                self.法术列表[v.nid] = v
            end
        end
    end
    if not self.是否孩子 then
        for _, k in pairs(require('数据库/抗性库')) do
            self.对象数据[k] = 对象.抗性[k]
        end
        for k, v in pairs(self.法术列表) do
            if v.是否主动 then
                table.insert(self.主动技能, v)
            end
        end
        if 对象.AI then
            for k, v in pairs(对象.AI) do
                self[v] = true
            end
        end
    end
end

function 战斗对象:__index(k)
    local t = rawget(self, '对象数据')
    if t and t[k] ~= nil then
        return t[k]
    end
    local t = rawget(self, '对象')
    if t and t[k] ~= nil then
        return t[k]
    end
end

function 战斗对象:播放动作()
    for i, v in self.战场:遍历玩家() do
        v.rpc:孩子施法(self.位置)
        for m, n in pairs(self.战场._观战表) do
            n.rpc:孩子施法(self.位置)
        end
    end
end

function 战斗对象:删除状态(id)
    for i, v in self.战场:遍历玩家() do
        v.rpc:删除状态(self.位置)
        for m, n in pairs(self.战场._观战表) do
            n.rpc:战斗删除状态(self.位置,id)
        end
    end
end

function 战斗对象:当前喊话(s)
    for i, v in self.战场:遍历玩家() do
        if not v.离线角色 then
            v.rpc:战斗喊话(self.位置, s)
        end
        for m, n in pairs(self.战场._观战表) do
            if not n.离线角色 then
                n.rpc:战斗喊话(self.位置, s)
            end
        end
    end
end

function 战斗对象:队伍喊话(s)
    for i, v in self:遍历我方玩家() do
        if not v.离线角色 then
            v.rpc:战斗喊话(self.位置, s)
        end
        for m, n in pairs(self.战场._观战表) do
            if not n.离线角色 then
                n.rpc:战斗喊话(self.位置, s)
            end
        end
    end
end

function 战斗对象:脱离战斗()
    self.战场:强制结束()
end

--===============================================================================
function 战斗对象:战斗开始()
    if self.对象.战斗_开始 then
        self.对象:战斗_开始(self)
    end
end

function 战斗对象:战斗结束(助战)
    if self.对象.战斗_结束 then
        self.对象:战斗_结束(助战)
    end
    -- if self.是否怪物 then
    --     self.战场:战斗结束(self)
    -- end
end

function 战斗对象:进入战斗()
    self.当前数据.位置 = self.位置
    self.ev:进入战斗(self)
    if self.内丹列表[1] then
        self.内丹列表[1]:切换内丹BUFF(self)
    end
end

function 战斗对象:取数据(v) --客户端获取数据
    local wx = self.外形
    if self.是否玩家 then
        wx = self:角色_取战斗模型()
    end
    local r = {}
    r.nid = self.nid
    r.转生 = self.转生
    r.名称 = self.名称
    r.名称颜色 = self.名称颜色
    r.外形 = wx
    r.染色 = self.染色
    r.位置 = self.位置
    r.是否死亡 = self.是否死亡
    r.是否玩家 = self.是否玩家
    r.是否召唤 = self.是否召唤
    r.离线角色 = self.离线角色
    r.buf = {}
    for _, v in pairs(self.BUFF列表) do
        table.insert(r.buf, v.id)
    end
    --buf
    if not v or (v < 11 and self.位置 < 11) or (v > 10 and self.位置 > 10) then
        r.气血 = self.气血
        r.最大气血 = self.最大气血
        r.魔法 = self.魔法
        r.最大魔法 = self.最大魔法
    end
    return r
end

--===============================================================================
function 战斗对象:回合开始()
    self.已行动 = false
    self.回合数 = self.回合数 + 1
    self.当前数据.位置 = self.位置
    self.已保护 = false --注每回合只可触发
    self.ev:回合开始(self)
    if self.ev:BUFF回合开始(self) == false then
    end
    local 敌方可用 = false
    if self.是否怪物 then
        self.魔法 = 200000
        if #self.主动技能 > 0 then
            self.指令 = ({ '物理', '法术' })[math.random(2)]
            if self.施法几率 then
                if self.施法几率 >= math.random(100) then
                    self.指令 = '法术'
                end
            end
            if self.施法几率 == 0 then
                self.指令 = '物理'
            end
            local 物理处理 = false
            if self.指令 == '法术' then
                local 特殊技能 = {'互相拉血' , '指定拉血' , '天魔解体_AI' , '睡自己'}
                local 特殊技能数量 = 0
                --排除掉单位只有特殊技能的情况
                for n = 1 , #self.主动技能 do
                    for k = 1 , #特殊技能 do
                        if self.主动技能[n].名称 == 特殊技能[k] then
                            特殊技能数量 = 特殊技能数量 + 1
                        end
                    end
                end
                if 特殊技能数量 == #self.主动技能 then
                    物理处理 = true
                end
                if not 物理处理 then
                    local i = math.random(#self.主动技能)
                    if 特殊技能数量 >= 1 then
                        for n = 1 , #特殊技能 do
                            while self.主动技能[i].名称 == 特殊技能[n] do
                                i = math.random(#self.主动技能)
                            end
                        end
                    end
                    self.选择 = self.主动技能[i].nid
                    敌方可用 = self.主动技能[i].敌方可用
                end
            end
            if 物理处理 then
                self.指令 = '物理'
            end
        else
            self.指令 = '物理'
        end
        if self.指令 == "法术" then
            if self.选择 and 敌方可用 then
                self.目标 = self:随机敌方存活目标()
            else
                self.目标 = self:随机我方存活目标()
            end
        elseif self.指令 == "物理" then
            self.目标 = self:随机敌方存活目标()
        end
        self.战场:脚本战斗回合开始(self)
    end
    --print(self.名称,self.是否孩子)
    if self.是否孩子 then
        local 主人 = self:取主人目标(self.主人)
       -- print(主人,"是否存在")
        if 主人 then
            for i=1,3 do
                if self.天资[i] then
                    if self.天资[i] ~= '淘气' and self.天资[i] ~= '天真' and self.天资[i] ~= '好奇' then
                        local 几率 = MYF.取孩子技能几率(self.评价,self.亲密,self.孝心,self.天资[i])
                        if self.天资[i] == '水系吸收' or self.天资[i] == '玄冰甲' or self.天资[i] == '火系吸收' or self.天资[i] == '烈火甲' or self.天资[i] == '雷系吸收' or self.天资[i] == '天雷甲' or self.天资[i] == '风系吸收' or self.天资[i] == '狂风甲' or self.天资[i] == '鬼火吸收' or self.天资[i] == '冥火甲' then
                            if math.random(1, 100) <= 40 then
                                if not self.离线角色 then
                                    self:当前喊话('看我的#G'..self.天资[i]..'#46')
                                end
                            end
                        else
                            if math.random(1, 100) <= 几率 then
                                if not self.离线角色 then
                                    self:当前喊话('看我的#G'..self.天资[i]..'#46')
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function 战斗对象:回合开始数据(data)
    self.rpc:回合开始(data)
    self.掉线等待 = nil
end

function 战斗对象:回合结束()
    self.保护 = nil
    self.目标 = nil
    self.当前数据.位置 = self.位置
    if self.内丹列表[2] then
        local i = math.random(#self.内丹列表)
        self.内丹列表[i]:切换内丹BUFF(self)
    end
    self.ev:BUFF回合结束(self)
    self.ev:法术回合结束(self)
    if self.是否怪物 then
        self.战场:脚本战斗回合结束(self)
    end
    if self.是否孩子 then
        local 主人 = self:取主人目标(self.主人)
        if 主人 then
            if 主人.孩子增益.龙腾 or 主人.孩子增益.先发制人 then
                主人.速度 = 主人.速度 - 200
            end
            主人.孩子增益 = {}
            for i=1,3 do
                if self.天资[i] then
                    if self.天资[i] ~= '淘气' and self.天资[i] ~= '天真' and self.天资[i] ~= '好奇' then
                        local 几率 = MYF.取孩子技能几率(self.评价,self.亲密,self.孝心,self.天资[i])
                        if self.天资[i] == '水系吸收' or self.天资[i] == '玄冰甲' or self.天资[i] == '火系吸收' or self.天资[i] == '烈火甲' or self.天资[i] == '雷系吸收' or self.天资[i] == '天雷甲' or self.天资[i] == '风系吸收' or self.天资[i] == '狂风甲' or self.天资[i] == '鬼火吸收' or self.天资[i] == '冥火甲' then
                            if math.random(1, 100) <= 40 then
                                主人.孩子增益[self.天资[i]] = 几率
                                -- if not self.离线角色 then
                                --     self:当前喊话('看我的#G'..self.天资[i]..'#46')
                                -- end
                                self:播放动作()
                            end
                        else
                            if math.random(1, 100) <= 几率 then
                                if self.天资[i] == '金刚护体' then
                                    主人.孩子增益[self.天资[i]] = 2
                                elseif self.天资[i] == '铁布衫' then
                                    主人.孩子增益[self.天资[i]] = 1
                                elseif self.天资[i] == '龙腾' or self.天资[i] == '先发制人' then
                                    主人.速度 = 主人.速度 + 200
                                elseif self.天资[i] == '清心咒' or self.天资[i] == '莲台心法' then
                                    主人.ev:宝莲灯解除()
                                    主人:删除状态(301)
                                elseif self.天资[i] == '破冰术' or self.天资[i] == '飞龙在天' then
                                    主人.ev:大手印解除()
                                    主人:删除状态(401)
                                elseif self.天资[i] == '解毒术' or self.天资[i] == '丹青妙手' then
                                    主人.ev:孩子解除()
                                    主人:删除状态(101)
                                else
                                    主人.孩子增益[self.天资[i]] = 几率
                                end
                                -- if not self.离线角色 then
                                --     self:当前喊话('看我的#G'..self.天资[i]..'#46')
                                -- end
                                self:播放动作()
                            end
                        end
                    end
                end
            end
        end
    end
end

function 战斗对象:回合结束数据(data)
    self.rpc:回合结束(data)
    self.掉线等待 = nil
end

--===============================================================================
function 战斗对象:打开菜单(时间) --助战问题存在队伍位置重叠
    local sum = self.战场:取对象(self.位置 + 5) -- +5是找召唤的位置
    -- print('队长位置')
    -- print(self.位置)
    -- print('-----------------')
    self.菜单指令, self.菜单目标, self.菜单选择 = self.rpc:人物菜单(时间, sum == nil,self.nid)
    self:置指令(self.菜单指令, self.菜单目标, self.菜单选择)
    if sum then
        sum.菜单指令, sum.菜单目标, sum.菜单选择 = self.rpc:召唤菜单(sum.nid,self.nid)
        sum:置指令(sum.菜单指令, sum.菜单目标, sum.菜单选择)
    end
    if self.是否队长 then
        local 助战 = self.战场:取助战对象()
        -- local t = self.战场:取数据(self.位置)
        for i,v in pairs(助战) do --获取助战的指令
            if v.队长 == self.nid then
                local sum = self.战场:取对象(v.位置 + 5)
                v.菜单指令, v.菜单目标, v.菜单选择 = self.rpc:人物菜单(时间, sum == nil,v.nid)
                -- print(v.名称,v.菜单指令,v.菜单目标,v.菜单选择)
                v:置指令(v.菜单指令, v.菜单目标, v.菜单选择)
                if sum then
                    sum.菜单指令, sum.菜单目标, sum.菜单选择 = self.rpc:召唤菜单(sum.nid,v.nid)
                    -- print(sum.名称,sum.菜单指令,sum.菜单目标,sum.菜单选择)
                    sum:置指令(sum.菜单指令, sum.菜单目标, sum.菜单选择)
                end
            end
        end
    end
end

function 战斗对象:执行自动() --3秒后
    if self.自动 then
        self.指令 = self.菜单指令
        self.目标 = self.菜单目标
        -- if type(self.自动) == 'number' then
        --     self.自动 = self.自动 - 1
        --     if self.自动 == 0 then
        --         self.自动 = false
        --     end
        -- end
        local sum = self.战场:取对象(self.位置 + 5)
        if sum then
            sum.指令 = sum.菜单指令
            sum.目标 = sum.菜单目标
        end
        self.rpc:战斗自动(self.自动, self.指令, sum and sum.指令)
        return true
    end
end

function 战斗对象:自动战斗(v) --客户端按钮
    self.自动 = v
    if v then
        self.自动 = '∞'
        local sum = self.战场:取对象(self.位置 + 5)

        if sum then
            self.战斗召唤指令 = sum.菜单指令
            self.战斗召唤目标 = sum.菜单目标
            self.战斗召唤选择 = sum.选择
        end
        return self.自动, self.菜单指令, sum and sum.菜单指令
    end
end

function 战斗对象:强退自动战斗(v) --客户端按钮
    local sum = self.战场:取对象(self.位置 + 5)
    if sum then
        self.战斗召唤指令 = sum.菜单指令
        self.战斗召唤目标 = sum.菜单目标
        self.战斗召唤选择 = sum.选择
    end
    return self.自动, self.菜单指令, sum and sum.菜单指令
end

function 战斗对象:置指令(i, n, m) --菜单，或者脚本
    self.指令 = i
    self.目标 = n or self.目标
    self.选择 = m or self.选择
    if i == '物理' then
        -- if n == self.位置 then --不能自己
        --     self.目标 = 0
        -- end
    elseif i == '法术' then
        -- if n == self.位置 then --不能自己
        --     print('这里啊')
        --     self.目标 = 0
        -- end

        if not self.法术列表[m] then
            self.选择 = 0
        end
        --elseif i == '道具' then

    elseif i == '保护' then
        if n ~= self.位置 then --不能自己
            self.保护 = self.目标
        end
    end
end

function 战斗对象:机器人指令()
    local sum = self.战场:取对象(self.位置 + 5)
    local 功能 = self.机器人功能
    local 战斗人物选择
    if 功能.战斗人物法术 then
        if 功能.战斗人物辅助法术 then
            for _, v in pairs(self.法术列表) do
                if v.名称 == 功能.战斗人物辅助法术 and self.回合数 == 0 then
                    self.辅助冷却.名称 = v.名称
                    self.辅助冷却.回合 = self.回合数 + 5
                    self.辅助技能 = v.nid
                    战斗人物选择 = v.nid
                    break
                else
                    if self.辅助冷却.回合 == nil then
                        self.辅助冷却.回合 = 0
                    end
                    if self.辅助冷却.回合 > self.回合数 then
                        for _, v in pairs(self.法术列表) do
                            if v.名称 == 功能.战斗人物法术 and v.名称 ~= self.辅助冷却.名称 then
                                战斗人物选择 = v.nid
                                break
                            end
                        end
                    else
                        if self.回合数 ~= 0 then
                            战斗人物选择 = self.辅助技能
                            self.辅助冷却.回合 = self.回合数 + 5
                            break
                        end
                    end
                end
            end
        else
            for _, v in pairs(self.法术列表) do --没有辅助技能的走这里
                if v.名称 == 功能.战斗人物法术 then
                    战斗人物选择 = v.nid
                    break
                end
            end
        end
    end
    self:置指令(功能.战斗人物指令, nil, 战斗人物选择)
    if sum then
        sum:置指令(功能.战斗召唤指令, nil)
    end
end

--===============================================================================
function 战斗对象:回合演算()
    local 数据 = require('战斗/回合数据')(self.位置)
    if self.是否死亡 or self.ev:BUFF指令开始(self) == false then
        if self.指令 ~= '召还' then
            return 数据
        end
    end
    if self.已行动 then
        return 数据
    end
    self.已行动 = true
    if self.是否怪物 then
        local 辅助法术 = {'妖之魔力', '力神复苏', '狮王之怒', '兽王神力', '魔神附身', '红袖添香', '莲步轻舞', '楚楚可怜', '魔神护体', '含情脉脉', '魔之飞步', '急速之魔', '魔神飞舞', '天外飞魔', '乾坤借速'}
        if self.指令 == '法术' then
            -- local 非辅助法术 = {}
            local 法术名称 = self:取技能名称(self.选择)
            local is辅助 = false
            if 法术名称 ~= 0 then
                for i = 1 , #辅助法术 do
                    if 法术名称 == 辅助法术[i] then
                        is辅助 = true
                    end
                end
                if is辅助 then
                    if not self.辅助冷却.名称 then
                        self.辅助冷却.名称 = 法术名称
                        self.辅助冷却.回合 = self.回合数 + 5
                    else
                        if self.辅助冷却.回合 > self.回合数 then
                            local 计数 = 0
                            local i = math.random(#self.主动技能)
                            while self.主动技能[i].名称 == self.辅助冷却.名称 do
                                计数 = 计数 + 1
                                if 计数 >= 10 then
                                    self.指令 = '物理'
                                    break
                                end
                                i = math.random(#self.主动技能)
                            end
                        end
                    end
                end
            end
        end
        local 死亡 = self:取我方死亡单位()
        if self.互相拉血 and 死亡 then
            local 编号 = self:取技能nid('互相拉血')
            if 编号 ~= 0 and math.random() >= 50 then
                self.指令 = '法术'
                self.选择 = 编号
                self.目标 = 死亡
            end
        end
        --大雁塔4
        if self.名称 == '大太子' then
            local 二太子死亡 = self:取我方指定单位存活('二太子')
            local 编号 = self:取技能nid('指定拉血')
            if 二太子死亡 == 0 and 编号 ~= 0 then
                local 单位 = self:取我方指定单位('二太子')
                self.指令 = '法术'
                self.选择 = 编号
                self.目标 = 单位
            end
        end
        if self.名称 == '二太子' then
            local 二太子死亡 = self:取我方指定单位存活('三太子')
            local 编号 = self:取技能nid('指定拉血')
            if 二太子死亡 == 0 and 编号 ~= 0 then
                local 单位 = self:取我方指定单位('三太子')
                self.指令 = '法术'
                self.选择 = 编号
                self.目标 = 单位
            end
        end
        if self.名称 == '三太子' then
            local 二太子死亡 = self:取我方指定单位存活('大太子')
            local 编号 = self:取技能nid('指定拉血')
            if 二太子死亡 == 0 and 编号 ~= 0 then
                local 单位 = self:取我方指定单位('大太子')
                self.指令 = '法术'
                self.选择 = 编号
                self.目标 = 单位
            end
        end
        if self.名称 == '石生' then
            local 魔族 = self:取敌方方随机指定种族单位(2)
            if 魔族 then
                数据:喊话('俺最讨厌那止拿着棒子，爪子的家伙了，打得俺生疼生疼。所以俺要先下手为强，拍死这些家伙')
                self.指令 = '物理'
                self.目标 = 魔族
            end
        end
        --大雁塔5
        if self.名称 == '贪睡的小蛇' then
            if self.狂暴状态 then
                local 编号 = self:取技能nid('天诛地灭')
                if 编号 ~= 0 then
                    self.指令 = '法术'
                    self.选择 = 编号
                    self.目标 = self:随机敌方存活目标()
                end
                self.狂暴状态 = nil
            else
                local 编号 = self:取技能nid('睡自己')
                if 编号 ~= 0 then
                    self.指令 = '法术'
                    self.选择 = 编号
                    self.目标 = self.位置
                end
            end
        end
        --水德星君,火德星君
        if self.名称 == '水德星君' or self.名称 == '火德星君' then
            --常规指令,给自己回血
            local 编号 = self:取技能nid('互相拉血')
            if 编号 ~= 0 then
                self.指令 = '法术'
                self.选择 = 编号
                self.目标 = self.位置
            end
            --火德星君
            if self.名称 == '火德星君' then
                local 赤焰妖死亡 = self:取我方指定单位存活('赤焰妖')
                local 喷火牛死亡 = self:取我方指定单位存活('喷火牛')
                if 赤焰妖死亡 == 2 or 喷火牛死亡 == 1 then
                    编号 = self:取技能nid('血海深仇')
                    if 编号 ~= 0 then
                        self.指令 = '法术'
                        self.选择 = 编号
                        self.目标 = self:随机敌方存活目标()
                    end
                end
            end
            --仅剩自己时逃跑
            local 存活 = self:取我方存活数()
            if 存活 == 1 then
                self.指令 = '逃跑'
                if self.名称 == '水德星君' then
                    数据:喊话('尔等厉害,就此别过,改日再战！')
                else
                    数据:喊话('哼,还会再见面的。我等着你们！')
                end
            end
        end
        if self.名称 == '娄金狗' then
            local 编号 = self:取技能nid('互相拉血')
            if 编号 ~= 0 then
                local 单位 = self:取我方指定单位('胃土雉')
                self.指令 = '法术'
                self.选择 = 编号
                self.目标 = 单位
            end
        end
        if self.名称 == '昂日鸡' then
            local 编号 = self:取技能nid('互相拉血')
            if 编号 ~= 0 then
                local 单位 = self:取我方指定单位('毕月鸟')
                self.指令 = '法术'
                self.选择 = 编号
                self.目标 = 单位
            end
        end
        if self.名称 == '毕月鸟' then
            local 娄金狗死亡 = self:取我方指定单位存活('娄金狗')
            local 昂日鸡死亡 = self:取我方指定单位存活('昂日鸡')
            if (娄金狗死亡 or 昂日鸡死亡) and not self.狂暴喊话 then
                self.抗性.忽视抗雷 = 40
                self.抗性.加强雷 = 100
                self.抗性.雷系狂暴几率 = 100
            end
        end
    end
    if self.是否孩子 then
        if not self.是否施法 then
            self.指令 = ''
        else
            self.指令 = '特殊施法'
        end
    end
    if self.禁止行动 then
        self.指令 = '防御'
    end
    if self.指令 == '物理' then --物理
        self:指令_物理攻击(数据)
    elseif self.指令 == '法术' then --法术
        self:指令_使用法术(数据)
    elseif self.指令 == '道具' then --道具
        self:指令_使用道具(数据)
    elseif self.指令 == '召唤' then --召唤
        self:指令_召唤(数据)
    elseif self.指令 == '召还' then --召还
        self:指令_召还(数据)
    elseif self.指令 == '捕捉' then --捕捉
        self:指令_捕捉(数据)
    elseif self.指令 == '逃跑' then --逃跑
        self:指令_逃跑(数据)
    end
    return 数据
end

function 战斗对象:回合演算数据(data)
    self.掉线等待 = coroutine.running()
    self.rpc:战斗数据(data)
    if self.是否逃跑 then
        self.rpc:退出战斗()
        self:战斗结束()
        return
    end
    if not self.cid then
        coroutine.yield()
    end
end

--===============================================================================
function 战斗对象:指令_物理攻击(数据)
    local 目标 = self:取物理目标()
    if 目标 then
        local src = self:物理_生成对象('物理', 目标)
        local dst = 目标
        ::loop::
        local 目标数据 = self.战场:指令开始()
        self.ev:物理攻击前(src, dst)
        目标:被物理攻击(src, dst)
        self.ev:物理攻击(src, dst)
        if self.幽冥鬼手 and not src.躲避 and (not self:是否我方(dst) or self.ev:BUFF队友伤害(src, dst)) then
            local 临时目标 = self:取转移对象()
            src.伤害 = math.floor(src.伤害 * (self.幽冥鬼手 * 0.01))
            临时目标:被法术攻击(src)
        end
        数据:物理攻击(目标.位置, 目标数据)
        self.战场:指令结束()

        if not src.躲避 and (not self:是否我方(dst) or self.ev:BUFF队友伤害(src, dst)) then --附法
            local list = {}
            for k, v in pairs(self.法术列表) do
                if v.是否物理法术 then
                    table.insert(list, v)
                end
            end
            if #list > 0 then
                local 法术 = list[math.random(#list)]
                local 目标数据 = self.战场:指令开始()
                if 法术:物理法术(src, dst) then
                    数据:物理法术(法术.id, 目标数据)
                end
                self.战场:指令结束()
            end
            --攻击法术
            if self.抗性.附加震慑攻击 and math.random(100) < self.抗性.附加震慑攻击 then
                local 目标数据 = self.战场:指令开始()
                local 震慑,扣蓝=0.20 + 0.004 * math.pow(1 , 0.35) , 0.25 + 0.005 * math.pow(1 , 0.35)
                src.伤害 = (dst.气血 * (震慑 - dst.抗震慑/100 + src.忽视抗震慑/100) * (1 + src.加强震慑 / 100) + src.等级 * 3) * ( 1 - dst.抗震慑气血/100)
                扣蓝 = (dst.魔法 * 扣蓝 * (1 + src.加强震慑/100) + src.等级 * 3) * ( 1 - dst.抗震慑魔法/100)
                dst:减少魔法(math.floor(扣蓝))
                dst:被法术攻击(src)
                数据:物理法术(1202, 目标数据)
                self.战场:指令结束()
            end
        end

        if not self.是否死亡 and not 目标.是否死亡 and not src.防止连击 and src.连击次数 > 0 then
            src:物理_计算连击(dst)
            goto loop
        end
    end
end

function 战斗对象:指令_使用法术(数据)
    local 法术 = self.法术列表[self.选择]
    if type(法术) == 'table' and 法术.是否主动 then
        if self.是否怪物 then
            if self.名称 == '火德星君' then
                if 法术.数据.名称 == '血海深仇' then
                    数据:喊话('这就是怒火的力量！')
                end
            end
            if self.名称 == '娄金狗' and self.回合数 == 1 then
                if 法术.数据.名称 == '互相拉血' then
                    数据:喊话('只要我活着,胃土雉就可以稳定天魔')
                end
            end
            if self.名称 == '胃土雉' and self.回合数 == 1 then
                if 法术.数据.名称 == '天魔解体_AI' then
                    数据:喊话('我的命就交个你了,娄金狗！')
                end
            end
            if self.名称 == '昂日鸡' and self.回合数 == 1 then
                if 法术.数据.名称 == '互相拉血' then
                    数据:喊话('毕月鸟,你的气血由我来保证！')
                end
            end
            if self.名称 == '毕月鸟' and self.回合数 == 1 then
                数据:喊话('只要我的气血高于一半,那么就接受来自星宿的惩罚吧！')
            end
            if self.名称 == '毕月鸟' and not self.狂暴喊话 then
                数据:喊话('这就是星宿的愤怒！')
                self.狂暴喊话 = 1
            end
            if self.名称 == '大太子' then
                if 法术.数据.名称 == '指定拉血' then
                    数据:喊话('二弟，我来救你！')
                end
            end
            if self.名称 == '三太子' then
                if 法术.数据.名称 == '指定拉血' then
                    数据:喊话('大哥，我来救你！')
                end
            end
            if self.名称 == '二太子' then
                if 法术.数据.名称 == '指定拉血' then
                    数据:喊话('三弟，我来救你！')
                end
            end
            if self.名称 == '贪睡的小蛇' then
                if 法术.数据.名称 == '睡自己' then
                    数据:喊话('好困，我先睡一会#77')
                end
            end
        end
        self.当前法术 = 法术

        local src = setmetatable(
            {
                法术类型 = '',
                连击次数 = 0,
                伤害 = 0,
                狂暴 = false
            },
            { __index = self, __newindex = self }
        )
        -- print(法术.id)
        ::loop::
        local dst = self:取法术目标(法术.数据.名称)
        if self.ev:BUFF法术施放前(src, dst) == false then
            return
        end
        local 目标数据 = self.战场:指令开始()
        -- table.print(目标数据)
        self.ev:法术施放前(src, dst)
        local r = 法术:法术施放(src, dst)
        self.战场:指令结束()
        if r ~= false then
            数据:法术(法术.id, 目标数据)
            if src.法术类型 ~= '连击' then
                local 目标数据 = self.战场:指令开始()
                self.ev:法术施放后(src, dst, 法术)
                数据:法术后(目标数据)
                --self.ev:法术施放后(src, dst)
                self.战场:指令结束()
            end
        else
            数据:法术后(目标数据)
        end

        if not self.是否死亡 and self:取敌方存活数() > 0 and not src.防止连击 and src.连击次数 > 0 then
            --src:物理_计算连击(dst)
            src.法术类型 = '连击'
            src.连击次数 = src.连击次数 - 1
            goto loop
        end
    end
end

function 战斗对象:指令_使用道具(数据)
    local 道具
    if self.是否玩家 then
        道具 = self.对象.物品[self.选择]
    elseif self.是否召唤 then
        道具 = self.对象.主人.物品[self.选择]
    end
    local 目标 = self.战场:取对象(self.目标)
   -- print(self.名称,type(道具),目标)
    if type(道具) == 'table' and 目标 then
        if not 道具.战斗是否可用 then
         --   print("战斗是否可用")
            return
        end
        if 目标.是否玩家 and not 道具.人物是否可用 then
         --   print("是否玩家")
            return
        end
        if 目标.是否召唤 and not 道具.召唤是否可用 then
         --   print("是否召唤")
            return
        end
        self.当前物品 = 道具
        if self.ev:BUFF物品使用前(self, 目标) == false then
        --    print("BUFF物品使用前")
            return
        end
        --self.ev:使用道具前(数据,self,目标)
        local 目标数据 = self.战场:指令开始()
        目标:被使用道具(self, 道具)
        --self.ev:使用道具后(数据,self,目标)
        数据:道具(目标数据)
        self.战场:指令结束()
    end
end

function 战斗对象:判断是否满血(数据)

end

function 战斗对象:判断是否满蓝(数据)

end

function 战斗对象:指令_召唤(数据)
    local v = self.召唤列表[self.目标]
    if v and not v.战斗已上场 then
        local r = self:取召唤信息(self.位置 + 5)
        if r then
            r.指令 = nil
        end
        self.目标 = nil
        v.战斗已上场 = true
        local 召唤 = self.战场:加入(self.位置 + 5, v)
        召唤:战斗开始()
        --召唤.道具 = self.道具
        数据:召唤(召唤:取数据())
        self.对象.参战召唤 = v
    end
end

function 战斗对象:指令_召还(数据)
    local 召唤 = self.战场:退出(self.位置 + 5)
    -- 召唤:战斗结束()
    数据:召还(self.位置 + 5)
end

function 战斗对象:指令_捕捉(数据)
    local 目标 = self.战场:取对象(self.目标)
    if 目标 and not 目标.是否死亡 and 目标.是否怪物 and 目标.可以捕捉 then
        local src = self
        src.成功率 = 100
        --self.ev:捕捉事件(数据, src, 目标)
        local 结果 = math.random(100) <= src.成功率
        if 结果 then
            local 原始 = _召唤库[目标.原名]
            local 召唤兽数据 = { 名称 = 目标.原名, 等级 = 目标.等级 }
            if 原始 then
                local 随机 = {}
                local 属性 = {'成长','初血','初法','初攻','初敏'}
                for i=1,5 do
                    随机[i] = math.random(800,1000) / 1000
                    if 原始[属性[i]] < 1 then
                        随机[i] = 1 - 随机[i] + 1
                    end
                    if 属性[i] == '成长' then
                        召唤兽数据[属性[i]] = string.format("%.2f", 原始[属性[i]] * 随机[i]) + 0
                    else
                        召唤兽数据[属性[i]] = math.floor(原始[属性[i]] * 随机[i])
                    end

                end
            end
            local 召唤 = __沙盒.生成召唤(召唤兽数据)
            if 召唤 then
                self.对象:召唤_添加(召唤)
                self.战场:退出(目标.位置)
            end
        end
        数据:捕捉(目标.位置, 结果)
    else
        数据:捕捉(false)
    end
end

function 战斗对象:指令_逃跑(数据)
    local src = self
    src.成功率 = 100
    if src.PK then
        src.成功率 = 50
    end
    if src.PK发起方 then
        src.成功率 = 0
    end
    if src.水陆 then
        src.成功率 = 0
    end
    self.是否逃跑 = math.random(100) <= src.成功率
    local 助战 = self.战场:取助战对象()
    local 存在
    for i,v in pairs(助战) do
        存在 = 1
    end
    if self.是否逃跑 then
        self.战场:退出(self.位置,存在)
        if self.是否玩家 then
            self.战场:退出(self.位置 + 5,存在)
            for i,v in pairs(助战) do
                v.战场:退出(v.位置,存在)
                v.战场:退出(v.位置+5,存在)
            end
        end
    end
    数据:逃跑(self.是否逃跑)
end

function 战斗对象:置接收数据(data)
    if data then
        table.insert(self.回合数据, 1, data)
    else
        table.remove(self.回合数据, 1)
    end
    self.当前数据 = self.回合数据[1]
end

--=========================================================================
function 战斗对象:物理_计算BUFF(dst, 伤害)
    assert(self.伤害类型, '错误')
    --如果挨打方存在BUFF 千松扫尾 伤害=伤害*1.2
end

function 战斗对象:物理_计算狂暴致命(dst, 伤害)
    assert(self.伤害类型, '错误')
    local 狂暴, 致命 = false, false
    狂暴 = math.random(100) <= self.抗性.狂暴几率
    致命 = math.random(100) <= self.抗性.致命几率
    if 致命 then
        if dst.抗性.抗致命几率 then
            if dst.抗性.抗致命几率 >= math.random(100) then
                致命 = false
            end
        end
    end
    if 狂暴 and 致命 then--致命优先级高于狂暴
        伤害 = 伤害 * 1.5 + dst.气血 * 0.1
        狂暴 = false
    elseif 狂暴 then
        伤害 = 伤害 * 1.5 + dst.抗性.防御
    elseif 致命 then
        伤害 = 伤害 * 1.5 + dst.气血 * 0.1
    end
    return 伤害, 狂暴, 致命
end

function 战斗对象:物理_计算连击(dst)
    assert(self.伤害类型, '错误')
    self.连击次数 = self.连击次数 - 1
    self.初始伤害 = math.floor(self.初始伤害 * 0.75)
    local 伤害, 狂暴, 致命 = self:物理_计算狂暴致命(dst, self.初始伤害)
    if dst.指令 == '防御' then
        伤害 = 伤害 * 0.5
    end
    self.伤害 = math.floor(伤害)
    self.狂暴 = 狂暴
    self.致命 = 致命
end

function 战斗对象:物理_生成保护()
    assert(self.伤害类型, '错误')
    local t = {}
    for k, v in pairs(self) do
        t[k] = v
    end
    t.伤害类型 = '保护'
    t.躲避 = false
    t.伤害 = t.伤害
    self.伤害 = 0
    setmetatable(t, getmetatable(self))
    return t
end

function 战斗对象:物理_生成对象(类型, dst)
    local t = setmetatable({
        伤害类型 = 类型,
        初始伤害 = 0,
        伤害 = 0,
        躲避 = false,
        致命 = false,
        狂暴 = false,
        连击次数 = 0,
        反击次数 = 0
    }, { __index = self, __newindex = self })

    if 类型 == '反震' then
        --◆我自岿然-护身符特技之一  特技效果：物理和师门法术造成的反震效果减半
        t.伤害 = dst.伤害 * (self.反震程度 * 0.01) - dst.抗反震
        return t
    end
    if 类型 == '转移' then
        t.伤害 = dst.伤害 * (50 * 0.01)--
        return t
    end
    local src = self
    if math.random(100) <= dst.躲闪率 - src.忽视躲闪率 - src.命中率 and 类型 ~= '反击' then
        -- if not dst.躲闪率 then
        -- dst.躲闪率 = 0
        -- end
        t.躲避 = true
        if src.孩子增益.嗜血狂攻 then
            t.躲避 = false
        end
        return t
    end
    --src 攻击方   dst 挨打方
    local 伤害, 狂暴, 致命 = 0, false, false
    伤害=src.攻击*(1+src.加成攻击/100)

    local 攻击五行,挨打五行=self:取五行属性(src),self:取五行属性(dst)
    local 攻击方五行克制=self:取五行强克(src)
    伤害=伤害*(1+0.5*self:取五行克制(攻击五行,挨打五行))*self:取强力克系数(攻击方五行克制,挨打五行)*self:取无属性伤害加成(src,dst)
    -- print(伤害)
    伤害, 狂暴, 致命 = t:物理_计算狂暴致命(dst, 伤害)

    伤害 = 伤害 - dst.抗性.防御 * (1 - src.忽视防御程度 / 100)
    if 伤害 < 1 then 伤害 = 1 end

    local 忽视防御影响=1
    if math.random(100) < src.忽视防御几率 or src.大势锤 then
        local 忽视程度 = src.忽视防御程度
        if src.大势锤 then
            忽视程度 = 忽视程度 + src.大势锤
        end
        忽视防御影响= 1 - dst.抗性.物理吸收 / 100 * (1 - 忽视程度 / 100)
    else
        忽视防御影响=1 - dst.抗性.物理吸收/100
    end
    伤害=伤害*忽视防御影响
    -- print('新伤害',伤害)
    t.初始伤害 = 伤害
    --如果src存在buff 大势锤 无视dst物理吸收
    -- if math.random(100) < src.忽视防御几率 then
    --     伤害 = 伤害 * (1 + (dst.物理吸收 - src.忽视防御程度) * 0.01)
    -- else
    --     伤害 = 伤害 * (1 - dst.物理吸收 * 0.01)
    -- end

    if dst.指令 == '防御' then
        伤害 = 伤害 * 0.5
    end

    if math.random(100) <= (src.连击率 - dst.抗连击率) then
        t.连击次数 = src.连击次数
        --◆牵制(高级技能) 技能效果： 　　具有此技能的召唤兽在场时，敌方所有人物的连击次数不超过3次(不计算第一次攻击，仅限玩家之间PK时使用)。 注意事项： 　　召唤兽被封印，技能仍生效。
    end

    if 类型 ~= '反击' then
        if math.random(100) <= (dst.反击率 - src.忽视反击率) then
            t.反击次数 = math.random(dst.反击次数)
        end
        -- if dst.反击率 - src.忽视反击率 >= 100 then
        --     t.反击次数 = math.random(dst.反击次数)
        -- else
        --     for i = 1, dst.反击次数 do
        --         if math.random(100) <= (dst.反击率 - src.忽视反击率) then
        --             t.反击次数 = t.反击次数 + 1
        --         end
        --     end
        -- end
    end
    local 波动 = math.random(925,1075) / 1000
    t.伤害 = math.floor(伤害 * 波动)
    if t.伤害 < 1 then t.伤害 = 1 end
    t.狂暴 = 狂暴
    t.致命 = 致命
    return t
end

--=========================================================================
function 战斗对象:被物理攻击(src, dst)
    local 数据 = self.当前数据
    数据.位置 = self.位置
    if self.是否死亡 or self.是否无敌 or self.ev:BUFF被物理攻击前(src, self) == false then
        return 数据
    end
    if not 数据 then
        return
    end

    self.ev:被物理攻击前(src, dst)

    if src.伤害类型 == '物理' and self:是否敌方(src) then
        for _, v in self:遍历我方存活() do
            if not v.已保护 and v.保护 == self.位置 then
                v.已保护 = true
                local 保护数据 = self.战场:指令开始()
                local src2 = src:物理_生成保护()
                v:被物理攻击(src2)
                数据.保护 = 保护数据[v.位置]
                self.战场:指令结束()
                break
            end
        end
    end

    local 实际伤害 = src.伤害

    if self:是否我方(src) then
        if not src.ev:BUFF队友伤害(src, dst) then
            实际伤害 = 1
        end
    end
    if self.孩子增益.金刚护体 then
        --print(self.孩子增益.金刚护体)
        if self.孩子增益.金刚护体 >= 1 then
            实际伤害 = 0
            self.孩子增益.金刚护体 = self.孩子增益.金刚护体 - 1
        end
    elseif self.孩子增益.铁布衫 then
        if self.孩子增益.铁布衫 >= 1 then
            实际伤害 = 0
            self.孩子增益.铁布衫 = self.孩子增益.铁布衫 - 1
        end
    end
    local 将军令数据,临时目标
    if not src.躲避 then--未闪避
        if 实际伤害 > 0 then
            if 实际伤害 > self.气血 then
                实际伤害 = self.气血
            end
            if self.银索金铃 then
                local 转化上限 = math.floor(实际伤害 * (self.银索金铃 / 100))
                if 转化上限 >= 1 then
                    if self.魔法 >= 转化上限 then
                        self:减少魔法(转化上限, nil, true)
                        实际伤害 = 实际伤害 - 转化上限
                    else
                        实际伤害 = 实际伤害 - self.魔法
                        self:减少魔法(self.魔法, nil, true)
                    end
                end
            end
            if self.将军令 then
                临时目标 = self:取转移对象()
                if 临时目标 then
                    将军令数据 = self.战场:指令开始()
                    local src2 = self:法宝_生成转移对象('转移', 临时目标, 实际伤害)
                    临时目标:法宝_接受伤害(src2)
                    self.战场:指令结束()
                end
            end
            if self.黑龙珠 then
                local 转化上限 = math.floor(实际伤害 * (self.黑龙珠 / 100))
                local 临时目标 = self:取转移对象()
                临时目标:减少魔法(转化上限, nil, true)
            end
            if src.绝情鞭 then
                local 转化上限 = math.floor(实际伤害 * (src.绝情鞭 / 100))
                self:减少魔法(转化上限, nil, true)
            end
            self.气血 = self.气血 - 实际伤害
            self.怨气 = self.怨气 + 25
        else
            实际伤害 = 1
        end
    end
    self.ev:被物理攻击后(src, dst)
    self.ev:BUFF被物理攻击后(src, dst)

    local 反击数据, 反震数据 --有保护的情况下不会触发反震、反击

    if not 数据.保护 and not src.躲避 and src.伤害类型 == '物理' and math.random(100) <= self.反震率 then
        反震数据 = self.战场:指令开始()--设置临时指令,加入数据
        local src2 = self:物理_生成对象('反震', src)--生成目标以及伤害
        src:被物理攻击(src2,src)--设置目标掉血
        self.战场:指令结束()--结束临时指令
    end
    if self.气血 > 0 then
        if not 数据.保护 and src.伤害类型 == '物理' and src.反击次数 > 0 then
            反击数据 = self.战场:指令开始()
            local src2 = self:物理_生成对象('反击', src)
            src:被物理攻击(src2)
            src.反击次数 = src.反击次数 - 1
            self.战场:指令结束()
        end
    else
        self.气血 = 0
        self.是否死亡 = true
        if self.是否召唤 then
             self.对象:死亡处理()
        end
    end
    if self.是否死亡 and self.是否消失 then
        self.战场:退出(self.位置)
    end

    local d = 数据:物理伤害(实际伤害, self.指令 == '防御', self.是否死亡, self.是否消失)

    if src.躲避 then
        d.躲避 = true
    elseif src.致命 then
        d.类型 = '致命'
    elseif src.狂暴 then
        d.类型 = '狂暴'
    end

    if 反震数据 then
        d.反震 = 反震数据[src.位置]
    end
    if 反击数据 then
        数据:物理反击(反击数据[src.位置])
    end
    if 将军令数据 then
        d.将军令 = 将军令数据[临时目标.位置]
    end

    return 数据
end

function 战斗对象:被法术攻击(src , v)--src为伤害来源,self为当前被攻击者
    local 禁反震技能 = {'天魔解体', '夺命勾魂', '追神摄魄', '销魂蚀骨', '阎罗追命', '魔音摄心'}
    local 禁反震 = false
    local 蓝伤 = false
    if v then
        if type(v) == 'table' then
            if v.名称 == '分光化影' or v.名称 == '小楼夜哭' then
                蓝伤 = true
            end
            for i=1,#禁反震技能 do
                if v.名称 == 禁反震技能[i] then
                    禁反震 = true
                end
            end
        end
    end
    local 数据 = self.当前数据
    数据.位置 = self.位置
    if self.是否死亡 or self.是否无敌 or self.ev:BUFF被法术攻击前(src, self) == false then
        return
    end
    local 实际伤害 = math.floor(src.伤害)
    local 反射数据
    if 蓝伤 then
        if self.七宝玲珑塔 then
            将军令数据 = self.战场:指令开始()
            local src2 = self:法宝_生成转移对象('反射', src, 实际伤害)
            src:法宝_接受伤害(src2)
            self.战场:指令结束()
        end
        if self.锦襕袈裟 then
            local 转化上限 = math.floor(实际伤害 * (self.锦襕袈裟 / 100))
            if 转化上限 >= 1 then
                if self.气血 >= 转化上限 then
                    self.气血 = self.气血 - 转化上限
                    self.怨气 = self.怨气 + 25
                    实际伤害 = 实际伤害 - 转化上限
                else
                    实际伤害 = 实际伤害 - self.气血
                    self.气血 = self.气血 - self.气血
                    self.怨气 = self.怨气 + 25
                    self:减少魔法(self.魔法, nil, true)
                end
            end
        end
        self:减少魔法(实际伤害, nil, true)
        if self.魔法 < 0 then
            self.魔法 = 0
        end
    else
        if v and v.名称 ~= '天魔解体' then
            --法宝
            if self.银索金铃 then
                local 转化上限 = math.floor(实际伤害 * (self.银索金铃 / 100))
                if 转化上限 >= 1 then
                    if self.魔法 >= 转化上限 then
                        self:减少魔法(转化上限, nil, true)
                        实际伤害 = 实际伤害 - 转化上限
                    else
                        实际伤害 = 实际伤害 - self.魔法
                        self:减少魔法(self.魔法, nil, true)
                    end
                end
            end
            if self.黑龙珠 then
                local 转化上限 = math.floor(实际伤害 * (self.黑龙珠 / 100))
                src:减少魔法(转化上限, nil, true)
            end
        end

        self.气血 = self.气血 - 实际伤害
        self.怨气 = self.怨气 + 25
    end
    self.ev:BUFF被法术攻击后(src, self)
    local 将军令数据, 临时目标, 反震数据
    if self.气血 > 0 then
        if v and v.名称 ~= '天魔解体' then
            if self.将军令 then
                临时目标 = self:取转移对象()
                if 临时目标 then
                    将军令数据 = self.战场:指令开始()
                    local src2 = self:法宝_生成转移对象('转移', 临时目标, 实际伤害)
                    临时目标:法宝_接受伤害(src2)
                    self.战场:指令结束()
                end
            end
            if not 禁反震 then
                if math.random(100) <= self.反震率 then
                    反震数据 = self.战场:指令开始()
                    local src2 = self:法宝_生成转移对象('反震', src)
                    src:法宝_接受伤害(src2)
                    self.战场:指令结束()
                end
            end

        end
    else
        self.气血 = 0
        self.是否死亡 = true
        if self.是否消失 then
            self.战场:退出(self.位置)
        end
        if self.是否召唤 then
            self.对象:死亡处理()
        end
    end
    local d = 数据:法术伤害(实际伤害, self.是否死亡, self.是否消失) ---1111
    if 将军令数据 then
        d.将军令 = 将军令数据[临时目标.位置]
    end
    if 反射数据 then
        d.七宝玲珑塔 = 反射数据[src.位置]
    end
    if 反震数据 then
        d.反震 = 反震数据[src.位置]
    end
    if self.伤害类型 == "狂暴" then
        d.类型 = '狂暴'
    end
end


function 战斗对象:取五行属性(目标)
    local 五行={}
    for i, v in ipairs { '金', '木', '水', '火', '土' } do
        五行[v]=目标.抗性[v]/100
    end
    return 五行
end

function 战斗对象:取五行强克(目标)
    local 五行={}
    for i, v in ipairs { '强力克金', '强力克木', '强力克水', '强力克火', '强力克土' } do
        五行[v]=目标.抗性[v]/100+目标.增加强克效果/100
    end
    return 五行
end

function 战斗对象:取五行克制(攻击方五行,挨打方五行)
    local 攻击方结果=0
    local 挨打方结果=0
    if 攻击方五行.金~=nil and 攻击方五行.金~= 0 then
        if 挨打方五行.木~=nil and 挨打方五行.木~=0 then
            攻击方结果=攻击方结果+攻击方五行.金*挨打方五行.木
        end
        if 挨打方五行.火~=nil and 挨打方五行.火~=0 then
            挨打方结果=挨打方结果+挨打方五行.火*攻击方五行.金
        end
    end
    if 攻击方五行.木~=nil and 攻击方五行.木~= 0 then
        if 挨打方五行.土~=nil and 挨打方五行.土~=0 then
            攻击方结果=攻击方结果+攻击方五行.木*挨打方五行.土
        end
        if 挨打方五行.金~=nil and 挨打方五行.金~=0 then
            挨打方结果=挨打方结果+挨打方五行.金*攻击方五行.木
        end
    end
    if 攻击方五行.水~=nil and 攻击方五行.水~= 0 then
        if 挨打方五行.火~=nil and 挨打方五行.火~=0 then
            攻击方结果=攻击方结果+攻击方五行.水*挨打方五行.火
        end
        if 挨打方五行.土~=nil and 挨打方五行.土~=0 then
            挨打方结果=挨打方结果+挨打方五行.土*攻击方五行.水
        end
    end
    if 攻击方五行.火~=nil and 攻击方五行.火~= 0 then
        if 挨打方五行.金~=nil and 挨打方五行.金~=0 then
            攻击方结果=攻击方结果+攻击方五行.火*挨打方五行.金
        end
        if 挨打方五行.水~=nil and 挨打方五行.水~=0 then
            挨打方结果=挨打方结果+挨打方五行.水*攻击方五行.火
        end
    end
    if 攻击方五行.土~=nil and 攻击方五行.土~= 0 then
        if 挨打方五行.水~=nil and 挨打方五行.水~=0 then
            攻击方结果=攻击方结果+攻击方五行.土*挨打方五行.水
        end
        if 挨打方五行.木~=nil and 挨打方五行.木~=0 then
            挨打方结果=挨打方结果+挨打方五行.木*攻击方五行.土
        end
    end
    攻击方结果=攻击方结果-挨打方结果
    if 攻击方结果<0 then
        攻击方结果=0
    end
    return 攻击方结果
end

function 战斗对象:取强力克系数(攻击方强力克,挨打方五行)
    local 攻击方结果=1
    if 攻击方强力克.强力克金~=nil and 攻击方强力克.强力克金~= 0 then
      攻击方结果=攻击方结果+攻击方强力克.强力克金*挨打方五行.金
    end
    if 攻击方强力克.强力克木~=nil and 攻击方强力克.强力克木~= 0 then
      攻击方结果=攻击方结果+攻击方强力克.强力克木*挨打方五行.木
    end
    if 攻击方强力克.强力克水~=nil and 攻击方强力克.强力克水~= 0 then
      攻击方结果=攻击方结果+攻击方强力克.强力克水*挨打方五行.水
    end
    if 攻击方强力克.强力克火~=nil and 攻击方强力克.强力克火~= 0 then
      攻击方结果=攻击方结果+攻击方强力克.强力克火*挨打方五行.火
    end
    if 攻击方强力克.强力克土~=nil and 攻击方强力克.强力克土~= 0 then
      攻击方结果=攻击方结果+攻击方强力克.强力克土*挨打方五行.土
    end
    return 攻击方结果
end

function 战斗对象:取无属性伤害加成(攻击方,挨打方)
  local 加成=1
  if 攻击方.无属性伤害~=nil and 攻击方.无属性伤害>0 then
    if 攻击方.金>0 or 攻击方.木>0 or 攻击方.水>0 or 攻击方.火>0 or 攻击方.土>0 then
      加成=加成+攻击方.无属性伤害/100-挨打方.抗无属性伤害/100
    end
  end
  return 加成
end

function 战斗对象:被使用法术(src, 法术)
    local 数据 = self.当前数据
    数据.位置 = self.位置
end

function 战斗对象:被物理法术(src, 法术)
    local 数据 = self.当前数据
    数据.位置 = self.位置

end

function 战斗对象:被使用道具(来源, 道具)
    local 数据 = self.当前数据
    数据.位置 = self.位置
    --self.ev:被使用道具前(数据, 来源, self)
    道具:使用(self)
    --self.ev:被使用道具后(数据, 来源, self)
    return 数据
end

function 战斗对象:法宝_生成转移对象(类型, dst, 伤害)
    local t = setmetatable({
        伤害类型 = 类型,
        初始伤害 = 0,
        伤害 = 0,
        躲避 = false,
        致命 = false,
        狂暴 = false,
        连击次数 = 0,
        反击次数 = 0
    }, { __index = self, __newindex = self })

    if 类型 == '转移' then
        dst.伤害 = 伤害
        t.伤害 = dst.伤害 * (self.将军令 * 0.01)
        return t
    elseif 类型 == '反震' then
        t.伤害 = dst.伤害 * (self.反震程度 * 0.01)
        return t
    elseif 类型 == '反射' then
        dst.伤害 = 伤害
        t.伤害 = dst.伤害 * (self.七宝玲珑塔 * 0.01)
        return t
    end
end

function 战斗对象:法宝_接受伤害(src)
    local 数据 = self.当前数据
    数据.位置 = self.位置
    if self.是否死亡 or self.是否无敌 or self.ev:BUFF被物理攻击前(src, self) == false then
        return 数据
    end
    self.ev:被物理攻击前(src, self)
    local 实际伤害 = src.伤害
    self.气血 = self.气血 - 实际伤害
    self.ev:被物理攻击后(src, self)
    self.ev:BUFF被物理攻击后(src, self)
    if self.气血 <= 0 then
        self.气血 = 0
        self.是否死亡 = true
        if self.是否召唤 then
             self.对象:死亡处理()
        end
    end
    if self.是否死亡 and self.是否消失 then
        self.战场:退出(self.位置)
    end
    local d = 数据:物理伤害(实际伤害, self.指令 == '防御', self.是否死亡, self.是否消失)
    return 数据
end

return 战斗对象
