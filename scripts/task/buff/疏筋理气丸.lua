-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-05-23 11:39:39
local 任务 = {
    名称 = '疏筋理气丸',
    类型 = '其它',
    是否BUFF = true,
    是否可取消 = false,
    是否可追踪 = false
}

function 任务:任务初始化(玩家, ...)
    self.时间 = os.time() + 3600 * 24
    self.HP = 1000000
    self.MP = 1000000
end

function 任务:任务上线(玩家)
    -- self:删除()
end

function 任务:添加时间()
    self.时间 = os.time() + 3600 * 24
    self.HP = 1000000
    self.MP = 1000000
end

function 任务:任务更新(玩家, sec)
    if self.时间 < os.time() or (self.HP <= 0 and self.MP <= 0) then
        self:删除()
    end
end

function 任务:玩家战斗结束(玩家)
    if self.HP > 0 and 玩家.气血 < 玩家.最大气血 then
        local xhp = 玩家.最大气血 - 玩家.气血
        if self.HP < xhp then
            xhp = self.HP
        end
        self.HP = self.HP - xhp
        玩家:增减气血(xhp)
    end
    if self.MP > 0 and 玩家.魔法 < 玩家.最大魔法 then
        local xMP = 玩家.最大魔法 - 玩家.魔法
        if self.MP < xMP then
            xMP = self.MP
        end
        self.MP = self.MP - xMP
        玩家:增减魔法(xMP)
    end
end

function 任务:召唤战斗结束(玩家)
    local 召唤 = 玩家:取参战召唤兽()
    if 召唤 then
        if self.HP > 0 and 召唤.气血 < 召唤.最大气血 then
            local xhp = 召唤.最大气血 - 召唤.气血
            if self.HP < xhp then
                xhp = self.HP
            end
            召唤:增减气血(xhp)
        end
        if self.MP > 0 and 召唤.魔法 < 召唤.最大魔法 then
            local xMP = 召唤.最大魔法 - 召唤.魔法
            if self.MP < xMP then
                xMP = self.MP
            end
            self.MP = self.MP - xMP
            召唤:增减魔法(xMP)
        end
    end
end

function 任务:任务取详情(玩家)
    return '#Y剩余时间 #G' .. tostring((self.时间 - os.time()) // 60) ..
        "分钟#r#Y剩余HP#G" .. self.HP .. "#r#Y剩余MP#G" .. self.MP
end

return 任务
