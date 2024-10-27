-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-05-23 11:41:29
local 任务 = {
    名称 = '引导_一坐领取',
    别名 = '一坐骑领取引导',
    类型 = '引导任务',
    是否可取消 = false,
    是否可追踪 = false,
}

function 任务:任务初始化(玩家, ...)
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务更新(玩家, sec)
end

function 任务:完成(玩家)
    local r = 玩家:取任务('引导_一坐领取')
    if r then
        local 银子 = 0
        local 经验 = 5000
        玩家:添加参战召唤兽经验(经验 * 1.5)
        玩家:添加银子(银子)
        玩家:添加经验(经验)
        self:删除()
    end
end
local _详情 = '你已经60级了去找#G至尊小宝#W领取一坐骑！'
function 任务:任务取详情(玩家)
    return _详情
end

return 任务
