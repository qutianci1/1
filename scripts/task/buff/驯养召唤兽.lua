-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-05-23 11:39:43
local 任务 = {
    名称 = '驯养召唤兽',
    类型 = '其它',
    是否BUFF = true,
    是否可取消 = false,
    是否可追踪 = false
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    if self.时间 <= os.time() then
        self:删除()
    end
end

function 任务:添加任务(玩家)
    -- self.循环 = 0
    -- self.时间 = os.time() + 3600
    -- self.消耗成就 = 0
    -- self.驯养数值 = 0
    -- 玩家:提示窗口('#Y开始驯养')
    return true
end

function 任务:任务更新(sec, 玩家)
    self.循环 = self.循环 + 1
    if self.循环 >= 100 then
        self.循环 = 0
        if 玩家.帮派数据.帮派成就 >= 200 then
            玩家:扣除成就(200)
            self.消耗成就 = self.消耗成就 + 200
            玩家:添加亲密(self.召唤兽.nid,1000)
            self.驯养数值 = self.驯养数值 + 1000
            玩家:提示窗口('#Y你的召唤兽#G'..self.召唤兽.名称..'#Y亲密增加了1000')
        else
            玩家:提示窗口('#Y成就不足,无法继续驯养')
            self:删除()
        end
    end
    if self.时间 <= sec then
        self:删除()
    end
end

function 任务:任务取详情(玩家)
    -- table.print(self.列表)
    return '#G召唤兽驯养：#W当前驯养目标为#G'..self.召唤兽.名称..'#W,已消耗成就#G'..self.消耗成就..'#W,已驯养亲密#G'..self.驯养数值..'。#r#W剩余时间: #G' .. math.floor(tostring((self.时间 - os.time()) / 60))
end

return 任务
