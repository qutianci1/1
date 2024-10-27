-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-05-23 11:39:24
local 任务 = {
    名称 = '夺命香',
    类型 = '其它',
    是否BUFF = true,
    是否可取消 = false,
    是否可追踪 = false
}

function 任务:任务初始化(玩家, ...)
    self.时间 = os.time() + 60 * 60
end

function 任务:任务上线(玩家)
    self:删除()
end

function 任务:任务更新(玩家, sec)
    if self.时间 < os.time() then
        self:删除()
    end
end

function 任务:任务取详情(玩家)
    return '#G夺命香#Y可在野外强制PK玩家#r剩余时间 #G' .. tostring((self.时间 - os.time()) // 60) .. "分钟"
end

return 任务
