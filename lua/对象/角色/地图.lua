-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-05-04 21:53:04
-- @Last Modified time  : 2024-10-25 16:40:30

local 角色 = require('角色')

function 角色:地图_初始化()
    self.是否移动 = false
    self.遇敌时间 = 0
    self.周围 = {}
    self.周围玩家 = {}
    self.周围物品 = {}
    self.周围NPC = {}
    self.周围跳转 = {}
    self.当前地图 = __地图[self.地图]
    self.当前地图:添加玩家(self)
    self.xy = require('GGE.坐标')(self.x, self.y)
    self.X, self.Y = self.x // 20, (self.当前地图.实际高度 - self.y) // 20
    if not self.rect then
        self.rect = require('GGE.矩形')(self.x, self.y, 1024, 768)
        self.rect:置中心(self.rect.w // 2, self.rect.h // 2) --屏幕大小/2
    end
end

function 角色:地图_更新()
    if not self.是否战斗 then
        self.rect:置坐标(self.x, self.y)
        for _, v in pairs(self.周围) do
            if not v.所属 or v.所属 == self.名称 then --剧情NPC，只有自己显示
                if not self.当前地图:取对象(v.nid) then --不在地图中
                    -- print(v.名称,__玩家[v.nid].地图,self.地图)
                    -- print("~~~~~~~~~~~~~~~~~~")
                    self:地图_删除对象(v)
                elseif not self:检查点(v.x, v.y) then --不在范围中
                    if (not v.是否组队 or v.是否队长) and not self:是否队友(v) then
                        self:地图_删除对象(v)
                    end
                elseif ggetype(v) == '地图NPC' and v.生成时间 ~= v.更新时间 then
                    self:地图_删除对象(v)
                end
            end
        end

        for _, v in self.当前地图:遍历对象() do
            if v ~= self and self:检查点(v.x, v.y) then
                if not self.周围[v.nid] then --在周围,并且不在列表
                    if ggetype(v) == '地图NPC' then --NPC
                        v = v:生成对象()
                        --self.task:NPC刷新事件(self.接口, v) --已接任务
                        if v.是否可见 then
                            --self:任务_NPC刷新事件(self.接口, v) --未接任务
                            self:地图_添加对象(v)
                        else
                            self.周围[v.nid] = v
                        end
                    elseif not v.是否组队 or v.是否队长 or self:是否队友(v) then
                        self:地图_添加对象(v)
                    end
                end
            end
        end
        --更新NPC头顶
        -- for k, v in pairs(self.周围NPC) do
        --     self.task:NPC更新事件(self.接口, v)
        --     if v.是否删除 then
        --         self.周围[k] = nil
        --         self.周围NPC[k] = nil
        --     end
        -- end

        --self.task:地图刷新事件(self.接口)
        self:暗雷()
    end
end

function 角色:暗雷()
    if self.当前地图.地图等级 then
        if self.是否移动 then
            self.遇敌时间 = self.遇敌时间 + math.random(1, 3)
        end
        if self.遇敌时间 > 10 and not self.是否战斗 then
            self.遇敌时间 = 0
            if self.task:任务特殊暗雷(self.接口,self.当前地图.名称) == false then
                return
            end
            if self.task:任务触发暗雷(self.接口) == false then
                return
            end
            self.是否移动 = false
            coroutine.xpcall(function()
                self.接口:进入战斗('scripts/war/野怪.lua', self.当前地图.id)
            end

            )
        end
    end
end

function 角色:检查点(x, y)
    return self.rect:检查点(x, y)
end

function 角色:遍历周围玩家()
    return next, self.周围玩家
end

function 角色:遍历周围NPC()
    return next, self.周围NPC
end

function 角色:角色_通过NPC跳转(npc)
    if npc then
        if npc.tid and npc.tx and npc.ty then
            self.接口:切换地图(npc.tid, npc.tx, npc.ty)
        end
    end

    -- for i , v in pairs(self.周围NPC) do
    --     local map = __地图[npc.tid]
    --     if map then
    --         self.接口:切换地图(npc.tid, npc.tx, npc.ty)
    --     end
    -- end
end

function 角色:地图_添加对象(o) --1111
    if not self.是否战斗 then
        self.周围[o.nid] = o
        local tp = ggetype(o)
        if tp == '角色' then
            self.周围玩家[o.nid] = o
        elseif tp == '地图NPC' then
            self.周围NPC[o.nid] = o
        elseif tp == '地图跳转' then
            self.周围跳转[o.nid] = o
        end
        self.rpc:地图添加(o:取简要数据())
        if o.是否队长 then
            for i, v in o:遍历队友() do
                v.队长 = o.nid
                v.队伍位置 = i
                self:地图_添加对象(v)
            end
        end
    end
end

function 角色:地图_删除对象(o)
    --检查交易
    --检查队友
    self.周围[o.nid] = nil
    self.周围玩家[o.nid] = nil
    self.周围物品[o.nid] = nil
    self.周围NPC[o.nid] = nil
    self.rpc:地图删除(o.nid)
    if o.是否队长 then
        for i, v in o:遍历队友() do
            self:地图_删除对象(v)
        end
    end
end

function 角色:移动_切换地图(map, x, y, leader)--任我行飞地图的时候切换地图编号
    if os.date("%H") <= '18' or os.date("%H") >= '06' then --小于18时或者大于06时就就是06-18时这时间段
        if map.id == 1411 then
            map.id = 1001
        elseif map.id == 1413 then
            map.id = 1203
        elseif map.id == 1415 then
            map.id = 1193
        end
    end
    self.是否移动 = false
    if (not self.是否组队 or self.是否队长 or leader) and not self.是否摆摊 then
        x = math.abs(math.floor(x))
        y = math.abs(math.floor(y))
        print(x,y)
        if map and map:检查点(x, y) then
            if self.task:切换地图前事件(self.接口, map, x, y) == false then
                return --任务阻止
            end
            self.当前地图:删除玩家(self)
            self.当前地图:删除召唤(self.观看召唤)
            self.当前地图:删除宠物(self.观看宠物)
            self.地图 = map.id
            if not self.离线角色 then
                self.rpc:切换地图(self.地图, x, y)
            end
            self.x = x
            self.y = y
            self:地图_初始化()
            if self.观看召唤 then
                self.观看召唤.是否移动 = false
                self.观看召唤.x = x
                self.观看召唤.y = y
                self.当前地图:添加召唤(self.观看召唤)
            end

            if self.观看宠物 then
                self.观看宠物.是否移动 = false
                self.观看宠物.x = x
                self.观看宠物.y = y
                self.当前地图:添加宠物(self.观看宠物)
            end

            if self.是否队长 then
                for i, v in self:遍历队友() do
                    v.队长 = self.nid
                    v.队伍位置 = i
                    coroutine.xpcall(v.移动_切换地图, v, map, x, y, true)
                end
            end

            self.task:切换地图后事件(self.接口, map, x, y)
            return true
        else
            print('切换地图错误')
        end
    end
end

function 角色:角色_移动开始(x, y, tx, ty, 模式) --当前和目标,两组坐标
    if not self.是否战斗 and not self.是否摆摊 then
        self.是否移动 = { tx, ty }

        local 召唤 = self.观看召唤
        local 宠物 = self.观看宠物
        if 召唤 and self.xy:取距离(召唤.x, 召唤.y) > 50 then
            召唤.是否移动 = true
            召唤.x, 召唤.y = self.x + math.random(-20, 20), self.y + math.random(-20, 20)
            self.rpc:召唤移动(召唤.nid, 召唤.x, 召唤.y)
            self.rpn:召唤移动(召唤.nid, 召唤.x, 召唤.y)
        end
        if 宠物 and self.xy:取距离(宠物.x, 宠物.y) > 40 then
            宠物.是否移动 = true
            宠物.x, 宠物.y = self.x + math.random(-40, 40), self.y + math.random(-40, 40)
            self.rpc:宠物移动(宠物.nid, 宠物.x, 宠物.y)
            self.rpn:宠物移动(宠物.nid, 宠物.x, 宠物.y)
        end

        self.rpn:移动开始(self.nid, tx, ty, 模式) --周围
    end
end

function 角色:角色_移动更新(x, y, d)
    if not self.是否战斗 and not self.是否摆摊 then
        --检查时间
        self.方向 = d
        self.x, self.y = x, y
        self.X, self.Y = x // 20, (self.当前地图.实际高度 - y) // 20
        self.xy:pack(x, y)
        if self.是否队长 then
            for i, v in self:遍历队友() do
                v:角色_移动更新(x, y, d)
            end
        end
    end
end

function 角色:角色_移动结束(x, y, d)
    if not self.是否战斗 and not self.是否摆摊 then
        self.x, self.y = x, y
        self.X, self.Y = x // 20, (self.当前地图.实际高度 - y) // 20
        self.方向 = d
        self.是否移动 = false
        self.xy:pack(x, y)

        self.rpn:移动结束(self.nid, x, y, d) --周围
        if self.是否队长 then
            for i, v in self:遍历队友() do
                v:角色_移动更新(x, y, d)
            end
        end
    end
end

function 角色:角色_切换方向(v)
    if not self.是否战斗 then
        self.方向 = v
        self.rpn:切换方向(self.nid, v)
    end
end

--===========================================================================
function 角色:角色_地图跳转(id)
    if coroutine.isyieldable() and not self.是否战斗 and not self.是否摆摊 then
        self.是否移动 = false
        local t = self.当前地图:取跳转(id)
        if t then
            self.npc = nil
            --对话
            self:移动_切换地图(t:取目标())
        end
    end
end

function 角色:角色_地图物品(id)
    if not self.是否战斗 and self.周围物品[id] then
        -- local t = self.周围物品[id]
        -- local r = t:触发()
        -- if r==true then
        --     self.周围物品[id] = nil
        --     self:删除对象(t)
        -- end
        -- return r
    end
end

--=============================================================

function 角色:角色_NPC对话(nid)
    if not self.是否战斗 and nid then
        local npc = self.周围NPC[nid]
        if npc then
            local npc = npc:对话(self)
            if npc then
                self.task:任务NPC对话(self.接口, npc)
                return npc.台词, npc.头像, npc.结束
            else
                warn('NPC错误')
            end
        end
    end
end

function 角色:角色_NPC菜单(nid, opt)
    if not self.是否战斗 and nid then
        local npc = self.周围NPC[nid]
         if npc then
            local npc = npc:菜单(self, opt)
            if npc then
                self.task:任务NPC菜单(self.接口, npc, opt)
                return npc.台词, npc.头像, npc.结束
            end
         end
    end
end
function 角色:角色_给予(nid, cash, items)
    if self.加锁状态 then
        self.接口:常规提示('#Y高级操作请先解除安全码!请不要将安全码透露给他人')
        return
    end
    if not self.是否战斗 and nid and type(cash) == 'number' and type(items) == 'table' then
        if nid == self.nid or (not self.周围NPC[nid] and not __玩家[nid]) then
            return
        end

        if self.周围NPC[nid] then
            for i, v in ipairs(items) do
                if type(v[1]) ~= 'number' or type(v[2]) ~= 'number' then
                    return --位置和数量
                end
                if not self.物品[v[1]] or self.物品[v[1]].数量 < v[2] then
                    return false
                end
                items[i] = self.物品[v[1]]:生成提交(v[2])
            end
            --local npc = self.周围NPC[nid]
            local npc = __NPC[nid]
            if npc then
                local npc = { npc:给予(self, cash, items) }
                self.task:任务NPC给予(self.接口, self.周围NPC[nid], cash, items)
                return npc.台词, npc.头像, npc.结束
            end
        elseif __玩家[nid] then
            local P = __玩家[nid]
            if P.设置.接受物品 == false then
                return
            end
            if cash > self.银子 then
                return false
            end
            self.银子 = self.银子 - cash
            P.银子 = P.银子 + cash
            if cash > 0 then
                P.rpc:提示窗口(string.format("#G%s#Y给了你%s两银子。", self.名称, cash))
                self.rpc:提示窗口(string.format("#Y你给了#G%s#Y%s两银子。", P.名称, cash))
                记录给与信息(P, self, cash)
            end


            for i, v in ipairs(items) do
                if type(v[1]) ~= 'number' or type(v[2]) ~= 'number' then
                    return --位置和数量
                end
                if not self.物品[v[1]] or self.物品[v[1]].数量 < v[2] then
                    return false
                end
                if self.物品[v[1]].禁止交易 then
                    self.rpc:常规提示("#Y这东西不能给别人。")
                    return false
                end
                items[i] = self.物品[v[1]]:开始拆分(v[2])
            end
            if P:物品_检查添加(items) then
                for i, v in ipairs(items) do
                    items[i] = v:结束拆分()
                    P.rpc:提示窗口(string.format("#G%s#Y给了你%s个%s。", self.名称, items[i].数量,
                        (items[i].原名 or items[i].名称)))
                    self.rpc:提示窗口(string.format("#Y你给了#G%s#Y%s个%s。", P.名称, items[i].数量,
                    (items[i].原名 or items[i].名称)))
                    记录给与物品(P, self, items[i].数量,(items[i].原名 or items[i].名称))
                end
                P:物品_添加(items)
            end
            --P接受 self给予方
            -- P.rpc:提示窗口(...)

            -- 16.1给予成功加提示框：#Y你给了#G接受方名称#Y多少个物品名称。
            -- 16.2接受成功加提示框：#G给予方名称#Y给了你多少个物品名称。
            -- 16.3给予银子成功加提示框：#Y你给了#G接受方名称#Y多少两银子。
            -- 16.4接受银子成功加提示框：#G给予方名称#Y给了你多少两银子。
            -- 16.5禁止交易或任务用的道具加限制给予提示框：#Y这东西不能给别人。


        end
    end
end

function 记录给与信息(给予方, 接收方, 金额)
    local 当前时间 = os.date("%Y-%m-%d %H:%M:%S")
    local 日志信息 = string.format("%s - 给与成功: %s 给了 %s 银子 %s",
                                   当前时间, 给予方.名称, 接收方.名称, 金额)
    MYF.写出管理日志('玩家日志.txt', 日志信息)
end

function 记录给与物品(给予方, 接收方, 数量, 物品名称)
    local 当前时间 = os.date("%Y-%m-%d %H:%M:%S")
    local 日志信息 = string.format("%s - 给与物品成功: %s 给了 %s %d 个 %s",
                                   当前时间, 给予方.名称, 接收方.名称, 数量, 物品名称)
    MYF.写出管理日志('玩家日志.txt', 日志信息)
end
-- function 角色:角色_给予(nid, cash, items)
--     if self.加锁状态 then
--         self.接口:常规提示('#Y高级操作请先解除安全码!请不要将安全码透露给他人')
--         return
--     end
--     if not self.是否战斗 and nid and type(cash) == 'number' and type(items) == 'table' then
--         if nid == self.nid or (not self.周围NPC[nid] and not __玩家[nid]) then
--             return
--         end

--         if self.周围NPC[nid] then
--             for i, v in ipairs(items) do
--                 if type(v[1]) ~= 'number' or type(v[2]) ~= 'number' then
--                     return --位置和数量
--                 end
--                 if not self.物品[v[1]] or self.物品[v[1]].数量 < v[2] then
--                     return false
--                 end
--                 items[i] = self.物品[v[1]]:生成提交(v[2])
--             end
--             --local npc = self.周围NPC[nid]
--             local npc = __NPC[nid]
--             if npc then
--                 local npc = { npc:给予(self, cash, items) }
--                 self.task:任务NPC给予(self.接口, self.周围NPC[nid], cash, items)
--                 return npc.台词, npc.头像, npc.结束
--             end
--         elseif __玩家[nid] then
--             local P = __玩家[nid]
--             if P.设置.接受物品 == false then
--                 return
--             end
--             if cash > self.银子 then
--                 return false
--             end
--             self.银子 = self.银子 - cash
--             P.银子 = P.银子 + cash
--             if cash > 0 then
--                 P.rpc:提示窗口(string.format("#G%s#Y给了你%s两银子。", self.名称, cash))
--                 self.rpc:提示窗口(string.format("#Y你给了#G%s#Y%s两银子。", P.名称, cash))
--             end


--             for i, v in ipairs(items) do
--                 if type(v[1]) ~= 'number' or type(v[2]) ~= 'number' then
--                     return --位置和数量
--                 end
--                 if not self.物品[v[1]] or self.物品[v[1]].数量 < v[2] then
--                     return false
--                 end
--                 if self.物品[v[1]].禁止交易 then
--                     self.rpc:常规提示("#Y这东西不能给别人。")
--                     return false
--                 end
--                 items[i] = self.物品[v[1]]:开始拆分(v[2])
--             end
--             if P:物品_检查添加(items) then
--                 for i, v in ipairs(items) do
--                     items[i] = v:结束拆分()
--                     P.rpc:提示窗口(string.format("#G%s#Y给了你%s个%s。", self.名称, items[i].数量,
--                         (items[i].原名 or items[i].名称)))
--                     self.rpc:提示窗口(string.format("#Y你给了#G%s#Y%s个%s。", P.名称, items[i].数量,
--                     (items[i].原名 or items[i].名称)))
--                 end
--                 P:物品_添加(items)
--             end
--             --P接受 self给予方
--             -- P.rpc:提示窗口(...)

--             -- 16.1给予成功加提示框：#Y你给了#G接受方名称#Y多少个物品名称。
--             -- 16.2接受成功加提示框：#G给予方名称#Y给了你多少个物品名称。
--             -- 16.3给予银子成功加提示框：#Y你给了#G接受方名称#Y多少两银子。
--             -- 16.4接受银子成功加提示框：#G给予方名称#Y给了你多少两银子。
--             -- 16.5禁止交易或任务用的道具加限制给予提示框：#Y这东西不能给别人。


--         end
--     end
-- end

function 角色:角色_攻击(nid)
    local P = self.周围[nid]
    if ggetype(P) == '地图NPC' then
        local r = self.task:任务攻击事件(self.接口,P)
        if type(r)=="string" then
            return r, P.头像 or P.外形
        end 
    end
end
