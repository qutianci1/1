-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-08-19 18:25:36
local 任务 = {
    名称 = '驯养坐骑',
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
    self.循环 = os.time()
    self.时间 = os.time() + 3600
    self.消耗成就 = 0
    self.驯养数值 = 0
    玩家:提示窗口('#Y开始驯养')
    return true
end

function 任务:任务更新(sec, 玩家)
    self.循环 = self.循环 + 1
    if self.循环 >= 100 then
        self.循环 = 0
        local z = 玩家:取乘骑坐骑()
        if z then
            if 玩家.帮派数据.帮派成就 >= 200 then
                玩家:扣除成就(200)
                self.消耗成就 = self.消耗成就 + 200
                if self.类型 == '经验' then
                    if z.等级 < 100 then
                        z:添加经验(700)
                        self.驯养数值 = self.驯养数值 + 700
                        玩家:提示窗口('#Y你的坐骑经验增加了700')
                    else
                        玩家:提示窗口('#Y坐骑等级已满,停止驯养')
                        self:删除()
                    end
                else
                    local 上限 = 50000
                    if self.高级驯养 then
                        上限 = 100000
                    end
                    if z:取技能熟练() < 上限 then
                        z:添加熟练(160)
                        self.驯养数值 = self.驯养数值 + 160
                        玩家:提示窗口('#Y你的坐骑技能熟练度增加了160')
                    else
                        玩家:提示窗口('#Y坐骑技能熟练度已达可驯养上限')
                    end
                    if self.消耗成就 / 1000 == math.floor(self.消耗成就 / 1000) and math.floor(self.消耗成就 / 1000) ~= 0 and self.高级驯养 then
                        local d = 玩家:取物品是否存在('高级坐骑令')
                        if not d then
                            玩家:提示窗口('#Y你的高级坐骑令不足,已停止驯养')
                            self:删除()
                        else
                            玩家:提示窗口('#Y高级坐骑令已扣除,开启新一轮驯养')
                            d:减少(1)
                        end
                    end
                end
            else
                玩家:提示窗口('#Y你的帮派成就不足200,已停止驯养')
                self:删除()
            end
        else
            玩家:提示窗口('#Y由于你没有乘骑坐骑,无法驯养。')
        end
    end
    if self.时间 <= sec then
        self:删除()
    end
end

function 任务:任务取详情(玩家)
    local z = 玩家:取乘骑坐骑()
    local 坐骑 = '未知'
    if z then
        坐骑 = z.名称
    end
    return '#G坐骑'..self.类型..'驯养：#W当前驯养目标为#G'..坐骑..'#W,已消耗成就#G'..self.消耗成就..'#W,已驯养'..self.类型..'#G'..self.驯养数值..'。#r#W剩余时间: #G' .. math.floor(tostring((self.时间 - os.time()) / 60))
end

return 任务
