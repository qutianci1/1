-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-05-23 12:24:37

local NPC = {}
local 对话 = [[
看什么看？小心我吃了你#78
]]

function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('日常_五环任务')
    if r then
        if r.进度 == 7 then
            对话 = '食婴鬼手下的手下,应该是食婴鬼的孙子辈吧....\nmenu\n打这孙子\n准备准备'
        end
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    elseif i == '打这孙子' then
        local r = 玩家:取任务('日常_五环任务')
        if r then
            if r.进度 == 7 then
                local z = 玩家:进入战斗('scripts/task/日常/日常_五环任务.lua')
                if z then
                    if r then
                        local 银两 , 师门 , 经验 = r:计算奖励(玩家)
                        玩家:添加银子(银两)
                        玩家:添加师贡(师门)
                        玩家:添加任务经验(经验,'五环')
                        r:更新进度(玩家)
                        r.次数 = r.次数 + 1
                    end
                end
            end
        end
    end
end

return NPC
