-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-05-23 11:39:17
local 任务 = {
    名称 = '变身卡',
    类型 = '其它',
    是否BUFF = true,
    是否可取消 = false,
    是否可追踪 = false
}

function 任务:任务初始化(玩家, ...)
    -- self.变身属性 = {}
end

function 任务:任务上线(玩家)
    if self.时间 <= os.time() then
        self:清除变身(玩家)
    end
end

function 任务:添加任务(玩家)
     local r = 玩家:取任务("变身卡")
    if r then
        r:清除变身(玩家)
    end
    self.时间 = os.time() + 36000
    self.原形 = 玩家.外形
    self.外形 = self.变身属性.外观
    玩家:提示窗口('#Y你使用了#G'..self.变身属性.名称..'-'..self.变身属性.类型..'')
    玩家:添加任务(self)
    玩家:刷新外形()
    return true
end

function 任务:清除变身(玩家)
    self:删除()
    玩家:刷新外形()
end

function 任务:任务更新(sec, 玩家)
    --print(self.时间)
    if self.时间 <= sec then
        self:清除变身(玩家)
    end
end

function 任务:任务取详情(玩家)
    return '#G'..self.变身属性.名称..'卡：#W剩余时间: #G' .. math.floor(tostring((self.时间 - os.time()) / 60))
end

return 任务
