-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-06-21 18:38:23
-- @Last Modified time  : 2023-06-21 18:41:18

local NPC = {}
local 对话 = [[金克木,木克土，土克水,水克火,火克金,相生相克,生生不息。
menu
就是你了,看我来破你这五行阵
手抖点错了
]]

function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('日常_大雁塔任务')
    if r then
        if r.进度 == 9 or r.进度 == 10 then
            return 对话
        end
    end
    return '金克木,木克土，土克水,水克火,火克金,相生相克,生生不息。'
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
