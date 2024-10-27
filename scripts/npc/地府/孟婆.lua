-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-23 06:04:07
-- @Last Modified time  : 2022-08-29 01:40:53
local NPC = {}
local 对话 = [[
人生一世，草木一春。孩子，你可以重新来过。需要投胎转世么？
]]
-- menu
-- 1|好的，我做好准备了
-- 2|我要飞升
-- 3|我什么都不想做

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
