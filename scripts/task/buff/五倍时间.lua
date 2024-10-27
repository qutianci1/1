-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:56
-- @Last Modified time  : 2023-05-23 11:39:04

local 任务 = {
    名称 = '五倍时间',
    类型 = '其它',
    是否BUFF = true,
    是否可取消 = false,
    是否可追踪 = false
}

function 任务:任务初始化()
    print('任务:初始化')
end
local _详情 ={
    '你的五倍时间还可持续#R%d#W分钟',
    '你的冻结了#R%d#W分钟五倍时间',
} 

function 任务:任务取详情(玩家)
    if self.冻结 then
        return string.format(_详情[2], self.剩余时间 // 60)
    end
    return string.format(_详情[1], (self.时间 - os.time()) // 60)
end

function 任务:任务取消(玩家)
end
function 任务:任务更新(sec)
    if self.时间 <=sec then
        self:删除()
    end
end
function 任务:任务上线(玩家)
    if not self.冻结 and self.时间 - os.time() <= 0 then
        self:删除()
    end
end

function 任务:添加任务(玩家, 时间)
    if self.冻结 then
        return false
    end
    玩家:添加任务(self)
    self.时间 = os.time() + 时间 * 3600
    self.冻结 = false
    return true
end
function 任务:增加时长(玩家, 时间)
    if self.冻结 then
        return false
    end
    local 剩余时间 = self.时间 - os.time()
    self.时间 = os.time() + 时间 * 3600 + 剩余时间
    return self.时间
end

function 任务:冻结五倍(玩家)
    self.冻结 = true
    self.剩余时间 = self.时间 - os.time()
    return self.剩余时间
end

function 任务:恢复冻结(玩家)
    self.冻结 = false
    self.时间 = os.time() + self.剩余时间
    return self.剩余时间
end

return 任务
