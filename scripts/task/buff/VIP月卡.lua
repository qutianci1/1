-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2024-10-18 16:48:38
local 任务 = {
    名称 = 'VIP月卡',
    类型 = '其它',
    是否BUFF = true,
    是否可取消 = false,
    是否可追踪 = false
}

function 任务:任务初始化(玩家, ...)
    self.时间 = os.time() + 3600 * 720
    self.HP = 10000000
    self.MP = 10000000
end

function 任务:任务上线(玩家)
    -- self:删除()
end

function 任务:添加时间()
    self.时间 = self.时间 + 3600 * 720
    self.HP = 10000000
    self.MP = 10000000
end

function 任务:任务更新(玩家, sec)
    if self.时间 < os.time()  then
        self:删除()
    end
end

function 任务:玩家战斗结束(玩家)
    if 玩家.气血 < 玩家.最大气血 then
        玩家:增减气血(玩家.最大气血)
    end
    if 玩家.魔法 < 玩家.最大魔法 then
        玩家:增减魔法(玩家.最大魔法)
    end
end

function 任务:召唤战斗结束(玩家)
    local 召唤 = 玩家:取参战召唤兽()
    if 召唤 then
            召唤:添加忠诚度(99)

        if 召唤.气血 < 召唤.最大气血 then
            召唤:增减气血(召唤.最大气血)
        end
        if 召唤.魔法 < 召唤.最大魔法 then
            召唤:增减魔法(召唤.最大魔法)
        end
    end
end

function 任务:任务取详情(玩家)
    return '#R尊贵的VIP玩家#r#Y剩余时间：#G' .. tostring((self.时间 - os.time()) // 86400) ..
        "天#r#Y功效：#r#G不掉忠诚#r#G恢复100%血蓝#r#G获得经验增加30%"
end

return 任务
