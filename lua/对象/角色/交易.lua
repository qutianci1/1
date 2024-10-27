-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-14 07:03:21
-- @Last Modified time  : 2024-05-10 15:40:06
local 角色 = require('角色')

function 角色:交易_取召唤()
    local list = {}
    for k, v in self:遍历召唤() do
        table.insert(list, {
            nid = v.nid,
            名称 = v.名称,
            --外形 = v.外形,
            禁止交易 = v.禁止交易 or v.是否参战 or v.是否观看
        })
    end
    return list
end

function 角色:角色_交易开始(nid)
    local P = self.周围玩家[nid]
    if self.加锁状态 then
        self.接口:常规提示('#Y高级操作请先解除安全码!请不要将安全码透露给他人')
        return
    end
    if P then
        if P.加锁状态 then
            self.接口:常规提示('#Y对方没有进行高级解锁')
            return
        elseif P.离线角色 then
            self.接口:常规提示('#Y召集状态下无法交易！')
            return
        end
    end
    if not self.是否交易 and not self.是否战斗 and P and (not P.是否交易 or P.交易对象 == self) and not P.是否战斗 then
        self.是否交易 = true
        self.交易对象 = P
        local 等级转换=P.转生..'转'..P.等级..' 级'
        self.rpc:交易窗口(P.名称, self.银子, self:交易_取召唤(),P.等级)

        if not P.交易对象 then
            P:角色_交易开始(self.nid)
        end
    end
end

function 角色:角色_交易结束()
    if self.是否交易 then
        local 交易对象 = self.交易对象
        self.交易对象 = nil
        self.是否交易 = false
        self.交易确认 = false
        self.交易确定 = false
        self.rpc:交易窗口()

        if 交易对象 and 交易对象.是否交易 then
            交易对象:角色_交易结束()
        end
    end
end

function 角色:角色_交易确认(银两, 召唤, 物品)
    if self.是否交易 and not self.交易确认 and
        type(银两) == 'number' and 银两 >= 0 and 银两 <= self.银子 and
        type(召唤) == 'table' and type(物品) == 'table' then
        self.交易确认 = true
        self.交易银两 = 银两
        self.交易召唤 = {}
        self.交易物品 = {}

        for i, nid in ipairs(召唤) do
            if not self.召唤[nid] then
                return '召唤不存在'
            end
            self.交易召唤[i] = self.召唤[nid]
            召唤[i] = { nid = self.召唤[nid].nid, 名称 = self.召唤[nid].名称 }
        end

        for i, t in ipairs(物品) do
            if not self.物品[t.id] then
                return '物品不存在'
            end
            self.交易物品[i] = self.物品[t.id]:开始交易(t.数量)
            if not self.交易物品[i] then
                return '物品错误'
            end
            物品[i] = self.交易物品[i]:取简要数据()
        end
        self.交易对象.rpc:交易确认(银两, 召唤, 物品)
    end
end

-- function 角色:角色_交易确定()
--     if self.是否交易 and self.交易确认 and not self.交易确定 then
--         self.交易确定 = true
--         local P = self.交易对象
--         if P.交易确认 and P.交易确定 then
--             if P.交易银两 > P.银子 then
--                 self:角色_交易结束()
--                 return
--             elseif self.交易银两 > self.银子 then
--                 self:角色_交易结束()
--                 return
--             elseif not self:物品_检查添加(P.交易物品) then
--                 self.rpc:提示窗口('#Y你的物品空间不足，交易失败！')
--                 P.rpc:提示窗口('#R%s#Y的物品空间不足，交易失败！', self.名称)
--                 self:角色_交易结束()
--                 return
--             elseif not P:物品_检查添加(self.交易物品) then
--                 P.rpc:提示窗口('#Y你的物品空间不足，交易失败！')
--                 self.rpc:提示窗口('#R%s#Y的物品空间不足，交易失败！', P.名称)
--                 self:角色_交易结束()
--                 return
--             end

--             for i, v in ipairs(self.交易物品) do
--                 if v.禁止交易 then
--                     self.rpc:提示窗口('#Y绑定物品不能交易')
--                     self:角色_交易结束()
--                     return
--                 end
--             end
--             for i, v in ipairs(P.交易物品) do
--                 if v.禁止交易 then
--                     P.rpc:提示窗口('#Y绑定物品不能交易')
--                     self:角色_交易结束()
--                     return
--                 end
--             end

--             for i, v in ipairs(self.交易召唤) do
--                 if v.是否参战 or v.是否观看 or v.禁止交易 then
--                     self.rpc:提示窗口('#Y召唤兽#R%s#Y无法交易！', v.名称)
--                     self:角色_交易结束()
--                     return
--                 end
--             end
--             for i, v in ipairs(P.交易召唤) do
--                 if v.是否参战 or v.是否观看 or v.禁止交易 then
--                     P.rpc:提示窗口('#Y召唤兽#R%s#Y无法交易！', v.名称)
--                     self:角色_交易结束()
--                     return
--                 end
--             end
--             local 召唤数量1,召唤数量2 = 0,0
--             for i, v in ipairs(self.交易召唤) do
--                 召唤数量1 = 召唤数量1 + 1
--             end
--             for i, v in ipairs(P.交易召唤) do
--                 召唤数量2 = 召唤数量2 + 1
--             end
--             if self.召唤兽携带上限 < 召唤数量2 then
--                 self.rpc:提示窗口('你携带不了这么多召唤兽')
--                 self:角色_交易结束()
--                 return
--             end
--             if P.召唤兽携带上限 < 召唤数量1 then
--                 P.rpc:提示窗口('你携带不了这么多召唤兽')
--                 self:角色_交易结束()
--                 return
--             end

--             self.银子 = self.银子 - self.交易银两
--             self.银子 = self.银子 + P.交易银两

--             P.银子 = P.银子 - P.交易银两
--             P.银子 = P.银子 + self.交易银两


--             local 物品 = {}
--             for i, v in ipairs(P.交易物品) do
--                 物品[i] = v:结束交易()
--                 物品[i].rid = self.rid
--                 if 物品[i].单价2 then
--                     物品[i].单价2=nil
--                 end
--                 P.rpc:提示窗口('#W【交易】你给了#G%s#Y%s个%s', self.名称, 物品[i].数量,
--                     (物品[i].原名 or 物品[i].名称))
--                 self.rpc:提示窗口('#W【交易】#Y%s给了你#Y%s个%s', P.名称, 物品[i].数量,
--                     (物品[i].原名 or 物品[i].名称))

--             end
--             self:物品_添加(物品)

--             物品 = {}
--             for i, v in ipairs(self.交易物品) do
--                 物品[i] = v:结束交易()
--                 物品[i].rid = P.rid
--                 if 物品[i].单价2 then
--                     物品[i].单价2=nil
--                 end
--                 self.rpc:提示窗口('#W【交易】你给了#G%s#Y%s个%s', P.名称, 物品[i].数量,
--                     (物品[i].原名 or 物品[i].名称))
--                 P.rpc:提示窗口('#W【交易】#Y%s给了你#Y%s个%s', self.名称, 物品[i].数量,
--                     (物品[i].原名 or 物品[i].名称))
--             end
--             P:物品_添加(物品)

--             for i, v in ipairs(P.交易召唤) do
--                 P.召唤[v.nid] = nil
--                 v.亲密 = 0
--                 self:召唤_添加(v)
--                 P.rpc:提示窗口('#W【交易】你给了#G%s#Y%s', self.名称, v.名称)
--                 self.rpc:提示窗口('#W【交易】#Y%s给了你#Y%s', P.名称, v.名称)
--             end
--             for i, v in ipairs(self.交易召唤) do
--                 self.召唤[v.nid] = nil
--                 v.亲密 = 0
--                 P:召唤_添加(v)
--                 P.rpc:提示窗口('#W【交易】#Y%s给了你#Y%s', self.名称, v.名称)
--                 self.rpc:提示窗口('#W【交易】你给了#G%s#Y%s', P.名称, v.名称)
--             end
--             self.rpc:交易窗口()
--             P.rpc:交易窗口()
--         end
--     end
-- end
function 角色:角色_交易确定()
    if self.是否交易 and self.交易确认 and not self.交易确定 then
        self.交易确定 = true
        local P = self.交易对象
        if P.交易确认 and P.交易确定 then
            if P.交易银两 > P.银子 then
                self:角色_交易结束()
                return
            elseif self.交易银两 > self.银子 then
                self:角色_交易结束()
                return
            elseif not self:物品_检查添加(P.交易物品) then
                self.rpc:提示窗口('#Y你的物品空间不足，交易失败！')
                P.rpc:提示窗口('#R%s#Y的物品空间不足，交易失败！', self.名称)
                self:角色_交易结束()
                return
            elseif not P:物品_检查添加(self.交易物品) then
                P.rpc:提示窗口('#Y你的物品空间不足，交易失败！')
                self.rpc:提示窗口('#R%s#Y的物品空间不足，交易失败！', P.名称)
                self:角色_交易结束()
                return
            end

            for i, v in ipairs(self.交易物品) do
                if v.禁止交易 then
                    self.rpc:提示窗口('#Y绑定物品不能交易')
                    self:角色_交易结束()
                    return
                end
            end
            for i, v in ipairs(P.交易物品) do
                if v.禁止交易 then
                    P.rpc:提示窗口('#Y绑定物品不能交易')
                    self:角色_交易结束()
                    return
                end
            end

            for i, v in ipairs(self.交易召唤) do
                if v.是否参战 or v.是否观看 or v.禁止交易 then
                    self.rpc:提示窗口('#Y召唤兽#R%s#Y无法交易！', v.名称)
                    self:角色_交易结束()
                    return
                end
            end
            for i, v in ipairs(P.交易召唤) do
                if v.是否参战 or v.是否观看 or v.禁止交易 then
                    P.rpc:提示窗口('#Y召唤兽#R%s#Y无法交易！', v.名称)
                    self:角色_交易结束()
                    return
                end
            end

            local 自己当前召唤兽数量 = self:取召唤兽数量()
            local 自己交易后召唤兽数量 = 自己当前召唤兽数量 - #self.交易召唤 + #P.交易召唤
            if 自己交易后召唤兽数量 >= self.召唤兽携带上限 then
                self.rpc:提示窗口('#Y你携带不了这么多召唤兽')
                self:角色_交易结束()
               return
            end

            local 对方当前召唤兽数量 = P:取召唤兽数量()
            local 对方交易后召唤兽数量 = 对方当前召唤兽数量 - #P.交易召唤 + #self.交易召唤
            if 对方交易后召唤兽数量 >= P.召唤兽携带上限 then
                P.rpc:提示窗口('#Y你携带不了这么多召唤兽')
                self:角色_交易结束()
            return
            end

            self.银子 = self.银子 - self.交易银两
            self.银子 = self.银子 + P.交易银两

            P.银子 = P.银子 - P.交易银两
            P.银子 = P.银子 + self.交易银两


            local 物品 = {}
            for i, v in ipairs(P.交易物品) do
                物品[i] = v:结束交易()
                物品[i].rid = self.rid
                if 物品[i].单价2 then
                    物品[i].单价2=nil
                end
                P.rpc:提示窗口('#W【交易】你给了#G%s#Y%s个%s', self.名称, 物品[i].数量,
                    (物品[i].原名 or 物品[i].名称))
                self.rpc:提示窗口('#W【交易】#Y%s给了你#Y%s个%s', P.名称, 物品[i].数量,
                    (物品[i].原名 or 物品[i].名称))
            记录交易日志(P, self, 物品[i].数量,(物品[i].原名 or 物品[i].名称))
            end
            self:物品_添加(物品)
            物品 = {}
            for i, v in ipairs(self.交易物品) do
                物品[i] = v:结束交易()
                物品[i].rid = P.rid
                if 物品[i].单价2 then
                    物品[i].单价2=nil
                end
                self.rpc:提示窗口('#W【交易】你给了#G%s#Y%s个%s', P.名称, 物品[i].数量,
                    (物品[i].原名 or 物品[i].名称))
                P.rpc:提示窗口('#W【交易】#Y%s给了你#Y%s个%s', self.名称, 物品[i].数量,
                    (物品[i].原名 or 物品[i].名称))
                记录交易日志(self, P, 物品[i].数量,(物品[i].原名 or 物品[i].名称))
            end
            P:物品_添加(物品)
            for i, v in ipairs(P.交易召唤) do
                P.召唤[v.nid] = nil
                v.亲密 = 0
                self:召唤_添加(v)
                P.rpc:提示窗口('#W【交易】你给了#G%s#Y%s', self.名称, v.名称)
                self.rpc:提示窗口('#W【交易】#Y%s给了你#Y%s', P.名称, v.名称)
                记录召唤兽交易(self, P, v.名称)
            end
            for i, v in ipairs(self.交易召唤) do
                self.召唤[v.nid] = nil
                v.亲密 = 0
                P:召唤_添加(v)
                P.rpc:提示窗口('#W【交易】#Y%s给了你#Y%s', self.名称, v.名称)
                self.rpc:提示窗口('#W【交易】你给了#G%s#Y%s', P.名称, v.名称)
                记录召唤兽交易(P, self, v.名称)
            end
            self.rpc:交易窗口()
            P.rpc:交易窗口()
        end
    end
end

function 记录交易日志(给予方, 接收方, 数量, 物品名称)
    local 当前时间 = os.date("%Y-%m-%d %H:%M:%S")
    local 日志信息 = string.format("%s - 交易成功: %s 给了 %s %d 个 %s",
                                   当前时间, 给予方.名称, 接收方.名称, 数量, 物品名称)
    MYF.写出管理日志('玩家日志.txt', 日志信息)
end

function 记录召唤兽交易(给予方, 接收方, 召唤兽名称)
    local 当前时间 = os.date("%Y-%m-%d %H:%M:%S")
    local 日志信息 = string.format("%s - 交易成功: %s 给了 %s 召唤兽 %s",
                                   当前时间, 给予方.名称, 接收方.名称, 召唤兽名称)
    MYF.写出管理日志('玩家日志.txt', 日志信息)
end

function 角色:角色_扣除银子(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n then
        return
    end
    if self.银子 < n then
        return false
    end
    self.银子 = self.银子 - n
    self.刷新的属性.银子 = true
    self.rpc:提示窗口("#Y你扣除了%s两银子", n)
    return self.银子
end

function 角色:角色_扣除师贡(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n then
        return
    end
    local 总量 = self.银子 + self.师贡
    if 总量 < n then
        return false
    end
    local 临时记录 = self.师贡
    self.师贡 = self.师贡 - n
    if self.师贡 > 0 then
        self.刷新的属性.师贡 = true
        self.rpc:提示窗口("#Y你扣除了%s师贡", n)
        return true
    else
        local _临时记录 = self.银子
        self.银子 = self.银子 + self.师贡
        _临时记录 = _临时记录 - self.银子
        self.师贡 = 0
        self.刷新的属性.师贡 = true
        self.刷新的属性.银子 = true
        if 临时记录 > 0 then
            self.rpc:提示窗口("#Y你扣除了%s师贡", 临时记录)
        end
        if _临时记录 > 0 then
            self.rpc:提示窗口("#Y你扣除了%s金钱", _临时记录)
        end
        return true
    end
    return false
end

function 角色:角色_扣除体力(n)
    if type(n) ~= 'number' or math.abs(n) ~= n or math.floor(n) ~= n then
        return
    end
    if self.体力 < n then
        self.rpc:提示窗口("#Y体力不足，无法继续！", n)
        return false
    end
    self.体力 = self.体力 - n
    self.体力更新 = true
    self.rpc:提示窗口("#Y你扣除了%s点体力", n)

    return self.体力
end
