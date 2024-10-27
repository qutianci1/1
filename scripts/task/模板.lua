-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-01 12:16:40
-- @Last Modified time  : 2023-05-21 18:34:15

local 任务 = {
    名称 = '模板',
    类型 = '测试任务'
}

function 任务:任务初始化(玩家, ...)
    self.进度 = 1
end

function 任务:任务上线(玩家)
end

function 任务:任务更新(玩家, sec)
end

function 任务:任务取消(玩家)
end

function 任务:任务取详情(玩家)
    return '任务描述 #G'
end

function 任务:任务NPC对话(玩家, NPC)

end

function 任务:任务NPC菜单(玩家, NPC, i)

end



return 任务
